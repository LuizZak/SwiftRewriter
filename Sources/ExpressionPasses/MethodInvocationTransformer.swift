import SwiftAST
import SwiftRewriterLib

public final class MethodInvocationTransformer: PostfixInvocationTransformer {
    
    let baseExpressionMatcher: ValueMatcher<Expression>
    let methodSignature: FunctionSignature
    let newMethodName: String
    let argumentRewriters: [ArgumentRewritingStrategy]
    let argumentTypes: [SwiftType]
    
    /// The number of arguments this method invocation transformer needs, exactly,
    /// in order to be fulfilled.
    public let requiredArgumentCount: Int
    
    init(baseExpressionMatcher: ValueMatcher<Expression>,
         methodSignature: FunctionSignature,
         newMethodName: String,
         argumentRewriters: [ArgumentRewritingStrategy],
         argumentTypes: [SwiftType]) {
        
        self.baseExpressionMatcher = baseExpressionMatcher
        self.methodSignature = methodSignature
        self.newMethodName = newMethodName
        self.argumentRewriters = argumentRewriters
        self.argumentTypes = argumentTypes
        
        requiredArgumentCount = argumentRewriters.requiredArgumentCount()
    }
    
    func canApply(to postfix: PostfixExpression) -> Bool {
        guard let memberNameAccess = postfix.exp.asPostfix else {
            return false
        }
        guard let memberName = memberNameAccess.asPostfix?.op.asMember else {
            return false
        }
        guard let function = postfix.op.asFunctionCall else {
            return false
        }
        
        if function.arguments.count != requiredArgumentCount {
            return false
        }
        
        let selector = function.selectorWith(methodName: memberName.name)
        guard methodSignature.asSelector.keywords == selector.keywords else {
            return false
        }
        
        guard baseExpressionMatcher.matches(memberNameAccess.exp) else {
            return false
        }
        
        return true
    }
    
    func attemptApply(on postfix: PostfixExpression) -> Expression? {
        if !canApply(to: postfix) {
            return nil
        }
        guard let memberNameAccess = postfix.exp.asPostfix else {
            return nil
        }
        guard let function = postfix.op.asFunctionCall else {
            return nil
        }
        
        let newArgs =
            argumentRewriters.rewrite(arguments: function.arguments)
        
        let newExp =
            memberNameAccess
                .exp.copy()
                .dot(newMethodName)
                .call(newArgs)
        
        newExp.op.asFunctionCall?.arguments.enumerated().forEach { (i, arg) in
            arg.expression.expectedType = argumentTypes[i]
        }
        
        return newExp
        
    }
    
}
