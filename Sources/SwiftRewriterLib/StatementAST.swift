import GrammarModels

/// Encapsulates a compound statement, that is, a series of statements enclosed
/// within braces.
public struct CompoundStatement: Equatable {
    /// An empty compound statement.
    public static var empty = CompoundStatement()
    
    public var statements: [Statement]
    
    public init() {
        self.statements = []
    }
    
    public init(statements: [Statement]) {
        self.statements = statements
    }
}

extension CompoundStatement: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Statement...) {
        self.statements = elements
    }
}

/// A top-level statement
public indirect enum Statement: Equatable {
    case semicolon
    case compound(CompoundStatement)
    case `if`(Expression, body: CompoundStatement, `else`: CompoundStatement?)
    case `while`(Expression, body: CompoundStatement)
    case `for`(Pattern, Expression, body: CompoundStatement)
    // TODO: case `switch`(...)
    case `defer`(CompoundStatement)
    case `return`(Expression?)
    case `break`
    case `continue`
    case expressions([Expression])
    case variableDeclarations([StatementVariableDeclaration])
    
    public static func expression(_ expr: Expression) -> Statement {
        return .expressions([expr])
    }
    
    public static func variableDeclaration(identifier: String, type: ObjcType, initialization: Expression?) -> Statement {
        return .variableDeclarations([
            StatementVariableDeclaration(identifier: identifier, type: type, initialization: initialization)
        ])
    }
}

/// A pattern for pattern-matching
public enum Pattern: Equatable {
    case identifier(String)
    indirect case tuple([Pattern])
    
    public var simplified: Pattern {
        switch self {
        case .tuple(let pt) where pt.count == 1:
            return pt[0]
        default:
            return self
        }
    }
}

public struct StatementVariableDeclaration: Equatable {
    public var identifier: String
    public var type: ObjcType
    public var initialization: Expression?
    
    public init(identifier: String, type: ObjcType, initialization: Expression?) {
        self.identifier = identifier
        self.type = type
        self.initialization = initialization
    }
}

/// An expression
public indirect enum Expression: Equatable {
    case assignment(lhs: Expression, op: SwiftOperator, rhs: Expression)
    case binary(lhs: Expression, op: SwiftOperator, rhs: Expression)
    case unary(op: SwiftOperator, Expression)
    case prefix(op: SwiftOperator, Expression)
    case postfix(Expression, Postfix)
    case constant(Constant)
    case parens(Expression)
    case identifier(String)
    case cast(Expression, type: ObjcType)
    case arrayLiteral([Expression])
    case dictionaryLiteral([ExpressionDictionaryPair])
    case ternary(Expression, `true`: Expression, `false`: Expression)
    
    /// `true` if this expression node requires parenthesis for unary, prefix, and
    /// postfix operations.
    public var requiresParens: Bool {
        switch self {
        case .cast:
            return true
        default:
            return false
        }
    }
}

public struct ExpressionDictionaryPair: Equatable {
    public var key: Expression
    public var value: Expression
    
    public init(key: Expression, value: Expression) {
        self.key = key
        self.value = value
    }
}

/// A postfix expression type
public indirect enum Postfix: Equatable {
    case optionalAccess
    case member(String)
    case `subscript`(Expression)
    case functionCall(arguments: [FunctionArgument])
}

/// A function argument kind
public enum FunctionArgument: Equatable {
    case labeled(String, Expression)
    case unlabeled(Expression)
    
    public var expression: Expression {
        switch self {
        case .labeled(_, let exp), .unlabeled(let exp):
            return exp
        }
    }
}

/// One of the recognized constant values
public enum Constant: Equatable {
    case float(Float)
    case boolean(Bool)
    case int(Int)
    case binary(Int)
    case octal(Int)
    case hexadecimal(Int)
    case string(String)
    case rawConstant(String)
    case `nil`
}

/// Describes an operator across one or two operands
public enum SwiftOperator: String {
    /// If `true`, a spacing is suggested to be placed in between operands.
    /// True for most operators except range operators.
    public var requiresSpacing: Bool {
        switch self {
        case .openRange, .closedRange:
            return false
        default:
            return true
        }
    }
    
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
    
    case addAssign = "+="
    case subtractAssign = "-="
    case multiplyAssign = "*="
    case divideAssign = "/="
    
    case negate = "!"
    case and = "&&"
    case or = "||"
    
    case bitwiseAnd = "&"
    case bitwiseOr = "|"
    case bitwiseXor = "^"
    case bitwiseNot = "~"
    case bitwiseShiftLeft = "<<"
    case bitwiseShiftRight = ">>"
    
