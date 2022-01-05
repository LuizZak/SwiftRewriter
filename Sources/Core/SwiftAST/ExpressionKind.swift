/// A deterministic container for all expression types provided by `SwiftAST`.
///
/// Useful for clients that perform different operations across all available
/// `Expression` subclasses.
public enum ExpressionKind {
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
    case unknown(UnknownExpression)
}

/// Protocol for expression subclasses that expose their type wrapped in `ExpressionKind`
public protocol ExpressionKindType: Expression {
    var expressionKind: ExpressionKind { get }
}
