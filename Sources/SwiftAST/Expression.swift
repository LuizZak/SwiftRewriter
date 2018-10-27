import Foundation

/// An expression component is understood to be any component of an expression,
/// or an expression itself, which can be contained within another expression,
/// and can contain sub-expressions itself.
///
/// `Expression`-subtypes are always expression components themselves, and constructs
/// such as postfix operators, which themselves can contain expressions, should
/// be marked as expression components as well.
public protocol ExpressionComponent {
    /// Returns an array of sub-expressions contained within this expression fragment,
    /// in case it is an expression formed of other expressions.
    var subExpressions: [Expression] { get }
}

open class Expression: SyntaxNode, Codable, ExpressionComponent, Equatable, CustomStringConvertible, CustomReflectable {
    /// `true` if this expression sub-tree contains only literal-based sub-expressions.
    /// Literal based sub-expressions include: `.constant`, as well as `.binary`,
    /// `.unary`, `.prefix`, `.parens`, and `.ternary` which only feature
    /// literal sub-expressions.
    ///
    /// For ternary expressions, the test predicate doesn't have to be be a
    /// literal as well for the result to be `true`.
    open var isLiteralExpression: Bool {
        return false
    }
    
    /// In case this expression is a literal expression type, returns the
    /// resolved literal kind it represents, recursively traversing literal
    /// sub-expressions until a `ConstantExpression` can be found to inspect.
    ///
    /// Composed expression types such as binary and ternary expressions always
    /// return `nil`.
    open var literalExpressionKind: LiteralExpressionKind? {
        return nil
    }
    
    /// `true` if this expression node requires parenthesis for unary, prefix, and
    /// postfix operations.
    open var requiresParens: Bool {
        return false
    }
    
    open var description: String {
        return "\(type(of: self))"
    }
    
    open var customMirror: Mirror {
        return Mirror(reflecting: "")
    }
    
    /// Returns an array of sub-expressions contained within this expression, in
    /// case it is an expression formed of other expressions.
    open var subExpressions: [Expression] {
        return []
    }
    
    /// If this expression's parent type is an expression, returns that parent
    /// casted to an expression.
    ///
    /// Returns `nil`, in case no parent is present, or if the parent is not an
    /// Expression type.
    open var parentExpression: Expression? {
        return parent as? Expression
    }
    
    /// Resolved type of this expression.
    /// Is `nil`, in case it has not been resolved yet.
    open var resolvedType: SwiftType?
    
    /// An expected type for this expression.
    /// This is usually set by an outer syntax node context to hint at an expected
    /// resulting type for this expression, such as boolean expressions in `if`
    /// statements or rhs types in assignment operations.
    ///
    /// Is nil, in case no specific type is expected.
    open var expectedType: SwiftType?
    
    /// Returns `true` if this expression's type has been successfully resolved
    /// with a non-error type.
    public var isTypeResolved: Bool {
        return resolvedType != nil && !isErrorTyped
    }
    
    /// Returns `true` if this expression's type is currently resolved as an error type.
    public var isErrorTyped: Bool {
        return resolvedType == .errorType
    }
    
    override public init() {
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.resolvedType =
            try container.decodeIfPresent(SwiftType.self, forKey: .resolvedType)
    }
    
    /// Changes this Expression's resolved type to be an error type.
    /// This overwrites any existing type that may be assigned.
    /// Returns self for potential chaining support.
    @discardableResult
    open func makeErrorTyped() -> Expression {
        resolvedType = .errorType
        return self
    }
    
    /// Accepts the given visitor instance, calling the appropriate visiting method
    /// according to this expression's type.
    ///
    /// - Parameter visitor: The visitor to accept
    /// - Returns: The result of the visitor's `visit-` call when applied to this
    /// expression
    open func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitExpression(self)
    }
    
    open override func copy() -> Expression {
        fatalError("Must be overriden by subclasses")
    }
    
    open func isEqual(to other: Expression) -> Bool {
        return false
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if encoder.userInfo[SerializationOptions._encodeExpressionTypes] as? Bool == true {
            try container.encodeIfPresent(resolvedType, forKey: .resolvedType)
        }
    }
    
    public static func == (lhs: Expression, rhs: Expression) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.isEqual(to: rhs)
    }
    
    final func cast<T: Expression>() -> T? {
        return self as? T
    }
    
    private enum CodingKeys: String, CodingKey {
        case resolvedType
    }
}

