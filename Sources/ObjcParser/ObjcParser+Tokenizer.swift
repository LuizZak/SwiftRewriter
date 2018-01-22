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
        if !_hasReadToken {
            lexer.skipWhitespace()
            _readToken()
        }
        
        return currentToken
    }
    
    /// Reads all tokens up until the end of the file
    public func allTokens() -> [Token] {
        var toks: [Token] = []
        
        while !lexer.isEof() && tokenType() != .eof && tokenType() != .unknown {
            toks.append(nextToken())
        }
        
        return toks
    }
    
    /// Gets the current token, and skips to the next token on the string
    public func nextToken() -> Token {
        lexer.skipWhitespace()
        
        let tok = token()
        _readToken()
        return tok
    }
    
    /// Skips the current token up to the next
    public func skipToken() {
        if lexer.isEof() {
            return
        }
        
        _readToken()
    }
    
    private func _readToken() {
        _hasReadToken = true
        
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
            } else if try !attemptReadSpecialChar() {
                try readOperator()
            }
        } catch {
            currentToken = Token(type: .eof, string: "", location: .invalid)
        }
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
    
    private func attemptReadSpecialChar() throws -> Bool {
        let range = startRange()
        let type: TokenType
        
        switch try lexer.peek() {
        case ":":
            type = .colon
        case ";":
            type = .semicolon
        case ",":
            type = .comma
        case "(":
            type = .openParens
        case ")":
            type = .closeParens
        case "[":
            type = .openSquareBracket
        case "]":
            type = .closeSquareBracket
        default:
            return false
        }
        
        try lexer.advance()
        
        currentToken =
            Token(type: type, string: String(range.makeSubstring()), location: range.makeLocation())
        
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
