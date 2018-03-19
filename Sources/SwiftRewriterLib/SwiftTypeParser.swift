import SwiftAST
import MiniLexer

/// Support for parsing of Swift type signatures into `SwiftType` structures.
public class SwiftTypeParser {
    /// Parses a Swift type from a given type string
    public static func parse(from string: String) throws -> SwiftType {
        let lexer = Lexer(input: string)
        
        return try parseType(lexer)
    }
    
    ///
    /// ```
    /// swift-type
    ///     : tuple
    ///     | block
    ///     | array
    ///     | dictionary
    ///     | type-identifier
    ///     | optional
    ///     | implicitly-unwrapped-optional
    ///     | protocol-composition
    ///     | metatype
    ///     ;
    ///
    /// tuple
    ///     : '(' tuple-element (',' tuple-element)* ')' ;
    /// tuple-element
    ///     : swift-type
    ///     | identifier ':' swift-type
    ///     ;
    ///
    /// array
    ///     : '[' type ']' ;
    ///
    /// block
    ///     : '(' block-argument-list ')' '->' swift-type ;
    ///
    /// optional
    ///     : swift-type '?' ;
    ///
    /// implicitly-unwrapped-optional
    ///     : swift-type '!' ;
    ///
    /// protocol-composition
    ///     : swift-type '&' swift-type ('&' swift-type)* ;
    ///
    /// meta-type
    ///     : swift-type '.' 'Type'
    ///     | swift-type '.' 'Protocol'
    ///     ;
    ///
    /// type-identifier
    ///     : identifier generic-argument-clause?
    ///     | identifier generic-argument-clause? '.' type-identifier
    ///     ;
    ///
    /// generic-argument-clause
    ///     : '<' swift-type (',' swift-type)* '>'
    ///
    /// -- Block
    /// block-argument-list
    ///     : block-argument (',' block-argument)* ;
    ///
    /// block-argument
    ///     : (argument-label identifier? ':') swift-type ;
    ///
    /// argument-label
    ///     : '_'
    ///     | identifier
    ///     ;
    ///
    /// -- Atoms
    /// identifier
    ///     : (letter | '_') (letter | '_' | digit)+ ;
    ///
    /// letter : [a-zA-Z]
    ///
    /// digit : [0-9]
    /// ```
    private static func parseType(_ lexer: Lexer) throws -> SwiftType {
        let identifier = (.letter | "_") .. (.letter | "_" | .digit)+
        
        
        
        throw Error.invalidType
    }
    
    private static func parseBlock(_ lexer: Lexer) throws -> (returnType: SwiftType, parameters: [SwiftType]) {
        var returnType: SwiftType
        var parameters: [SwiftType] = []
        
        lexer.skipWhitespace()
        try lexer.advance(expectingCurrent: "(")
        lexer.skipWhitespace()
        
        var afterComma = false
        while !lexer.safeIsNextChar(equalTo: "(") {
            parameters.append(try parseType(lexer))
            lexer.skipWhitespace()
            
            if lexer.advanceIf(equals: ",") {
                lexer.skipWhitespace()
                
                afterComma = true
            }
        }
        
        try lexer.advance(expectingCurrent: ")")
        lexer.skipWhitespace()
        
        if !lexer.advanceIf(equals: "->") {
            throw Error.invalidType
        }
        
        lexer.skipWhitespace()
        
        returnType = try parseType(lexer)
        
        return (returnType, parameters)
    }
    
    public enum Error: Swift.Error {
        case invalidType
    }
}

private extension Lexer {
    func canConsume(_ rule: GrammarRule) -> Bool {
        do {
            return try withTemporaryIndex {
                _=try rule.consume(from: self)
                
                return true
            }
        } catch {
            return false
        }
    }
}

private class TokenizerLexer<T: TokenType> {
    let lexer: Lexer
    private var hasStarted = false
    private var current = Token(value: "", tokenType: T.eofToken())
    
    public init(lexer: Lexer) {
        self.lexer = lexer
    }
    
    public convenience init(string: String) {
        self.init(lexer: Lexer(input: string))
    }
    
    public func nextToken() -> Token? {
        guaranteeRead()
        
        return current
    }
    
    public func token(_ type: T) -> Bool {
        guaranteeRead()
        
        return current.tokenType == type
    }
    
    private func guaranteeRead() {
        if hasStarted {
            return
        }
        
        readToken()
    }
    
    private func readToken() {
        if lexer.isEof() {
            current =
                Token(value: "",
                      tokenType: T.eofToken())
            return
        }
        
        let start = lexer.inputIndex
        
        guard let token = T.parseToken(lexer: lexer) else {
            return
        }
        
        current = Token(value: String(lexer.inputString[start..<lexer.inputIndex]),
                        tokenType: token)
    }
    
    public struct Token {
        var value: String
        var tokenType: T
    }
}

public protocol TokenType: Equatable {
    static func eofToken() -> Self
    static func parseToken(lexer: Lexer) -> Self?
}

public enum SwiftTypeTokens: TokenType {
    case openParens
    case closeParens
    case identifier
    case eof
    
    public static func eofToken() -> SwiftTypeTokens {
        return .eof
    }
    
    public static func parseToken(lexer: Lexer) -> SwiftTypeTokens? {
        if lexer.safeIsNextChar(equalTo: "(") {
            _=lexer.safeAdvance()
            return .openParens
        }
        
        if lexer.safeIsNextChar(equalTo: ")") {
            _=lexer.safeAdvance()
            return .closeParens
        }
        
        return nil
    }
}

