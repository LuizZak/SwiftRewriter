//
//  ObjcLexer.swift
//  ObjcParser
//
//  Created by Luiz Silva on 22/01/2018.
//

import MiniLexer
import GrammarModels

public class ObjcLexer {
    var lexer: Lexer
    var source: CodeSource
    
    /// Whether a token has been read yet by this parser
    var _hasReadToken: Bool = false
    internal(set) public var currentToken = Token(type: .eof, string: "",
                                                  location: .invalid)
    
    /// Whether to automatically skip over single/multi-comment tokens.
    /// Defaults to true.
    public var autoSkipComments: Bool = true
    
    /// Gets a value specifying whether the current token is pointing to the end
    /// of the valid source string.
    ///
    /// When `isEof` is `true`, no further token reading operations can be made,
    /// and `currentToken` remains the `TokenType.eof` token kind for the remainder
    /// of the lexer's lifetime.
    public var isEof: Bool {
        return lexer.isEof() || tokenType() == .eof
    }
    
    public init(source: CodeSource) {
        self.source = source
        self.lexer = Lexer(input: source.fetchSource())
    }
    
    /// Current lexer's location as a `SourceLocation`.
    func location() -> SourceLocation {
        return SourceLocation(source: source, range: locationAsRange())
    }
    
    /// Current lexer's location as a `SourceRange.location` enum case
    func locationAsRange() -> SourceRange {
        return currentToken.location.range
    }
    
    /// Attempts to consume a given token, failing with an error if the operation
    /// fails.
    /// After reading, the current token is advanced to the next.
    public func consume(tokenType: TokenType) throws -> Token {
        if self.tokenType() != tokenType {
            throw Error.unexpectedToken(received: self.tokenType(), expected: tokenType, at: location())
        }
        
        return nextToken()
    }
    
    /// Gets the token type for the current token
    public func tokenType() -> TokenType {
        return token().type
    }
    
    /// Returns whether the token type for the current token matches a given one
    public func tokenType(_ tok: TokenType) -> Bool {
        return tokenType() == tok
    }
    
    /// Reads the next token from the parser, without advancing
    public func token() -> Token {
        if !_hasReadToken {
            _readToken()
        }
        
        return currentToken
    }
    
