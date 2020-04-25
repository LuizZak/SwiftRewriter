public protocol ExpressionPostfixBuildable {
    var expressionToBuild: Expression { get }
    
    /// Creates a function call invocation postfix expression with this expression
    /// buildable
    func call(_ arguments: [FunctionArgument], type: SwiftType?,
              callableSignature: SwiftType?) -> PostfixExpression
    
    /// Creates a function call invocation postfix expression with this expression
    /// buildable with a sequence of unlabeled function argument expressions
    func call(_ unlabeledArguments: [Expression], type: SwiftType?,
              callableSignature: SwiftType?) -> PostfixExpression
    
    /// Creates a member access postfix expression with this expression buildable
    func dot(_ member: String, type: SwiftType?) -> PostfixExpression
    
    /// Creates a subscript access postfix expression with this expression buildable
    func sub(_ exp: Expression, type: SwiftType?) -> PostfixExpression
    
    /// Creates a subscript access postfix expression with this expression buildable
    func sub(_ arguments: [FunctionArgument], type: SwiftType?) -> PostfixExpression
}

extension ExpressionPostfixBuildable {
    public func call() -> PostfixExpression {
        call([] as [FunctionArgument], type: nil, callableSignature: nil)
    }
    
    public func call(_ arguments: [FunctionArgument]) -> PostfixExpression {
        call(arguments, type: nil, callableSignature: nil)
    }
    
    public func call(_ unlabeledArguments: [Expression]) -> PostfixExpression {
        call(unlabeledArguments, type: nil, callableSignature: nil)
    }
    
    public func call(_ unlabeledArguments: [Expression],
                     callableSignature: SwiftType?) -> PostfixExpression {
        
        call(unlabeledArguments, type: nil, callableSignature: callableSignature)
    }
    
    public func dot(_ member: String) -> PostfixExpression {
        dot(member, type: nil)
    }
    
    public func sub(_ exp: Expression) -> PostfixExpression {
        sub(exp, type: nil)
    }
    
    public func sub(_ arguments: [FunctionArgument]) -> PostfixExpression {
        sub(arguments, type: nil)
    }
}

public extension ExpressionPostfixBuildable {
    func call(_ arguments: [FunctionArgument],
              type: SwiftType?,
              callableSignature: SwiftType?) -> PostfixExpression {
        
        let op = Postfix.functionCall(arguments: arguments)
        op.returnType = type
        op.callableSignature = callableSignature
        return .postfix(expressionToBuild, op)
    }
    
    /// Returns a postfix call with this expression as a function, and a series
    /// of unlabeled arguments as input.
    func call(_ unlabeledArguments: [Expression],
              type: SwiftType?,
              callableSignature: SwiftType?) -> PostfixExpression {
        
        let op = Postfix.functionCall(arguments: unlabeledArguments.map(FunctionArgument.unlabeled))
        op.returnType = type
        op.callableSignature = callableSignature
        
        return .postfix(expressionToBuild, op)
    }
    
    /// Creates a member access postfix expression with this expression
    func dot(_ member: String, type: SwiftType?) -> PostfixExpression {
        let op = Postfix.member(member)
        op.returnType = type
        
        return .postfix(expressionToBuild, op)
    }
    
    /// Creates a subscript access postfix expression with this expression
    func sub(_ exp: Expression, type: SwiftType?) -> PostfixExpression {
        let op = Postfix.subscript(exp)
        op.returnType = type
        
        return .postfix(expressionToBuild, op)
    }
    
    func sub(_ arguments: [FunctionArgument], type: SwiftType?) -> PostfixExpression {
        let op = Postfix.subscript(arguments: arguments)
        op.returnType = type
        
        return .postfix(expressionToBuild, op)
    }
}

extension Expression: ExpressionPostfixBuildable {
    public var expressionToBuild: Expression { self }
}

extension Expression {
    /// Creates a BinaryExpression between this expression and a right-hand-side
    /// expression.
    public func binary(op: SwiftOperator, rhs: Expression) -> BinaryExpression {
        .binary(lhs: self, op: op, rhs: rhs)
    }
    
    /// Creates a BinaryExpression between this expression and a right-hand-side
    /// expression.
    public func assignment(op: SwiftOperator, rhs: Expression) -> AssignmentExpression {
        .assignment(lhs: self, op: op, rhs: rhs)
    }
    
    /// Creates a type-cast expression with this expression
    public func casted(to type: SwiftType, optional: Bool = true) -> CastExpression {
        let exp = Expression.cast(expressionToBuild, type: type, isOptionalCast: optional)
        
        return exp
    }
    
    /// Begins an optional postfix creation from this expression.
    public func optional() -> OptionalAccessPostfixBuilder {
        OptionalAccessPostfixBuilder(exp: self, isForceUnwrap: false)
    }
    
    /// Begins a force-unwrap optional postfix creation from this expression.
    public func forceUnwrap() -> OptionalAccessPostfixBuilder {
        OptionalAccessPostfixBuilder(exp: self, isForceUnwrap: true)
    }
}

extension Expression {
    public func typed(_ type: SwiftType?) -> Self {
        resolvedType = type
        
        return self
    }
    
    public func typed(expected: SwiftType?) -> Self {
        expectedType = expected
        
        return self
    }
}

public struct OptionalAccessPostfixBuilder: ExpressionPostfixBuildable {
    public var exp: Expression
    public var isForceUnwrap: Bool
    
    public var expressionToBuild: Expression { exp }
    
    public func copy() -> OptionalAccessPostfixBuilder {
        OptionalAccessPostfixBuilder(exp: exp.copy(), isForceUnwrap: isForceUnwrap)
    }
    
    public func call(_ arguments: [FunctionArgument],
                     type: SwiftType?,
                     callableSignature: SwiftType?) -> PostfixExpression {
        
        let op = Postfix.functionCall(arguments: arguments)
        op.returnType = type
        op.callableSignature = callableSignature
        op.optionalAccessKind = isForceUnwrap ? .forceUnwrap : .safeUnwrap
        
        return .postfix(expressionToBuild, op)
    }
    
    public func call(_ unlabeledArguments: [Expression],
                     type: SwiftType?,
                     callableSignature: SwiftType?) -> PostfixExpression {
        
        let op = Postfix.functionCall(arguments: unlabeledArguments.map(FunctionArgument.unlabeled))
        op.returnType = type
        op.callableSignature = callableSignature
        op.optionalAccessKind = isForceUnwrap ? .forceUnwrap : .safeUnwrap
        
        return .postfix(expressionToBuild, op)
    }
    
    public func dot(_ member: String, type: SwiftType?) -> PostfixExpression {
        let op = Postfix.member(member)
        op.returnType = type
        op.optionalAccessKind = isForceUnwrap ? .forceUnwrap : .safeUnwrap
        
        return .postfix(expressionToBuild, op)
    }
    
    public func sub(_ exp: Expression, type: SwiftType?) -> PostfixExpression {
        let op = Postfix.subscript(exp)
        op.returnType = type
        op.optionalAccessKind = isForceUnwrap ? .forceUnwrap : .safeUnwrap
        
        return .postfix(expressionToBuild, op)
    }
    
    public func sub(_ arguments: [FunctionArgument], type: SwiftType?) -> PostfixExpression {
        let op = Postfix.subscript(arguments: arguments)
        op.returnType = type
        op.optionalAccessKind = isForceUnwrap ? .forceUnwrap : .safeUnwrap
        
        return .postfix(expressionToBuild, op)
    }
}
