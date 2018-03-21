import SwiftAST
import MiniLexer

/// Support for parsing of Swift type signatures into `SwiftType` structures.
public class SwiftTypeParser {
    /// Parses a Swift type from a given type string
    public static func parse(from string: String) throws -> SwiftType {
        let lexer = TokenizerLexer<SwiftTypeToken>(input: string)
        
        return try parseType(lexer)
    }
    
    /// Swift type grammar
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
    ///
    /// tuple-element
    ///     : swift-type
    ///     | identifier ':' swift-type
    ///     ;
    ///
    /// block
    ///     : '(' block-argument-list ')' '->' swift-type ;
    ///
    /// array
    ///     : '[' type ']' ;
    ///
    /// dictionary
    ///     : '[' type ':' type ']' ;
    ///
    /// type-identifier
    ///     : identifier generic-argument-clause?
    ///     | identifier generic-argument-clause? '.' type-identifier
    ///     ;
    ///
    /// generic-argument-clause
    ///     : '<' swift-type (',' swift-type)* '>'
    ///
    /// optional
    ///     : swift-type '?' ;
    ///
    /// implicitly-unwrapped-optional
    ///     : swift-type '!' ;
    ///
    /// protocol-composition
    ///     : type-identifier '&' type-identifier ('&' type-identifier)* ;
    ///
    /// meta-type
    ///     : swift-type '.' 'Type'
    ///     | swift-type '.' 'Protocol'
    ///     ;
    ///
    /// -- Block
    /// block-argument-list
    ///     : block-argument (',' block-argument)* ;
    ///
    /// block-argument
    ///     : (argument-label identifier? ':') 'inout'? swift-type ;
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
    private static func parseType(_ lexer: TokenizerLexer<SwiftTypeToken>) throws -> SwiftType {
        let type: SwiftType
        
        if lexer.hasNextToken(.identifier) {
            let ident = try parseTypeIdentifier(lexer)
            
            // Protocol type composition
            if lexer.hasNextToken(.ampersand) {
                type = try verifyProtocolCompositionTrailing(after: [ident], lexer: lexer)
            } else {
                type = ident
            }
        } else if lexer.hasNextToken(.openBrace) {
            type = try parseArrayOrDictionary(lexer)
        } else if lexer.hasNextToken(.openParens) {
            type = try parseTupleOrBlock(lexer)
        } else {
            throw unexpectedTokenError(lexer: lexer)
        }
        
        return try verifyTrailing(after: type, lexer: lexer)
    }
    
    /// Parses an identifier type.
    ///
    /// ```
    /// type-identifier
    ///     : identifier generic-argument-clause?
    ///     | identifier generic-argument-clause? '.' type-identifier
    ///     ;
    ///
    /// generic-argument-clause
    ///     : '<' swift-type (',' swift-type)* '>'
    /// ```
    private static func parseTypeIdentifier(_ lexer: TokenizerLexer<SwiftTypeToken>, chainedAfter parentType: SwiftType? = nil) throws -> SwiftType {
        guard let identifier = lexer.consumeToken(.identifier) else {
            throw unexpectedTokenError(lexer: lexer)
        }
        
        // Type-alias 'Void' into an empty tuple (SwiftType.void)
        if identifier.value == "Void" {
            if parentType != nil {
                throw Error.invalidType
            }
            
            return .void
        }
        
        // Attempt a generic type parse
        var type = try verifyGenericArgumentsTrailing(after: String(identifier.value), lexer: lexer)
        
        // Chained access to sub-types
        let periodBT = lexer.backtracker()
        if lexer.consumeToken(.period) != nil {
            // Backtrack out of this method, in case it's actually a metatype
            // trailing
            let identBT = lexer.backtracker()
            if let identifier = lexer.consumeToken(.identifier)?.value,
                identifier == "Type" || identifier == "Protocol" {
                periodBT.backtrack()
                return type
            }
            
            identBT.backtrack()
            
            type = .nested(type, try parseTypeIdentifier(lexer, chainedAfter: type))
        }
        
        return type
    }
    