    /// Reads all tokens up until the end of the file
    public func allTokens() -> [Token] {
        var toks: [Token] = []
        
        while !isEof && tokenType() != .unknown {
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
        
        if let index = token().location.range.end {
            lexer.inputIndex = index
            _readToken()
        }
    }
    
    /// Advances through the tokens until a predicate returns false for a token
    /// value.
    /// The method stops such that the next token is the first token the closure
    /// returned false to.
    /// The method returns automatically when end-of-file is reached.
    public func advance(until predicate: (Token) throws -> Bool) rethrows {
        while !isEof {
            if try predicate(token()) {
                return
            }
            
            skipToken()
        }
    }
    
    /// Advances through the tokens until a given token.
    ///
    /// The method stops such that the next token is the first token of the given
    /// type that was found.
    ///
    /// The method returns automatically when end-of-file is reached.
    public func advance(untilTokenType type: TokenType) {
        while !isEof {
            if tokenType(type) {
                return
            }
            
            skipToken()
        }
    }
    
    internal func _readToken() {
        let index = lexer.inputIndex
        defer {
            lexer.inputIndex = index
        }
        
        _hasReadToken = true
        
        lexer.skipWhitespace()
        
        if autoSkipComments {
            skipComments()
        }
        
        if lexer.isEof() {
            if currentToken.type != .eof {
                currentToken = Token(type: .eof, string: "", location: location())
            }
            
            return
        }
        
        do {
            let p = try! lexer.peek()
            
            if !autoSkipComments && attemptReadCommentToken() {
                // Done!
            } else if attemptReadPreprocessorDirective() {
               // Done!
            } else if isStringLiteralToken() {
                try readStringLiteralToken()
            } else if Lexer.isDigit(p) {
                try readNumberToken()
            } else if Lexer.isLetter(p) || p == "_" || p == "@" {
                if try !attemptReadKeywordToken() && !attemptReadQualifierToken() 
                {
                    if p == "@" {
                        _=try attemptReadSpecialChar()
                    } else {
                        try readIdentifierToken()
                    }
                }
            } else if try !attemptReadSpecialChar() {
                try readOperator()
            }
        } catch {
            currentToken = Token(type: .eof, string: "", location: .invalid)
        }
    }
    
    private func skipComments() {
        while lexer.advanceIf(equals: "//") {
            lexer.advance(until: { $0 == "\n" })
            if !lexer.safeAdvance() {
                return
            }
        }
        
        while lexer.advanceIf(equals: "/*") {
            while !lexer.isEof() {
                if !lexer.safeAdvance() {
                    return
                }
                
                if lexer.advanceIf(equals: "*/") {
                    break
                }
            }
        }
        
        lexer.skipWhitespace()
    }
    
    private func attemptReadCommentToken() -> Bool {
        let range = startRange()
        let tokenType: TokenType
        
        if lexer.advanceIf(equals: "//") {
            lexer.advance(until: { $0 == "\n" })
            _=lexer.safeAdvance()
            
            tokenType = .singleLineComment
        } else if lexer.advanceIf(equals: "/*") {
            let bk = backtracker()
            
            while !lexer.isEof() {
                if !lexer.safeAdvance() {
                    bk.backtrack()
                    return false
                }
                
                if lexer.advanceIf(equals: "*/") {
                    break
                }
            }
            
            tokenType = .multiLineComment
        } else {
            return false
        }
        
        currentToken =
            Token(type: tokenType, string: range.makeString(), location: range.makeLocation())
        
        return true
    }
    
    /// Parses a pre-processor directive token.
    /// Pre-processor tokens start with a '#' and end at the end of the line it's
    /// at.
    ///
    /// ```
    /// preprocessor_directive:
    ///    '#' ~[\n]* '\n'
    /// ```
    private func attemptReadPreprocessorDirective() -> Bool {
        // TODO: Have preprocessors only work if they are the first non-comment
        // token on a line.
        guard lexer.safeIsNextChar(equalTo: "#") else {
            return false
        }
        
        let range = startRange()
        let type = TokenType.preprocessorDirective
        
        lexer.advance(until: { $0 == "\n" })
        _=lexer.safeAdvance()
        
        currentToken =
            Token(type: type, string: range.makeString(), location: range.makeLocation())
        
        return true
    }
    
    private func readIdentifierToken() throws {
        let range = startRange()
        let ident = try lexer.lexIdentifier()
        var type = TokenType.identifier
        
        if ident == "id" {
            type = .id
        }
        
        currentToken =
            Token(type: type, string: String(ident), location: range.makeLocation())
    }
    
    private func attemptReadQualifierToken() -> Bool {
        let range = startRange()
        
        do {
            _=try lexer.lexTypeQualifier()
            currentToken =
                Token(type: .typeQualifier, string: range.makeString(),
                      location: range.makeLocation())
            
            return true
        } catch {
            return false
        }
    }
    
    private func attemptReadKeywordToken() throws -> Bool {
        let backtrack = backtracker()
        let range = startRange()
        
        if try lexer.peek() == "@" {
            try lexer.advance()
            
            if lexer.isEof() {
                backtrack.backtrack()
                return false
            }
        }
        
        _=try lexer.rewindOnFailure { try lexer.lexIdentifier() }
        
        let keyword = range.makeSubstring()
        
        guard let kw = Keyword(rawValue: String(keyword)) else {
            backtrack.backtrack()
            return false
        }
        
        currentToken =
            Token(type: .keyword(kw), string: String(keyword), location: range.makeLocation())
        
        return true
    }
    
    private func attemptReadSpecialChar() throws -> Bool {
        let range = startRange()
        let type: TokenType
        var length = 1
        
        switch try lexer.peek() {
        case "@":
            type = .at
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
        case "{":
            type = .openBrace
        case "}":
            type = .closeBrace
        case ".":
            if lexer.checkNext(matches: "...") {
                type = .ellipsis
                length = 3
            } else {
                type = .period
            }
        default:
            return false
        }
        
        try lexer.advanceLength(length)
        
        currentToken =
            Token(type: type, string: range.makeString(), location: range.makeLocation())
        
        return true
    }
    
    func startRange() -> RangeMarker {
        return _RangeMarker(objcLexer: self)
    }
    
    /// Creates and returns a backtracking point which can be activated to rewind
    /// the lexer to the point at which this method was called.
    func backtracker() -> Backtrack {
        return _Backtrack(lexer: self)
    }
    
    func rewindOnFailure<T>(_ block: () throws -> T) rethrows -> T {
        let bt = backtracker()
        
        do {
            return try block()
        } catch {
            bt.backtrack()
            throw error
        }
    }
    
    private struct _RangeMarker: RangeMarker {
        let objcLexer: ObjcLexer
        let index: Lexer.Index
        
        init(objcLexer: ObjcLexer) {
            self.objcLexer = objcLexer
            self.index = _RangeMarker.lexerIndex(in: objcLexer)
        }
        
        func makeSubstring() -> Substring {
            return objcLexer.lexer.inputString[rawRange()]
        }
        
        func makeRange() -> SourceRange {
            if index == _RangeMarker.lexerIndex(in: objcLexer) {
                return .location(index)
            }
            
            return .range(rawRange())
        }
        
        func makeLocation() -> SourceLocation {
            return SourceLocation(source: objcLexer.source, range: makeRange())
        }
        
        private func rawRange() -> Range<Lexer.Index> {
            return index..<_RangeMarker.lexerIndex(in: objcLexer)
        }
        
        private static func lexerIndex(in lexer: ObjcLexer) -> Lexer.Index {
            return lexer.lexer.inputIndex
        }
    }
    
    class _Backtrack: Backtrack {
        let lexer: ObjcLexer
        let index: Lexer.Index
        let token: Token
        let hasReadToken: Bool
        private var activated = false
        
        init(lexer: ObjcLexer) {
            self.lexer = lexer
            self.hasReadToken = lexer._hasReadToken
            self.index = lexer.lexer.inputIndex
            self.token = lexer.currentToken
        }
        
        func backtrack() {
            guard !activated else {
                return
            }
            
            lexer._hasReadToken = hasReadToken
            lexer.lexer.inputIndex = index
            lexer.currentToken = token
            
            activated = true
        }
    }
    
    public enum Error: Swift.Error, CustomStringConvertible {
        case unexpectedToken(received: TokenType, expected: TokenType, at: SourceLocation)
        
        public var description: String {
            switch self {
            case let .unexpectedToken(received, expected, location):
                return "Unexpected token at \(location.description): received \(received), but expected \(expected)"
            }
        }
    }
}

public protocol RangeMarker {
    func makeSubstring() -> Substring
    func makeString() -> String
    
    func makeLocation() -> SourceLocation
}

public extension RangeMarker {
    public func makeString() -> String {
        return String(makeSubstring())
    }
}

public protocol Backtrack: class {
    func backtrack()
}

/// Protocol for sourcing code strings from
public protocol CodeSource: Source {
    func fetchSource() -> String
}
