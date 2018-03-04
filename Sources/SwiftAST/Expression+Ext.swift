public extension Expression {
    /// Creates a BiniaryExpression between this expression and a right-hand-side
    /// expression.
    public func binary(op: SwiftOperator, rhs: Expression) -> BinaryExpression {
        return .binary(lhs: self, op: op, rhs: rhs)
    }
    
    public func optional() -> OptionalAccessPostfixBuilder {
        return OptionalAccessPostfixBuilder(exp: self)
    }
    
    /// Creates a function call invocation postfix expression with this expression
    public func call(arguments: [FunctionArgument] = []) -> PostfixExpression {
        return .postfix(self, .functionCall(arguments: arguments))
    }
    
    /// Creates a function call invocation postfix expression with this expression
    /// with a sequence of unlabeled function argument expressions
    public func call(_ unlabeledArguments: [Expression]) -> PostfixExpression {
        return .postfix(self, .functionCall(arguments: unlabeledArguments.map(FunctionArgument.unlabeled)))
    }
    
    /// Creates a member access postfix expression with this expression
    public func dot(_ member: String) -> PostfixExpression {
        return .postfix(self, .member(member))
    }
    
    /// Creates a subscript access postfix expression with this expression
    public func sub(_ exp: Expression) -> PostfixExpression {
        return .postfix(self, .subscript(exp))
    }
    
    /// Creates a type-cast expression with this expression
    public func casted(to type: SwiftType) -> CastExpression {
        return .cast(self, type: type)
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
