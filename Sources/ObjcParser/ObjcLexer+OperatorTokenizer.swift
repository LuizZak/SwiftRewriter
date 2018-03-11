import MiniLexer
import GrammarModels

let operators: [(string: String, op: Operator)] = [
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
