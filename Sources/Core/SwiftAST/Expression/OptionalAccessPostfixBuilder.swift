public extension Expression {
    /// Begins an optional postfix creation from this expression.
    func optional() -> OptionalAccessPostfixBuilder {
        OptionalAccessPostfixBuilder(exp: self, isForceUnwrap: false)
    }
    
    /// Begins a force-unwrap optional postfix creation from this expression.
    func forceUnwrap() -> OptionalAccessPostfixBuilder {
        OptionalAccessPostfixBuilder(exp: self, isForceUnwrap: true)
    }
}

public struct OptionalAccessPostfixBuilder: ExpressionPostfixBuildable {
    public var exp: Expression
    public var isForceUnwrap: Bool
    
    public var expressionToBuild: Expression { exp }
    
    public func copy() -> OptionalAccessPostfixBuilder {
        OptionalAccessPostfixBuilder(exp: exp.copy(), isForceUnwrap: isForceUnwrap)
    }
    
    public func call(
        _ arguments: [FunctionArgument],
        type: SwiftType?,
        callableSignature: BlockSwiftType?
    ) -> PostfixExpression {
        
        let op = Postfix.functionCall(arguments: arguments)
        op.returnType = type
        op.callableSignature = callableSignature
        op.optionalAccessKind = isForceUnwrap ? .forceUnwrap : .safeUnwrap
        
        return .postfix(expressionToBuild, op)
    }
    
    public func call(
        _ unlabeledArguments: [Expression],
        type: SwiftType?,
        callableSignature: BlockSwiftType?
    ) -> PostfixExpression {
        
        let op = Postfix
            .functionCall(
                arguments: unlabeledArguments.map(FunctionArgument.unlabeled)
            )
        
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
    
    public func sub(expressions: [Expression], type: SwiftType?) -> PostfixExpression {
        let op = Postfix.subscript(expressions: expressions)
        op.returnType = type
        
        return .postfix(expressionToBuild, op)
    }
    
    public func sub(_ arguments: [FunctionArgument], type: SwiftType?) -> PostfixExpression {
        let op = Postfix.subscript(arguments: arguments)
        op.returnType = type
        op.optionalAccessKind = isForceUnwrap ? .forceUnwrap : .safeUnwrap
        
        return .postfix(expressionToBuild, op)
    }
}