    /// Parses a protocol composition for an identifier type.
    ///
    /// ```
    /// protocol-composition
    ///     : type-identifier '&' type-identifier ('&' type-identifier)* ;
    /// ```
    private static func verifyProtocolCompositionTrailing(after types: [SwiftType],
                                                          lexer: TokenizerLexer<SwiftTypeToken>) throws -> SwiftType {
        var types = types
        
        while lexer.consumeToken(.ampersand) != nil {
            // If we find a parenthesis, unwrap the tuple (if it's a tuple) and
            // check if all its inner types are nominal, then it's a composable
            // type.
            if lexer.hasNextToken(.openParens) {
                let toParens = lexer.backtracker()
                
                let type = try parseType(lexer)
                if !type.isProtocolComposable {
                    toParens.backtrack()
                    
                    throw notProtocolComposableError(type: type, lexer: lexer)
                } else {
                    types.append(type)
                }
            } else {
                types.append(try parseTypeIdentifier(lexer))
            }
        }
        
        return .protocolComposition(types)
    }
    
    /// Parses a generic argument clause.
    ///
    /// ```
    /// generic-argument-clause
    ///     : '<' swift-type (',' swift-type)* '>'
    /// ```
    private static func verifyGenericArgumentsTrailing(after typeName: String, lexer: TokenizerLexer<SwiftTypeToken>) throws -> SwiftType {
        guard lexer.consumeToken(.openBracket) != nil else {
            return SwiftType.typeName(typeName)
        }
        
        var afterComma = false
        var types: [SwiftType] = []
        
        repeat {
            afterComma = false
            
            types.append(try parseType(lexer))
            
            if lexer.consumeToken(.comma) != nil {
                afterComma = true
                continue
            }
            try lexer.advance(over: .closeBracket)
            break
        } while !lexer.isEof
        
        if afterComma {
            throw expectedTypeNameError(lexer: lexer)
        }
        
        return SwiftType.generic(typeName, parameters: types)
    }
    
    /// Parses an array or dictionary type.
    ///
    /// ```
    /// array
    ///     : '[' type ']' ;
    ///
    /// dictionary
    ///     : '[' type ':' type ']' ;
    /// ```
    private static func parseArrayOrDictionary(_ lexer: TokenizerLexer<SwiftTypeToken>) throws -> SwiftType {
        try lexer.advance(over: .openBrace)
        
        let type1 = try parseType(lexer)
        var type2: SwiftType?
        
        if lexer.hasNextToken(.colon) {
            lexer.consumeToken(.colon)
            
            type2 = try parseType(lexer)
        }
        
        try lexer.advance(over: .closeBrace)
        
        if let type2 = type2 {
            return .dictionary(key: type1, value: type2)
        }
        
        return .array(type1)
    }
    
