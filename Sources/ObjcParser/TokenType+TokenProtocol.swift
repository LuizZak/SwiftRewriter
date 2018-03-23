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

extension TokenType {
    public static func tokenType(at lexer: Lexer) -> TokenType? {
        // Lex identifiers
        do {
            let p = try lexer.peek()
            
            if Lexer.isLetter(p) || p == "_" || p == "@" {
                if let keyword = lexer.withTemporaryIndex(changes: { attemptReadKeywordToken(lexer: lexer) }) {
                    return keyword
                }
                if let qualifier = lexer.withTemporaryIndex(changes: { attemptReadQualifierToken(lexer: lexer) }) {
                    return qualifier
                }
                if p == "@", let specialChar = lexer.withTemporaryIndex(changes: { attemptReadSpecialChar(lexer: lexer) }) {
                    return specialChar
                }
                if let ident = lexer.withTemporaryIndex(changes: { readIdentifierToken(lexer: lexer) }) {
                    return ident
                }
            } else if let specialChar = lexer.withTemporaryIndex(changes: { attemptReadSpecialChar(lexer: lexer) }) {
                return specialChar
            }
            
            return attemptReadOperator(lexer: lexer)
        } catch {
            return nil
        }
    }
    
    private static func readIdentifierToken(lexer: Lexer) -> TokenType? {
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
        // Lex operators first
        var op: Operator?
        
        for knownOp in operators {
            if lexer.advanceIf(equals: knownOp.string) {
                op = knownOp.op
                break
            }
        }
        
        if let op = op {
            return .operator(op)
        }
        
        return nil
    }
    
    private static func attemptReadQualifierToken(lexer: Lexer) -> TokenType? {
        do {
            let qualifier = try lexer.lexTypeQualifier()
            
            return .typeQualifier(String(qualifier))
        } catch {
            return nil
        }
    }
    
    private static func attemptReadKeywordToken(lexer: Lexer) -> TokenType? {
        do {
            var isAt = false
            if try lexer.peek() == "@" {
                isAt = true
                try lexer.advance()
                
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
