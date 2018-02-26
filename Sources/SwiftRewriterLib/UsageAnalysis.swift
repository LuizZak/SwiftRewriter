import SwiftAST

/// Simplified API interface to find usages of symbols across intentions
public protocol UsageAnalyzer {
    /// Finds all usages of a known method
    func findUsages(of method: KnownMethod) -> [MemberUsage]
}

/// Default implementation of UsageAnalyzer
public class DefaultUsageAnalyzer: UsageAnalyzer {
    public var intentions: IntentionCollection
    
    public init(intentions: IntentionCollection) {
        self.intentions = intentions
    }
    
    public func findUsages(of method: KnownMethod) -> [MemberUsage] {
        let types = intentions.typeIntentions()
        
        // Get all existing method bodies, from all types
        let bodies = types.flatMap { $0.methods.compactMap { $0.functionBody?.body } }
        
        //bodies.
        
        return []
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

/*
 let analyzer = UsageAnalysis(in: intentions)
 let usages = analyzer.findUsages(of: methodIntention)
 
 usages[0].method
 usages[0].expression
 
 */
