import SwiftAST

/// An invocation transformer that allows renaming an instance or type property
/// access
public class PropertyInvocationTransformer: PostfixInvocationTransformer {
    
    let baseExpressionMatcher: ValueMatcher<Expression>
    let oldName: String
    let newName: String
    
    public init(baseExpressionMatcher: ValueMatcher<Expression>,
                oldName: String,
                newName: String) {
        
        self.baseExpressionMatcher = baseExpressionMatcher
        self.oldName = oldName
        self.newName = newName
        
    }
    
    public func canApply(to postfix: PostfixExpression) -> Bool {
        guard let member = postfix.op.asMember else {
            return false
        }
        guard member.name == oldName else {
            return false
        }
        guard baseExpressionMatcher.matches(postfix.exp) else {
            return false
        }
        
        return true
    }
    
    public func attemptApply(on postfix: PostfixExpression) -> Expression? {
        if !canApply(to: postfix) {
            return nil
        }
        
        return postfix.exp.copy().dot(newName)
    }
}
