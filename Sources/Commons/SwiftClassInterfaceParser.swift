import SwiftAST
import TypeSystem
import KnownType
import MiniLexer
import Utils

/// Provudes capabilities for parsing Swift class declarations.
public final class SwiftClassInterfaceParser {
    private typealias Tokenizer = TokenizerLexer<FullToken<Token>>
    
    /// Parses a class type interface signature from a given input string.
    ///
    /// String must contain a single, complete class or extension definition.
    /// Definition must be interface-only (i.e. no method implementations or bodies).
    ///
    /// Support for parsing Swift types is borrowed from `SwiftTypeParser`,
    /// and support for parsing Swift function signatures is borrowed from
    /// `FunctionSignatureParser`.
    public static func parseDeclaration(from string: String) throws -> IncompleteKnownType {
        var builder = KnownTypeBuilder(typeName: "")
        builder.useSwiftSignatureMatching = true
        
        try parseDeclaration(from: string, into: &builder)
        
        return IncompleteKnownType(typeBuilder: builder)
    }
    
    /// Parses a class type interface signature from a given input string into
    /// a given know type builder object.
    ///
    /// String must contain a single, complete class or extension definition.
    /// Definition must be interface-only (i.e. no method implementations or bodies).
    ///
    /// Support for parsing Swift types is borrowed from `SwiftTypeParser`,
    /// and support for parsing Swift function signatures is borrowed from
    /// `FunctionSignatureParser`.
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
    /// Support for parsing Swift types is borrowed from `SwiftTypeParser`,
    /// and support for parsing Swift function signatures is borrowed from
    /// `FunctionSignatureParser`.
    public static func parseDeclaration(from lexer: Lexer,
                                        into typeBuilder: inout KnownTypeBuilder) throws {
        
        let tokenizer = Tokenizer(lexer: lexer)
        
        var builder = typeBuilder
        
        try parseTypeDeclarationHeader(from: tokenizer, &builder)
        
        typeBuilder = builder
    }
    
    /// ```
    /// type-declaration
    ///     : attributes? type-declaration-header type-body
    ///     ;
    ///
    /// type-declaration-header
    ///     : 'class' type-name type-inheritance-clause?
    ///     : 'struct' type-name type-inheritance-clause?
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
        
        let attributes: [Attribute]
        let isExtension: Bool
        
        // Verify attributes
        if tokenizer.tokenType(is: .at) {
            attributes = try parseAttributes(from: tokenizer)
        } else {
            attributes = []
        }
        
        if tokenizer.tokenType(is: .extension) {
            try tokenizer.advance(overTokenType: .extension)
            isExtension = true
        } else if tokenizer.tokenType(is: .class) {
            try tokenizer.advance(overTokenType: .class)
            isExtension = false
            
            typeBuilder =
                typeBuilder.settingKind(.class)
        } else {
            try tokenizer.advance(overTokenType: .struct)
            isExtension = false
            
            typeBuilder =
                typeBuilder.settingKind(.struct)
        }
        
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
            .settingAttributes(attributes.map { $0.asKnownAttribute })
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
        
