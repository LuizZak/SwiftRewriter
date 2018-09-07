import SwiftAST
import MiniLexer
import Utils

/// Provudes capabilities for parsing Swift class declarations.
public final class SwiftClassInterfaceParser {
    private typealias Tokenizer = TokenizerLexer<FullToken<Token>>
    
    /// Parses a class type interface signature from a given input string.
    ///
    /// String must contain a single, complete class or extension definition.
    /// Definition must be interface-only (i.e. no method implementations or bodies).
    public static func parseDefinition(from string: String) throws -> IncompleteKnownType {
        
        var builder = KnownTypeBuilder(typeName: "")
        
        try parseDefinition(from: string, into: &builder)
        
        return IncompleteKnownType(typeBuilder: builder)
    }
    
    /// Parses a class type interface signature from a given input string into
    /// a given know type builder object.
    ///
    /// String must contain a single, complete class or extension definition.
    /// Definition must be interface-only (i.e. no method implementations or bodies).
    public static func parseDefinition(from string: String,
                                       into typeBuilder: inout KnownTypeBuilder) throws {
        
        let tokenizer = Tokenizer(input: string)
        
        var builder = typeBuilder
        
        builder = builder.named("")
        
        typeBuilder = builder
    }
    
    /// ```
    /// class-header
    ///     : 'class' type-name (':' type-name (',' type-name)*)?
    //          '{' class-body-definition '}'
    ///     ;
    ///
    /// type-name
    ///     : identifier
    ///     ;
    /// ```
    private static func parseClassHeader(from tokenizer: Tokenizer,
                                         _ typeBuilder: inout KnownTypeBuilder) throws {
        
        try tokenizer.advance(overTokenType: .class)
        let name = try typeName(from: tokenizer)
        var supertypes: [String] = []
        
        // Supertype/class conformances
        // (':' type-name (',' type-name)*)?
        if tokenizer.consumeToken(ifTypeIs: .colon) != nil {
            let supertype = try typeName(from: tokenizer)
            supertypes.append(supertype)
            
            // (',' type-name)*
            _=tokenizer.lexer.performGreedyRounds { (lexer, _) in
                guard tokenizer.consumeToken(ifTypeIs: .comma) != nil else {
                    return false
                }
                
                try supertypes.append(typeName(from: tokenizer))
                
                return true
            }
        }
        
        typeBuilder = typeBuilder
            .named(name)
            .protocolConformances(protocolNames: supertypes)
    }
    
    private static func typeName(from tokenizer: Tokenizer) throws -> String {
        do {
            let token = try tokenizer.advance(overTokenType: .identifier)
            
            return String(token.value)
        } catch {
            throw tokenizer.lexer.syntaxError("Expected identifier")
        }
    }
}

public class IncompleteKnownType {
    
    private var knownTypeBuilder: KnownTypeBuilder
    
    fileprivate init(typeBuilder: KnownTypeBuilder) {
        self.knownTypeBuilder = typeBuilder
    }
    
    func complete(typeSystem: TypeSystem) -> KnownType {
        
        // We add all supertypes we find as protocol conformances since we can't
        // verify during parsing that a type is either a protocol or a class, here
        // we check for these protocol conformances to pick out which conformance
        // is actually a supertype name, thus allowing us to complete the type
        // properly.
        for conformance in knownTypeBuilder.protocolConformances {
            if typeSystem.isClassInstanceType(conformance) {
                knownTypeBuilder = knownTypeBuilder
                    .removingConformance(to: conformance)
                    .settingSupertype(KnownTypeReference.typeName(conformance))
                
                break
            }
        }
        
        return knownTypeBuilder.build()
    }
}

extension SwiftClassInterfaceParser {
    
    private enum Token: String, TokenProtocol {
        private static let identifierLexer = (.letter | "_") + (.letter | "_" | .digit)*
        
        case openParens = "("
        case closeParens = ")"
        case colon = ":"
        case comma = ","
        case at = "@"
        case underscore = "_"
        case identifier
        case functionArrow
        case `var`
        case `let`
        case `func`
        case `inout`
        case `class`
        case `throws`
        case `static`
        case `public`
        case `private`
        case `mutating`
        case `rethrows`
        case `internal`
        case `extension`
        case `fileprivate`
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
            case .functionArrow:
                return 2
            case .var, .let:
                return 3
            case .func:
                return 4
            case .inout, .class:
                return 5
            case .throws, .public, .static:
                return 6
            case .private:
                return 7
            case .mutating, .rethrows, .internal:
                return 8
            case .extension:
                return 9
            case .fileprivate:
                return 11
            case .identifier:
                return Token.identifierLexer.maximumLength(in: lexer) ?? 0
            case .eof:
                return 0
            }
        }
        
        var tokenString: String {
            return rawValue
        }
        
        static func tokenType(at lexer: Lexer) -> SwiftClassInterfaceParser.Token? {
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
            
            if lexer.checkNext(matches: "->") {
                return .functionArrow
            }
            
            guard let next = try? lexer.peek() else {
                return nil
            }
            
            if Lexer.isLetter(next) {
                guard let ident = try? lexer.withTemporaryIndex(changes: {
                    try identifierLexer.consume(from: lexer)
                }) else {
                    return nil
                }
                
                switch ident {
                case "let":
                    return .let
                case "var":
                    return .var
                case "class":
                    return .class
                case "func":
                    return .func
                case "inout":
                    return .inout
                case "throws":
                    return .throws
                case "public":
                    return .public
                case "static":
                    return .static
                case "private":
                    return .private
                case "mutating":
                    return .mutating
                case "rethrows":
                    return .rethrows
                case "internal":
                    return .internal
                case "extension":
                    return .extension
                case "fileprivate":
                    return .fileprivate
                    
                default:
                    return .identifier
                }
            }
            
            if let token = Token(rawValue: String(next)) {
                return token
            }
            
            return nil
        }
        
        static var eofToken: Token = .eof
    }
    
}