    /// Parses a tuple or block type
    ///
    /// ```
    /// tuple
    ///     : '(' tuple-element (',' tuple-element)* ')' ;
    ///
    /// tuple-element
    ///     : swift-type
    ///     | identifier ':' swift-type
    ///     ;
    ///
    /// block
    ///     : '(' block-argument-list ')' '->' swift-type ;
    ///
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
    /// ```
    private static func parseTupleOrBlock(_ lexer: TokenizerLexer<SwiftTypeToken>) throws -> SwiftType {
        var returnType: SwiftType
        var parameters: [SwiftType] = []
        
        try lexer.advance(over: .openParens)
        
        var afterComma = false
        while !lexer.hasNextToken(.closeParens) {
            afterComma = false
            
            // Inout label
            var handledInout = false
            if lexer.consumeToken(.inout) != nil {
                handledInout = true
            }
            
            // If we see an 'inout', skip identifiers and force a parameter type
            // to be read
            if !handledInout {
                // Check if we're handling a label
                let hasSingleLabel: Bool = lexer.backtracking {
                    return (lexer.consumeToken(.identifier) != nil && lexer.consumeToken(.colon) != nil)
                }
                let hasDoubleLabel: Bool = lexer.backtracking {
                    return (lexer.consumeToken(.identifier) != nil && lexer.consumeToken(.identifier) != nil && lexer.consumeToken(.colon) != nil)
                }
                
                if hasSingleLabel {
                    lexer.consumeToken(.identifier)
                    lexer.consumeToken(.colon)
                } else if hasDoubleLabel {
                    lexer.consumeToken(.identifier)
                    lexer.consumeToken(.identifier)
                    lexer.consumeToken(.colon)
                }
            }
            
            // Inout label
            if lexer.consumeToken(.inout) != nil {
                if handledInout {
                    throw unexpectedTokenError(lexer: lexer)
                }
            }
            
            parameters.append(try parseType(lexer))
            
            if lexer.consumeToken(.comma) != nil {
                afterComma = true
            } else if !lexer.hasNextToken(.closeParens) {
                throw unexpectedTokenError(lexer: lexer)
            }
        }
        
        if afterComma {
            throw expectedTypeNameError(lexer: lexer)
        }
        
        try lexer.advance(over: .closeParens)
        
        // It's a block if if features a function arrow afterwards...
        if lexer.consumeToken(.functionArrow) != nil {
            returnType = try parseType(lexer)
            
            return .block(returnType: returnType, parameters: parameters)
        }
        
        // ...otherwise it is a tuple
        
        // Check for protocol compositions (types must be all nominal)
        if lexer.hasNextToken(.ampersand) {
            if let notComposable = parameters.first(where: { !$0.isProtocolComposable }) {
                throw notProtocolComposableError(type: notComposable, lexer: lexer)
            }
            
            return try verifyProtocolCompositionTrailing(after: parameters, lexer: lexer)
        }
        
        if parameters.count == 1 {
            return parameters[0]
        }
        
        return .tuple(parameters)
    }
    
    private static func verifyTrailing(after type: SwiftType, lexer: TokenizerLexer<SwiftTypeToken>) throws -> SwiftType {
        // Meta-type
        if lexer.consumeToken(.period) != nil {
            guard let ident = lexer.consumeToken(.identifier)?.value else {
                throw unexpectedTokenError(lexer: lexer)
            }
            if ident != "Type" && ident != "Protocol" {
                throw expectedMetatypeError(lexer: lexer)
            }
            
            return try verifyTrailing(after: .metatype(for: type), lexer: lexer)
        }
        
        // Optional
        if lexer.consumeToken(.questionMark) != nil {
            return try verifyTrailing(after: .optional(type), lexer: lexer)
        }
        
        // Implicitly unwrapped optional
        if lexer.consumeToken(.exclamationMark) != nil {
            return try verifyTrailing(after: .implicitUnwrappedOptional(type), lexer: lexer)
        }
        
        return type
    }
    
    private static func expectedMetatypeError(lexer: TokenizerLexer<SwiftTypeToken>) -> Error {
        let index = indexOn(lexer: lexer)
        return .expectedMetatype(index)
    }
    
    private static func expectedTypeNameError(lexer: TokenizerLexer<SwiftTypeToken>) -> Error {
        let index = indexOn(lexer: lexer)
        return .expectedTypeName(index)
    }
    
    private static func unexpectedTokenError(lexer: TokenizerLexer<SwiftTypeToken>) -> Error {
        let index = indexOn(lexer: lexer)
        return .unexpectedToken(lexer.nextTokens()[0].tokenType, index)
    }
    
    private static func notProtocolComposableError(
        type: SwiftType, lexer: TokenizerLexer<SwiftTypeToken>) -> Error {
        
        let index = indexOn(lexer: lexer)
        return .notProtocolComposable(type, index)
    }
    
    private static func indexOn(lexer: TokenizerLexer<SwiftTypeToken>) -> Int {
        let input = lexer.lexer.inputString
        return input.distance(from: input.startIndex, to: lexer.lexer.inputIndex)
    }
    
    public enum Error: Swift.Error, CustomStringConvertible {
        case invalidType
        case expectedTypeName(Int)
        case expectedMetatype(Int)
        case notProtocolComposable(SwiftType, Int)
        case unexpectedToken(SwiftTypeToken, Int)
        
