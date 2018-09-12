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
    public static func parseDeclaration(from string: String) throws -> IncompleteKnownType {
        
        var builder = KnownTypeBuilder(typeName: "")
        
        try parseDeclaration(from: string, into: &builder)
        
        return IncompleteKnownType(typeBuilder: builder)
    }
    
    /// Parses a class type interface signature from a given input string into
    /// a given know type builder object.
    ///
    /// String must contain a single, complete class or extension definition.
    /// Definition must be interface-only (i.e. no method implementations or bodies).
    ///
    /// ```
    /// type-declaration
    ///     : type-declaration-header type-body
    ///     ;
    ///
    /// type-body
    ///     : '{' type-members? '}'
    ///     ;
    /// ```
    public static func parseDeclaration(from string: String,
                                        into typeBuilder: inout KnownTypeBuilder) throws {
        
        return try parseDeclaration(from: Lexer(input: string), into: &typeBuilder)
    }
    
    /// Parses a class type interface signature from a given lexer into a given
    /// know type builder object.
    ///
    /// String must contain a single, complete class or extension definition.
    /// Definition must be interface-only (i.e. no method implementations or bodies).
    ///
    /// ```
    /// type-declaration
    ///     : type-declaration-header type-body
    ///     ;
    ///
    /// type-body
    ///     : '{' type-members? '}'
    ///     ;
    /// ```
    public static func parseDeclaration(from lexer: Lexer,
                                        into typeBuilder: inout KnownTypeBuilder) throws {
        
        let tokenizer = Tokenizer(lexer: lexer)
        
        var builder = typeBuilder
        
        try parseTypeDeclarationHeader(from: tokenizer, &builder)
        
        typeBuilder = builder
    }
    
    /// ```
    /// type-declaration-header
    ///     : 'class' type-name type-inheritance-clause?
    ///     : 'extension' type-name type-inheritance-clause?
    ///     ;
    ///
    /// type-inheritance-clause
    ///     : ':' type-name (',' type-name)*
    ///
    /// type-name
    ///     : identifier
    ///     ;
    /// ```
    private static func parseTypeDeclarationHeader(from tokenizer: Tokenizer,
                                                   _ typeBuilder: inout KnownTypeBuilder) throws {
        
        let isExtension: Bool
        
        if tokenizer.tokenType(is: .extension) {
            try tokenizer.advance(overTokenType: .extension)
            isExtension = true
        } else {
            try tokenizer.advance(overTokenType: .class)
            isExtension = false
        }
        
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
        
        try parseTypeBody(from: tokenizer, &typeBuilder)
        
        typeBuilder = typeBuilder
            .named(name)
            .settingIsExtension(isExtension)
            .protocolConformances(protocolNames: supertypes)
    }
    
    /// ```
    /// type-body
    ///     : '{' type-members? '}'
    ///     ;
    ///
    /// type-members
    ///     : type-member+
    ///     ;
    /// ```
    private static func parseTypeBody(from tokenizer: Tokenizer,
                                      _ typeBuilder: inout KnownTypeBuilder) throws {
        
        try tokenizer.advance(overTokenType: .openBrace)
        
        if !tokenizer.tokenType(is: .closeBrace) {
            try parseTypeMembers(from: tokenizer, &typeBuilder)
        }
        
        try tokenizer.advance(overTokenType: .closeBrace)
    }
    
    /// ```
    /// type-members
    ///     : type-member+
    ///     ;
    ///
    /// type-member
    ///     : var-declaration
    ///     | function-declaration
    ///     | initializer-declaration
    ///     ;
    /// ```
    private static func parseTypeMembers(from tokenizer: Tokenizer,
                                         _ typeBuilder: inout KnownTypeBuilder) throws {
        
        _ = tokenizer.lexer.performGreedyRounds { (lexer, round) -> Bool in
            try parseTypeMember(from: tokenizer, &typeBuilder)
            
            return true
        }
    }
    
    /// ```
    /// type-member
    ///     : declaration-modifiers? var-declaration
    ///     | declaration-modifiers? function-declaration
    ///     | declaration-modifiers? initializer-declaration
    ///     ;
    ///
    /// function-declaration
    ///     : 'func' function-signature
    ///     ;
    ///
    /// initializer-declaration
    ///     : 'init' function-signature
    ///     ;
    /// ```
    private static func parseTypeMember(from tokenizer: Tokenizer,
                                        _ typeBuilder: inout KnownTypeBuilder) throws {
        
        let modifiers: [DeclarationModifier] =
            (try? parseDeclarationModifiers(from: tokenizer)) ?? []
        
        switch tokenizer.tokenType() {
        case .var:
            let varDecl = try parseVarDeclaration(from: tokenizer)
            
            typeBuilder =
                typeBuilder.property(named: varDecl.identifier, type: varDecl.type)
            
        default:
            throw tokenizer.lexer.syntaxError(
                "Expected variable, function or initializer declaration"
            )
        }
        
    }
    
    /// ```
    /// var-declaration
    ///     : 'var' identifier ':' swift-type
    ///     ;
    /// ```
    private static func parseVarDeclaration(from tokenizer: Tokenizer) throws -> VarDeclaration {
        try tokenizer.advance(overTokenType: .var)
        
        let ident = try identifier(from: tokenizer)
        let type = try SwiftTypeParser.parse(from: tokenizer.lexer)
        
        return VarDeclaration(identifier: ident, type: type)
    }
    
    /// ```
    /// declaration-modifiers
    ///     : declaration-modifier+
    ///     ;
    /// ```
    private static func parseDeclarationModifiers(from tokenizer: Tokenizer) throws -> [DeclarationModifier] {
        var modifiers: [DeclarationModifier] = []
        
        try tokenizer.lexer.expect(atLeast: 1) { (lexer) -> Bool in
            modifiers.append(try parseDeclarationModifier(from: tokenizer))
            
            return true
        }
        
        return modifiers
    }
    
    /// ```
    /// declaration-modifier
    ///     : access-level-modifier
    ///     | 'class'
    ///     | 'convenience'
    ///     | 'dynamic'
    ///     | 'final'
    ///     | 'lazy'
    ///     | 'optional'
    ///     | 'override'
    ///     | 'required'
    ///     | 'static'
    ///     | 'unowned'
    ///     | 'unowned(safe)'
    ///     | 'unowned(unsafe)'
    ///     | 'weak'
    ///     ;
    ///
    /// access-level-modifier
    ///     : 'public'
    ///     | 'public(set)'
    ///     | 'open'
    ///     | 'open(set)'
    ///     ;
    /// ```
    private static func parseDeclarationModifier(from tokenizer: Tokenizer) throws -> DeclarationModifier {
        
        let ignored: Set<Token> = [
            .convenience,
            .dynamic,
            .final,
            .optional,
            .required
        ]
        
        let tokenType = tokenizer.tokenType()
        
        if ignored.contains(tokenType) {
            tokenizer.skipToken()
            
            return DeclarationModifier.ignored
        }
        
        switch tokenType {
        case .static, .class:
            tokenizer.skipToken()
            
            return DeclarationModifier.static
            
        case .override:
            tokenizer.skipToken()
            
            return DeclarationModifier.override
            
        case .weak:
            tokenizer.skipToken()
            
            return DeclarationModifier.ownership(.weak)
            
        case .unowned, .unowned_safe:
            tokenizer.skipToken()
            
            return DeclarationModifier.ownership(.unownedSafe)
            
        case .unowned_unsafe:
            tokenizer.skipToken()
            
            return DeclarationModifier.ownership(.unownedUnsafe)
        default:
            break
        }
        
        return DeclarationModifier.accessLevel(try parseAccessLevel(from: tokenizer))
    }
    
    /// ```
    /// access-level-modifier
    ///     : 'public'
    ///     | 'public(set)'
    ///     | 'open'
    ///     | 'open(set)'
    ///     ;
    /// ```
    private static func parseAccessLevel(from tokenizer: Tokenizer) throws -> AccessLevel {
        if tokenizer.tokenType(is: .open) {
            tokenizer.skipToken()
            return .open
        }
        if tokenizer.tokenType(is: .public) {
            tokenizer.skipToken()
            return .public
        }
        
        throw tokenizer.lexer.syntaxError("Expected access level modifier")
    }
    
    private static func typeName(from tokenizer: Tokenizer) throws -> String {
        do {
            let token = try tokenizer.advance(overTokenType: .identifier)
            
            return String(token.value)
        } catch {
            throw tokenizer.lexer.syntaxError("Expected type name")
        }
    }
    
    private static func identifier(from tokenizer: Tokenizer) throws -> String {
        do {
            let token = try tokenizer.advance(overTokenType: .identifier)
            
            return String(token.value)
        } catch {
            throw tokenizer.lexer.syntaxError("Expected identifier")
        }
    }
    
    private struct VarDeclaration {
        var identifier: String
        var type: SwiftType
    }
    
    private enum DeclarationModifier: Hashable {
        case accessLevel(AccessLevel)
        case `static`
        case ownership(Ownership)
        case `override`
        case ignored
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
        case openBrace = "{"
        case closeBrace = "}"
        case colon = ":"
        case comma = ","
        case at = "@"
        case underscore = "_"
        case identifier
        case functionArrow
        case `var`
        case `let`
        case `func`
        case `weak`
        case `open`
        case `inout`
        case `final`
        case `class`
        case `throws`
        case `static`
        case `public`
        case `dynamic`
        case `unowned`
        case unowned_safe
        case unowned_unsafe
        case optional
        case `mutating`
        case `rethrows`
        case `required`
        case `override`
        case `extension`
        case `convenience`
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
            case .openParens, .closeParens, .openBrace, .closeBrace, .colon,
                 .comma, .underscore, .at:
                return 1
            case .functionArrow:
                return 2
            case .var, .let:
                return 3
            case .func, .weak, .open:
                return 4
            case .inout, .class, .final:
                return 5
            case .throws, .public, .static:
                return 6
            case .dynamic, .unowned:
                return 7
            case .mutating, .rethrows, .required, .override, .optional:
                return 8
            case .extension:
                return 9
            case .fileprivate, .convenience:
                return 11
            case .unowned_safe:
                return 12
            case .unowned_unsafe:
                return 14
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
                case "weak":
                    return .weak
                case "open":
                    return .open
                case "inout":
                    return .inout
                case "final":
                    return .final
                case "throws":
                    return .throws
                case "public":
                    return .public
                case "static":
                    return .static
                case "dynamic":
                    return .dynamic
                case "unowned":
                    
                    if lexer.checkNext(matches: "(safe)") {
                        return .unowned_safe
                    }
                    if lexer.checkNext(matches: "(unsafe)") {
                        return .unowned_unsafe
                    }
                    
                    return .unowned
                case "mutating":
                    return .mutating
                case "rethrows":
                    return .rethrows
                case "required":
                    return .required
                case "override":
                    return .override
                case "optional":
                    return .optional
                case "extension":
                    return .extension
                case "fileprivate":
                    return .fileprivate
                case "convenience":
                    return .convenience
                    
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
