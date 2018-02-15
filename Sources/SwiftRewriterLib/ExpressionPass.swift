import GrammarModels
import ObjcParser

/// A base class for expression rewriting passes.
open class ExpressionPass {
    public init() {
        
    }
    
    /// Entry point for expression pass
    public func applyPass(on expression: Expression) -> Expression {
        return visitExpression(expression)
    }
    
    open func visitExpression(_ expression: Expression) -> Expression {
        switch expression {
        case let .assignment(lhs, op, rhs):
            return visitAssignment(lhs: lhs, op: op, rhs: rhs)
        case let .binary(lhs, op, rhs):
            return visitBinary(lhs: lhs, op: op, rhs: rhs)
        case let .unary(op, expr):
            return visitUnary(op: op, expr)
        case let .prefix(op, expr):
            return visitPrefix(op: op, expr)
        case let .postfix(expr, post):
            return visitPostfix(expr, op: post)
        case .constant(let constant):
            return visitConstant(constant)
        case let .parens(expr):
            return visitParens(expr)
        case .identifier(let ident):
            return visitIdentifier(ident)
        case let .cast(expr, type):
            return visitCast(expr, type: type)
        case .arrayLiteral(let expressions):
            return visitArray(expressions)
        case .dictionaryLiteral(let pairs):
            return visitDictionary(pairs)
        case let .ternary(exp, ifTrue, ifFalse):
            return visitTernary(exp, ifTrue, ifFalse)
        }
    }
    
    open func visitAssignment(lhs: Expression, op: SwiftOperator, rhs: Expression) -> Expression {
        let lhs = visitExpression(lhs)
        let rhs = visitExpression(rhs)
        
        return .binary(lhs: lhs, op: op, rhs: rhs)
    }
    
    open func visitBinary(lhs: Expression, op: SwiftOperator, rhs: Expression) -> Expression {
        let lhs = visitExpression(lhs)
        let rhs = visitExpression(rhs)
        
        return .binary(lhs: lhs, op: op, rhs: rhs)
    }
    
    open func visitUnary(op: SwiftOperator, _ exp: Expression) -> Expression {
        return .unary(op: op, visitExpression(exp))
    }
    
    open func visitPrefix(op: SwiftOperator, _ exp: Expression) -> Expression {
        return .prefix(op: op, visitExpression(exp))
    }
    
    open func visitPostfix(_ exp: Expression, op: Postfix) -> Expression {
        let exp = visitExpression(exp)
        return .postfix(exp, op)
    }
    
    open func visitConstant(_ constant: Constant) -> Expression {
        return .constant(constant)
    }
    
    open func visitParens(_ exp: Expression) -> Expression {
        return .parens(visitExpression(exp))
    }
    
    open func visitIdentifier(_ identifier: String) -> Expression {
        return .identifier(identifier)
    }
    
    open func visitCast(_ exp: Expression, type: ObjcType) -> Expression {
        let exp = visitExpression(exp)
        return .cast(exp, type: type)
    }
    
    open func visitArray(_ array: [Expression]) -> Expression {
        return .arrayLiteral(array.map(visitExpression))
    }
    
    open func visitDictionary(_ dictionary: [ExpressionDictionaryPair]) -> Expression {
        return .dictionaryLiteral(dictionary.map { pair in
            return ExpressionDictionaryPair(key: visitExpression(pair.key), value: visitExpression(pair.value))
        })
    }
    
    open func visitTernary(_ exp: Expression, _ ifTrue: Expression, _ ifFalse: Expression) -> Expression {
        let exp = visitExpression(exp)
        let ifTrue = visitExpression(ifTrue)
        let ifFalse = visitExpression(ifFalse)
        
        return .ternary(exp, true: ifTrue, false: ifFalse)
    }
}
