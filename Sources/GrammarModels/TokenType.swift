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
