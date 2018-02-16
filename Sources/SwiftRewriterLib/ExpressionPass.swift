import GrammarModels
import ObjcParser

/// Represents the base protocol for visitors of an expression tree.
/// Visitors visit nodes while performing operations on each node along the way,
/// returning the resulting value after done traversing.
public protocol ExpressionVisitor {
    associatedtype ExprResult
    
    /// Visits an expression node
    ///
    /// - Parameter expression: Expression to visit
    /// - Returns: Result of visiting this expression node
    func visitExpression(_ expression: Expression) -> ExprResult
    
    /// Visits an assignment operation node
    ///
    /// - Parameters:
    ///   - lhs: Expression's left-hand side
    ///   - op: Expression's operator
    ///   - rhs: Expression's right-hand side
    /// - Returns: Result of visiting this assignment operation node
    func visitAssignment(lhs: Expression, op: SwiftOperator, rhs: Expression) -> ExprResult
    
    /// Visits a binary operation node
    ///
    /// - Parameters:
    ///   - lhs: Expression's left-hand side
    ///   - op: Expression's operator
    ///   - rhs: Expression's right-hand side
    /// - Returns: Result of visiting this binary operation node
    func visitBinary(lhs: Expression, op: SwiftOperator, rhs: Expression) -> ExprResult
    
    /// Visits a unary operation node
    ///
    /// - Parameters:
    ///   - op: The unary operator for the expression
    ///   - exp: The operand for the expression
    /// - Returns: Result of visiting this unary operation node
    func visitUnary(op: SwiftOperator, _ exp: Expression) -> ExprResult
    
    /// Visits a prefix operation node
    ///
    /// - Parameters:
    ///   - op: The prefix operator for the expression
    ///   - exp: The operand for the expression
    /// - Returns: Result of visiting this prefix operation node
    func visitPrefix(op: SwiftOperator, _ exp: Expression) -> ExprResult
    
    /// Visits a postfix operation node
    ///
    /// - Parameters:
    ///   - exp: The operand for the expression
    ///   - op: The postfix operator for the expression
    /// - Returns: Result of visiting this postfix operation node
    func visitPostfix(_ exp: Expression, op: Postfix) -> ExprResult
    
    /// Visits a constant node
    ///
    /// - Parameter constant: The constant contained within the node
    /// - Returns: Result of visiting this constant node
    func visitConstant(_ constant: Constant) -> ExprResult
    
    /// Visits a parenthesized expression node
    ///
    /// - Parameter exp: The expression contained within the parenthesis
    /// - Returns: Result of visiting this parenthesis node
    func visitParens(_ exp: Expression) -> ExprResult
    
    /// Visits an identifier node
    ///
    /// - Parameter identifier: The identifier contained within the node
    /// - Returns: Result of visiting this identifier node
    func visitIdentifier(_ identifier: String) -> ExprResult
    
    /// Visits a type-casting expression node
    ///
    /// - Parameters:
    ///   - exp: The expression being casted
    ///   - type: The target casting type
    /// - Returns: Result of visiting this cast node
    func visitCast(_ exp: Expression, type: ObjcType) -> ExprResult
    
    /// Visits an array literal node
    ///
    /// - Parameter array: The list of expressions that make up the array literal
    /// - Returns: Result of visiting this array literal node
    func visitArray(_ array: [Expression]) -> ExprResult
    
    /// Visits a dictionary literal node
    ///
    /// - Parameter dictionary: The list of dictionary entry pairs that make up
    /// the dictionary literal
    /// - Returns: Result of visiting this dictionary literal node
    func visitDictionary(_ dictionary: [ExpressionDictionaryPair]) -> ExprResult
    
    /// Visits a block expression
    ///
    /// - Parameters:
    ///   - parameters: Parameters for the block's invocation
    ///   - returnType: The return type of the block
    ///   - body: The block's statements body
    /// - Returns: Result of visiting this block expression node
    func visitBlock(_ parameters: [BlockParameter], _ returnType: ObjcType, _ body: CompoundStatement) -> ExprResult
    
    /// Visits a ternary operation node
    ///
    /// - Parameters:
    ///   - exp: The control expression
    ///   - ifTrue: The expression executed when the control expression evaluates
    /// to true
    ///   - ifFalse: The expression executed when the control expression evaluates
    /// to false
    /// - Returns: Result of visiting this ternary expression node
    func visitTernary(_ exp: Expression, _ ifTrue: Expression, _ ifFalse: Expression) -> ExprResult
    
    /// Visits an unknown expression node
    ///
    /// - Parameter context: Context for unknown expression node
    /// - Returns: Result of visiting this unknown expression node
    func visitUnknown(_ context: UnknownASTContext) -> ExprResult
}

