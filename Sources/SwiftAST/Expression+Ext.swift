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
    public func call(_ arguments: [FunctionArgument] = [], type: SwiftType? = nil,
                     callableSignature: SwiftType? = nil) -> PostfixExpression {
        let op = Postfix.functionCall(arguments: arguments)
        op.returnType = type
        op.callableSignature = callableSignature
        return .postfix(self, op)
    }
    
    /// Creates a function call invocation postfix expression with this expression
    /// with a sequence of unlabeled function argument expressions
    public func call(_ unlabeledArguments: [Expression], type: SwiftType? = nil,
                     callableSignature: SwiftType? = nil) -> PostfixExpression {
        let op = Postfix.functionCall(arguments: unlabeledArguments.map(FunctionArgument.unlabeled))
        op.returnType = type
        op.callableSignature = callableSignature
        
        return .postfix(self, op)
    }
    
    /// Creates a member access postfix expression with this expression
    public func dot(_ member: String, type: SwiftType? = nil) -> PostfixExpression {
        let op = Postfix.member(member)
        op.returnType = type
        
        return .postfix(self, .member(member))
    }
    
    /// Creates a subscript access postfix expression with this expression
    public func sub(_ exp: Expression, type: SwiftType? = nil) -> PostfixExpression {
        let op = Postfix.subscript(exp)
        op.returnType = type
        
        return .postfix(self, op)
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
