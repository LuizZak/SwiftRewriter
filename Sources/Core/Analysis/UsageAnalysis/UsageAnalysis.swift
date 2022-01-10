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

/// Usage analyzer that specializes in lookup of usages of locals within function
/// bodies.
public class LocalUsageAnalyzer: BaseUsageAnalyzer, LocalUsageAnalyzerType {

    public override init(typeSystem: TypeSystem) {
        super.init(typeSystem: typeSystem)
    }

    public func findDefinitionOf(
        localNamed local: String,
        inScopeOf syntaxNode: SyntaxNode,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> LocalCodeDefinition? {

        guard let scope = syntaxNode.nearestScope else {
            return nil
        }

        if let def = scope.firstDefinition(named: local) as? LocalCodeDefinition {
            return def
        }

        return nil
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
        
        return findUsagesOf(definition: definition, in: container, intention: intention)
    }
    
    public func findUsagesOf(
        definition: LocalCodeDefinition,
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
                
                guard def == definition else {
                    return
                }
                
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
        
        container.accept(visitor)
        
        return usages
    }
    
    public func findAllUsages(
        in syntaxNode: SyntaxNode,
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
