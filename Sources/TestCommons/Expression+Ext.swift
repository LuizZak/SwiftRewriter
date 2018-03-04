import SwiftAST

public extension Expression {
    /// Creates a BiniaryExpression between this expression and a right-hand-side
    /// expression.
    public func binary(op: SwiftOperator, rhs: Expression) -> BinaryExpression {
        return Expression.binary(lhs: self, op: op, rhs: rhs)
    }
    
    public func optional() -> OptionalAccessPostfixBuilder {
        return OptionalAccessPostfixBuilder(exp: self)
    }
    
    /// Creates a function call invocation postfix expression with this expression
    public func call(arguments: [FunctionArgument] = []) -> PostfixExpression {
        return Expression.postfix(self, .functionCall(arguments: arguments))
    }
    
    /// Creates a member access postfix expression with this expression
    public func dot(_ member: String) -> PostfixExpression {
        return Expression.postfix(self, .member(member))
    }
    
    /// Creates a subscript access postfix expression with this expression
    public func sub(_ exp: Expression) -> PostfixExpression {
        return Expression.postfix(self, .subscript(exp))
    }
}

public struct OptionalAccessPostfixBuilder {
    public var exp: Expression
    
    /// Creates a function call invocation postfix expression with this expression
    public func call(arguments: [FunctionArgument] = []) -> PostfixExpression {
        return .postfix(exp, .optionalAccess(.functionCall(arguments: arguments)))
    }
    
    /// Creates a member access postfix expression with this expression
    public func dot(_ member: String) -> PostfixExpression {
        return .postfix(exp, .optionalAccess(.member(member)))
    }
    
    /// Creates a subscript access postfix expression with this expression
    public func sub(_ exp: Expression) -> PostfixExpression {
        return .postfix(exp, .optionalAccess(.subscript(exp)))
    }
}
