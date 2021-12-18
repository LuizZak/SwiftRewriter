/// The type for a Token read by the lexer
public enum TokenType: Equatable {
    /// End-of-file token
    case eof
    case unknown
    
    case decimalLiteral(String)
    case floatLiteral(String)
    case octalLiteral(String)
    case hexLiteral(String)
    case stringLiteral(String)
    
    case id
    
    case identifier(String)
    case typeQualifier(String)
    case keyword(Keyword)
    
    case at
    
    case colon
    case semicolon
    case comma
    case period
    case ellipsis
    
    case openBrace
    case closeBrace
    
    case openParens
    case closeParens
    
    case openSquareBracket
    case closeSquareBracket
    
    case `operator`(Operator)
}

public extension TokenType {
    var isTypeQualifier: Bool {
        switch self {
        case .typeQualifier:
            return true
        default:
            return false
        }
    }
    
    var isIdentifier: Bool {
        switch self {
        case .identifier:
            return true
        default:
            return false
        }
    }
}

/// Describes an operator across one or two operands
public enum Operator: String {
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
}

extension TokenType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .eof, .unknown:
            return ""
        case .decimalLiteral:
            return "decimal literal"
        case .floatLiteral:
            return "float literal"
        case .octalLiteral:
            return "octal literal"
        case .hexLiteral:
            return "hex literal"
        case .stringLiteral:
            return "string literal"
        case .id:
            return "id"
        case .identifier:
            return "identifier"
        case .typeQualifier:
            return "type qualifier"
        case .keyword(let kw):
            return kw.rawValue
        case .at:
            return "@"
        case .colon:
            return ":"
        case .semicolon:
            return ";"
        case .comma:
            return ","
        case .period:
            return "."
        case .ellipsis:
            return "..."
        case .openBrace:
            return "{"
        case .closeBrace:
            return "}"
        case .openParens:
            return "("
        case .closeParens:
            return ")"
        case .openSquareBracket:
            return "["
        case .closeSquareBracket:
            return "]"
        case .operator(let op):
            return op.rawValue
        }
    }
}
