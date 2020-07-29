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

public class Expression: SyntaxNode, Codable, ExpressionComponent, Equatable,
                         CustomStringConvertible, CustomReflectable {
    
    /// `true` if this expression sub-tree contains only literal-based sub-expressions.
    /// Literal based sub-expressions include: `.constant`, as well as `.binary`,
    /// `.unary`, `.prefix`, `.parens`, and `.ternary` which only feature
    /// literal sub-expressions.
    ///
    /// For ternary expressions, the test predicate doesn't have to be be a
    /// literal as well for the result to be `true`.
    open var isLiteralExpression: Bool {
        false
    }
    
    /// In case this expression is a literal expression type, returns the
    /// resolved literal kind it represents, recursively traversing literal
    /// sub-expressions until a `ConstantExpression` can be found to inspect.
    ///
    /// Composed expression types such as binary and ternary expressions always
    /// return `nil`.
    open var literalExpressionKind: LiteralExpressionKind? {
        nil
    }
    
    /// `true` if this expression node requires parenthesis for unary, prefix, and
    /// postfix operations.
    open var requiresParens: Bool {
        false
    }
    
    open var description: String {
        "\(type(of: self))"
    }
    
    open var customMirror: Mirror {
        Mirror(reflecting: "")
    }
    
    /// Returns an array of sub-expressions contained within this expression, in
    /// case it is an expression formed of other expressions.
    open var subExpressions: [Expression] {
        []
    }
    
    /// If this expression's parent type is an expression, returns that parent
    /// casted to an expression.
    ///
    /// Returns `nil`, in case no parent is present, or if the parent is not an
    /// Expression type.
    open var parentExpression: Expression? {
        parent as? Expression
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
        resolvedType != nil && !isErrorTyped
    }
    
    /// Returns `true` if this expression's type is currently resolved as an error type.
    public var isErrorTyped: Bool {
        resolvedType == .errorType
    }
    
    override internal init() {
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
    @inlinable
    public func makeErrorTyped() -> Expression {
        resolvedType = .errorType
        return self
    }
    
    /// Accepts the given visitor instance, calling the appropriate visiting method
    /// according to this expression's type.
    ///
    /// - Parameter visitor: The visitor to accept
    /// - Returns: The result of the visitor's `visit-` call when applied to this
    /// expression
    @inlinable
    open func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitExpression(self)
    }
    
    @inlinable
    open override func copy() -> Expression {
        fatalError("Must be overriden by subclasses")
    }
    
    open func isEqual(to other: Expression) -> Bool {
        false
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
    
    @usableFromInline
    final func cast<T: Expression>() -> T? {
        self as? T
    }
    
    private enum CodingKeys: String, CodingKey {
        case resolvedType
    }
}

/// Helper static creators
public extension Expression {
    static func assignment(lhs: Expression, op: SwiftOperator, rhs: Expression) -> AssignmentExpression {
        AssignmentExpression(lhs: lhs, op: op, rhs: rhs)
    }
    
    static func binary(lhs: Expression, op: SwiftOperator, rhs: Expression) -> BinaryExpression {
        BinaryExpression(lhs: lhs, op: op, rhs: rhs)
    }
    
    static func unary(op: SwiftOperator, _ exp: Expression) -> UnaryExpression {
        UnaryExpression(op: op, exp: exp)
    }
    
    static func sizeof(_ exp: Expression) -> SizeOfExpression {
        SizeOfExpression(value: .expression(exp))
    }
    
    static func sizeof(type: SwiftType) -> SizeOfExpression {
        SizeOfExpression(value: .type(type))
    }
    
    static func prefix(op: SwiftOperator, _ exp: Expression) -> PrefixExpression {
        PrefixExpression(op: op, exp: exp)
    }
    
    static func postfix(_ exp: Expression, _ op: Postfix) -> PostfixExpression {
        PostfixExpression(exp: exp, op: op)
    }
    
    static func constant(_ constant: Constant) -> ConstantExpression {
        ConstantExpression(constant: constant)
    }
    
    static func parens(_ exp: Expression) -> ParensExpression {
        ParensExpression(exp: exp)
    }
    
    static func identifier(_ ident: String) -> IdentifierExpression {
        IdentifierExpression(identifier: ident)
    }
    
    static func cast(_ exp: Expression, type: SwiftType, isOptionalCast: Bool = true) -> CastExpression {
        CastExpression(exp: exp, type: type, isOptionalCast: isOptionalCast)
    }
    
    static func arrayLiteral(_ array: [Expression]) -> ArrayLiteralExpression {
        ArrayLiteralExpression(items: array)
    }
    
    static func dictionaryLiteral(_ pairs: [ExpressionDictionaryPair]) -> DictionaryLiteralExpression {
        DictionaryLiteralExpression(pairs: pairs)
    }
    
    static func dictionaryLiteral(
        _ pairs: KeyValuePairs<Expression, Expression>) -> DictionaryLiteralExpression {
        
        DictionaryLiteralExpression(
            pairs: pairs.map {
                ExpressionDictionaryPair(key: $0.key, value: $0.value)
            }
        )
    }
    
    static func ternary(_ exp: Expression,
                        `true` ifTrue: Expression,
                        `false` ifFalse: Expression) -> TernaryExpression {
        
        TernaryExpression(exp: exp, ifTrue: ifTrue, ifFalse: ifFalse)
    }
    
    static func block(parameters: [BlockParameter] = [],
                      `return` returnType: SwiftType = .void,
                      body: CompoundStatement) -> BlockLiteralExpression {
        
        BlockLiteralExpression(parameters: parameters, returnType: returnType, body: body)
    }
    
    static func tuple(_ elements: [Expression]) -> TupleExpression {
        TupleExpression(elements: elements)
    }
    
    static func selector(_ identifier: FunctionIdentifier) -> SelectorExpression {
        SelectorExpression(functionIdentifier: identifier)
    }
    static func selector(_ type: SwiftType, _ identifier: FunctionIdentifier) -> SelectorExpression {
        SelectorExpression(type: type, functionIdentifier: identifier)
    }
    
    static func selector(getter: String) -> SelectorExpression {
        SelectorExpression(getter: getter)
    }
    static func selector(_ type: SwiftType, getter: String) -> SelectorExpression {
        SelectorExpression(type: type, getter: getter)
    }
    
    static func selector(setter: String) -> SelectorExpression {
        SelectorExpression(setter: setter)
    }
    static func selector(_ type: SwiftType, setter: String) -> SelectorExpression {
        SelectorExpression(type: type, setter: setter)
    }
    
    static func unknown(_ exp: UnknownASTContext) -> UnknownExpression {
        UnknownExpression(context: exp)
    }
}

// MARK: - Operator definitions
public extension Expression {
    static func + (lhs: Expression, rhs: Expression) -> Expression {
        .binary(lhs: lhs, op: .add, rhs: rhs)
    }
    
    static func - (lhs: Expression, rhs: Expression) -> Expression {
        .binary(lhs: lhs, op: .subtract, rhs: rhs)
    }
    
    static func * (lhs: Expression, rhs: Expression) -> Expression {
        .binary(lhs: lhs, op: .multiply, rhs: rhs)
    }
    
    static func / (lhs: Expression, rhs: Expression) -> Expression {
        .binary(lhs: lhs, op: .divide, rhs: rhs)
    }
    
    static prefix func ! (lhs: Expression) -> Expression {
        .unary(op: .negate, lhs)
    }
    
    static func && (lhs: Expression, rhs: Expression) -> Expression {
        .binary(lhs: lhs, op: .and, rhs: rhs)
    }
    
    static func || (lhs: Expression, rhs: Expression) -> Expression {
        .binary(lhs: lhs, op: .or, rhs: rhs)
    }
    
    static func | (lhs: Expression, rhs: Expression) -> Expression {
        .binary(lhs: lhs, op: .bitwiseOr, rhs: rhs)
    }
    
    static func & (lhs: Expression, rhs: Expression) -> Expression {
        .binary(lhs: lhs, op: .bitwiseAnd, rhs: rhs)
    }
}

extension Expression {
    
    @inlinable
    public func copyTypeAndMetadata(from other: Expression) -> Self {
        self.metadata = other.metadata
        self.resolvedType = other.resolvedType
        self.expectedType = other.expectedType
        
        return self
    }
    
}
