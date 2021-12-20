/// The type for a Token read by the lexer
public enum ObjcTokenType: Equatable {
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
    case keyword(ObjcKeyword)
    
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
    
    case `operator`(ObjcOperator)
}

public extension ObjcTokenType {
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

extension ObjcTokenType: CustomStringConvertible {
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
