/// The type for a Token read by the lexer
public enum TokenType: Int {
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
    
    case openBrace
    case closeBrace
    
    case openParens
    case closeParens
    
    case openSquareBracket
    case closeSquareBracket
    
    case colon
    case semicolon
    case minusSign
    case plusSign
    case multiplicationSign
    case divisionSign
}
