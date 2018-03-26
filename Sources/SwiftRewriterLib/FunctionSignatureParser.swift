import SwiftAST
import MiniLexer
import Utils

/// Provides capabilities of parsing function signatures and argument arrays
/// from input strings.
public final class FunctionSignatureParser {
    private static let identifierLexer = (.letter | "_") + (.letter | "_" | .digit)*
    
    /// Parses an array of parameter signatures from a given input string.
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
    ///     : parameter-name ':' swift-type ('=' 'default')?
    ///     ;
    ///
    /// parameter-name
    ///     : identifier? identifier
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
        
        let lexer = Lexer(input: string)
        
        try lexer.advance(expectingCurrent: "(")
        lexer.skipWhitespace()
        
        var afterComma = false
        
        // Parse parameters one-by-one until no more parameters can be read:
        while !lexer.isEof() {
            // Parameter
            if lexer.safeNextCharPasses(with: { $0 == "_" || Lexer.isLetter($0) }) {
                afterComma = false
                
                let param = try parseParameter(lexer: lexer)
                
                parameters.append(param)
                
                lexer.skipWhitespace()
                if try lexer.peek() == "," {
                    try lexer.advance()
                    lexer.skipWhitespace()
                    afterComma = true
                }
                
                continue
            } else if lexer.safeIsNextChar(equalTo: ")") {
                break
            }
            
            throw LexerError.unexpectedCharacter(lexer.inputIndex,
                                                 char: try lexer.peek(),
                                                 message: "Expected ')'")
        }
        
        if afterComma {
            throw LexerError.syntaxError("Expected argument after ','")
        }
        
        try lexer.advance(expectingCurrent: ")")
        
        // Verify extraneous input
        lexer.skipWhitespace()
        
        if !lexer.isEof() {
            let rem = lexer.consumeRemaining()
            
            throw LexerError.syntaxError("Extraneous input '\(rem)'")
        }
        
        return parameters
    }
    
    private static func skipTypeAnnotations(lexer: Lexer) throws {
        lexer.skipWhitespace()
        
        while try lexer.peek() == "@" {
            try lexer.advance()
            try identifierLexer.stepThroughApplying(on: lexer)
            lexer.skipWhitespace()
        }
        
        // Inout marks the end of an attributes list
        _=lexer.advanceIf(equals: "inout ")
    }
    
    private static func parseParameter(lexer: Lexer) throws -> ParameterSignature {
        let label = try identifierLexer.consume(from: lexer)
        
        lexer.skipWhitespace()
        
        if try lexer.peek() == ":" {
            try lexer.advance()
            
            try skipTypeAnnotations(lexer: lexer)
            let type = try SwiftTypeParser.parse(from: lexer)
            
            return ParameterSignature(name: String(label), type: type)
        }
        
        let name = try identifierLexer.consume(from: lexer)
        
        lexer.skipWhitespace()
        
        try lexer.advance(expectingCurrent: ":")
        
        try skipTypeAnnotations(lexer: lexer)
        let type = try SwiftTypeParser.parse(from: lexer)
        
        return ParameterSignature(label: String(label), name: String(name), type: type)
    }
}
