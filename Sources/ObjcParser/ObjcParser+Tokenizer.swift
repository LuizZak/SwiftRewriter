import MiniLexer
import GrammarModels

// MARK: - Lexing extensions
public extension ObjcParser {
    /// Gets the token type for the current token
    public func tokenType() -> TokenType {
        return token().type
    }
    
    /// Reads the next token from the parser, without advancing
    public func token() -> Token {
        return currentToken
    }
    
    /// Reads all tokens up until the end of the file
    public func allTokens() -> [Token] {
        var toks: [Token] = []
        
        while tokenType() != .eof && tokenType() != .unknown {
            toks.append(nextToken())
        }
        
        return toks
    }
    
    /// Gets the current token, and skips to the next token on the string
    public func nextToken() -> Token {
        let tok = token()
        skipToken()
        return tok
    }
    
    /// Skips the current token up to the next
    public func skipToken() {
        if lexer.isEof() {
            return
        }
        
        switch currentToken.location {
        case .location:
            _=lexer.safeAdvance()
        case .range(let range):
            lexer.inputIndex = range.upperBound
        case .invalid:
            // This case is invalid!
            break
        }
        
        readCurrentToken()
    }
    
    /// Parses the current token under the read head
    internal func readCurrentToken() {
        lexer.withTemporaryIndex {
            _readToken()
        }
    }
    
    private func _readToken() {
        if lexer.isEof() {
            currentToken = Token(type: .eof, string: "", location: location())
            return
        }
        
        do {
            let p = try! lexer.peek()
            
            if isStringLiteralToken() {
                try readStringLiteralToken()
            } else if Lexer.isDigit(p) {
                try readNumberToken()
            } else if Lexer.isLetter(p) || p == "_" || p == "@" {
                if try !attemptReadKeywordToken() {
                    try readIdentifierToken()
                }
            }
        } catch {
            currentToken = Token(type: .eof, string: "", location: location())
        }
    }
    
    /// Tries to parse either a decimal, hexadecimal, octal or floating-point literal
    /// token.
    private func readNumberToken() throws {
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
    
    /// Returns true if the current read position can be parsed as a string literal
    /// token
    private func isStringLiteralToken() -> Bool {
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
    private func readStringLiteralToken() throws {
        let range = startRange()
        let str = try lexer.lexStringLiteral()
        
        currentToken =
            Token(type: .stringLiteral, string: String(str), location: range.makeLocation())
    }
    
    private func readIdentifierToken() throws {
        let range = startRange()
        let ident = try lexer.lexIdentifier()
        
        currentToken =
            Token(type: .identifier, string: String(ident), location: range.makeLocation())
    }
    
    private func attemptReadKeywordToken() throws -> Bool {
        let backtrack = backtracker()
        let range = startRange()
        
        if try lexer.peek() == "@" {
            try lexer.advance()
        }
        
        _=try lexer.lexIdentifier()
        
        let keyword = range.makeSubstring()
        
        if !ObjcParser.isKeyword(keyword) {
            backtrack.backtrack()
            return false
        }
        
        currentToken =
            Token(type: .keyword, string: String(keyword), location: range.makeLocation())
        
        return true
    }
    
    private static func isKeyword<S: StringProtocol>(_ value: S) -> Bool {
        return keywords.contains(where: { $0 == value })
    }
    
    private static let keywords: [String] = [
        "if", "else", "for", "while", "switch", "continue", "break", "return",
        "void", "@interface", "@implementation", "@property", "@end", "@protocol",
        "typedef", "struct", "enum"
    ]
}
