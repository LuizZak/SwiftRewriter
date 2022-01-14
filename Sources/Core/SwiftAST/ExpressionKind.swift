/// A deterministic container for all expression types provided by `SwiftAST`.
///
/// Useful for clients that perform different operations across all available
/// `Expression` subclasses.
public enum ExpressionKind: Codable {
    case arrayLiteral(ArrayLiteralExpression)
    case assignment(AssignmentExpression)
    case binary(BinaryExpression)
    case blockLiteral(BlockLiteralExpression)
    case cast(CastExpression)
    case constant(ConstantExpression)
    case dictionaryLiteral(DictionaryLiteralExpression)
    case identifier(IdentifierExpression)
    case parens(ParensExpression)
    case `postfix`(PostfixExpression)
    case `prefix`(PrefixExpression)
    case selector(SelectorExpression)
    case sizeOf(SizeOfExpression)
    case ternary(TernaryExpression)
    case tuple(TupleExpression)
    case typeCheck(TypeCheckExpression)
    case unary(UnaryExpression)
    case tryExpression(TryExpression)
    case unknown(UnknownExpression)

    /// Attempts to initialize this expression kind with a given expression.
    ///
    /// The method requires that the expression conform to `ExpressionKindType`
    /// at runtime.
    public init?(_ expression: Expression) {
        guard let kind = (expression as? ExpressionKindType)?.expressionKind else {
            return nil
        }

        self = kind
    }

    /// Extracts the `Expression` within this `ExpressionKind`.
    public var expression: Expression {
        switch self {
        case .arrayLiteral(let e):
            return e
        case .assignment(let e):
            return e
        case .binary(let e):
            return e
        case .blockLiteral(let e):
            return e
        case .cast(let e):
            return e
        case .constant(let e):
            return e
        case .dictionaryLiteral(let e):
            return e
        case .identifier(let e):
            return e
        case .parens(let e):
            return e
        case .postfix(let e):
            return e
        case .prefix(let e):
            return e
        case .selector(let e):
            return e
        case .sizeOf(let e):
            return e
        case .ternary(let e):
            return e
        case .tuple(let e):
            return e
        case .typeCheck(let e):
            return e
        case .unary(let e):
            return e
        case .tryExpression(let e):
            return e
        case .unknown(let e):
            return e
        }
    }
}

/// Protocol for expression subclasses that expose their type wrapped in `ExpressionKind`
public protocol ExpressionKindType: Expression {
    var expressionKind: ExpressionKind { get }
}
