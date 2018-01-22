import MiniLexer
import GrammarModels

extension ObjcLexer {
    /// Tries to parse either a decimal, hexadecimal, octal or floating-point
    /// literal token.
    internal func readNumberToken() throws {
        let range = startRange()
        var string: Substring
        var type: TokenType = .eof
        
        if lexer.safeIsNextChar(equalTo: "0") {
            // Hexadecimal or octal?
            if try !lexer.isEof(offsetBy: 1) && (lexer.peekForward() == "x" || lexer.peekForward() == "X") {
                string = try lexer.lexHexLiteral()
                type = .hexLiteral
            } else if try !lexer.isEof(offsetBy: 1) && Lexer.isDigit(lexer.peekForward()) {
                string = try lexer.lexOctalLiteral()
                
                type = .octalLiteral
            } else {
                string = try lexer.lexDecimalLiteral()
                type = .decimalLiteral
            }
        } else {
            let isFloat: Bool = lexer.withTemporaryIndex {
                lexer.advance(while: Lexer.isDigit)
                if lexer.safeIsNextChar(equalTo: "e") ||
                    lexer.safeIsNextChar(equalTo: "E") ||
                    lexer.safeIsNextChar(equalTo: ".") {
                    return true
                }
                
                return false
            }
            
            if isFloat {
                string = try lexer.lexFloatingPointLiteral()
                type = .floatLiteral
            } else {
                string = try lexer.lexDecimalLiteral()
                type = .decimalLiteral
            }
        }
        
        currentToken =
            Token(type: type, string: String(string), location: range.makeLocation())
    }
}