/// Helper static creators
public extension Expression {
    public static func assignment(lhs: Expression, op: SwiftOperator, rhs: Expression) -> AssignmentExpression {
        return AssignmentExpression(lhs: lhs, op: op, rhs: rhs)
    }
    
    public static func binary(lhs: Expression, op: SwiftOperator, rhs: Expression) -> BinaryExpression {
        return BinaryExpression(lhs: lhs, op: op, rhs: rhs)
    }
    
    public static func unary(op: SwiftOperator, _ exp: Expression) -> UnaryExpression {
        return UnaryExpression(op: op, exp: exp)
    }
    
    public static func sizeof(_ exp: Expression) -> SizeOfExpression {
        return SizeOfExpression(value: .expression(exp))
    }
    
    public static func sizeof(type: SwiftType) -> SizeOfExpression {
        return SizeOfExpression(value: .type(type))
    }
    
    public static func prefix(op: SwiftOperator, _ exp: Expression) -> PrefixExpression {
        return PrefixExpression(op: op, exp: exp)
    }
    
    public static func postfix(_ exp: Expression, _ op: Postfix) -> PostfixExpression {
        return PostfixExpression(exp: exp, op: op)
    }
    
    public static func constant(_ constant: Constant) -> ConstantExpression {
        return ConstantExpression(constant: constant)
    }
    
    public static func parens(_ exp: Expression) -> ParensExpression {
        return ParensExpression(exp: exp)
    }
    
    public static func identifier(_ ident: String) -> IdentifierExpression {
        return IdentifierExpression(identifier: ident)
    }
    
    public static func cast(_ exp: Expression, type: SwiftType) -> CastExpression {
        return CastExpression(exp: exp, type: type)
    }
    
    public static func arrayLiteral(_ array: [Expression]) -> ArrayLiteralExpression {
        return ArrayLiteralExpression(items: array)
    }
    
    public static func dictionaryLiteral(_ pairs: [ExpressionDictionaryPair]) -> DictionaryLiteralExpression {
        return DictionaryLiteralExpression(pairs: pairs)
    }
    
    public static func dictionaryLiteral(
        _ pairs: DictionaryLiteral<Expression, Expression>) -> DictionaryLiteralExpression {
        
        return
            DictionaryLiteralExpression(
                pairs: pairs.map {
                    ExpressionDictionaryPair(key: $0.key, value: $0.value)
                }
            )
    }
    
    public static func ternary(_ exp: Expression,
                               `true` ifTrue: Expression,
                               `false` ifFalse: Expression) -> TernaryExpression {
        
        return TernaryExpression(exp: exp, ifTrue: ifTrue, ifFalse: ifFalse)
    }
    
    public static func block(parameters: [BlockParameter] = [],
                             `return` returnType: SwiftType = .void,
                             body: CompoundStatement) -> BlockLiteralExpression {
        
        return BlockLiteralExpression(parameters: parameters, returnType: returnType, body: body)
    }
    
    public static func unknown(_ exp: UnknownASTContext) -> UnknownExpression {
        return UnknownExpression(context: exp)
    }
}

// MARK: - Operator definitions
public extension Expression {
    public static func + (lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .add, rhs: rhs)
    }
    
    public static func - (lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .subtract, rhs: rhs)
    }
    
    public static func * (lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .multiply, rhs: rhs)
    }
    
    public static func / (lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .divide, rhs: rhs)
    }
    
    public static prefix func ! (lhs: Expression) -> Expression {
        return .unary(op: .negate, lhs)
    }
    
    public static func && (lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .and, rhs: rhs)
    }
    
    public static func || (lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .or, rhs: rhs)
    }
    
    public static func | (lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .bitwiseOr, rhs: rhs)
    }
    
    public static func & (lhs: Expression, rhs: Expression) -> Expression {
        return .binary(lhs: lhs, op: .bitwiseAnd, rhs: rhs)
    }
}

extension Expression {
    
    public func copyTypeAndMetadata(from other: Expression) -> Self {
        self.metadata = other.metadata
        self.resolvedType = other.resolvedType
        self.expectedType = other.expectedType
        
        return self
    }
    
}
