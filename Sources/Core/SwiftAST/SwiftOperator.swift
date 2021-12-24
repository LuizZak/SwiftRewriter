/// Specifies an operator across one or two operands
public enum SwiftOperator: String, Codable {
    /// If `true`, a spacing is suggested to be placed in between operands.
    /// True for most operators except range operators.
    public var requiresSpacing: Bool {
        switch self {
        case .openRange, .closedRange:
            return false
        default:
            return true
        }
    }
    
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "/"
    case mod = "%"
    
    case addAssign = "+="
    case subtractAssign = "-="
    case multiplyAssign = "*="
    case divideAssign = "/="
    /// Modulo assign (%=)
    case modAssign = "%="
    
    case negate = "!"
    case and = "&&"
    case or = "||"
    
    /// Bitwise And (&)
    case bitwiseAnd = "&"
    /// Bitwise Or (|)
    case bitwiseOr = "|"
    /// Bitwise Xor (^)
    case bitwiseXor = "^"
    /// Bitwise Not (~)
    case bitwiseNot = "~"
    /// Bitwise Shift left (<<)
    case bitwiseShiftLeft = "<<"
    /// Bitwise Shift right (>>)
    case bitwiseShiftRight = ">>"
    
    /// Bitwise And assign (&=)
    case bitwiseAndAssign = "&="
    /// Bitwise Or assign (|=)
    case bitwiseOrAssign = "|="
    /// Bitwise Xor assign (^=)
    case bitwiseXorAssign = "^="
    /// Bitwise Not assign (~=)
    case bitwiseNotAssign = "~="
    /// Bitwise Shift left assign (<==)
    case bitwiseShiftLeftAssign = "<<="
    /// Bitwise Shift right assign (>>=)
    case bitwiseShiftRightAssign = ">>="
    
    case lessThan = "<"
    case lessThanOrEqual = "<="
    case greaterThan = ">"
    case greaterThanOrEqual = ">="
    
    case assign = "="
    case equals = "=="
    case unequals = "!="
    case identityEquals = "==="
    case identityUnequals = "!=="
    
    /// Null-coalesce operator (??)
    case nullCoalesce = "??"
    
    /// Open range (..<)
    case openRange = "..<"

    /// Closed range (...)
    case closedRange = "..."
    
    /// Gets the category for this operator
    public var category: SwiftOperatorCategory {
        switch self {
        // Arithmetic
        case .add, .subtract, .multiply, .divide, .mod:
            return .arithmetic
            
        // Logical
        case .and, .or, .negate:
            return .logical
            
        // Bitwise
        case .bitwiseAnd, .bitwiseOr, .bitwiseXor, .bitwiseNot, .bitwiseShiftLeft,
             .bitwiseShiftRight:
            return .bitwise
            
        // Assignment
        case .assign, .addAssign, .subtractAssign, .multiplyAssign, .divideAssign,
             .bitwiseAndAssign, .bitwiseOrAssign, .bitwiseXorAssign, .bitwiseNotAssign,
             .bitwiseShiftLeftAssign, .bitwiseShiftRightAssign, .modAssign:
            return .assignment
            
        // Comparison
        case .lessThan, .lessThanOrEqual, .greaterThan, .greaterThanOrEqual,
             .equals, .unequals, .identityEquals, .identityUnequals:
            return .comparison
            
        // Null-coalesce
        case .nullCoalesce:
            return .nullCoalesce
            
        // Range-making operators
        case .openRange, .closedRange:
            return .range
        }
    }
}

public enum SwiftOperatorCategory: Equatable {
    case arithmetic
    case comparison
    case logical
    case bitwise
    case nullCoalesce
    case assignment
    case range
}

extension SwiftOperator: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}
