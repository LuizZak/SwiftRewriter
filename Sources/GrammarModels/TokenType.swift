/// The type for a Token read by the lexer
public enum TokenType {
    /// End-of-file token
    case eof
    case unknown
    
    case decimalLiteral
    case floatLiteral
    case octalLiteral
    case hexLiteral
    case stringLiteral
    
    case identifier
    case keyword
    
    case colon
    case semicolon
    case comma
    
    case openBrace
    case closeBrace
    
    case openParens
    case closeParens
    
    case openSquareBracket
    case closeSquareBracket
    
    case `operator`(Operator)
    
    public var isOperator: Bool {
        switch self {
        case .operator:
            return true
        default:
            return false
        }
    }
    
    public var `operator`: Operator? {
        switch self {
        case .operator(let op):
            return op
        default:
            return nil
        }
    }
}

extension TokenType: Equatable {
    public static func ==(lhs: TokenType, rhs: TokenType) -> Bool {
        switch (lhs, rhs) {
        case (.eof, .eof),
             (.unknown, .unknown),
             (.decimalLiteral, .decimalLiteral),
             (.floatLiteral, .floatLiteral),
             (.octalLiteral, .octalLiteral),
             (.hexLiteral, .hexLiteral),
             (.stringLiteral, .stringLiteral),
             (.identifier, .identifier),
             (.keyword, .keyword),
             (.comma, .comma),
             (.colon, .colon),
             (.semicolon, .semicolon),
             (.openBrace, .openBrace),
             (.openParens, .openParens),
             (.openSquareBracket, .openSquareBracket),
             (.closeBrace, .closeBrace),
             (.closeParens, .closeParens),
             (.closeSquareBracket, .closeSquareBracket):
            return true
        case let (.operator(l), .operator(r)):
            return l == r
        default:
            return false
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
