import MiniLexer

/// Support for parsing of Swift type signatures into `SwiftType` structures.
public class SwiftTypeParser {
    private typealias Tokenizer = TokenizerLexer<FullToken<SwiftTypeToken>>
    
    /// Parses a Swift type from a given type string
    public static func parse(from string: String) throws -> SwiftType {
        let lexer = Lexer(input: string)
        
        let result = try parse(from: lexer)
        
        if !lexer.isEof() {
            throw unexpectedTokenError(lexer: Tokenizer(lexer: lexer))
        }
        
        return result
    }
    
    /// Parses a Swift type from a given lexer
    ///
    /// Formal Swift type grammar:
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
    ///     : arg-attribute-list? '(' block-argument-list '...'? ')' '->' swift-type ;
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
    ///     : (argument-label identifier? ':') arg-attribute-list? 'inout'? swift-type ;
    ///
    /// argument-label
    ///     : '_'
    ///     | identifier
    ///     ;
    ///
    /// arg-attribute-list
    ///     : attribute+
    ///     ;
    ///
    /// arg-attribute
    ///     : block-type-attribute
    ///     | '@' identifier
    ///     | '@' identifier '(' ..* ')'
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
    public static func parse(from lexer: Lexer) throws -> SwiftType {
        let tokenizer = Tokenizer(lexer: lexer)
        return try parseType(tokenizer)
    }
    
    private static func parseType(_ lexer: Tokenizer) throws -> SwiftType {
        let type: SwiftType
        
        if lexer.tokenType(is: .identifier) {
            let ident = try parseNominalType(lexer)
            
            // Void type
            if ident == .typeName("Void") {
                type = .void
            } else if lexer.tokenType(is: .ampersand) {
                // Protocol type composition
                let prot
                    = try verifyProtocolCompositionTrailing(after: [.nominal(ident)],
                                                            lexer: lexer)
                
                type = .protocolComposition(prot)
            } else if lexer.tokenType(is: .period) {
                // Verify meta-type access
                var isMetatypeAccess = false
                
                let periodBT = lexer.backtracker()
                if lexer.consumeToken(ifTypeIs: .period) != nil {
                    // Backtrack out of this method, in case it's actually a metatype
                    // trailing
                    if let identifier = lexer.consumeToken(ifTypeIs: .identifier)?.value,
                        identifier == "Type" || identifier == "Protocol" {
                        isMetatypeAccess = true
                    }
                    
                    periodBT.backtrack()
                }
                
                // Nested type
                if !isMetatypeAccess {
                    type = .nested(try parseNestedType(lexer, after: ident))
                } else {
                    type = .nominal(ident)
                }
            } else {
                type = .nominal(ident)
            }
        } else if lexer.tokenType(is: .openBrace) {
            type = try parseArrayOrDictionary(lexer)
        } else if lexer.tokenType(is: .openParens) || lexer.tokenType(is: .at) {
            type = try parseTupleOrBlock(lexer)
        } else {
            throw unexpectedTokenError(lexer: lexer)
        }
        
        return try verifyTrailing(after: type, lexer: lexer)
    }
    
    /// Parses a nominal identifier type.
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
    private static func parseNominalType(_ lexer: Tokenizer) throws -> NominalSwiftType {
        
        let identifier = try lexer.advance(overTokenType: .identifier)
        
        // Attempt a generic type parse
        let type =
            try verifyGenericArgumentsTrailing(after: String(identifier.value),
                                               lexer: lexer)
        
        return type
    }
    
    /// Parses a protocol composition component.
    ///
    /// ```
    /// protocol-composition
    ///     : type-identifier '&' type-identifier ('&' type-identifier)* ;
    /// ```
    private static func parseProtocolCompositionComponent(_ lexer: Tokenizer) throws -> ProtocolCompositionComponent {
        
        // Nested type
        if let nested = nestedTypeCategory(at: lexer) {
            switch nested {
            case .nested:
                let base = try parseNominalType(lexer)
                let nested = try parseNestedType(lexer, after: base)
                
                return .nested(nested)
                
            case .metatype:
                throw notProtocolComposableError(type: try parseType(lexer), lexer: lexer)
            }
        }
        
        // Nominal type
        let nominal = try parseNominalType(lexer)
        
        return .nominal(nominal)
    }
    
