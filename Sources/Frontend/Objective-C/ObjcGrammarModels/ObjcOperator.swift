/// Describes an operator across one or two operands
public enum ObjcOperator: String {
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
    
    case addAssign = "+="
    case subtractAssign = "-="
    case multiplyAssign = "*="
    case divideAssign = "/="
    
    case negate = "!"
    case and = "&&"
    case or = "||"
    
    case bitwiseAnd = "&"
    case bitwiseOr = "|"
    case bitwiseXor = "^"
    case bitwiseNot = "~"
    case bitwiseShiftLeft = "<<"
    case bitwiseShiftRight = ">>"
    
    case bitwiseAndAssign = "&="
    case bitwiseOrAssign = "|="
    case bitwiseXorAssign = "^="
    case bitwiseNotAssign = "~="
    case bitwiseShiftLeftAssign = "<<="
    case bitwiseShiftRightAssign = ">>="
    
    case lessThan = "<"
    case lessThanOrEqual = "<="
    case greaterThan = ">"
    case greaterThanOrEqual = ">="
    
    case assign = "="
    case equals = "=="
    case unequals = "!="
}
