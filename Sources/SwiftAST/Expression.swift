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

open class Expression: SyntaxNode, ExpressionComponent, Equatable, CustomStringConvertible, CustomReflectable {
    /// `true` if this expression sub-tree contains only literal-based sub-expressions.
    /// Literal based sub-expressions include: `.constant`, as well as `.binary`,
    /// `.unary`, `.prefix`, `.parens`, and `.ternary` which only feature
    /// literal sub-expressions.
    ///
    /// For ternary expressions, the test expression to the left of the question
    /// mark operand does not affect the result of literal-based tests.
    open var isLiteralExpression: Bool {
        return false
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
    
    public static func == (lhs: Expression, rhs: Expression) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.isEqual(to: rhs)
    }
    
    fileprivate func cast<T>() -> T? {
        return self as? T
    }
}

public class AssignmentExpression: Expression {
    public var lhs: Expression {
        didSet { oldValue.parent = nil; lhs.parent = self; }
    }
    public var op: SwiftOperator
    public var rhs: Expression {
        didSet { oldValue.parent = nil; rhs.parent = self; }
    }
    
    public override var subExpressions: [Expression] {
        return [lhs, rhs]
    }
    
    public override var requiresParens: Bool {
        return true
    }
    
    public override var description: String {
        // With spacing
        if op.requiresSpacing {
            return "\(lhs.description) \(op) \(rhs.description)"
        }
        
        // No spacing
        return "\(lhs.description)\(op)\(rhs.description)"
    }
    
    public init(lhs: Expression, op: SwiftOperator, rhs: Expression) {
        self.lhs = lhs
        self.op = op
        self.rhs = rhs
        
        super.init()
        
        lhs.parent = self
        rhs.parent = self
    }
    
    public override func copy() -> AssignmentExpression {
        return
            AssignmentExpression(
                lhs: lhs.copy(),
                op: op,
                rhs: rhs.copy()
            ).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitAssignment(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as AssignmentExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: AssignmentExpression, rhs: AssignmentExpression) -> Bool {
        return lhs.lhs == rhs.lhs && lhs.op == rhs.op && lhs.rhs == rhs.rhs
    }
}
public extension Expression {
    public var asAssignment: AssignmentExpression? {
        return cast()
    }
}

public class BinaryExpression: Expression {
    public var lhs: Expression {
        didSet { oldValue.parent = nil; lhs.parent = self; }
    }
    public var op: SwiftOperator
    public var rhs: Expression {
        didSet { oldValue.parent = nil; rhs.parent = self; }
    }
    
    public override var subExpressions: [Expression] {
        return [lhs, rhs]
    }
    
    public override var isLiteralExpression: Bool {
        return lhs.isLiteralExpression && rhs.isLiteralExpression
    }
    
    public override var requiresParens: Bool {
        return true
    }
    
    public override var description: String {
        // With spacing
        if op.requiresSpacing {
            return "\(lhs.description) \(op) \(rhs.description)"
        }
        
        // No spacing
        return "\(lhs.description)\(op)\(rhs.description)"
    }
    
    public init(lhs: Expression, op: SwiftOperator, rhs: Expression) {
        self.lhs = lhs
        self.op = op
        self.rhs = rhs
        
        super.init()
        
        self.lhs.parent = self
        self.rhs.parent = self
    }
    
    public override func copy() -> BinaryExpression {
        return
            BinaryExpression(
                lhs: lhs.copy(),
                op: op,
                rhs: rhs.copy()
            ).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitBinary(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as BinaryExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: BinaryExpression, rhs: BinaryExpression) -> Bool {
        return lhs.lhs == rhs.lhs && lhs.op == rhs.op && lhs.rhs == rhs.rhs
    }
}
extension Expression {
    public var asBinary: BinaryExpression? {
        return cast()
    }
}

public class UnaryExpression: Expression {
    public var op: SwiftOperator
    public var exp: Expression {
        didSet { oldValue.parent = nil; exp.parent = self; }
    }
    
    public override var subExpressions: [Expression] {
        return [exp]
    }
    
    public override var isLiteralExpression: Bool {
        return exp.isLiteralExpression
    }
    
    public override var description: String {
        // Parenthesized
        if exp.requiresParens {
            return "\(op)(\(exp))"
        }
        
        return "\(op)\(exp)"
    }
    
