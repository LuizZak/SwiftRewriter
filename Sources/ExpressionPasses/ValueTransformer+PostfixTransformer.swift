import SwiftAST
import Commons

struct ValueTransformerWrapper: PostfixInvocationTransformer {
    let valueTransformer: ValueTransformer<PostfixExpression, Expression>
    
    init(valueTransformer: ValueTransformer<PostfixExpression, Expression>) {
        self.valueTransformer = valueTransformer
    }
    
    public func canApply(to postfix: PostfixExpression) -> Bool {
        return true
    }
    
    public func attemptApply(on postfix: PostfixExpression) -> Expression? {
        return valueTransformer.transform(value: postfix)
    }
}

extension ValueTransformerWrapper: CustomStringConvertible {
    var description: String {
        return "\(valueTransformer)"
    }
}
