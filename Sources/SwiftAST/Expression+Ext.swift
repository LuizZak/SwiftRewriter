public extension Expression {
    /// Creates a BinaryExpression between this expression and a right-hand-side
    /// expression.
    public func binary(op: SwiftOperator, rhs: Expression) -> BinaryExpression {
        return .binary(lhs: self, op: op, rhs: rhs)
    }
    
    /// Creates a BinaryExpression between this expression and a right-hand-side
    /// expression.
    public func assignment(op: SwiftOperator, rhs: Expression) -> AssignmentExpression {
        return .assignment(lhs: self, op: op, rhs: rhs)
    }
    
    public func optional() -> OptionalAccessPostfixBuilder {
        return OptionalAccessPostfixBuilder(exp: self)
    }
    
    /// Creates a function call invocation postfix expression with this expression
    public func call(_ arguments: [FunctionArgument] = []) -> PostfixExpression {
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
    public func call(_ arguments: [FunctionArgument] = []) -> PostfixExpression {
        let op = Postfix.functionCall(arguments: arguments)
        op.hasOptionalAccess = true
        return .postfix(exp, op)
    }
    
    /// Creates a function call invocation postfix expression with this expression
    /// with a sequence of unlabeled function argument expressions
    public func call(_ unlabeledArguments: [Expression]) -> PostfixExpression {
        let op = Postfix.functionCall(arguments:unlabeledArguments.map(FunctionArgument.unlabeled))
        op.hasOptionalAccess = true
        return .postfix(exp, op)
    }
    
    /// Creates a member access postfix expression with this expression
    public func dot(_ member: String) -> PostfixExpression {
        let op = Postfix.member(member)
        op.hasOptionalAccess = true
        return .postfix(exp, op)
    }
    
    /// Creates a subscript access postfix expression with this expression
    public func sub(_ exp: Expression) -> PostfixExpression {
        let op = Postfix.subscript(exp)
        op.hasOptionalAccess = true
        return .postfix(exp, op)
    }
}
