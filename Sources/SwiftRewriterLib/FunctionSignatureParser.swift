import SwiftAST
import MiniLexer
import Utils

/// Provides capabilities of parsing function signatures and argument arrays
/// from input strings.
public final class FunctionSignatureParser {
    private typealias Tokenizer = TokenizerLexer<FullToken<Token>>
    
    /// Parses an array of parameter signatures from a given input string.
    ///
    /// Input must contain the argument list enclosed within their respective
    /// parenthesis - e.g. the following string produces the following parameter
    /// signatures:
    ///
    /// ```
    /// (_ arg0: Int, arg1: String?)
    /// ```
    /// resulting parameters:
    /// ```
    /// [
    ///   ParameterSignature(label: "_", name: "arg0", type: .typeName("Int")),
    ///   ParameterSignature(name: "arg1", type: .optional(.typeName("String")))
    /// ]
    /// ```
    ///
    /// Formal grammar of parameters signature:
    ///
    /// ```
    /// parameter-signature
    ///     : '(' parameter-list? ')'
    ///     ;
    ///
    /// parameter-list
    ///     : parameter (',' parameter)*
    ///     ;
    ///
    /// parameter
    ///     : parameter-name ':' parameter-attribute-list? swift-type ('=' 'default')?
    ///     ;
    ///
    /// parameter-name
    ///     : identifier? identifier
    ///     ;
    ///
    /// parameter-attribute-list
    ///     : parameter-attribute parameter-attribute-list?
    ///     : 'inout'
    ///     ;
    ///
    /// parameter-attribute
    ///     : '@' identifier
    ///     ;
    ///
    /// identifier
    ///     : [a-zA-Z_] [a-zA-Z_0-9]+
    ///     ;
    /// ```
    ///
    /// Support for parsing Swift types is borrowed from `SwiftTypeParser`.
    ///
    /// - Parameter string: The input string to parse, containing the parameter
    /// list enclosed within parenthesis.
    /// - Returns: An array of parameter signatures from the input string.
    /// - Throws: Lexing errors, if string is malformed.
    public static func parseParameters(from string: String) throws -> [ParameterSignature] {
        var parameters: [ParameterSignature] = []
        
        let tokenizer = Tokenizer(input: string)
        
        try tokenizer.advance(overTokenType: .openParens)
        
        var afterComma = false
        
        // Parse parameters one-by-one until no more parameters can be read:
        while !tokenizer.isEof {
            if tokenizer.tokenType(is: .underscore) || tokenizer.tokenType(is: .identifier) {
                afterComma = false
                
                let param = try parseParameter(tokenizer: tokenizer)
                
                parameters.append(param)
                
                if tokenizer.consumeToken(ifTypeIs: .comma) != nil {
                    afterComma = true
                }
                
                continue
            } else if tokenizer.tokenType(is: .closeParens) {
                break
            }
            
            throw LexerError.unexpectedCharacter(tokenizer.lexer.inputIndex,
                                                 char: try tokenizer.lexer.peek(),
                                                 message: "Expected ')'")
        }
        
        if afterComma {
            throw tokenizer.lexer.syntaxError("Expected argument after ','")
        }
        
        try tokenizer.advance(overTokenType: .closeParens)
        
        // Verify extraneous input
        if !tokenizer.lexer.isEof() {
            let index = tokenizer.lexer.inputIndex
            let rem = tokenizer.lexer.consumeRemaining()
            
            throw LexerError.syntaxError(index, "Extraneous input '\(rem)'")
        }
        
        return parameters
    }
    
    private static func skipTypeAnnotations(tokenizer: Tokenizer) throws {
        while tokenizer.consumeToken(ifTypeIs: .at) != nil {
            try tokenizer.advance(overTokenType: .identifier)
        }
        
        // Inout marks the end of an attributes list
        tokenizer.consumeToken(ifTypeIs: .inout)
    }
    
    private static func parseParameter(tokenizer: Tokenizer) throws -> ParameterSignature {
        let label: String?
        if tokenizer.tokenType(is: .underscore) {
            try tokenizer.advance(overTokenType: .underscore)
            label = nil
        } else {
            label = String(try tokenizer.advance(overTokenType: .identifier).value)
        }
        
        if tokenizer.consumeToken(ifTypeIs: .colon) != nil {
            guard let label = label else {
                throw tokenizer.lexer.syntaxError("Expected argument name after '_'")
            }
            
            try skipTypeAnnotations(tokenizer: tokenizer)
            
            let type = try SwiftTypeParser.parse(from: tokenizer.lexer)
            
            return ParameterSignature(name: label, type: type)
        }
        
        let name = try tokenizer.advance(overTokenType: .identifier).value
        
        try tokenizer.advance(overTokenType: .colon)
        
        try skipTypeAnnotations(tokenizer: tokenizer)
        let type = try SwiftTypeParser.parse(from: tokenizer.lexer)
        
        return ParameterSignature(label: label, name: String(name), type: type)
    }
    
    private enum Token: String, TokenProtocol {
        private static let identifierLexer = (.letter | "_") + (.letter | "_" | .digit)*
        
        case openParens = "("
        case closeParens = ")"
        case colon = ":"
        case comma = ","
        case at = "@"
        case underscore = "_"
        case `inout`
        case identifier
        case eof
        
        func advance(in lexer: Lexer) throws {
            let len = length(in: lexer)
            guard len > 0 else {
                throw LexerError.miscellaneous("Cannot advance")
            }
            
            try lexer.advanceLength(len)
        }
        
        func length(in lexer: Lexer) -> Int {
            switch self {
            case .openParens, .closeParens, .colon, .comma, .underscore, .at:
                return 1
            case .inout:
                return 5
            case .identifier:
                return Token.identifierLexer.maximumLength(in: lexer) ?? 0
            case .eof:
                return 0
            }
        }
        
        var tokenString: String {
            return rawValue
        }
        
        static func tokenType(at lexer: Lexer) -> FunctionSignatureParser.Token? {
            if lexer.isEof() {
                return .eof
            }
            
            if lexer.safeIsNextChar(equalTo: "_") {
                return lexer.withTemporaryIndex {
                    try? lexer.advance()
                    
                    if lexer.safeNextCharPasses(with: { !Lexer.isLetter($0) && !Lexer.isDigit($0) && $0 != "_" }) {
                        return .underscore
                    }
                    
                    return .identifier
                }
            }
            
            guard let next = try? lexer.peek() else {
                return nil
            }
            
            if Lexer.isLetter(next) {
                let ident = try? lexer.withTemporaryIndex { try identifierLexer.consume(from: lexer) }
                if ident == "inout" {
                    return .inout
                }
                
                return .identifier
            }
            
            if let token = Token(rawValue: String(next)) {
                return token
            }
            
            return nil
        }
        
        static var eofToken: Token = .eof
    }
}