    case bitwiseAndAssign = "&="
    case bitwiseOrAssign = "|="
    case bitwiseXorAssign = "^="
    case bitwiseNotAssign = "~="
    case bitwiseShiftLeftAssign = "<<="
    case bitwiseShiftRightAssign = ">>="
    
    case lessThan = "<"
    case lessThanOrEqual = "<="
    case greaterThan = ">"
    case greaterThanOrEqual = ">="
    
    case assign = "="
    case equals = "=="
    case unequals = "!="
    
    case nullCoallesce = "??"
    
    case openRange = "..<"
    case closedRange = "..."
}

// MARK: - String Conversion

extension ExpressionDictionaryPair: CustomStringConvertible {
    public var description: String {
        return key.description + ": " + value.description
    }
}

extension Pattern: CustomStringConvertible {
    public var description: String {
        switch self.simplified {
        case .tuple(let tups):
            return "(" + tups.map({ $0.description }).joined(separator: ", ") + ")"
        case .identifier(let ident):
            return ident
        }
    }
}

extension Expression: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .assignment(lhs, op, rhs),
             let .binary(lhs, op, rhs):
            
            // With spacing
            if op.requiresSpacing {
                return "\(lhs.description) \(op) \(rhs.description)"
            }
            
            // No spacing
            return "\(lhs.description)\(op)\(rhs.description)"
        case let .unary(op, exp), let .prefix(op, exp):
            // Parenthesized
            if exp.requiresParens {
                return "\(op)(\(exp))"
            }
            
            return "\(op)\(exp)"
        case let .postfix(exp, op):
            // Parenthesized
            if exp.requiresParens {
                return "(\(exp))\(op)"
            }
            
            return "\(exp)\(op)"
        case .constant(let cst):
            return cst.description
        case .parens(let exp):
            return "(" + exp.description + ")"
        case .identifier(let id):
            return id
        case .cast(let exp, let type):
            let cvt = TypeMapper(context: TypeContext())
            
            return "\(exp) as? \(cvt.swiftType(forObjcType: type, context: .alwaysNonnull))"
        case .arrayLiteral(let exps):
            return "[\(exps.map { $0.description }.joined(separator: ", "))]"
            
        case .dictionaryLiteral(let pairs):
            if pairs.count == 0 {
                return "[:]"
            }
            
            return "[" + pairs.map { $0.description }.joined(separator: ", ") + "]"
            
        case let .ternary(exp, ifTrue, ifFalse):
            return
                exp.description + " ? " +
                    ifTrue.description + " : " +
                    ifFalse.description
        }
    }
}

extension Postfix: CustomStringConvertible {
    public var description: String {
        switch self {
        case .optionalAccess:
            return "?"
        case .member(let mbm):
            return "." + mbm
        case .subscript(let subs):
            return "[" + subs.description + "]"
        case .functionCall(let arguments):
            return "(" + arguments.map { $0.description }.joined(separator: ", ") + ")"
        }
    }
}

extension FunctionArgument: CustomStringConvertible {
    public var description: String {
        switch self {
        case .labeled(let lbl, let exp):
            return "\(lbl): \(exp)"
        case .unlabeled(let exp):
            return exp.description
        }
    }
}

extension Constant: CustomStringConvertible {
    public var description: String {
        switch self {
        case .float(let fl):
            return fl.description
        case .boolean(let bool):
            return bool.description
        case .int(let int):
            return int.description
        case .binary(let int):
            return "0b" + String(int, radix: 2)
        case .octal(let int):
            return "0o" + String(int, radix: 8)
        case .hexadecimal(let int):
            return "0x" + String(int, radix: 16, uppercase: false)
        case .string(let str):
            return "\"\(str)\""
        case .rawConstant(let str):
            return str
        case .nil:
            return "nil"
        }
    }
}

extension SwiftOperator: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}

// MARK: - Literal initialiation
extension Constant: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension Constant: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Float) {
        self = .float(value)
    }
}

extension Constant: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .boolean(value)
    }
}

extension Constant: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

// MARK: - Operator definitions
public extension Expression {
    public static func +(lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .add, rhs: rhs)
    }
    
    public static func -(lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .subtract, rhs: rhs)
    }
    
    public static func *(lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .multiply, rhs: rhs)
    }
    
    public static func /(lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .divide, rhs: rhs)
    }
    
    public static prefix func !(lhs: Expression) -> Expression {
        return .unary(op: .negate, lhs)
    }
    
    public static func &&(lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .and, rhs: rhs)
    }
    
    public static func ||(lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .or, rhs: rhs)
    }
    
    public static func |(lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .bitwiseOr, rhs: rhs)
    }
    
    public static func &(lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .bitwiseAnd, rhs: rhs)
    }
}
