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
}

public extension ObjcLexer {
    internal func readOperator() throws {
        let range = startRange()
        
        var op: Operator?
        
        for knownOp in operators {
            if lexer.advanceIf(equals: knownOp.string) {
                op = knownOp.op
                break
            }
        }
        
        if let op = op {
            currentToken =
                Token(type: TokenType.operator(op), string: String(range.makeSubstring()),
                      location: range.makeLocation())
        } else {
            try lexer.advance()
        }
    }
}