        public var description: String {
            switch self {
            case .invalidType:
                return "Invalid Swift type signature"
            case .expectedTypeName(let offset):
                return "Expected type name at column \(offset + 1)"
            case .expectedMetatype(let offset):
                return "Expected .Type or .Protocol metatype at column \(offset + 1)"
            case let .notProtocolComposable(type, offset):
                return "Found protocol composition, but type \(type) is not composable on composition '&' at column \(offset + 1)"
            case let .unexpectedToken(token, offset):
                return "Unexpected token \(token) at column \(offset + 1)"
            }
        }
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
    private var hasReadFirstToken = false
    private var available: [Token] = []
    
    let lexer: Lexer
    
    var isEof: Bool {
        return available == [Token(value: "", tokenType: T.eofToken)]
    }
    
    public init(lexer: Lexer) {
        self.lexer = lexer
    }
    
    public convenience init(input: String) {
        self.init(lexer: Lexer(input: input))
    }
    
    public func nextTokens() -> [Token] {
        ensureReadFirstToken()
        
        return available
    }
    
    public func advance(over tokenType: T) throws {
        if !available.contains(where: { $0.tokenType == tokenType }) {
            let l = tokenType.length(in: lexer)
            let msg = try lexer.withTemporaryIndex { try lexer.consumeLength(l) }
            throw LexerError.syntaxError("Missing expected token '\(msg)'")
        }
        
        try tokenType.advance(in: lexer)
        
        readToken()
    }
    
    public func hasNextToken(_ type: T) -> Bool {
        ensureReadFirstToken()
        
        return available.contains { $0.tokenType == type }
    }
    
    @discardableResult
    public func consumeToken(_ type: T) -> Token? {
        if let token = self.token(type) {
            try? type.advance(in: lexer)
            readToken()
            
            return token
        }
        
        return nil
    }
    
    public func token(_ type: T) -> Token? {
        ensureReadFirstToken()
        
        return available.first { $0.tokenType == type }
    }
    
    private func ensureReadFirstToken() {
        if hasReadFirstToken {
            return
        }
        
        hasReadFirstToken = true
        readToken()
    }
    
    private func readToken() {
        lexer.skipWhitespace()
        
        // Check all available tokens
        let possible = lexer.withTemporaryIndex { T.possibleTokens(at: lexer) }
        
        available = possible.filter { $0 != T.eofToken }.map {
            let length = $0.length(in: lexer)
            let endIndex = lexer.inputString.index(lexer.inputIndex, offsetBy: length)
            
            return Token(value: lexer.inputString[lexer.inputIndex..<endIndex], tokenType: $0)
        }
        
        if available.count == 0 {
            available = [Token(value: "", tokenType: T.eofToken)]
        }
    }
    
    public func backtracker() -> Backtrack {
        ensureReadFirstToken()
        
        return Backtrack(lexer: self)
    }
    
    public func backtracking<U>(do block: () throws -> (U)) rethrows -> U {
        let backtrack = backtracker()
        defer {
            backtrack.backtrack()
        }
        
        return try block()
    }
    
    public struct Token: Equatable {
        var value: Substring
        var tokenType: T
    }
    
    public class Backtrack {
        let lexer: TokenizerLexer
        let index: Lexer.Index
        let tokens: [Token]
        private var didBacktrack: Bool
        
        init(lexer: TokenizerLexer) {
            self.lexer = lexer
            self.index = lexer.lexer.inputIndex
            tokens = lexer.available
            didBacktrack = false
        }
        
        func backtrack() {
            if didBacktrack {
                return
            }
            
            lexer.lexer.inputIndex = index
            lexer.available = tokens
            didBacktrack = true
        }
    }
}

/// A protocol for tokens that can be consumed serially with a `TokenizerLexer`.
public protocol TokenType: Equatable {
    /// Gets the token that represents the end-of-file of an input string.
    /// It is important that this token is unique since the usage of this token
    /// delimits the end of the input sequence on a tokenizer lexer.
    static var eofToken: Self { get }
    
    /// Returns an array of all possible tokens that can be read from the lexer
    /// at its given point.
    ///
    /// It is not required for tokens to return the state of the lexer to the
    /// previous state prior to the calling of this method.
    static func possibleTokens(at lexer: Lexer) -> [Self]
    
    /// Requests the length of this token type when applied to a given lexer.
    /// If this token cannot be possibly consumed from the lexer, conformers must
    /// return `0`.
    ///
    /// It is not required for tokens to return the state of the lexer to the
    /// previous state prior to the calling of this method.
    func length(in lexer: Lexer) -> Int
    