    /// Returns the category of a nesting at a given point of the provided lexer.
    /// Returns nil, in case no nested type was found to test for at all.
    private static func nestedTypeCategory(at lexer: Tokenizer) -> NestedTypeCategory? {
        let bt = lexer.backtracker()
        defer {
            bt.backtrack()
        }
        
        do {
            let base = try parseType(lexer)
            
            switch base {
            case .nested:
                return .nested
            case .metatype:
                return .metatype
            default:
                return nil
            }
        } catch {
            return nil
        }
    }
    
    private static func parseNestedType(_ lexer: Tokenizer,
                                        after base: NominalSwiftType) throws -> NestedSwiftType {
        
        var types = [base]
        
        repeat {
            let periodBT = lexer.backtracker()
            
            try lexer.advance(overTokenType: .period)
            
            do {
                // Check if the nesting is not actually a metatype access
                let identBT = lexer.backtracker()
                let ident = lexer.consumeToken(ifTypeIs: .identifier)?.value
                if ident == "Type" || ident == "Protocol" {
                    periodBT.backtrack()
                    break
                }
                
                identBT.backtrack()
            }
            
            let next = try parseNominalType(lexer)
            types.append(next)
        } while lexer.tokenType(is: .period)
        
        return NestedSwiftType.fromCollection(types)
    }
    
    /// Parses a protocol composition for an identifier type.
    ///
    /// ```
    /// protocol-composition
    ///     : type-identifier '&' type-identifier ('&' type-identifier)* ;
    /// ```
    private static func verifyProtocolCompositionTrailing(
        after types: [ProtocolCompositionComponent],
        lexer: Tokenizer) throws -> ProtocolCompositionSwiftType {
        
        var types = types
        
        while lexer.consumeToken(ifTypeIs: .ampersand) != nil {
            // If we find a parenthesis, unwrap the tuple (if it's a tuple) and
            // check if all its inner types are nominal, then it's a composable
            // type.
            if lexer.tokenType(is: .openParens) {
                let toParens = lexer.backtracker()
                
                let type = try parseType(lexer)
                switch type {
                    
                case .nominal(let nominal):
                    types.append(.nominal(nominal))
                    
                case .nested(let nested):
                    types.append(.nested(nested))
                    
                case .protocolComposition(let list):
                    types.append(contentsOf: list)
                    
                default:
                    toParens.backtrack()
                    
                    throw notProtocolComposableError(type: type, lexer: lexer)
                }
            } else {
                types.append(try parseProtocolCompositionComponent(lexer))
            }
        }
        
        return .fromCollection(types)
    }
    
