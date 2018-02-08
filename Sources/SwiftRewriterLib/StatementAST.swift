import GrammarModels

/// Encapsulates a compound statement, that is, a series of statements enclosed
/// within braces.
public struct CompoundStatement: Equatable {
    public var statements: [Statement] = []
    
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
    case `else`(Expression, body: CompoundStatement)
    case `while`(Expression, body: CompoundStatement)
    case `return`(Expression?)
    case `break`
    case `continue`
    case expression(Expression)
    case variableDeclaration(identifier: String, type: ObjcType, initialization: Expression?)
}

/// An expression
public indirect enum Expression: Equatable {
    case assignment(lhs: Expression, op: Operator, rhs: Expression)
    case binary(lhs: Expression, op: Operator, rhs: Expression)
    case unary(op: Operator, Expression)
    case prefix(op: Operator, Expression)
    case postfix(Expression, Postfix)
    case constant(Constant)
    case parens(Expression)
    case identifier(String)
}

/// A postfix expression type
public indirect enum Postfix: Equatable {
    case member(String)
    case `subscript`(Expression)
    case functionCall(arguments: [FunctionArgument])
}

/// A function argument kind
public enum FunctionArgument: Equatable {
    case labeled(String, Expression)
    case unlabeled(Expression)
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
    case `nil`
}

extension Expression: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .assignment(lhs, op, rhs),
             let .binary(lhs, op, rhs):
            return "\(lhs.description) \(op) \(rhs.description)"
        case let .unary(op, exp), let .prefix(op, exp):
            return "\(op)\(exp)"
        case let .postfix(exp, op):
            return "\(exp)\(op)"
        case .constant(let cst):
            return cst.description
        case .parens(let exp):
            return "(" + exp.description + ")"
        case .identifier(let id):
            return id
        }
    }
}

extension Postfix: CustomStringConvertible {
    public var description: String {
        switch self {
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
        case .nil:
            return "nil"
        }
    }
}