    /// Advances the lexer passed in by whatever length this token takes in the
    /// input stream.
    func advance(in lexer: Lexer) throws
}

public enum SwiftTypeToken: TokenType {
    private static let identifierLexer = (.letter | "_") + (.letter | "_" | .digit)*
    
    public static var eofToken: SwiftTypeToken = .eof
    
    /// Character '('
    case openParens
    /// Character ')'
    case closeParens
    /// Character '.'
    case period
    /// Function arrow chars '->'
    case functionArrow
    /// An identifier token
    case identifier
    /// An 'inout' keyword
    case `inout`
    /// Character '?'
    case questionMark
    /// Character '!'
    case exclamationMark
    /// Character ';'
    case colon
    /// Character '&'
    case ampersand
    /// Character '['
    case openBrace
    /// Character ']'
    case closeBrace
    /// Character '<'
    case openBracket
    /// Character '>'
    case closeBracket
    /// Character ','
    case comma
    /// End-of-file character
    case eof
    
    public func length(in lexer: Lexer) -> Int {
        switch self {
        case .openParens, .closeParens, .period, .questionMark, .exclamationMark,
             .colon, .ampersand, .openBrace, .closeBrace, .openBracket,
             .closeBracket, .comma:
            return 1
        case .functionArrow:
            return 2
        case .inout:
            return "inout".count
        case .identifier:
            return SwiftTypeToken.identifierLexer.maximumLength(in: lexer) ?? 0
        case .eof:
            return 0
        }
    }
    
    public func advance(in lexer: Lexer) throws {
        let l = length(in: lexer)
        if l == 0 {
            return
        }
        
        try lexer.advanceLength(l)
    }
    
    public static func possibleTokens(at lexer: Lexer) -> [SwiftTypeToken] {
        do {
            let next = try lexer.peek()
            
            // Single character tokens
            switch next {
            case "(":
                return [.openParens]
            case ")":
                return [.closeParens]
            case ".":
                return [.period]
            case "?":
                return [.questionMark]
            case "!":
                return [.exclamationMark]
            case ":":
                return [.colon]
            case "&":
                return [.ampersand]
            case "[":
                return [.openBrace]
            case "]":
                return [.closeBrace]
            case "<":
                return [.openBracket]
            case ">":
                return [.closeBracket]
            case ",":
                return [.comma]
            case "-":
                if try lexer.peekForward() == ">" {
                    try lexer.advanceLength(2)
                    
                    return [.functionArrow]
                }
            default:
                break
            }
            
            // Identifier
            if identifierLexer.passes(in: lexer) {
                // Check it's not actually an `inout` keyword
                let ident = try lexer.withTemporaryIndex { try identifierLexer.consume(from: lexer) }
                
                if ident == "inout" {
                    return [.inout]
                } else {
                    return [.identifier]
                }
            }
            
            return []
        } catch {
            return []
        }
    }
}

extension GrammarRule {
    /// Returns the maximal length this grammar rule can consume from a given lexer,
    /// if successful.
    ///
    /// Returns nil, if an error ocurred while consuming the rule.
    func maximumLength(in lexer: Lexer) -> Int? {
        do {
            let start = lexer.inputIndex
            
            let end: Lexer.Index = try lexer.withTemporaryIndex {
                try stepThroughApplying(on: lexer)
                return lexer.inputIndex
            }
            
            return lexer.inputString.distance(from: start, to: end)
        } catch {
            return nil
        }
    }
    
    /// Returns `true` if this grammar rule validates effectively when applied on
    /// a given lexer.
    ///
    /// Gives a better guarantee than using `canConsume(from:)` since that method
    /// does a cheaper validation of whether an initial consumption attempt can
    /// be performed without immediate failures.
    ///
    /// This method returns the lexer to the previous state before returning.
    func passes(in lexer: Lexer) -> Bool {
        do {
            _=try lexer.withTemporaryIndex {
                try stepThroughApplying(on: lexer)
            }
            
            return true
        } catch {
            return false
        }
    }
}
