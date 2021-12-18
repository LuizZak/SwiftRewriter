import MiniLexer
import GrammarModels

let operators: [(string: String, op: Operator)] = [
    // It is important to leave the operators in order, because since the first
    // match is used, an operator like "+" might be returned instead of the full
    // operator "+=".
    ("+=", .addAssign),
    ("+", .add),
    ("-=", .subtractAssign),
    ("-", .subtract),
    ("*=", .multiplyAssign),
    ("*", .multiply),
    ("/=", .divideAssign),
    ("/", .divide),
    ("<<=", .bitwiseShiftLeftAssign),
    ("<<", .bitwiseShiftLeft),
    (">>=", .bitwiseShiftRightAssign),
    (">>", .bitwiseShiftRight),
    ("&&", .and),
    ("||", .or),
    ("&=", .bitwiseAndAssign),
    ("|=", .bitwiseOrAssign),
    ("^=", .bitwiseXorAssign),
    ("~=", .bitwiseNotAssign),
    ("&", .bitwiseAnd),
    ("|", .bitwiseOr),
    ("^", .bitwiseXor),
    ("~", .bitwiseNot),
    ("==", .equals),
    ("!=", .unequals),
    ("!", .negate),
    ("=", .assign),
    ("<=", .lessThanOrEqual),
    ("<", .lessThan),
    (">=", .greaterThanOrEqual),
    (">", .greaterThan)
]

extension TokenType: TokenProtocol {
    public static var eofToken: TokenType {
        .eof
    }
    
    public var tokenString: String {
        self.description
    }
    
    public func length(in lexer: Lexer) -> Int {
        switch self {
        case .unknown, .eof:
            return 0
        case .at, .colon, .openBrace, .closeBrace, .openParens, .closeParens,
             .openSquareBracket, .closeSquareBracket, .comma, .period, .semicolon:
            return 1
        case .id:
            return 2
        case .ellipsis:
            return 3
        case .operator(let op):
            return op.rawValue.count
        case .floatLiteral(let str), .stringLiteral(let str), .hexLiteral(let str),
             .octalLiteral(let str), .decimalLiteral(let str), .identifier(let str),
             .typeQualifier(let str):
            return str.count
        case .keyword(let kw):
            return kw.rawValue.count
        }
    }
    
    public func advance(in lexer: Lexer) throws {
        let l = length(in: lexer)
        
        if l <= 0 {
            return
        }
        
        try lexer.advanceLength(l)
    }
    
    public static func tokenType(at lexer: Lexer) -> TokenType? {
        // Lex identifiers
        do {
            let p = try lexer.peek()
            
            if Lexer.isLetter(p) || p == "_" || p == "@" {
                if let keyword = attemptReadKeywordToken(lexer: lexer) {
                    return keyword
                }
                if let qualifier = attemptReadQualifierToken(lexer: lexer) {
                    return qualifier
                }
                if p == "@", let specialChar = attemptReadSpecialChar(lexer: lexer) {
                    return specialChar
                }
                if let ident = readIdentifierToken(lexer: lexer) {
                    return ident
                }
            } else if let specialChar = attemptReadSpecialChar(lexer: lexer) {
                return specialChar
            }
            
            return attemptReadOperator(lexer: lexer)
        } catch {
            return nil
        }
    }
    
    private static func readIdentifierToken(lexer: Lexer) -> TokenType? {
        let bt = lexer.backtracker(); defer { bt.backtrack(lexer: lexer) }
        
        do {
            let ident = try lexer.lexIdentifier()
            
            if ident == "id" {
                return .id
            }
            
            return .identifier(String(ident))
        } catch {
            return nil
        }
    }
    
    private static func attemptReadOperator(lexer: Lexer) -> TokenType? {
        let bt = lexer.backtracker(); defer { bt.backtrack(lexer: lexer) }
        
        // Lex operators first
        for knownOp in operators {
            if lexer.advanceIf(equals: knownOp.string) {
                return .operator(knownOp.op)
            }
        }
        
        return nil
    }
    
    private static func attemptReadQualifierToken(lexer: Lexer) -> TokenType? {
        let bt = lexer.backtracker(); defer { bt.backtrack(lexer: lexer) }
        
        do {
            let qualifier = try lexer.lexTypeQualifier()
            
            return .typeQualifier(String(qualifier))
        } catch {
            return nil
        }
    }
    
    private static func attemptReadKeywordToken(lexer: Lexer) -> TokenType? {
        let bt = lexer.backtracker(); defer { bt.backtrack(lexer: lexer) }
        
        do {
            var isAt = false
            if lexer.advanceIf(equals: "@") {
                isAt = true
                
                if lexer.isEof() {
                    return nil
                }
            }
            
            let keyword = try (isAt ? "@" : "") + lexer.lexIdentifier()
            
            guard let kw = Keyword(rawValue: String(keyword)) else {
                return nil
            }
            
            return .keyword(kw)
        } catch {
            return nil
        }
    }
    
    private static func attemptReadSpecialChar(lexer: Lexer) -> TokenType? {
        let bt = lexer.backtracker(); defer { bt.backtrack(lexer: lexer) }
        
        do {
            let type: TokenType
            
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
                } else {
                    type = .period
                }
            default:
                return nil
            }
            
            return type
        } catch {
            return nil
        }
    }
}