public extension Expression {
    /// Accepts the given visitor instance, calling the appropriate visiting method
    /// according to this expression's type.
    ///
    /// - Parameter visitor: The visitor to accept
    /// - Returns: The result of the visitor's `visit-` call when applied to this
    /// expression
    public func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        switch self {
        case let .assignment(lhs, op, rhs):
            return visitor.visitAssignment(lhs: lhs, op: op, rhs: rhs)
            
        case let .binary(lhs, op, rhs):
            return visitor.visitBinary(lhs: lhs, op: op, rhs: rhs)
            
        case let .unary(op, exp):
            return visitor.visitUnary(op: op, exp)
            
        case let .prefix(op, exp):
            return visitor.visitPrefix(op: op, exp)
            
        case let .postfix(exp, op):
            return visitor.visitPostfix(exp, op: op)
            
        case .constant(let cst):
            return visitor.visitConstant(cst)
            
        case .parens(let exp):
            return visitor.visitParens(exp)
            
        case .identifier(let id):
            return visitor.visitIdentifier(id)
            
        case let .cast(exp, type):
            return visitor.visitCast(exp, type: type)
            
        case .arrayLiteral(let exps):
            return visitor.visitArray(exps)
            
        case .dictionaryLiteral(let pairs):
            return visitor.visitDictionary(pairs)
            
        case let .ternary(exp, ifTrue, ifFalse):
            return visitor.visitTernary(exp, ifTrue, ifFalse)
            
        case let .block(parameters, ret, body):
            return visitor.visitBlock(parameters, ret, body)
            
        case .unknown(let context):
            return visitor.visitUnknown(context)
        }
    }
}

/// A base class for expression rewriting passes.
open class ExpressionPass: ExpressionVisitor {
    public init() {
        
    }
    
    /// Entry point for expression pass
    public func applyPass(on expression: Expression) -> Expression {
        return expression.accept(self)
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
        let lhs = lhs.accept(self)
        let rhs = rhs.accept(self)
        
        return .binary(lhs: lhs, op: op, rhs: rhs)
    }
    
    open func visitBinary(lhs: Expression, op: SwiftOperator, rhs: Expression) -> Expression {
        let lhs = lhs.accept(self)
        let rhs = rhs.accept(self)
        
        return .binary(lhs: lhs, op: op, rhs: rhs)
    }
    
    open func visitUnary(op: SwiftOperator, _ exp: Expression) -> Expression {
        return .unary(op: op, exp.accept(self))
    }
    
    open func visitPrefix(op: SwiftOperator, _ exp: Expression) -> Expression {
        return .prefix(op: op, exp.accept(self))
    }
    
    open func visitPostfix(_ exp: Expression, op: Postfix) -> Expression {
        let exp = exp.accept(self)
        let op2: Postfix
        
        switch op {
        case .functionCall(let arguments):
            op2 = .functionCall(arguments: arguments.map { arg in
                switch arg {
                case .unlabeled(let exp):
                    return .unlabeled(exp.accept(self))
                case let .labeled(label, exp):
                    return .labeled(label, exp.accept(self))
                }
            })
        case .subscript(let exp):
            op2 = .subscript(exp.accept(self))
        default:
            op2 = op
        }
        
        return .postfix(exp, op2)
    }
    
    open func visitConstant(_ constant: Constant) -> Expression {
        return .constant(constant)
    }
    
    open func visitParens(_ exp: Expression) -> Expression {
        return .parens(exp.accept(self))
    }
    
    open func visitIdentifier(_ identifier: String) -> Expression {
        return .identifier(identifier)
    }
    
    open func visitCast(_ exp: Expression, type: ObjcType) -> Expression {
        let exp = exp.accept(self)
        return .cast(exp, type: type)
    }
    
    open func visitArray(_ array: [Expression]) -> Expression {
        return .arrayLiteral(array.map { $0.accept(self) })
    }
    
    open func visitDictionary(_ dictionary: [ExpressionDictionaryPair]) -> Expression {
        return .dictionaryLiteral(dictionary.map { pair in
            return ExpressionDictionaryPair(key: pair.key.accept(self), value: pair.value.accept(self))
        })
    }
    
    open func visitTernary(_ exp: Expression, _ ifTrue: Expression, _ ifFalse: Expression) -> Expression {
        let exp = exp.accept(self)
        let ifTrue = ifTrue.accept(self)
        let ifFalse = ifFalse.accept(self)
        
        return .ternary(exp, true: ifTrue, false: ifFalse)
    }
    
    open func visitBlock(_ parameters: [BlockParameter], _ returnType: ObjcType, _ body: CompoundStatement) -> Expression {
        return .block(parameters: parameters, return: returnType, body: body)
    }
    
    open func visitUnknown(_ context: UnknownASTContext) -> Expression {
        return .unknown(context)
    }
}
