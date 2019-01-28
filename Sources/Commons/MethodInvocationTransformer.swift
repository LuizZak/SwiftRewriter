import SwiftAST
import SwiftRewriterLib

public final class MethodInvocationTransformer: PostfixInvocationTransformer {
    
    let baseExpressionMatcher: ValueMatcher<Expression>
    let invocationMatcher: MethodInvocationTransformerMatcher
    
    init(baseExpressionMatcher: ValueMatcher<Expression>,
         invocationMatcher: MethodInvocationTransformerMatcher) {
        
        self.baseExpressionMatcher = baseExpressionMatcher
        self.invocationMatcher = invocationMatcher
    }
    
    public func canApply(to postfix: PostfixExpression) -> Bool {
        guard let memberNameAccess = postfix.exp.asPostfix else {
            return false
        }
        guard let memberName = memberNameAccess.asPostfix?.op.asMember else {
            return false
        }
        guard let function = postfix.op.asFunctionCall else {
            return false
        }
        
        if function.arguments.count < invocationMatcher.transformer.requiredArgumentCount {
            return false
        }
        
        let identifier = function.identifierWith(methodName: memberName.name)
        
        guard invocationMatcher.identifier == identifier else {
            return false
        }
        
        guard baseExpressionMatcher.matches(memberNameAccess.exp) else {
            return false
        }
        
        return true
    }
    
    public func attemptApply(on postfix: PostfixExpression) -> Expression? {
        if !canApply(to: postfix) {
            return nil
        }
        guard let memberNameAccess = postfix.exp.asPostfix else {
            return nil
        }
        guard let memberName = memberNameAccess.op.asMember else {
            return nil
        }
        guard let function = postfix.op.asFunctionCall else {
            return nil
        }
        
        let name = invocationMatcher.transformer.rewriteName(memberName.name)
        let call = invocationMatcher.transformer.rewriteFunctionCall(function)
        
        return .postfix(memberNameAccess.exp.copy().dot(name), call)
    }
}
