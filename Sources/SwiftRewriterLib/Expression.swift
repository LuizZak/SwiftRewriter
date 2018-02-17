import GrammarModels

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
    case cast(Expression, type: SwiftType)
    case arrayLiteral([Expression])
    case dictionaryLiteral([ExpressionDictionaryPair])
    case ternary(Expression, `true`: Expression, `false`: Expression)
    case block(parameters: [BlockParameter], `return`: SwiftType, body: CompoundStatement)
    case unknown(UnknownASTContext)
    
    /// `true` if this expression node requires parenthesis for unary, prefix, and
    /// postfix operations.
    public var requiresParens: Bool {
        switch self {
        case .cast, .block, .ternary:
            return true
        default:
            return false
        }
    }
}

public struct BlockParameter: Equatable {
    var name: String
    var type: SwiftType
    
    public init(name: String, type: SwiftType) {
        self.name = name
        self.type = type
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
    
    public var label: String? {
        switch self {
        case .labeled(let label, _):
            return label
        case .unlabeled:
            return nil
        }
    }
    
    public var isLabeled: Bool {
        switch self {
        case .labeled:
            return true
        case .unlabeled:
            return false
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
    
    /// Returns an integer value if this constant represents one, or nil, in case
    /// it does not.
    public var integerValue: Int? {
        switch self {
        case .int(let i), .binary(let i), .octal(let i), .hexadecimal(let i):
            return i
        default:
            return nil
        }
    }
    
    /// Returns `true` if this constant represents an integer value.
    public var isInteger: Bool {
        switch self {
        case .int, .binary, .octal, .hexadecimal:
            return true
        default:
            return false
        }
    }
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
    
    case mod = "%"
    
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
            
            return "\(exp) as? \(cvt.typeNameString(for: type))"
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
            
        case let .block(parameters, ret, _):
            let cvt = TypeMapper(context: TypeContext())
            
            var buff = "{ "
            
            buff += "("
            buff += parameters.map { $0.description }.joined(separator: ", ")
            buff += ") -> "
            buff += cvt.typeNameString(for: ret)
            buff += " in "
            
            buff += "< body >"
            
            buff += " }"
            
            return buff
            
        case .unknown(let context):
            return context.description
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

extension BlockParameter: CustomStringConvertible {
    public var description: String {
        let cvt = TypeMapper(context: TypeContext())
        
        return "\(self.name): \(cvt.typeNameString(for: type))"
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
