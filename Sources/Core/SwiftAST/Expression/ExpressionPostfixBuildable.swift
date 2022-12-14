public protocol ExpressionPostfixBuildable {
    var expressionToBuild: Expression { get }
    
    /// Creates a function call invocation postfix expression with this expression
    /// buildable
    func call(
        _ arguments: [FunctionArgument],
        type: SwiftType?,
        callableSignature: BlockSwiftType?
    ) -> PostfixExpression
    
    /// Creates a function call invocation postfix expression with this expression
    /// buildable with a sequence of unlabeled function argument expressions
    func call(
        _ unlabeledArguments: [Expression],
        type: SwiftType?,
        callableSignature: BlockSwiftType?
    ) -> PostfixExpression
    
    /// Creates a member access postfix expression with this expression buildable
    func dot(_ member: String, type: SwiftType?) -> PostfixExpression
    
    /// Creates a subscript access postfix expression with this expression buildable
    func sub(_ exp: Expression, type: SwiftType?) -> PostfixExpression

    /// Creates a subscript access postfix expression with this expression buildable
    func sub(expressions: [Expression], type: SwiftType?) -> PostfixExpression
    
    /// Creates a subscript access postfix expression with this expression buildable
    func sub(_ arguments: [FunctionArgument], type: SwiftType?) -> PostfixExpression
}

public extension ExpressionPostfixBuildable {
    func call() -> PostfixExpression {
        call([] as [FunctionArgument], type: nil, callableSignature: nil)
    }
    
    func call(_ arguments: [FunctionArgument]) -> PostfixExpression {
        call(arguments, type: nil, callableSignature: nil)
    }
    
    func call(_ unlabeledArguments: [Expression]) -> PostfixExpression {
        call(unlabeledArguments, type: nil, callableSignature: nil)
    }
    
    func call(
        _ unlabeledArguments: [Expression],
        callableSignature: BlockSwiftType?
    ) -> PostfixExpression {
        
        call(unlabeledArguments, type: nil, callableSignature: callableSignature)
    }
    
    func dot(_ member: String) -> PostfixExpression {
        dot(member, type: nil)
    }
    
    func sub(_ exp: Expression) -> PostfixExpression {
        sub(exp, type: nil)
    }
    
    func sub(expressions: [Expression]) -> PostfixExpression {
        sub(expressions: expressions, type: nil)
    }
    
    func sub(_ arguments: [FunctionArgument]) -> PostfixExpression {
        sub(arguments, type: nil)
    }
}

public extension ExpressionPostfixBuildable {
    func call(
        _ arguments: [FunctionArgument],
        type: SwiftType?,
        callableSignature: BlockSwiftType?
    ) -> PostfixExpression {
        
        let op = Postfix.functionCall(arguments: arguments)
        op.returnType = type
        op.callableSignature = callableSignature
        return .postfix(expressionToBuild, op)
    }
    
    /// Returns a postfix call with this expression as a function, and a series
    /// of unlabeled arguments as input.
    func call(
        _ unlabeledArguments: [Expression],
        type: SwiftType?,
        callableSignature: BlockSwiftType?
    ) -> PostfixExpression {
        
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
    
    func sub(expressions: [Expression], type: SwiftType?) -> PostfixExpression {
        let op = Postfix.subscript(expressions: expressions)
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
