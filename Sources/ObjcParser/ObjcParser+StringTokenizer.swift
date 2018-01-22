import MiniLexer
import GrammarModels

extension ObjcParser {
    /// Parses a string literal at the current position
    internal func readStringLiteralToken() throws {
        let range = startRange()
        let str = try lexer.lexStringLiteral()
        
        currentToken =
            Token(type: .stringLiteral, string: String(str), location: range.makeLocation())
    }
    
    /// Returns true if the current read position can be parsed as a string literal
    /// token
    internal func isStringLiteralToken() -> Bool {
        do {
            let p = try lexer.peek()
            
            if p == "\"" {
                return true
            }
            if lexer.isEof(offsetBy: 1) {
                return false
            }
            
            // 'L' long C-strings/'@' Objective-C string literals
            let p2 = try lexer.peekForward()
            
            return (p == "@" || p == "L") && p2 == "\""
        } catch {
            return false
        }
    }
}