    public init(op: SwiftOperator, exp: Expression) {
        self.op = op
        self.exp = exp
        
        super.init()
        
        exp.parent = self
    }
    
    public override func copy() -> UnaryExpression {
        return UnaryExpression(op: op, exp: exp.copy()).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitUnary(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as UnaryExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: UnaryExpression, rhs: UnaryExpression) -> Bool {
        return lhs.op == rhs.op && lhs.exp == rhs.exp
    }
}
extension Expression {
    public var asUnary: UnaryExpression? {
        return cast()
    }
}

public class SizeOfExpression: Expression {
    public var value: Value {
        didSet {
            switch oldValue {
            case .expression(let exp):
                exp.parent = nil
            case .type: break
            }
            
            switch value {
            case .expression(let exp):
                exp.parent = self
            case .type: break
            }
        }
    }
    
    /// If this `SizeOfExpression`'s value is an expression input value, returns
    /// that expression, otherwise returns `nil`
    public var exp: Expression? {
        switch value {
        case .expression(let exp):
            return exp
        case .type:
            return nil
        }
    }
    
    public override var subExpressions: [Expression] {
        switch value {
        case .expression(let exp):
            return [exp]
        case .type:
            return []
        }
    }
    
    public init(value: Value) {
        self.value = value
        super.init()
    }
    
