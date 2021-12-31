import SwiftAST
import KnownType
import Intentions
import TypeSystem

/// Simplified API interface to find usages of symbols across intentions
public protocol UsageAnalyzer {
    /// Finds all usages of a known method
    func findUsagesOf(method: KnownMethod) -> [DefinitionUsage]
    
    /// Finds all usages of a known property
    func findUsagesOf(property: KnownProperty) -> [DefinitionUsage]
}

/// A refined usage analyzer capable of inspecting usages of local variables by
/// name within a method body.
public protocol LocalsUsageAnalyzer: UsageAnalyzer {
    /// Finds all usages of a local with a given name.
    /// Returns all usages of any local named `local`, even those which are shadowed
    /// by other, deeper scoped definitions.
    func findUsagesOf(
        localNamed local: String,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> [DefinitionUsage]
    
    /// Finds all usages of a local with a given name in the scope of a given
    /// `SyntaxNode`.
    /// `syntaxNode` must either be a `Statement` node, or any node which is a
    /// descendent of a `Statement` node, otherwise a fatal error is raised.
    func findUsagesOf(
        localNamed local: String,
        inScopeOf syntaxNode: SyntaxNode,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> [DefinitionUsage]
    
    /// Finds the definition of a local with a given name within the scope of a
    /// given `SyntaxNode`.
    /// `syntaxNode` must either be a `Statement` node, or any node which is a
    /// descendent of a `Statement` node, otherwise a fatal error is raised.
    /// Returns `nil`, in case no definition with the given name could be found
    /// within scope of `syntaxNode`
    func findDefinitionOf(
        localNamed local: String,
        inScopeOf syntaxNode: SyntaxNode,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> LocalCodeDefinition?
}

public class BaseUsageAnalyzer: UsageAnalyzer {
    var typeSystem: TypeSystem
    
    init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
    }
    
    public func findUsagesOf(method: KnownMethod) -> [DefinitionUsage] {
        let containers = statementContainers()
        
        var usages: [DefinitionUsage] = []
        
        for (container, intention) in containers {
            let visitor = AnonymousSyntaxNodeVisitor { node in
                guard let exp = node as? PostfixExpression else {
                    return
                }
                guard let expMethod = exp.member?.memberDefinition as? KnownMethod else {
                    return
                }
                guard expMethod.signature == method.signature else {
                    return
                }
                
                if expMethod.ownerType?.asTypeName == method.ownerType?.asTypeName {
                    let usage =
                        DefinitionUsage(
                            intention: intention,
                            definition: .forKnownMember(method),
                            expression: exp,
                            isReadOnlyUsage: true
                        )
                    
                    usages.append(usage)
                }
            }
            
            switch container {
            case .function(let body):
                visitor.visitStatement(body.body)
            case .expression(let exp):
                visitor.visitExpression(exp)
            case .statement(let stmt):
                visitor.visitStatement(stmt)
            }
        }
        
        return usages
    }
    
    public func findUsagesOf(property: KnownProperty) -> [DefinitionUsage] {
        let containers = statementContainers()
        
        var usages: [DefinitionUsage] = []
        
        for (container, intention) in containers {
            let visitor = AnonymousSyntaxNodeVisitor { node in
                guard let exp = node as? PostfixExpression else {
                    return
                }
                guard let expProperty = exp.member?.memberDefinition as? KnownProperty else {
                    return
                }
                guard expProperty.name == property.name else {
                    return
                }
                
                if expProperty.ownerType?.asTypeName == property.ownerType?.asTypeName {
                    let readOnly = self.isReadOnlyContext(exp)
                    
                    let usage =
                        DefinitionUsage(
                            intention: intention,
                            definition: .forKnownMember(property),
                            expression: exp,
                            isReadOnlyUsage: readOnly
                        )
                    
                    usages.append(usage)
                }
            }
            
            switch container {
            case .function(let body):
                visitor.visitStatement(body.body)
            case .expression(let exp):
                visitor.visitExpression(exp)
            case .statement(let stmt):
                visitor.visitStatement(stmt)
            }
        }
        
        return usages
    }
    
    func isReadOnlyContext(_ expression: Expression) -> Bool { 
        if let assignment = expression.parentExpression?.asAssignment {
            return expression !== assignment.lhs
        }
        // Unary '&' is interpreted as 'address-of', which is a mutable operation.
        if let unary = expression.parentExpression?.asUnary {
            return unary.op != .bitwiseAnd
        }
        if let postfix = expression.parentExpression?.asPostfix {
            let root = postfix.topPostfixExpression
            
            // If at any point we find a function call, the original value cannot
            // be mutated due to any change on the returned value, so we just
            // assume it's never written.
            let chain = PostfixChainInverter.invert(expression: root)
            if let call = chain.first(where: { $0.postfix is FunctionCallPostfix }),
                let member = call.postfixExpression?.exp.asPostfix?.member {
                
                // Skip checking mutating methods on reference types, since those
                // don't mutate variables.
                if let type = chain.first?.expression?.resolvedType,
                    !typeSystem.isScalarType(type) {
                    
                    return true
                }
                
                if let method = member.memberDefinition as? KnownMethod {
                    return !method.signature.isMutating
                }
                
                return true
            }
            
            // Writing to a reference type at any point invalidates mutations
            // to the original value.
            let types = chain.compactMap(\.resolvedType)
            if types.contains(where: { typeSystem.isClassInstanceType($0) }) {
                return true
            }
            
            return isReadOnlyContext(root)
        }
        
        return true
    }
    
    func statementContainers() -> [(StatementContainer, FunctionBodyCarryingIntention)] {
        []
    }
}

/// Default implementation of UsageAnalyzer which searches for definitions in all
/// function bodies, top-level statements and expressions.
public class IntentionCollectionUsageAnalyzer: BaseUsageAnalyzer {
    public var intentions: IntentionCollection
    private let numThreads: Int
    
    // TODO: Passing `numThreads` here seems arbitrary (it is passed to
    // `FunctionBodyQueue` when collecting function bodies). Maybe we could store
    // the maximal thread count in a global, and replace all of its usages,
    // instead?
    
    public init(intentions: IntentionCollection, typeSystem: TypeSystem, numThreads: Int) {
        self.intentions = intentions
        self.numThreads = numThreads
        
        super.init(typeSystem: typeSystem)
    }

    override func statementContainers() -> [(StatementContainer, FunctionBodyCarryingIntention)] {
        let queue =
            FunctionBodyQueue.fromIntentionCollection(
                intentions, delegate: EmptyFunctionBodyQueueDelegate(),
                numThreads: numThreads
            )

        return queue.items.compactMap { item in
            if let intention = item.intention {
                return (item.container, intention)
            }

            return nil
        }
    }
}

/// Usage analyzer that specializes in lookup of usages of locals within function
/// bodies.
public class LocalUsageAnalyzer: BaseUsageAnalyzer {
    
    public override init(typeSystem: TypeSystem) {
        super.init(typeSystem: typeSystem)
    }
    
    public func findUsagesOf(
        localNamed local: String,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> [DefinitionUsage] {
        
        var usages: [DefinitionUsage] = []
        
        let visitor =
            AnonymousSyntaxNodeVisitor { node in
                guard let identifier = node as? IdentifierExpression else {
                    return
                }
                guard let def = identifier.definition as? LocalCodeDefinition else {
                    return
                }
                
                if def.name == local {
                    let readOnly = self.isReadOnlyContext(identifier)
                    
                    let usage =
                        DefinitionUsage(
                            intention: intention,
                            definition: def,
                            expression: identifier,
                            isReadOnlyUsage: readOnly
                        )
                    
                    usages.append(usage)
                }
            }
        
        container.accept(visitor)
        
        return usages
    }
    
    public func findUsagesOf(
        localNamed local: String,
        inScopeOf syntaxNode: SyntaxNode,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> [DefinitionUsage] {
        
        guard let definition = findDefinitionOf(localNamed: local, inScopeOf: syntaxNode) else {
            return []
        }
        
        return findUsagesOf(definition: definition, inScopeOf: syntaxNode, in: container, intention: intention)
    }
    
    public func findUsagesOf(
        definition: LocalCodeDefinition,
        inScopeOf syntaxNode: SyntaxNode,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> [DefinitionUsage] {
        
        var usages: [DefinitionUsage] = []
        
        let visitor =
            AnonymousSyntaxNodeVisitor { node in
                guard let identifier = node as? IdentifierExpression else {
                    return
                }
                
                guard let def = identifier.definition as? LocalCodeDefinition else {
                    return
                }
                
                if def != definition {
                    let readOnly = self.isReadOnlyContext(identifier)
                    
                    let usage =
                        DefinitionUsage(
                            intention: intention,
                            definition: def,
                            expression: identifier,
                            isReadOnlyUsage: readOnly
                        )
                    
                    usages.append(usage)
                }
        }
        
        container.accept(visitor)
        
        return usages
    }
    
    public func findAllUsages(
        in syntaxNode: SyntaxNode,
        container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> [DefinitionUsage] {
        
        var usages: [DefinitionUsage] = []
        
        let visitor =
            AnonymousSyntaxNodeVisitor { node in
                guard let identifier = node as? IdentifierExpression else {
                    return
                }
                guard let definition = identifier.definition else {
                    return
                }
                
                let readOnly = self.isReadOnlyContext(identifier)
                
                let usage =
                    DefinitionUsage(
                        intention: intention,
                        definition: definition,
                        expression: identifier,
                        isReadOnlyUsage: readOnly
                    )
                
                usages.append(usage)
            }
        
        switch syntaxNode {
        case let stmt as Statement:
            visitor.visitStatement(stmt)
            
        case let exp as Expression:
            visitor.visitExpression(exp)
            
        default:
            fatalError("Cannot search for definitions in statement node of type \(type(of: syntaxNode))")
        }
        
        return usages
    }
    
    public func findDefinitionOf(
        localNamed local: String,
        inScopeOf syntaxNode: SyntaxNode
    ) -> LocalCodeDefinition? {

        let scope = scopeFor(syntaxNode: syntaxNode)
        
        return scope?.firstDefinition(named: local) as? LocalCodeDefinition
    }
    
    private func scopeFor(syntaxNode: SyntaxNode) -> CodeScope? {
        if let statement = syntaxNode as? Statement {
            return statement.nearestScope
        }
        if let statement = syntaxNode.firstAncestor(ofType: Statement.self) {
            return scopeFor(syntaxNode: statement)
        }
        
        fatalError("Unknown syntax node type \(type(of: syntaxNode)) with no \(Statement.self)-typed parent node!")
    }
}

/// Reports the usage of a type member or global declaration
public struct DefinitionUsage {
    /// Intention for function body or statement/expression which this member
    /// usage is contained within.
    ///
    /// Can be nil, if no contextual intention was provided during analysis.
    public var intention: FunctionBodyCarryingIntention?
    
    /// The definition that was effectively used
    public var definition: CodeDefinition
    
    /// The expression the usage is effectively used.
    ///
    /// In case the usage is of a type member, this expression is a
    /// `PostfixExpression` where the `Postfix.member("")` points to the actual
    /// member name.
    /// In case the usage is of a local variable, the expression points to the
    /// identifier node referencing the variable.
    public var expression: Expression
    
    /// Whether, in the context of this usage, the referenced definition is being
    /// used in a read-only context.
    public var isReadOnlyUsage: Bool
}
