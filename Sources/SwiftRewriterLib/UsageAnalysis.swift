import SwiftAST

/// Simplified API interface to find usages of symbols across intentions
public protocol UsageAnalyzer {
    /// Finds all usages of a known method
    func findUsagesOf(method: KnownMethod) -> [MemberUsage]
    
    /// Finds all usages of a known property
    func findUsagesOf(property: KnownProperty) -> [MemberUsage]
}

/// Default implementation of UsageAnalyzer
public class DefaultUsageAnalyzer: UsageAnalyzer {
    public var intentions: IntentionCollection
    
    public init(intentions: IntentionCollection) {
        self.intentions = intentions
    }
    
    public func findUsagesOf(method: KnownMethod) -> [MemberUsage] {
        let types = intentions.typeIntentions()
        
        // Get all existing method bodies, from all types
        let typeMethods = types.flatMap { $0.methods }
        
        var usages: [MemberUsage] = []
        
        for typeMethod in typeMethods {
            guard let body = typeMethod.functionBody?.body else {
                continue
            }
            
            let iterator = SyntaxNodeSequence(statement: body, inspectBlocks: true)
            
            for exp in iterator.lazy.compactMap({ $0 as? PostfixExpression }) {
                guard let expMethod = exp.op.asMember?.memberDefinition as? KnownMethod else {
                    continue
                }
                guard expMethod.signature == method.signature else {
                    continue
                }
                
                if expMethod.ownerType?.typeName == method.ownerType?.typeName {
                    let usage = MemberUsage(function: typeMethod, expression: exp)
                    
                    usages.append(usage)
                }
            }
        }
        
        return usages
    }
    
    public func findUsagesOf(property: KnownProperty) -> [MemberUsage] {
        let types = intentions.typeIntentions()
        
        // Get all existing method bodies, from all types
        let typeMethods = types.flatMap { $0.methods }
        
        var usages: [MemberUsage] = []
        
        for typeMethod in typeMethods {
            guard let body = typeMethod.functionBody?.body else {
                continue
            }
            
            let iterator = SyntaxNodeSequence(statement: body, inspectBlocks: true)
            
            for exp in iterator.lazy.compactMap({ $0 as? PostfixExpression }) {
                guard let expProperty = exp.op.asMember?.memberDefinition as? KnownProperty else {
                    continue
                }
                guard expProperty.name == property.name else {
                    continue
                }
                
                if expProperty.ownerType?.typeName == property.ownerType?.typeName {
                    let usage = MemberUsage(function: typeMethod, expression: exp)
                    
                    usages.append(usage)
                }
            }
        }
        
        return usages
    }
}

/// Reports the usage of a type member or global declaration
public struct MemberUsage {
    /// Function the usage is contained within
    public var function: FunctionIntention
    
    /// The expression the usage is effectively used.
    ///
    /// This expression is a `PostfixExpression` where the `Postfix.member("")`
    /// points to the actual member name.
    public var expression: PostfixExpression
}
