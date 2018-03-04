import SwiftAST

public extension Expression {
    /// Creates a BiniaryExpression between this expression and a right-hand-side
    /// expression.
    public func binary(op: SwiftOperator, rhs: Expression) -> BinaryExpression {
        return Expression.binary(lhs: self, op: op, rhs: rhs)
    }
    
    /// Creates a function call invocation postfix expression with this expression
    public func call(arguments: [FunctionArgument] = []) -> PostfixExpression {
        return Expression.postfix(self, .functionCall(arguments: arguments))
    }
    
    /// Creates a member access postfix expression with this expression
    public func dot(_ member: String) -> PostfixExpression {
        return Expression.postfix(self, .member(member))
    }
}