    public override func copy() -> SizeOfExpression {
        return SizeOfExpression(value: value.copy()).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V>(_ visitor: V) -> V.ExprResult where V : ExpressionVisitor {
        return visitor.visitSizeOf(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as SizeOfExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: SizeOfExpression, rhs: SizeOfExpression) -> Bool {
        return lhs.value == rhs.value
    }
    
    /// Inner expression value for this SizeOfExpression
    public enum Value: Equatable {
        case type(SwiftType)
        case expression(Expression)
        
        public func copy() -> Value {
            switch self {
            case .type:
                return self
            case .expression(let exp):
                return .expression(exp.copy())
            }
        }
    }
}
extension Expression {
    public var asSizeOf: SizeOfExpression? {
        return cast()
    }
}

public class PrefixExpression: Expression {
    public var op: SwiftOperator
    public var exp: Expression {
        didSet { oldValue.parent = nil; exp.parent = self; }
    }
    
    public override var subExpressions: [Expression] {
        return [exp]
    }
    
    public override var isLiteralExpression: Bool {
        return exp.isLiteralExpression
    }
    
    public override var description: String {
        // Parenthesized
        if exp.requiresParens {
            return "\(op)(\(exp))"
        }
        
        return "\(op)\(exp)"
    }
    
    public init(op: SwiftOperator, exp: Expression) {
        self.op = op
        self.exp = exp
        
        super.init()
        
        exp.parent = self
    }
    
    public override func copy() -> PrefixExpression {
        return PrefixExpression(op: op, exp: exp.copy()).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitPrefix(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as PrefixExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: PrefixExpression, rhs: PrefixExpression) -> Bool {
        return lhs.op == rhs.op && lhs.exp == rhs.exp
    }
}
extension Expression {
    public var asPrefix: PrefixExpression? {
        return cast()
    }
}

public class PostfixExpression: Expression {
    private var _subExpressions: [Expression] = []
    
    public var exp: Expression {
        didSet {
            oldValue.parent = nil
            exp.parent = self
            
            _subExpressions = [exp] + op.subExpressions
        }
    }
    public var op: Postfix {
        didSet {
            oldValue.subExpressions.forEach { $0.parent = nil }
            oldValue.postfixExpression = nil
            op.subExpressions.forEach { $0.parent = self }
            op.postfixExpression = self
            
            _subExpressions = [exp] + op.subExpressions
        }
    }
    
    public override var subExpressions: [Expression] {
        return _subExpressions
    }
    
    public override var description: String {
        // Parenthesized
        if exp.requiresParens {
            return "(\(exp))\(op)"
        }
        
        return "\(exp)\(op)"
    }
    
    public init(exp: Expression, op: Postfix) {
        self.exp = exp
        self.op = op
        
        super.init()
        
        exp.parent = self
        
        op.subExpressions.forEach { $0.parent = self }
        op.postfixExpression = self
        
        _subExpressions = [exp] + op.subExpressions
    }
    
    public override func copy() -> PostfixExpression {
        return PostfixExpression(exp: exp.copy(), op: op.copy()).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitPostfix(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as PostfixExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: PostfixExpression, rhs: PostfixExpression) -> Bool {
        return lhs.exp == rhs.exp && lhs.op == rhs.op
    }
}
extension Expression {
    public var asPostfix: PostfixExpression? {
        return cast()
    }
}

public class ConstantExpression: Expression, ExpressibleByStringLiteral,
                                 ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public var constant: Constant
    
    public override var isLiteralExpression: Bool {
        if constant.isInteger {
            return true
        }
        
        switch constant {
        case .boolean, .nil, .float, .string:
            return true
        default:
            return false
        }
    }
    
    public override var description: String {
        return constant.description
    }
    
    public init(constant: Constant) {
        self.constant = constant
    }
    
    public override func copy() -> ConstantExpression {
        return ConstantExpression(constant: constant).copyTypeAndMetadata(from: self)
    }
    
    public required init(stringLiteral value: String) {
        constant = .string(value)
    }
    public required init(integerLiteral value: Int) {
        constant = .int(value, .decimal)
    }
    public required init(floatLiteral value: Float) {
        constant = .float(value)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitConstant(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as ConstantExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: ConstantExpression, rhs: ConstantExpression) -> Bool {
        return lhs.constant == rhs.constant
    }
}
public extension Expression {
    public var asConstant: ConstantExpression? {
        return self as? ConstantExpression
    }
}

public class ParensExpression: Expression {
    public var exp: Expression {
        didSet { oldValue.parent = nil; exp.parent = self; }
    }
    
    public override var subExpressions: [Expression] {
        return [exp]
    }
    
    public override var isLiteralExpression: Bool {
        return exp.isLiteralExpression
    }
    
    public override var description: String {
        return "(" + exp.description + ")"
    }
    
    public init(exp: Expression) {
        self.exp = exp
        
        super.init()
        
        exp.parent = self
    }
    
    public override func copy() -> ParensExpression {
        return ParensExpression(exp: exp.copy()).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitParens(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as ParensExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: ParensExpression, rhs: ParensExpression) -> Bool {
        return lhs.exp == rhs.exp
    }
}
public extension Expression {
    public var asParens: ParensExpression? {
        return cast()
    }
    
    /// Returns the first non-`ParensExpression` child expression of this syntax
    /// node.
    ///
    /// If `self` is not an instance of `ParensExpression`, self is returned
    /// instead.
    public var unwrappingParens: Expression {
        if let parens = self as? ParensExpression {
            return parens.exp.unwrappingParens
        }
        
        return self
    }
}

public class IdentifierExpression: Expression, ExpressibleByStringLiteral {
    public var identifier: String
    
    public override var description: String {
        return identifier
    }
    
    public required init(stringLiteral value: String) {
        self.identifier = value
    }
    
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    public override func copy() -> IdentifierExpression {
        return IdentifierExpression(identifier: identifier).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitIdentifier(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as IdentifierExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: IdentifierExpression, rhs: IdentifierExpression) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
public extension Expression {
    public var asIdentifier: IdentifierExpression? {
        return cast()
    }
}

public class CastExpression: Expression {
    public var exp: Expression {
        didSet { oldValue.parent = nil; exp.parent = self }
    }
    public var type: SwiftType
    public var isOptionalCast: Bool = true
    
    public override var subExpressions: [Expression] {
        return [exp]
    }
    
    public override var description: String {
        return "\(exp) \(isOptionalCast ? "as?" : "as") \(type)"
    }
    
    public override var requiresParens: Bool {
        return true
    }
    
    public init(exp: Expression, type: SwiftType) {
        self.exp = exp
        self.type = type
        
        super.init()
        
        exp.parent = self
    }
    
    public override func copy() -> CastExpression {
        return CastExpression(exp: exp.copy(), type: type).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitCast(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as CastExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: CastExpression, rhs: CastExpression) -> Bool {
        return lhs.exp == rhs.exp &&
            lhs.type == rhs.type &&
            lhs.isOptionalCast == rhs.isOptionalCast
    }
}
public extension Expression {
    public var asCast: CastExpression? {
        return cast()
    }
}

public class ArrayLiteralExpression: Expression {
    public var items: [Expression] {
        didSet {
            oldValue.forEach { $0.parent = nil }
            items.forEach { $0.parent = self }
        }
    }
    
    public override var subExpressions: [Expression] {
        return items
    }
    
    public override var description: String {
        return "[\(items.map { $0.description }.joined(separator: ", "))]"
    }
    
    public init(items: [Expression]) {
        self.items = items
        
        super.init()
        
        items.forEach { $0.parent = self }
    }
    
    public override func copy() -> ArrayLiteralExpression {
        return ArrayLiteralExpression(items: items.map { $0.copy() }).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitArray(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as ArrayLiteralExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: ArrayLiteralExpression, rhs: ArrayLiteralExpression) -> Bool {
        return lhs.items == rhs.items
    }
}
public extension Expression {
    public var asArray: ArrayLiteralExpression? {
        return cast()
    }
}

public class DictionaryLiteralExpression: Expression {
    private var _subExpressions: [Expression] = []
    
    public var pairs: [ExpressionDictionaryPair] {
        didSet {
            oldValue.forEach { $0.key.parent = nil; $0.value.parent = nil }
            pairs.forEach { $0.key.parent = self; $0.value.parent = self }
            
            _subExpressions = pairs.flatMap { [$0.key, $0.value] }
        }
    }
    
    public override var subExpressions: [Expression] {
        return _subExpressions
    }
    
    public override var description: String {
        if pairs.isEmpty {
            return "[:]"
        }
        
        return "[" + pairs.map { $0.description }.joined(separator: ", ") + "]"
    }
    
    public init(pairs: [ExpressionDictionaryPair]) {
        self.pairs = pairs
        
        super.init()
        
        pairs.forEach { $0.key.parent = self; $0.value.parent = self }
        _subExpressions = pairs.flatMap { [$0.key, $0.value] }
    }
    
    public override func copy() -> DictionaryLiteralExpression {
        return DictionaryLiteralExpression(pairs: pairs.map { $0.copy() }).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitDictionary(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as DictionaryLiteralExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: DictionaryLiteralExpression, rhs: DictionaryLiteralExpression) -> Bool {
        return lhs.pairs == rhs.pairs
    }
}
public extension Expression {
    public var asDictionary: DictionaryLiteralExpression? {
        return cast()
    }
}

public class TernaryExpression: Expression {
    public var exp: Expression {
        didSet { oldValue.parent = nil; exp.parent = self }
    }
    public var ifTrue: Expression {
        didSet { oldValue.parent = nil; ifTrue.parent = self }
    }
    public var ifFalse: Expression {
        didSet { oldValue.parent = nil; ifFalse.parent = self }
    }
    
    public override var subExpressions: [Expression] {
        return [exp, ifTrue, ifFalse]
    }
    
    public override var isLiteralExpression: Bool {
        return ifTrue.isLiteralExpression && ifFalse.isLiteralExpression
    }
    
    public override var description: String {
        return exp.description + " ? " + ifTrue.description + " : " + ifFalse.description
    }
    
    public override var requiresParens: Bool {
        return true
    }
    
    public init(exp: Expression, ifTrue: Expression, ifFalse: Expression) {
        self.exp = exp
        self.ifTrue = ifTrue
        self.ifFalse = ifFalse
        
        super.init()
        
        exp.parent = self
        ifTrue.parent = self
        ifFalse.parent = self
    }
    
    public override func copy() -> TernaryExpression {
        return
            TernaryExpression(
                exp: exp.copy(),
                ifTrue: ifTrue.copy(),
                ifFalse: ifFalse.copy()
            ).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitTernary(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as TernaryExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: TernaryExpression, rhs: TernaryExpression) -> Bool {
        return lhs.exp == rhs.exp && lhs.ifTrue == rhs.ifTrue && lhs.ifFalse == rhs.ifFalse
    }
}
public extension Expression {
    public var asTernary: TernaryExpression? {
        return cast()
    }
}

public class BlockLiteralExpression: Expression {
    public var parameters: [BlockParameter]
    public var returnType: SwiftType
    public var body: CompoundStatement {
        didSet { oldValue.parent = nil; body.parent = self }
    }
    
    public override var description: String {
        var buff = "{ "
        
        buff += "("
        buff += parameters.map { $0.description }.joined(separator: ", ")
        buff += ") -> "
        buff += returnType.description
        buff += " in "
        
        buff += "< body >"
        
        buff += " }"
        
        return buff
    }
    
    public override var requiresParens: Bool {
        return true
    }
    
    public init(parameters: [BlockParameter], returnType: SwiftType, body: CompoundStatement) {
        self.parameters = parameters
        self.returnType = returnType
        self.body = body
        
        super.init()
        
        self.body.parent = self
    }
    
    public override func copy() -> BlockLiteralExpression {
        return BlockLiteralExpression(parameters: parameters,
                                      returnType: returnType,
                                      body: body.copy()).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitBlock(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as BlockLiteralExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: BlockLiteralExpression, rhs: BlockLiteralExpression) -> Bool {
        return lhs.parameters == rhs.parameters &&
            lhs.returnType == rhs.returnType &&
            lhs.body == rhs.body
    }
}
public extension Expression {
    public var asBlock: BlockLiteralExpression? {
        return cast()
    }
}

public class UnknownExpression: Expression {
    public var context: UnknownASTContext
    
    public override var description: String {
        return context.description
    }
    
    public init(context: UnknownASTContext) {
        self.context = context
    }
    
    public override func copy() -> UnknownExpression {
        return UnknownExpression(context: context).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitUnknown(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        return other is UnknownExpression
    }
    
    public static func == (lhs: UnknownExpression, rhs: UnknownExpression) -> Bool {
        return true
    }
}
public extension Expression {
    public var asUnknown: UnknownExpression? {
        return cast()
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

public struct BlockParameter: Equatable {
    public var name: String
    public var type: SwiftType
    
    public init(name: String, type: SwiftType) {
        self.name = name
        self.type = type
    }
}

public struct ExpressionDictionaryPair: Equatable {
    public var key: Expression
    public var value: Expression
    
    public init(key: Expression, value: Expression) {
        self.key = key
        self.value = value
    }
    
    public func copy() -> ExpressionDictionaryPair {
        return ExpressionDictionaryPair(key: key.copy(), value: value.copy())
    }
}

/// A postfix operation of a PostfixExpression
public class Postfix: ExpressionComponent, Equatable, CustomStringConvertible {
    /// Owning postfix expression for this postfix operator
    public internal(set) weak var postfixExpression: PostfixExpression?
    
    /// Custom metadata that can be associated with this postfix node
    public var metadata: [String: Any] = [:]
    
    /// Returns `true` if this postfix operation has an optional access specified
    /// to come before it.
    public var hasOptionalAccess: Bool = false
    
    public var description: String {
        return hasOptionalAccess ? "?" : ""
    }
    
    public var subExpressions: [Expression] {
        return []
    }
    
    /// Resulting type for this postfix access
    public var returnType: SwiftType?
    
    fileprivate init() {
        
    }
    
    public func copy() -> Postfix {
        fatalError("Must be overriden by subclasses")
    }
    
    public func withOptionalAccess(enabled: Bool) -> Postfix {
        hasOptionalAccess = enabled
        return self
    }
    
    public func isEqual(to other: Postfix) -> Bool {
        return false
    }
    
    public static func == (lhs: Postfix, rhs: Postfix) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}

public final class MemberPostfix: Postfix {
    public let name: String
    
    public override var description: String {
        return super.description + "." + name
    }
    
    public init(name: String) {
        self.name = name
    }
    
    public override func copy() -> MemberPostfix {
        return MemberPostfix(name: name).copyTypeAndMetadata(from: self)
    }
    
    public override func isEqual(to other: Postfix) -> Bool {
        switch other {
        case let rhs as MemberPostfix:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: MemberPostfix, rhs: MemberPostfix) -> Bool {
        return lhs.hasOptionalAccess == rhs.hasOptionalAccess && lhs.name == rhs.name
    }
}
public extension Postfix {
    public static func member(_ name: String) -> MemberPostfix {
        return MemberPostfix(name: name)
    }
    
    public var asMember: MemberPostfix? {
        return self as? MemberPostfix
    }
}
// Helper casting getter extensions to postfix expression
public extension PostfixExpression {
    var member: MemberPostfix? {
        return op as? MemberPostfix
    }
}

public final class SubscriptPostfix: Postfix {
    public let expression: Expression
    
    public override var description: String {
        return super.description + "[" + expression.description + "]"
    }
    
    public override var subExpressions: [Expression] {
        return [expression]
    }
    
    public init(expression: Expression) {
        self.expression = expression
    }
    
    public override func copy() -> SubscriptPostfix {
        return
            SubscriptPostfix(expression: expression.copy())
                .copyTypeAndMetadata(from: self)
    }
    
    public func replacingExpression(_ exp: Expression) -> SubscriptPostfix {
        let sub = Postfix.subscript(exp)
        sub.hasOptionalAccess = hasOptionalAccess
        sub.returnType = returnType
        
        return sub
    }
    
    public override func isEqual(to other: Postfix) -> Bool {
        switch other {
        case let rhs as SubscriptPostfix:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: SubscriptPostfix, rhs: SubscriptPostfix) -> Bool {
        return lhs.hasOptionalAccess == rhs.hasOptionalAccess && lhs.expression == rhs.expression
    }
}
public extension Postfix {
    public static func `subscript`(_ exp: Expression) -> SubscriptPostfix {
        return SubscriptPostfix(expression: exp)
    }
    
    public var asSubscription: SubscriptPostfix? {
        return self as? SubscriptPostfix
    }
}
// Helper casting getter extensions to postfix expression
public extension PostfixExpression {
    var subscription: SubscriptPostfix? {
        return op as? SubscriptPostfix
    }
}

/// Postfix access that invokes an expression as a function.
public final class FunctionCallPostfix: Postfix {
    public let arguments: [FunctionArgument]
    
    public override var description: String {
        return super.description + "(" + arguments.map { $0.description }.joined(separator: ", ") + ")"
    }
    
    public override var subExpressions: [Expression] {
        return arguments.map { $0.expression }
    }
    
    /// Gets the list of keywords for the arguments passed to this function call.
    public var argumentKeywords: [String?] {
        return arguments.map { $0.label }
    }
    
    /// A .block callable signature for this function call postfix.
    public var callableSignature: SwiftType?
    
    public init(arguments: [FunctionArgument]) {
        self.arguments = arguments
    }
    
    public override func copy() -> FunctionCallPostfix {
        let copy =
            FunctionCallPostfix(arguments: arguments.map { $0.copy() })
                .copyTypeAndMetadata(from: self)
        copy.callableSignature = callableSignature
        return copy
    }
    
    /// Returns a new function call postfix with the arguments replaced to a given
    /// arguments array, while keeping argument labels and resolved type information.
    ///
    /// The number of arguments passed must match the number of arguments present
    /// in this function call postfix.
    ///
    /// - precondition: `expressions.count == self.arguments.count`
    public func replacingArguments(_ expressions: [Expression]) -> FunctionCallPostfix {
        precondition(expressions.count == arguments.count)
        
        let newArgs: [FunctionArgument] =
            zip(arguments, expressions).map { tuple in
                let (arg, exp) = tuple
                
                return FunctionArgument(label: arg.label, expression: exp)
            }
        
        let new =
            FunctionCallPostfix(arguments: newArgs)
                .copyTypeAndMetadata(from: self)
        new.callableSignature = callableSignature
        
        return new
    }
    
    public override func isEqual(to other: Postfix) -> Bool {
        switch other {
        case let rhs as FunctionCallPostfix:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: FunctionCallPostfix, rhs: FunctionCallPostfix) -> Bool {
        return lhs.hasOptionalAccess == rhs.hasOptionalAccess && lhs.arguments == rhs.arguments
    }
}
public extension Postfix {
    public static func functionCall(arguments: [FunctionArgument] = []) -> FunctionCallPostfix {
        return FunctionCallPostfix(arguments: arguments)
    }
    
    public var asFunctionCall: FunctionCallPostfix? {
        return self as? FunctionCallPostfix
    }
}
// Helper casting getter extensions to postfix expression
public extension PostfixExpression {
    var functionCall: FunctionCallPostfix? {
        return op as? FunctionCallPostfix
    }
}

/// A function argument kind from a function call expression
public struct FunctionArgument: Equatable {
    public var label: String?
    public var expression: Expression
    
    public var isLabeled: Bool {
        return label != nil
    }
    
    public init(label: String?, expression: Expression) {
        self.label = label
        self.expression = expression
    }
    
    public func copy() -> FunctionArgument {
        return FunctionArgument(label: label, expression: expression.copy())
    }
    
    public static func unlabeled(_ exp: Expression) -> FunctionArgument {
        return FunctionArgument(label: nil, expression: exp)
    }
    
    public static func labeled(_ label: String, _ exp: Expression) -> FunctionArgument {
        return FunctionArgument(label: label, expression: exp)
    }
}

/// Represents one of the recognized compile-time constant value types.
public enum Constant: Equatable {
    case float(Float)
    case boolean(Bool)
    case int(Int, IntegerType)
    case string(String)
    case rawConstant(String)
    case `nil`
    
    /// Returns an integer value if this constant represents one, or nil, in case
    /// it does not.
    public var integerValue: Int? {
        switch self {
        case .int(let i, _):
            return i
        default:
            return nil
        }
    }
    
    /// Returns `true` if this constant represents an integer value.
    public var isInteger: Bool {
        switch self {
        case .int:
            return true
        default:
            return false
        }
    }
    
    public static func binary(_ value: Int) -> Constant {
        return .int(value, .binary)
    }
    
    public static func octal(_ value: Int) -> Constant {
        return .int(value, .octal)
    }
    
    public static func hexadecimal(_ value: Int) -> Constant {
        return .int(value, .hexadecimal)
    }
    
    public enum IntegerType {
        case decimal
        case binary
        case octal
        case hexadecimal
    }
}

/// Describes an operator across one or two operands
public enum SwiftOperator: String {
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
    
    case nullCoalesce = "??"
    
    case openRange = "..<"
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
             .bitwiseShiftLeftAssign, .bitwiseShiftRightAssign:
            return .assignment
            
        // Comparison
        case .lessThan, .lessThanOrEqual, .greaterThan, .greaterThanOrEqual,
             .equals, .unequals:
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

// MARK: - String Conversion

extension ExpressionDictionaryPair: CustomStringConvertible {
    public var description: String {
        return key.description + ": " + value.description
    }
}

extension BlockParameter: CustomStringConvertible {
    public var description: String {
        return "\(self.name): \(type)"
    }
}

extension FunctionArgument: CustomStringConvertible {
    public var description: String {
        if let label = label {
            return "\(label): \(expression)"
        }
        
        return expression.description
    }
}

extension Constant: CustomStringConvertible {
    public var description: String {
        switch self {
        case .float(let fl):
            return fl.description
            
        case .boolean(let bool):
            return bool.description
            
        case let .int(int, category):
            
            switch category {
            case .decimal:
                return int.description
            case .binary:
                return "0b" + String(int, radix: 2)
            case .octal:
                return "0o" + String(int, radix: 8)
            case .hexadecimal:
                return "0x" + String(int, radix: 16, uppercase: false)
            }
            
        case .string(let str):
            return "\"\(str)\""
            
        case .rawConstant(let str):
            return str
            
        case .nil:
            return "nil"
        }
    }
}

extension SwiftOperator: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}

// MARK: - Literal initialiation
extension Constant: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value, .decimal)
    }
}

extension Constant: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Float) {
        self = .float(value)
    }
}

extension Constant: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .boolean(value)
    }
}

extension Constant: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
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

extension CastExpression {
    
    public func copyTypeAndMetadata(from other: CastExpression) -> Self {
        _ = (self as Expression).copyTypeAndMetadata(from: other)
        self.isOptionalCast = other.isOptionalCast
        
        return self
    }
    
}

extension Postfix {
    
    public func copyTypeAndMetadata(from other: Postfix) -> Self {
        self.metadata = other.metadata
        self.returnType = other.returnType
        self.hasOptionalAccess = other.hasOptionalAccess
        
        return self
    }
    
}

extension FunctionCallPostfix {
    
    public func copyTypeAndMetadata(from other: FunctionCallPostfix) -> Self {
        _ = (self as Postfix).copyTypeAndMetadata(from: other)
        
        self.callableSignature = callableSignature
        
        return self
    }
    
}
