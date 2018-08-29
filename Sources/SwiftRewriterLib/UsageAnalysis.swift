import SwiftAST

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
    func findUsagesOf(local: String) -> [DefinitionUsage]
}

public class BaseUsageAnalyzer: UsageAnalyzer {
    public func findUsagesOf(method: KnownMethod) -> [DefinitionUsage] {
        let bodies = functionBodies()
        
        var usages: [DefinitionUsage] = []
        
        for functionBody in bodies {
            let body = functionBody.body
            
            let iterator = SyntaxNodeSequence(node: body, inspectBlocks: true)
            
            for exp in iterator.lazy.compactMap({ $0 as? PostfixExpression }) {
                guard let expMethod = exp.member?.memberDefinition as? KnownMethod else {
                    continue
                }
                guard expMethod.signature == method.signature else {
                    continue
                }
                
                if expMethod.ownerType?.asTypeName == method.ownerType?.asTypeName {
                    let usage = DefinitionUsage(intention: functionBody,
                                                expression: exp,
                                                isReadOnlyUsage: true)
                    
                    usages.append(usage)
                }
            }
        }
        
        return usages
    }
    
    public func findUsagesOf(property: KnownProperty) -> [DefinitionUsage] {
        let bodies = functionBodies()
        
        var usages: [DefinitionUsage] = []
        
        for functionBody in bodies {
            let body = functionBody.body
            
            let iterator = SyntaxNodeSequence(node: body, inspectBlocks: true)
            
            for exp in iterator.lazy.compactMap({ $0 as? PostfixExpression }) {
                guard let expProperty = exp.member?.memberDefinition as? KnownProperty else {
                    continue
                }
                guard expProperty.name == property.name else {
                    continue
                }
                
                if expProperty.ownerType?.asTypeName == property.ownerType?.asTypeName {
                    let readOnly = isReadOnlyContext(exp)
                    
                    let usage = DefinitionUsage(intention: functionBody,
                                                expression: exp,
                                                isReadOnlyUsage: readOnly)
                    
                    usages.append(usage)
                }
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
            
            let chain = PostfixChainInverter.invert(expression: root)
            if chain.contains(where: { $0.postfix is FunctionCallPostfix }) {
                return true
            }
            
            return isReadOnlyContext(root)
        }
        
        return true
    }
    
    func functionBodies() -> [FunctionBodyIntention] {
        return []
    }
}

/// Default implementation of UsageAnalyzer which searches for definitions in all
/// method bodies.
public class DefaultUsageAnalyzer: BaseUsageAnalyzer {
    public var intentions: IntentionCollection
    
    public init(intentions: IntentionCollection) {
        self.intentions = intentions
    }
    
    override func functionBodies() -> [FunctionBodyIntention] {
        let queue =
            FunctionBodyQueue.fromIntentionCollection(
                intentions, delegate: EmptyFunctionBodyQueueDelegate())
        
        return queue.items.map { $0.body }
    }
}

public class LocalUsageAnalyzer: BaseUsageAnalyzer {
    public var functionBody: FunctionBodyIntention
    
    public init(functionBody: FunctionBodyIntention) {
        self.functionBody = functionBody
    }
    
    public func findUsagesOf(localNamed local: String) -> [DefinitionUsage] {
        let bodies = functionBodies()
        
        var usages: [DefinitionUsage] = []
        
        for functionBody in bodies {
            let body = functionBody.body
            
            let visitor =
                AnonymousSyntaxNodeVisitor { node in
                    guard let identifier = node as? IdentifierExpression else {
                        return
                    }
                    
                    switch identifier.definition {
                    case .local(let definition)? where definition.name == local:
                        let readOnly = self.isReadOnlyContext(identifier)
                        
                        let usage = DefinitionUsage(intention: functionBody,
                                                    expression: identifier,
                                                    isReadOnlyUsage: readOnly)
                        
                        usages.append(usage)
                        
                    default:
                        break
                    }
                }
            
            visitor.visitStatement(body)
        }
        
        return usages
    }
    
    override func functionBodies() -> [FunctionBodyIntention] {
        return [functionBody]
    }
}

/// Reports the usage of a type member or global declaration
public struct DefinitionUsage {
    /// Intention for function body which this member usage is contained wihin.
    public var intention: FunctionBodyIntention
    
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
