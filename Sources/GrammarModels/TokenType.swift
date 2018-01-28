/// The type for a Token read by the lexer
public enum TokenType: Equatable {
    /// End-of-file token
    case eof
    case unknown
    
    case singleLineComment
    case multiLineComment
    
    case preprocessorDirective
    
    case decimalLiteral
    case floatLiteral
    case octalLiteral
    case hexLiteral
    case stringLiteral
    
    case id
    
    case identifier
    case typeQualifier
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

extension TokenType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .eof:
            return "<eof>"
        case .unknown:
            return "<unknown>"
        case .singleLineComment:
            return "single line comment"
        case .multiLineComment:
            return "multi-line comment"
        case .preprocessorDirective:
            return "preprocessor directive"
        case .decimalLiteral:
            return "decimal literal"
        case .floatLiteral:
            return "floating-point literal"
        case .octalLiteral:
            return "octal literal"
        case .hexLiteral:
            return "hexadecimal literal"
        case .stringLiteral:
            return "string literal"
        case .id:
            return "id"
        case .identifier:
            return "identifier"
        case .typeQualifier:
            return "type qualifier"
        case .keyword(let kw):
            return "'\(kw.rawValue)'"
        case .at:
            return "'@'"
        case .colon:
            return "':'"
        case .semicolon:
            return "';'"
        case .comma:
            return "','"
        case .ellipsis:
            return "'...'"
        case .period:
            return "'.'"
        case .openBrace:
            return "'{'"
        case .closeBrace:
            return "'}'"
        case .openParens:
            return "'('"
        case .closeParens:
            return "')'"
        case .openSquareBracket:
            return "'['"
        case .closeSquareBracket:
            return "']'"
        case .`operator`(let op):
            return op.description
        }
    }
}

/// Describes an operator across one or two operands
public enum Operator: Int {
    case add
    case subtract
    case multiply
    case divide
    
    case addAssign
    case subtractAssign
    case multiplyAssign
    case divideAssign
    
    case negate
    case and
    case or
    
    case bitwiseAnd
    case bitwiseOr
    case bitwiseXor
    case bitwiseNot
    case bitwiseShiftLeft
    case bitwiseShiftRight
    
    case bitwiseAndAssign
    case bitwiseOrAssign
    case bitwiseXorAssign
    case bitwiseNotAssign
    case bitwiseShiftLeftAssign
    case bitwiseShiftRightAssign
    
    case lessThan
    case lessThanOrEqual
    case greaterThan
    case greaterThanOrEqual
    
    case assign
    case equals
    case unequals
}

extension Operator: CustomStringConvertible {
    public var description: String {
        switch self {
        case .add:
            return "'+'"
        case .subtract:
            return "'-'"
        case .multiply:
            return "'*'"
        case .divide:
            return "'/'"
        case .addAssign:
            return "'+='"
        case .subtractAssign:
            return "'-='"
        case .multiplyAssign:
            return "'*='"
        case .divideAssign:
            return "'/='"
        case .negate:
            return "'!'"
        case .and:
            return "'&&'"
        case .or:
            return "'||'"
        case .bitwiseAnd:
            return "'&'"
        case .bitwiseOr:
            return "'|'"
        case .bitwiseXor:
            return "'^'"
        case .bitwiseNot:
            return "'~'"
        case .bitwiseShiftLeft:
            return "'<<'"
        case .bitwiseShiftRight:
            return "'>>'"
        case .bitwiseAndAssign:
            return "'&='"
        case .bitwiseOrAssign:
            return "'|='"
        case .bitwiseXorAssign:
            return "'^='"
        case .bitwiseNotAssign:
            return "'~='"
        case .bitwiseShiftLeftAssign:
            return "'<<='"
        case .bitwiseShiftRightAssign:
            return "'>>='"
        case .lessThan:
            return "'<'"
        case .lessThanOrEqual:
            return "'<='"
        case .greaterThan:
            return "'>'"
        case .greaterThanOrEqual:
            return "'>='"
        case .assign:
            return "'='"
        case .equals:
            return "'=='"
        case .unequals:
            return "'!='"
        }
    }
}
