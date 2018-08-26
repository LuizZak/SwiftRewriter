import SwiftAST
import SwiftRewriterLib

extension ValueTransformer: PostfixInvocationTransformer where T == PostfixExpression, U == Expression {
    func canApply(to postfix: PostfixExpression) -> Bool {
        return true
    }
    
    func attemptApply(on postfix: PostfixExpression) -> Expression? {
        return transform(value: postfix)
    }
}
