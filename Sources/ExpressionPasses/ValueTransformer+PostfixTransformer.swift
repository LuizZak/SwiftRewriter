import SwiftAST
import Commons

struct ValueTransformerWrapper: PostfixInvocationTransformer {
    let valueTransformer: ValueTransformer<PostfixExpression, Expression>
    
    init(valueTransformer: ValueTransformer<PostfixExpression, Expression>) {
        self.valueTransformer = valueTransformer
    }
    
    public func canApply(to postfix: PostfixExpression) -> Bool {
        true
    }
    
    public func attemptApply(on postfix: PostfixExpression) -> Expression? {
        valueTransformer.transform(value: postfix)
    }
}

extension ValueTransformerWrapper: CustomStringConvertible {
    var description: String {
        "\(valueTransformer)"
    }
}
