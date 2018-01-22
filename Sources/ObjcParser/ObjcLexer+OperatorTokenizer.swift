import MiniLexer
import GrammarModels

public extension ObjcLexer {
    internal func readOperator() throws {
        let range = startRange()
        
        var op: Operator?
        
        if lexer.advanceIf(equals: "+=") {
            op = .addAssign
        } else if lexer.advanceIf(equals: "+") {
            op = .add
        } else if lexer.advanceIf(equals: "-=") {
            op = .subtractAssign
        } else if lexer.advanceIf(equals: "-") {
            op = .subtract
        } else if lexer.advanceIf(equals: "*=") {
            op = .multiplyAssign
        } else if lexer.advanceIf(equals: "*") {
            op = .multiply
        } else if lexer.advanceIf(equals: "/=") {
            op = .divideAssign
        } else if lexer.advanceIf(equals: "/") {
            op = .divide
        } else if lexer.advanceIf(equals: "<<=") {
            op = .bitwiseShiftLeftAssign
        } else if lexer.advanceIf(equals: "<<") {
            op = .bitwiseShiftLeft
        } else if lexer.advanceIf(equals: ">>=") {
            op = .bitwiseShiftRightAssign
        } else if lexer.advanceIf(equals: ">>") {
            op = .bitwiseShiftRight
        } else if lexer.advanceIf(equals: "&&") {
            op = .and
        } else if lexer.advanceIf(equals: "||") {
            op = .or
        } else if lexer.advanceIf(equals: "&=") {
            op = .bitwiseAndAssign
        } else if lexer.advanceIf(equals: "|=") {
            op = .bitwiseOrAssign
        } else if lexer.advanceIf(equals: "^=") {
            op = .bitwiseXorAssign
        } else if lexer.advanceIf(equals: "~=") {
            op = .bitwiseNotAssign
        } else if lexer.advanceIf(equals: "&") {
            op = .bitwiseAnd
        } else if lexer.advanceIf(equals: "|") {
            op = .bitwiseOr
        } else if lexer.advanceIf(equals: "^") {
            op = .bitwiseXor
        } else if lexer.advanceIf(equals: "~") {
            op = .bitwiseNot
        } else if lexer.advanceIf(equals: "==") {
            op = .equals
        } else if lexer.advanceIf(equals: "!=") {
            op = .unequals
        } else if lexer.advanceIf(equals: "!") {
            op = .negate
        } else if lexer.advanceIf(equals: "=") {
            op = .assign
        } else if lexer.advanceIf(equals: "<=") {
            op = .lessThanOrEqual
        } else if lexer.advanceIf(equals: "<") {
            op = .lessThan
        } else if lexer.advanceIf(equals: ">=") {
            op = .greaterThanOrEqual
        } else if lexer.advanceIf(equals: ">") {
            op = .greaterThan
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