        while !tokenizer.tokenType(is: .closeBrace) {
            try parseTypeMember(from: tokenizer, &typeBuilder)
        }
    }
    
    /// ```
    /// type-member
    ///     : attributes? declaration-modifiers? type-member-declaration
    ///     ;
    ///
    /// type-member-declaration
    ///     : var-declaration
    ///     | let-declaration
    ///     | function-declaration
    ///     | initializer-declaration
    ///     ;
    /// ```
    private static func parseTypeMember(from tokenizer: Tokenizer,
                                        _ typeBuilder: inout KnownTypeBuilder) throws {
        
        let attributes: [Attribute] =
            (try? parseAttributes(from: tokenizer)) ?? []
        
        let knownAttributes = attributes.map { $0.asKnownAttribute }
        
        let modifiers: [DeclarationModifier] =
            (try? parseDeclarationModifiers(from: tokenizer)) ?? []
        
        switch tokenizer.tokenType() {
        case .let:
            let letDecl = try parseLetDeclaration(from: tokenizer)
            
            typeBuilder =
                typeBuilder.field(
                    named: letDecl.identifier,
                    type: letDecl.type,
                    isConstant: true,
                    isStatic: modifiers.contains(.static),
                    attributes: knownAttributes)
            
        case .var:
            let varDecl = try parseVarDeclaration(from: tokenizer)
            
            var ownership: Ownership = .strong
            for modifier in modifiers {
                switch modifier {
                case .ownership(let own):
                    ownership = own
                    
                default:
                    break
                }
            }
            
            typeBuilder =
                typeBuilder.property(
                    named: varDecl.identifier,
                    type: varDecl.type,
                    ownership: ownership,
                    isStatic: modifiers.contains(.static),
                    accessor: varDecl.isConstant ? .getter : .getterAndSetter,
                    attributes: knownAttributes)
            
        case .func:
            var funcDecl = try parseFunctionDeclaration(from: tokenizer)
            funcDecl.signature.isStatic = modifiers.contains(.static)
            
            typeBuilder =
                typeBuilder.method(withSignature: funcDecl.signature,
                                   attributes: knownAttributes)
            
        case ._init:
            let initDecl = try parseInitializerDeclaration(from: tokenizer)
            
            typeBuilder =
                typeBuilder.constructor(withParameters: initDecl.parameters,
                                        attributes: knownAttributes,
                                        isFailable: initDecl.isFailable)
            
        default:
            throw tokenizer.lexer.syntaxError(
                "Expected variable, function or initializer declaration"
            )
        }
    }
    
    /// ```
    /// var-declaration
    ///     : 'var' identifier ':' swift-type getter-setter-keywords?
    ///     ;
    ///
    /// getter-setter-keywords
    ///     : '{' 'get' '}'
    ///     | '{' 'get' 'set' '}'
    ///     | '{' 'set' 'get' '}'
    ///     ;
    /// ```
    private static func parseVarDeclaration(from tokenizer: Tokenizer) throws -> VarDeclaration {
        try tokenizer.advance(overTokenType: .var)
        
        let ident = try identifier(from: tokenizer)
        try tokenizer.advance(overTokenType: .colon)
        let type = try SwiftTypeParser.parse(from: tokenizer.lexer)
        var isConstant = true
        
        // getter-setter-keywords
        if tokenizer.tokenType(is: .openBrace) {
            try tokenizer.advance(overTokenType: .openBrace)
            
            // 'set' implies 'get'
            if tokenizer.tokenType(is: .set) {
                tokenizer.skipToken()
                try tokenizer.advance(overTokenType: .get)
                
                isConstant = false
            } else {
                try tokenizer.advance(overTokenType: .get)
                
                if tokenizer.tokenType(is: .set) {
                    tokenizer.skipToken()
                    
                    isConstant = false
                }
            }
            
            try tokenizer.advance(overTokenType: .closeBrace)
        } else {
            isConstant = false
        }
        
        return VarDeclaration(identifier: ident,
                              type: type,
                              isProperty: true,
                              isConstant: isConstant)
    }
    
    /// ```
    /// let-declaration
    ///     : 'let' identifier ':' swift-type
    /// ```
    private static func parseLetDeclaration(from tokenizer: Tokenizer) throws -> VarDeclaration {
        try tokenizer.advance(overTokenType: .let)
        
        let ident = try identifier(from: tokenizer)
        try tokenizer.advance(overTokenType: .colon)
        let type = try SwiftTypeParser.parse(from: tokenizer.lexer)
        
        return VarDeclaration(identifier: ident,
                              type: type,
                              isProperty: false,
                              isConstant: true)
    }
    
    /// ```
    /// function-declaration
    ///     : 'func' function-signature
    ///     ;
    /// ```
    private static func parseFunctionDeclaration(from tokenizer: Tokenizer) throws -> FunctionDeclaration {
        try tokenizer.advance(overTokenType: .func)
        
        let signature =
            try FunctionSignatureParser.parseSignature(from: tokenizer.lexer)
        
        return FunctionDeclaration(signature: signature)
    }
    
    /// ```
    /// initializer-declaration
    ///     : 'init' '?'? function-parameters
    ///     ;
    /// ```
    private static func parseInitializerDeclaration(from tokenizer: Tokenizer) throws -> InitializerDeclaration {
        try tokenizer.advance(overTokenType: ._init)
        
        var isFailable = false
        
        if tokenizer.tokenType(is: .qmark) {
            tokenizer.skipToken()
            
            isFailable = true
        }
        
        let parameters =
            try FunctionSignatureParser.parseParameters(from: tokenizer.lexer)
        
        return InitializerDeclaration(parameters: parameters,
                                      isFailable: isFailable)
    }
    
    /// ```
    /// attributes
    ///     : attribute+
    ///     ;
    /// ```
    private static func parseAttributes(from tokenizer: Tokenizer) throws -> [Attribute] {
        var attributes: [Attribute] = []
        
        while tokenizer.tokenType(is: .at) {
            attributes.append(try parseAttribute(from: tokenizer))
        }
        
        return attributes
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
    /// attribute
    ///     : '@' identifier attribute-argument-clause?
    ///     | swift-rewriter-attribute
    ///     ;
    ///
    /// attribute-argument-clause
    ///     : '(' balanced-tokens? ')'
    ///     ;
    ///
    /// balanced-tokens
    ///     : balanced-token+
    ///     ;
    ///
    /// balanced-token
    ///     : '(' balanced-tokens ')'
    ///     | '[' balanced-tokens ']'
    ///     | '{' balanced-tokens '}'
    ///     | identifier
    ///     | keyword
    ///     | literal
    ///     | operator
    ///     | { Any punctuation except '(', ')', '[', ']', '{', or '}' }
    ///     ;
    /// ```
    private static func parseAttribute(from tokenizer: Tokenizer) throws -> Attribute {
        
        func skipBalancedTokens() throws {
            switch tokenizer.tokenType() {
            case .openParens:
                tokenizer.skipToken()
                
                while !tokenizer.isEof && !tokenizer.tokenType(is: .closeParens) {
                    try skipBalancedTokens()
                }
                
                try tokenizer.advance(overTokenType: .closeParens)
                
            case .openBrace:
                tokenizer.skipToken()
                
                while !tokenizer.isEof && !tokenizer.tokenType(is: .closeBrace) {
                    try skipBalancedTokens()
                }
                
                try tokenizer.advance(overTokenType: .closeBrace)
                
            case .openSquare:
                tokenizer.skipToken()
                
                while !tokenizer.isEof && !tokenizer.tokenType(is: .closeSquare) {
                    try skipBalancedTokens()
                }
                
                try tokenizer.advance(overTokenType: .closeSquare)
                
            default:
                tokenizer.skipToken()
            }
        }
        
        let backtracker = tokenizer.backtracker()
        if let swiftAttribute = try? parseSwiftRewriterAttribute(from: tokenizer) {
            return Attribute.swiftRewriter(swiftAttribute)
        }
        backtracker.backtrack()
        
        try tokenizer.advance(overTokenType: .at)
        
        let name = String(try tokenizer.advance(overTokenType: .identifier).value)
        let content: String?
        
        // attribute-argument-clause
        //     : '(' balanced-tokens? ')'
        //     ;
        if tokenizer.tokenType(is: .openParens) {
            let range = tokenizer.lexer.startRange()
            
            try skipBalancedTokens()
            
            let newStart = tokenizer.lexer.inputString.index(after: range.range().lowerBound)
            let newEnd = tokenizer.lexer.inputString.index(before: range.range().upperBound)
            
            content = String(tokenizer.lexer.inputString[newStart..<newEnd])
        } else {
            content = nil
        }
        
        return Attribute.generic(name: name, content: content)
    }
    
    /// Parses a Swift attribute in the form of a SwiftRewriterAttribute from a
    /// given input lexer.
    ///
    /// Formal grammar:
    ///
    /// ```
    /// swift-rewriter-attribute
    ///     : '@' '_swiftrewriter' '(' swift-rewriter-attribute-clause ')'
    ///     ;
    ///
    /// swift-rewriter-attribute-clause
    ///     : 'mapFrom' ':' function-identifier
    ///     | 'mapFrom' ':' function-signature
    ///     | 'initFromFunction' ':' function-signature
    ///     | 'mapToBinary' ':' swift-operator
    ///     | 'renameFrom' ':' identifier
    ///     ;
    /// ```
    ///
    /// Support for parsing Swift function signatures and identifiers is borrowed
    /// from `FunctionSignatureParser`.
    public static func parseSwiftRewriterAttribute(from lexer: Lexer) throws -> SwiftRewriterAttribute {
        let tokenizer = Tokenizer(lexer: lexer)
        
        return try parseSwiftRewriterAttribute(from: tokenizer)
    }
    
    private static func parseSwiftRewriterAttribute(from tokenizer: Tokenizer) throws -> SwiftRewriterAttribute {
        
        try tokenizer.advance(overTokenType: .at)
        let ident = try tokenizer.advance(overTokenType: .identifier)
        
        if ident.value != "_swiftrewriter" {
            throw tokenizer.lexer.syntaxError(
                "Expected '_swiftrewriter' to initiate SwiftRewriter attribute"
            )
        }
        
        let content: SwiftRewriterAttribute.Content
        
        try tokenizer.advance(overTokenType: .openParens)
        
        if tokenizer.token().value == "mapFrom" {
            tokenizer.skipToken()
            try tokenizer.advance(overTokenType: .colon)
            
            // Try an identifier first
            let backtracker = tokenizer.backtracker()
            do {
                let identifier =
                    try FunctionSignatureParser.parseIdentifier(from: tokenizer.lexer)
                
                try tokenizer.advance(overTokenType: .closeParens)
                
                return SwiftRewriterAttribute(content: .mapFromIdentifier(identifier))
            } catch {
                backtracker.backtrack()
                
                let signature =
                    try FunctionSignatureParser.parseSignature(from: tokenizer.lexer)
                
                content = .mapFrom(signature)
            }
            
        } else if tokenizer.token().value == "mapToBinary" {
            tokenizer.skipToken()
            try tokenizer.advance(overTokenType: .colon)
            
            let op = try parseSwiftOperator(from: tokenizer)
            
            content = .mapToBinaryOperator(op)
            
        } else if tokenizer.token().value == "renameFrom" {
            tokenizer.skipToken()
            try tokenizer.advance(overTokenType: .colon)
            
            let ident = try tokenizer.advance(overTokenType: .identifier)
            
            content = .renameFrom(String(ident.value))
            
        } else if tokenizer.token().value == "initFromFunction" {
            tokenizer.skipToken()
            try tokenizer.advance(overTokenType: .colon)
            
            let identifier =
                try FunctionSignatureParser.parseIdentifier(from: tokenizer.lexer)
            
            try tokenizer.advance(overTokenType: .closeParens)
            
            return SwiftRewriterAttribute(content: .initFromFunction(identifier))
            
        } else {
            throw tokenizer.lexer.syntaxError(
                "Expected 'mapFrom', 'mapToBinary', or 'renameFrom' in SwiftRewriter attribute"
            )
        }
        
        try tokenizer.advance(overTokenType: .closeParens)
        
        return SwiftRewriterAttribute(content: content)
    }
    
    /// ```
    /// swift-operator
    ///     :
    ///     | "+"
    ///     | "-"
    ///     | "*"
    ///     | "/"
    ///     | "%"
    ///     | "+="
    ///     | "-="
    ///     | "*="
    ///     | "/="
    ///     | "!"
    ///     | "&&"
    ///     | "||"
    ///     | "&"
    ///     | "|"
    ///     | "^"
    ///     | "~"
    ///     | "<<"
    ///     | ">>"
    ///     | "&="
    ///     | "|="
    ///     | "^="
    ///     | '~='
    ///     | '<<='
    ///     | '>>='
    ///     | '<'
    ///     | '<='
    ///     | '>'
    ///     | '>='
    ///     | '='
    ///     | '=='
    ///     | '!='
    ///     | '??'
    ///     | '..<'
    ///     | '...'
    ///     ;
    /// ```
    private static func parseSwiftOperator(from tokenizer: Tokenizer) throws -> SwiftOperator {
        
        let op = try tokenizer.advance(matching: { $0.tokenType.isOperator })
        
        switch op.tokenType {
        case .operator(let o):
            return o
        default:
            throw tokenizer.lexer.syntaxError("Expected Swift operator")
        }
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
    ///     | 'open'
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
        var isProperty: Bool
        var isConstant: Bool
    }
    
    private struct FunctionDeclaration {
        var signature: FunctionSignature
    }
    
    private struct InitializerDeclaration {
        var parameters: [ParameterSignature]
        var isFailable: Bool
    }
    
    private enum Attribute {
        case generic(name: String, content: String?)
        case swiftRewriter(SwiftRewriterAttribute)
        
        var asKnownAttribute: KnownAttribute {
            switch self {
            case .generic(let name, let content):
                return KnownAttribute(name: name, parameters: content)
                
            case .swiftRewriter(let attribute):
                return KnownAttribute(name: SwiftRewriterAttribute.name,
                                      parameters: attribute.content.asString)
            }
        }
    }
    
    public struct SwiftRewriterAttribute {
        public static let name = "_swiftrewriter"
        
        public var content: Content
        
        public enum Content {
            case mapFrom(FunctionSignature)
            case mapFromIdentifier(FunctionIdentifier)
            case initFromFunction(FunctionIdentifier)
            case mapToBinaryOperator(SwiftOperator)
            case renameFrom(String)
            
            public var asString: String {
                switch self {
                case .mapFrom(let signature):
                    return
                        "mapFrom: " +
                            TypeFormatter.asString(signature: signature,
                                                   includeName: true,
                                                   includeFuncKeyword: false,
                                                   includeStatic: false)
                    
                case .mapFromIdentifier(let identifier):
                    return
                        "mapFrom: \(identifier.description)"
                    
                case .mapToBinaryOperator(let op):
                    return "mapToBinary: \(op)"
                    
                case .initFromFunction(let identifier):
                    return "initFromFunction: \(identifier.description)"
                    
                case .renameFrom(let name):
                    return "renameFrom: \(name)"
                }
            }
        }
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
    
    public func modifying(with closure: (KnownTypeBuilder) -> KnownTypeBuilder) {
        knownTypeBuilder = closure(knownTypeBuilder)
    }
    
    public func complete(typeSystem: TypeSystem) -> KnownType {
        
        // We add all supertypes we find as protocol conformances since we can't
        // verify during parsing that a type is either a protocol or a class, here
        // we check for these protocol conformances to pick out which conformance
        // is actually a supertype name, thus allowing us to complete the type
        // properly.
        if knownTypeBuilder.supertype == nil {
            for conformance in knownTypeBuilder.protocolConformances {
                if typeSystem.isClassInstanceType(conformance) {
                    knownTypeBuilder = knownTypeBuilder
                        .removingConformance(to: conformance)
                        .settingSupertype(KnownTypeReference.typeName(conformance))
                    
                    break
                }
            }
        }
        
        return knownTypeBuilder.build()
    }
    
    /// Provides access to customized attributes found while parsing a type
    /// interface.
    public class AttributesCollection {
        
    }
}

extension SwiftClassInterfaceParser {
    
    fileprivate enum Token: TokenProtocol, Hashable {
        private static let identifierLexer = (.letter | "_") + (.letter | "_" | .digit)*
        private static let integerLexer = .digit+
        
        case openParens
        case closeParens
        case openBrace
        case closeBrace
        case openSquare
        case closeSquare
        case colon
        case comma
        case at
        case qmark
        case period
        case underscore
        case identifier
        case functionArrow
        case integerLiteral
        case stringLiteral
        case `operator`(SwiftOperator)
        case `var`
        case `let`
        case `get`
        case `set`
        case `func`
        case `weak`
        case `open`
        case `_init`
        case `inout`
        case `final`
        case `class`
        case `struct`
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
            case .openParens, .closeParens, .openBrace, .closeBrace, .openSquare,
                 .closeSquare, .colon, .comma, .underscore, .at, .period, .qmark:
                return 1
            case .functionArrow:
                return 2
            case .var, .let, .get, .set:
                return 3
            case .func, .weak, .open, ._init:
                return 4
            case .inout, .class, .final:
                return 5
            case .throws, .public, .static, .struct:
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
            case .integerLiteral:
                return Token.integerLexer.maximumLength(in: lexer) ?? 0
            case .stringLiteral:
                
                let l = lexer.startRange()
                try? lexer.advance()
                lexer.advance(while: { $0 != "\"" })
                try? lexer.advance()
                
                return lexer.inputString.distance(from: l.range().lowerBound,
                                                  to: l.range().upperBound)
            case .operator(let op):
                return op.rawValue.count
            case .eof:
                return 0
            }
        }
        
        var tokenString: String {
            switch self {
            case .openParens:
                return "("
            case .closeParens:
                return ")"
            case .openBrace:
                return "{"
            case .closeBrace:
                return "}"
            case .openSquare:
                return "["
            case .closeSquare:
                return "]"
            case .colon:
                return ":"
            case .comma:
                return ","
            case .at:
                return "@"
            case .period:
                return "."
            case .underscore:
                return "_"
            case .qmark:
                return "?"
            case .identifier:
                return "identifier"
            case .functionArrow:
                return "->"
            case .integerLiteral:
                return "integer-literal"
            case .stringLiteral:
                return "string-literal"
            case .operator(let op):
                return op.rawValue
            case .var:
                return "var"
            case .let:
                return "let"
            case .get:
                return "get"
            case .set:
                return "set"
            case .func:
                return "func"
            case .weak:
                return "weak"
            case .open:
                return "open"
            case ._init:
                return "init"
            case .inout:
                return "inout"
            case .final:
                return "final"
            case .class:
                return "class"
            case .struct:
                return "struct"
            case .throws:
                return "throws"
            case .static:
                return "static"
            case .public:
                return "public"
            case .dynamic:
                return "dynamic"
            case .unowned:
                return "unowned"
            case .unowned_safe:
                return "unowned_safe"
            case .unowned_unsafe:
                return "unowned_unsafe"
            case .optional:
                return "optional"
            case .mutating:
                return "mutating"
            case .rethrows:
                return "rethrows"
            case .required:
                return "required"
            case .override:
                return "override"
            case .extension:
                return "extension"
            case .convenience:
                return "convenience"
            case .fileprivate:
                return "fileprivate"
            case .eof:
                return ""
            }
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
            if lexer.checkNext(matches: "\"") {
                return .stringLiteral
            }
            
            // Operators
            if lexer.checkNext(matches: "+=") {
                return .operator(.addAssign)
            }
            if lexer.checkNext(matches: "+") {
                return .operator(.add)
            }
            if lexer.checkNext(matches: "-=") {
                return .operator(.subtractAssign)
            }
            if lexer.checkNext(matches: "-") {
                return .operator(.subtract)
            }
            if lexer.checkNext(matches: "*=") {
                return .operator(.multiplyAssign)
            }
            if lexer.checkNext(matches: "*") {
                return .operator(.multiply)
            }
            if lexer.checkNext(matches: "/=") {
                return .operator(.divideAssign)
            }
            if lexer.checkNext(matches: "/") {
                return .operator(.divide)
            }
            if lexer.checkNext(matches: "==") {
                return .operator(.equals)
            }
            if lexer.checkNext(matches: "=") {
                return .operator(.assign)
            }
            if lexer.checkNext(matches: "!=") {
                return .operator(.unequals)
            }
            if lexer.checkNext(matches: "!") {
                return .operator(.negate)
            }
            if lexer.checkNext(matches: ">=") {
                return .operator(.greaterThanOrEqual)
            }
            if lexer.checkNext(matches: ">>=") {
                return .operator(.bitwiseShiftRightAssign)
            }
            if lexer.checkNext(matches: ">>") {
                return .operator(.bitwiseShiftRight)
            }
            if lexer.checkNext(matches: ">") {
                return .operator(.greaterThan)
            }
            if lexer.checkNext(matches: "<<=") {
                return .operator(.bitwiseShiftLeftAssign)
            }
            if lexer.checkNext(matches: "<<") {
                return .operator(.lessThanOrEqual)
            }
            if lexer.checkNext(matches: "<<") {
                return .operator(.bitwiseShiftLeft)
            }
            if lexer.checkNext(matches: "<") {
                return .operator(.greaterThan)
            }
            if lexer.checkNext(matches: "%") {
                return .operator(.mod)
            }
            if lexer.checkNext(matches: "??") {
                return .operator(.nullCoalesce)
            }
            if lexer.checkNext(matches: "...") {
                return .operator(.closedRange)
            }
            if lexer.checkNext(matches: "..<") {
                return .operator(.openRange)
            }
            if lexer.checkNext(matches: "&&") {
                return .operator(.and)
            }
            if lexer.checkNext(matches: "||") {
                return .operator(.or)
            }
            if lexer.checkNext(matches: "&=") {
                return .operator(.bitwiseAndAssign)
            }
            if lexer.checkNext(matches: "&") {
                return .operator(.bitwiseAnd)
            }
            if lexer.checkNext(matches: "|=") {
                return .operator(.bitwiseOrAssign)
            }
            if lexer.checkNext(matches: "|") {
                return .operator(.bitwiseOr)
            }
            if lexer.checkNext(matches: "^=") {
                return .operator(.bitwiseXorAssign)
            }
            if lexer.checkNext(matches: "^") {
                return .operator(.bitwiseXor)
            }
            if lexer.checkNext(matches: "~=") {
                return .operator(.bitwiseNotAssign)
            }
            if lexer.checkNext(matches: "~") {
                return .operator(.bitwiseNot)
            }
            
            guard let next = try? lexer.peek() else {
                return nil
            }
            
            if Lexer.isDigit(next) {
                return .integerLiteral
            }
            
            // Identifiers and keywords
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
                case "get":
                    return .get
                case "set":
                    return .set
                case "func":
                    return .func
                case "weak":
                    return .weak
                case "open":
                    return .open
                case "init":
                    return ._init
                case "class":
                    return .class
                case "inout":
                    return .inout
                case "final":
                    return .final
                case "struct":
                    return .struct
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
            
            // Special characters
            switch next {
            case "(":
                return .openParens
            case ")":
                return .closeParens
            case "{":
                return .openBrace
            case "}":
                return .closeBrace
            case "[":
                return .openSquare
            case "]":
                return .closeSquare
            case ":":
                return .colon
            case ",":
                return .comma
            case "@":
                return .at
            case ".":
                return .period
            case "_":
                return .underscore
            case "?":
                return .qmark
            default:
                return nil
            }
        }
        
        static var eofToken: Token = .eof
    }
}

extension SwiftClassInterfaceParser.Token {
    
    var isOperator: Bool {
        switch self {
        case .operator:
            return true
        default:
            return false
        }
    }
}