    /// Parses a generic argument clause.
    ///
    /// ```
    /// generic-argument-clause
    ///     : '<' swift-type (',' swift-type)* '>'
    /// ```
    private static func verifyGenericArgumentsTrailing(
        after typeName: String, lexer: Tokenizer) throws -> NominalSwiftType {
        
        guard lexer.consumeToken(ifTypeIs: .openBracket) != nil else {
            return .typeName(typeName)
        }
        
        var types: [SwiftType] = []
        
        repeat {
            types.append(try parseType(lexer))
        } while !lexer.isEof && lexer.consumeToken(ifTypeIs: .comma) != nil
        
        try lexer.advance(overTokenType: .closeBracket)
        
        return .generic(typeName, parameters: .fromCollection(types))
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
    private static func parseArrayOrDictionary(_ lexer: Tokenizer) throws -> SwiftType {
        try lexer.advance(overTokenType: .openBrace)
        
        let type1 = try parseType(lexer)
        var type2: SwiftType?
        
        if lexer.tokenType(is: .colon) {
            lexer.consumeToken(ifTypeIs: .colon)
            
            type2 = try parseType(lexer)
        }
        
        try lexer.advance(overTokenType: .closeBrace)
        
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
    ///     : arg-attribute-list? '(' block-argument-list '...'? ')' '->' swift-type ;
    ///
    /// block-argument-list
    ///     : block-argument (',' block-argument)* ;
    ///
    /// block-argument
    ///     : (argument-label identifier? ':') arg-attribute-list? 'inout'? swift-type ;
    ///
    /// argument-label
    ///     : '_'
    ///     | identifier
    ///     ;
    ///
    /// arg-attribute-list
    ///     : attribute+
    ///     ;
    ///
    /// arg-attribute
    ///     : block-type-attribute
    ///     | '@' identifier
    ///     | '@' identifier '(' ..* ')'
    ///     ;
    /// ```
    private static func parseTupleOrBlock(_ lexer: Tokenizer) throws -> SwiftType {
        var attributes: [BlockTypeAttribute] = []
        
        func verifyAndSkipAnnotations() throws {
            if let attr = verifyBlockTypeAttribute(lexer: lexer) {
                attributes.append(attr)
                
                // Check for another attribute
                try verifyAndSkipAnnotations()
                return
            }
            
            guard lexer.consumeToken(ifTypeIs: .at) != nil else {
                return
            }
            
            try lexer.advance(overTokenType: .identifier)
            
            // Check for parenthesis on the annotation by detecting an open parens
            // with no whitespace right after the annotation identifier
            if lexer.lexer.safeIsNextChar(equalTo: "(") && lexer.consumeToken(ifTypeIs: .openParens) != nil {
                while !lexer.isEof && !lexer.tokenType(is: .closeParens) {
                    try lexer.advance(overTokenType: lexer.tokenType())
                }
                
                try lexer.advance(overTokenType: .closeParens)
            }
            
            // Check for another attribute
            try verifyAndSkipAnnotations()
        }
        
        func flushAnnotations() -> [BlockTypeAttribute] {
            defer { attributes.removeAll() }
            return attributes
        }
        
        var returnType: SwiftType
        var parameters: [SwiftType] = []
        var expectsBlock = false
        
        try verifyAndSkipAnnotations()
        let funcAttributes = flushAnnotations()
        
        try lexer.advance(overTokenType: .openParens)
        
        while !lexer.tokenType(is: .closeParens) {
            // Inout label
            var expectsType = false
            
            if lexer.consumeToken(ifTypeIs: .inout) != nil {
                expectsType = true
            }
            
            // Attributes
            if lexer.tokenType(is: .at) {
                expectsType = true
            }
            
            // If we see an 'inout', skip identifiers and force a parameter type
            // to be read
            if !expectsType {
                // Check if we're handling a label
                let hasSingleLabel: Bool = lexer.backtracking {
                    lexer.consumeToken(ifTypeIs: .identifier) != nil
                        && lexer.consumeToken(ifTypeIs: .colon) != nil
                }
                let hasDoubleLabel: Bool = lexer.backtracking {
                    lexer.consumeToken(ifTypeIs: .identifier) != nil
                        && lexer.consumeToken(ifTypeIs: .identifier) != nil
                        && lexer.consumeToken(ifTypeIs: .colon) != nil
                }
                
                if hasSingleLabel {
                    lexer.consumeToken(ifTypeIs: .identifier)
                    lexer.consumeToken(ifTypeIs: .colon)
                } else if hasDoubleLabel {
                    lexer.consumeToken(ifTypeIs: .identifier)
                    lexer.consumeToken(ifTypeIs: .identifier)
                    lexer.consumeToken(ifTypeIs: .colon)
                }
            }
            
            // Inout label
            if lexer.consumeToken(ifTypeIs: .inout) != nil {
                if expectsType {
                    throw unexpectedTokenError(lexer: lexer)
                }
            }
            
            let type = try parseType(lexer)
            
            // Verify ellipsis for variadic parameter
            if lexer.consumeToken(ifTypeIs: .ellipsis) != nil {
                parameters.append(.array(type))
                
                expectsBlock = true
                break
            }
            
            parameters.append(type)
            
            // Expect either a new type or a closing parens to finish off this
            // parameter list
            if lexer.consumeToken(ifTypeIs: .comma) == nil && !lexer.tokenType(is: .closeParens) {
                throw unexpectedTokenError(lexer: lexer)
            }
        }
        
        try lexer.advance(overTokenType: .closeParens)
        
        // It's a block if if features a function arrow afterwards...
        if lexer.consumeToken(ifTypeIs: .functionArrow) != nil {
            returnType = try parseType(lexer)
            
            return .block(returnType: returnType, parameters: parameters, attributes: Set(funcAttributes))
        } else if expectsBlock {
            throw expectedBlockType(lexer: lexer)
        }
        
        // ...otherwise it is a tuple
        
        // Check for protocol compositions (types must be all nominal)
        if lexer.tokenType(is: .ampersand) {
            if parameters.count != 1 {
                throw unexpectedTokenError(lexer: lexer)
            }
            
            switch parameters[0] {
            case .nominal(let nominal):
                let prot =
                    try verifyProtocolCompositionTrailing(after: [.nominal(nominal)],
                                                          lexer: lexer)
                
                return .protocolComposition(prot)
                
            case .nested(let nested):
                let prot =
                    try verifyProtocolCompositionTrailing(after: [.nested(nested)],
                                                          lexer: lexer)
                
                return .protocolComposition(prot)
                
            case .protocolComposition(let composition):
                let prot =
                    try verifyProtocolCompositionTrailing(after: Array(composition),
                                                          lexer: lexer)
                
                return .protocolComposition(prot)
                
            default:
                throw notProtocolComposableError(type: parameters[0], lexer: lexer)
            }
        }
        
        if parameters.isEmpty {
            return .tuple(.empty)
        }
        
        if parameters.count == 1 {
            return parameters[0]
        }
        
        return .tuple(TupleSwiftType.types(.fromCollection(parameters)))
    }
    
    /// Attempts to parse a block type attribute from the given lexer.
    /// If lexing fails, the lexer is backtracked and nil is returned.
    ///
    /// ```
    /// block-type-attribute
    ///     : autoclosure-attribute
    ///     | escaping-attribute
    ///     | convention-attribute
    ///     ;
    ///
    /// autoclosure-attribute
    ///     : '@' 'autoclosure'
    ///     ;
    ///
    /// escaping-attribute
    ///     : '@' 'escaping'
    ///     ;
    ///
    /// convention-attribute
    ///     : '@' 'convention' '(' convention-type ')'
    ///
    /// convention-type
    ///     : 'c'
    ///     | 'block'
    ///     | 'swift'
    ///     ;
    /// ```
    private static func verifyBlockTypeAttribute(lexer: Tokenizer) -> BlockTypeAttribute? {
        let backtracker = lexer.backtracker()
        
        do {
            try lexer.advance(overTokenType: .at)
            
            switch try lexer.advance(overTokenType: .identifier).value {
            case "autoclosure":
                let attribute = BlockTypeAttribute.autoclosure
                // Check for a '(' immediately after the attribute name
                if lexer.lexer.safeIsNextChar(equalTo: "(") {
                    backtracker.backtrack()
                    return nil
                }
                
                return attribute
            case "escaping":
                let attribute = BlockTypeAttribute.escaping
                
                // Check for a '(' immediately after the attribute name
                if lexer.lexer.safeIsNextChar(equalTo: "(") {
                    backtracker.backtrack()
                    return nil
                }
                
                return attribute
            case "convention":
                try lexer.advance(overTokenType: .openParens)
                
                let ident = try lexer.advance(overTokenType: .identifier).value
                
                try lexer.advance(overTokenType: .closeParens)
                
                switch ident {
                case "c":
                    return .convention(.c)
                    
                case "block":
                    return .convention(.block)
                    
                case "swift":
                    // Althouugh 'swift' is a valid block convention, by default
                    // all blocks are swift convention unless otherwise stated,
                    // so simply return as no convention block and parsing will
                    // default to a swift block
                    backtracker.backtrack()
                default:
                    backtracker.backtrack()
                }
                
            default:
                backtracker.backtrack()
            }
        } catch {
            backtracker.backtrack()
        }
        
        return nil
    }
    
    private static func verifyTrailing(after type: SwiftType, lexer: Tokenizer) throws -> SwiftType {
        // Meta-type
        if lexer.consumeToken(ifTypeIs: .period) != nil {
            guard let ident = lexer.consumeToken(ifTypeIs: .identifier)?.value else {
                throw unexpectedTokenError(lexer: lexer)
            }
            if ident != "Type" && ident != "Protocol" {
                throw expectedMetatypeError(lexer: lexer)
            }
            
            return try verifyTrailing(after: .metatype(for: type), lexer: lexer)
        }
        
        // Optional
        if lexer.consumeToken(ifTypeIs: .questionMark) != nil {
            return try verifyTrailing(after: .optional(type), lexer: lexer)
        }
        
        // Implicitly unwrapped optional
        if lexer.consumeToken(ifTypeIs: .exclamationMark) != nil {
            return try verifyTrailing(after: .implicitUnwrappedOptional(type),
                                      lexer: lexer)
        }
        
        return type
    }
    
    private static func expectedMetatypeError(lexer: Tokenizer) -> Error {
        let index = indexOn(lexer: lexer)
        return .expectedMetatype(index)
    }
    
    private static func expectedBlockType(lexer: Tokenizer) -> Error {
        let index = indexOn(lexer: lexer)
        return .expectedBlockType(index)
    }
    
    private static func unexpectedTokenError(lexer: Tokenizer) -> Error {
        let index = indexOn(lexer: lexer)
        return .unexpectedToken(lexer.token().tokenType.tokenString, index)
    }
    
    private static func notProtocolComposableError(
        type: SwiftType, lexer: Tokenizer) -> Error {
        
        let index = indexOn(lexer: lexer)
        return .notProtocolComposable(type, index)
    }
    
    private static func indexOn(lexer: Tokenizer) -> Int {
        let input = lexer.lexer.inputString
        return input.distance(from: input.startIndex, to: lexer.lexer.inputIndex)
    }
    
    /// Category for a nested type expression
    ///
    /// - nested: A proper nested type, e.g. `TypeA.TypeB`
    /// - metatype: A meta-type access, e.g. `TypeA.Type` or `TypeB.Protocol`
    private enum NestedTypeCategory {
        case nested
        case metatype
    }
    
    public enum Error: Swift.Error, CustomStringConvertible {
        case invalidType
        case expectedMetatype(Int)
        case expectedBlockType(Int)
        case notProtocolComposable(SwiftType, Int)
        case unexpectedToken(String, Int)
        
        public var description: String {
            switch self {
            case .invalidType:
                return "Invalid Swift type signature"
            case .expectedBlockType(let offset):
                return "Expected block type at column \(offset + 1)"
            case .expectedMetatype(let offset):
                return "Expected .Type or .Protocol metatype at column \(offset + 1)"
            case let .notProtocolComposable(type, offset):
                return """
                    Found protocol composition, but type \(type) is not composable \
                    on composition '&' at column \(offset + 1)
                    """
            case let .unexpectedToken(token, offset):
                return "Unexpected token '\(token)' at column \(offset + 1)"
            }
        }
    }
}

enum SwiftTypeToken: String, TokenProtocol {
    private static let identifierLexer = (.letter | "_") + (.letter | "_" | .digit)*
    
    public static var eofToken: SwiftTypeToken = .eof
    
    case openParens = "("
    case closeParens = ")"
    case period = "."
    case ellipsis = "..."
    case functionArrow = "->"
    /// An arbitrary identifier token
    case identifier
    case `inout`
    case questionMark = "?"
    case exclamationMark = "!"
    case colon = ":"
    case ampersand = "&"
    case openBrace = "["
    case closeBrace = "]"
    case openBracket = "<"
    case closeBracket = ">"
    case at = "@"
    case comma = ","
    case eof = ""
    
    public var tokenString: String {
        rawValue
    }
    
    public func length(in lexer: Lexer) -> Int {
        switch self {
        case .openParens, .closeParens, .period, .questionMark, .exclamationMark,
             .colon, .ampersand, .openBrace, .closeBrace, .openBracket,
             .closeBracket, .comma, .at:
            return 1
        case .functionArrow:
            return 2
        case .ellipsis:
            return 3
        case .inout:
            return "inout".count
        case .identifier:
            return SwiftTypeToken.identifierLexer.maximumLength(in: lexer) ?? 0
        case .eof:
            return 0
        }
    }
    
    public static func tokenType(at lexer: Lexer) -> SwiftTypeToken? {
        do {
            let next = try lexer.peek()
            
            // Single character tokens
            switch next {
            case "(":
                return .openParens
            case ")":
                return .closeParens
            case ".":
                if lexer.checkNext(matches: "...") {
                    return .ellipsis
                }
                
                return .period
            case "?":
                return .questionMark
            case "!":
                return .exclamationMark
            case ":":
                return .colon
            case "&":
                return .ampersand
            case "[":
                return .openBrace
            case "]":
                return .closeBrace
            case "<":
                return .openBracket
            case ">":
                return .closeBracket
            case "@":
                return .at
            case ",":
                return .comma
            case "-":
                if try lexer.peekForward() == ">" {
                    try lexer.advanceLength(2)
                    
                    return .functionArrow
                }
            default:
                break
            }
            
            // Identifier
            if identifierLexer.passes(in: lexer) {
                // Check it's not actually an `inout` keyword
                let ident = try lexer.withTemporaryIndex { try identifierLexer.consume(from: lexer) }
                
                if ident == "inout" {
                    return .inout
                } else {
                    return .identifier
                }
            }
            
            return nil
        } catch {
            return nil
        }
    }
}

private extension SwiftType {
    func withAttributes(_ attributes: [BlockTypeAttribute]) -> SwiftType {
        switch self {
        case .block(let blockType):

            return .block(
                returnType: blockType.returnType,
                parameters: blockType.parameters,
                attributes: blockType.attributes.union(attributes)
            )
            
        default:
            return self
        }
    }
}
