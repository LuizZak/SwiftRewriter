// TODO: Add extended `&-` operators that provide overflow-ignoring behavior

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

    /// Returns the operator precedence for this `SwiftOperator` in either a
    /// binary expression infix or unary prefix/postfix context.
    public func precedence(asInfix: Bool) -> SwiftOperatorPrecedence {
        guard asInfix else {
            return .prefixPostfixPrecedence
        }

        switch self {
        case .negate, .bitwiseNot:
            return .prefixPostfixPrecedence
        
        case .bitwiseShiftLeft, .bitwiseShiftRight:
            return .bitwiseShiftPrecedence

        case .multiply, .divide, .mod, .bitwiseAnd:
            return .multiplicationPrecedence
        
        case .add, .subtract, .bitwiseXor, .bitwiseOr:
            return .additionPrecedence

        case .openRange, .closedRange:
            return .rangePrecedence

        case .nullCoalesce:
            return .nullCoalescePrecedence

        case .lessThan, .lessThanOrEqual, .greaterThan, .greaterThanOrEqual,
             .equals, .unequals, .identityEquals, .identityUnequals:
            return .comparisonPrecedence
        
        case .and:
            return .logicalConjunctionPrecedence
        
        case .or:
            return .logicalDisjunctionPrecedence
        
        case .assign, .addAssign, .subtractAssign, .multiplyAssign, .divideAssign,
             .bitwiseAndAssign, .bitwiseOrAssign, .bitwiseXorAssign, .bitwiseNotAssign,
             .bitwiseShiftLeftAssign, .bitwiseShiftRightAssign, .modAssign:
            return .assignmentPrecedence
        }
    }
}

extension SwiftOperator: CustomStringConvertible {
    public var description: String {
        rawValue
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

/// Specifies a precedence for a Swift operator.
public struct SwiftOperatorPrecedence: Comparable {
    /// Precedence value. higher numbers indicate a higher precedence order.
    var value: Int

    /// Compares two operator precedences, returning `true` if `lhs` has a higher
    /// priority compared to `rhs` in order of execution.
    public static func < (
        lhs: SwiftOperatorPrecedence,
        rhs: SwiftOperatorPrecedence
    ) -> Bool {
        
        lhs.value > rhs.value
    }
}

public extension SwiftOperatorPrecedence {
    /// Precedence for operators that are used in a unary prefix or postfix
    /// context.
    static let prefixPostfixPrecedence: Self = .init(value: 2_000)

    /// Precedence for default bitwise shift operators `.bitwiseShiftLeft` (`<<`),
    /// and `.bitwiseShiftRight` (`>>`).
    static let bitwiseShiftPrecedence: Self = .init(value: 1_000)

    /// Precedence for default multiplicative operators `.multiply` (`*`), `.divide`
    /// (`/`), `.mod` (`%`), and `.bitwiseAnd` (`&`).
    static let multiplicationPrecedence: Self = .init(value: 900)

    /// Precedence for default additive operators `.add` (`+`), `.subtract`
    /// (`-`), `.bitwiseXor` (`^`), and `.bitwiseOr` (`|`).
    static let additionPrecedence: Self = .init(value: 800)

    /// Precedence for casting and type checking operators (`is`, `as`, `as?`,
    /// and `as!`).
    /// No `SwiftOperator` produces this precedence, but it is left here as a
    /// reference.
    static let castingPrecedence: Self = .init(value: 700)

    /// Precedence for default range-formation operators `.openRange` (`..<`),
    /// and `.closedRange` (`...`).
    static let rangePrecedence: Self = .init(value: 600)

    /// Precedence for `.nullCoalesce` (`??`) operator.
    static let nullCoalescePrecedence: Self = .init(value: 500)

    /// Precedence for default comparison operators `.equals` (`==`), `.unequals`
    /// (`!=`), `.lessThan` (`<`), `.lessThanOrEqual` (`<=`), `.greaterThan` (`>`),
    /// `.greaterThanOrEqual` (`>=`), `.identityEquals` (`===`), and
    /// `.identityUnequals` (`!==`).
    static let comparisonPrecedence: Self = .init(value: 400)

    /// Precedence for `.and` (`&&`).
    static let logicalConjunctionPrecedence: Self = .init(value: 300)

    /// Precedence for `.or` (`||`).
    static let logicalDisjunctionPrecedence: Self = .init(value: 200)

    /// Precedence for a ternary expression.
    /// No `SwiftOperator` produces this precedence, but it is left here as a
    /// reference.
    static let ternaryPrecedence: Self = .init(value: 100)

    /// Precedence for any assignment operator (suffixed with `-assign`).
    static let assignmentPrecedence: Self = .init(value: 50)
}
