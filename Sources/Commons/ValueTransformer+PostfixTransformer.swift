import SwiftAST

public struct ValueTransformerWrapper: PostfixInvocationTransformer {
    let valueTransformer: ValueTransformer<PostfixExpression, Expression>
    
    public init(valueTransformer: ValueTransformer<PostfixExpression, Expression>) {
        self.valueTransformer = valueTransformer
    }
    
    public func canApply(to postfix: PostfixExpression) -> Bool {
        true
    }
    
    public func attemptApply(on postfix: PostfixExpression) -> Expression? {
        valueTransformer(transform: postfix)
    }
}

extension ValueTransformerWrapper: CustomStringConvertible {
    public var description: String {
        "\(valueTransformer)"
    }
}
