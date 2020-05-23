import SwiftAST
import TypeSystem
import KnownType
import MiniLexer
import Utils

public final class SwiftRewriterAttributeParser {
    private typealias Tokenizer = TokenizerLexer<FullToken<Token>>
    
    /// Parses a Swift attribute in the form of a `SwiftRewriterAttribute` from
    /// a given input lexer.
    ///
    /// Formal grammar:
    ///
    /// ```
    /// swift-rewriter-attribute
    ///     : '@' '_swiftrewriter' '(' swift-rewriter-attribute-clause ')'
    ///     ;
    ///
    /// swift-rewriter-attribute-clause
    ///     : 'mapFrom' ':' '"' function-identifier '"'
    ///     | 'mapFrom' ':' '"' function-signature '"'
    ///     | 'initFromFunction' ':' '"' function-signature '"'
    ///     | 'mapToBinary' ':' '"' swift-operator '"'
    ///     | 'renameFrom' ':' '"' identifier '"'
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
        let ident = try identifier(from: tokenizer)
        
        if ident != "_swiftrewriter" {
            throw tokenizer.lexer.syntaxError(
                "Expected '_swiftrewriter' to initiate SwiftRewriter attribute"
            )
        }
        
        func tokenizingString<T>(_ block: (Tokenizer) throws -> T) throws -> T {
            let string = String(try tokenizer.advance(overTokenType: .stringLiteral).value.dropFirst().dropLast())
            let tokenizer = Tokenizer(input: string)
            
            return try block(tokenizer)
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
                    try tokenizingString {
                        try FunctionSignatureParser.parseIdentifier(from: $0.lexer)
                    }
                
                try tokenizer.advance(overTokenType: .closeParens)
                
                return SwiftRewriterAttribute(content: .mapFromIdentifier(identifier))
            } catch {
                backtracker.backtrack()
                
                let signature =
                    try tokenizingString {
                        try FunctionSignatureParser.parseSignature(from: $0.lexer)
                    }
                
                content = .mapFrom(signature)
            }
            
        } else if tokenizer.token().value == "mapToBinary" {
            tokenizer.skipToken()
            try tokenizer.advance(overTokenType: .colon)
            
            let op = try tokenizingString { try parseSwiftOperator(from: $0) }
            
            content = .mapToBinaryOperator(op)
            
        } else if tokenizer.token().value == "renameFrom" {
            tokenizer.skipToken()
            try tokenizer.advance(overTokenType: .colon)
            
            let ident = try tokenizingString { try identifier(from: $0) }
            
            content = .renameFrom(ident)
            
        } else if tokenizer.token().value == "initFromFunction" {
            tokenizer.skipToken()
            try tokenizer.advance(overTokenType: .colon)
            
            let identifier =
                try tokenizingString {
                    try FunctionSignatureParser.parseIdentifier(from: $0.lexer)
                }
            
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
        
        let op = try tokenizer.advance(matching: \.tokenType.isOperator)
        
        switch op.tokenType {
        case .operator(let o):
            return o
        default:
            throw tokenizer.lexer.syntaxError("Expected Swift operator")
        }
    }
    
    private static func identifier(from tokenizer: Tokenizer) throws -> String {
        do {
            let token = try tokenizer.advance(matching: \.tokenType.isIdentifier)
            
            switch token.tokenType {
            case .identifier(let isEscaped):
                if isEscaped {
                    return String(token.value.dropFirst().dropLast())
                }
                
                return String(token.value)
            default:
                throw tokenizer.lexer.syntaxError("Expected identifier")
            }
        } catch {
            throw tokenizer.lexer.syntaxError("Expected identifier")
        }
    }
}

extension SwiftRewriterAttributeParser {
    
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
        case identifier(isEscaped: Bool)
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
        case `subscript`
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
            case .subscript, .extension:
                return 9
            case .fileprivate, .convenience:
                return 11
            case .unowned_safe:
                return 12
            case .unowned_unsafe:
                return 14
            case .identifier(let isEscaped):
                if isEscaped {
                    _=lexer.safeAdvance()
                }
                
                let length = Token.identifierLexer.maximumLength(in: lexer) ?? 0
                
                return length + (isEscaped ? 2 : 0)
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
            case .subscript:
                return "subscript"
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
        
        static func tokenType(at lexer: Lexer) -> Token? {
            if lexer.isEof() {
                return .eof
            }
            
            if lexer.safeIsNextChar(equalTo: "_") {
                return lexer.withTemporaryIndex {
                    try? lexer.advance()
                    
                    if lexer.safeNextCharPasses(with: { !Lexer.isLetter($0) && !Lexer.isDigit($0) && $0 != "_" }) {
                        return .underscore
                    }
                    
                    return .identifier(isEscaped: false)
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
            
            // Escaped identifiers
            if lexer.safeIsNextChar(equalTo: "`") {
                return .identifier(isEscaped: true)
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
                case "subscript":
                    return .subscript
                case "extension":
                    return .extension
                case "fileprivate":
                    return .fileprivate
                case "convenience":
                    return .convenience
                    
                default:
                    return .identifier(isEscaped: false)
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

extension SwiftRewriterAttributeParser.Token {
    var isIdentifier: Bool {
        switch self {
        case .identifier:
            return true
        default:
            return false
        }
    }
    
    var isOperator: Bool {
        switch self {
        case .operator:
            return true
        default:
            return false
        }
    }
}
