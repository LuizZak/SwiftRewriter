public class PostfixExpression: Expression {
    private var _subExpressions: [Expression] = []
    
    public var exp: Expression {
        didSet {
            oldValue.parent = nil
            exp.parent = self
            
            _subExpressions[0] = exp
        }
    }
    public var op: Postfix {
        didSet {
            oldValue.subExpressions.forEach { $0.parent = nil }
            oldValue.postfixExpression = nil
            op.subExpressions.forEach { $0.parent = self }
            op.postfixExpression = self
            
            _subExpressions[1...] = op.subExpressions[...]
        }
    }
    
    public override var subExpressions: [Expression] {
        _subExpressions
    }
    
    public override var description: String {
        // Parenthesized
        if exp.requiresParens {
            return "(\(exp))\(op)"
        }
        
        return "\(exp)\(op)"
    }
    
    /// Returns the first ancestor of this postfix which is not a postfix node
    /// itself.
    public var firstNonPostfixAncestor: SyntaxNode? {
        if let postfix = parent as? PostfixExpression {
            return postfix.firstNonPostfixAncestor
        }
        
        return parent
    }
    
    /// In case this postfix expression is contained within another postfix
    /// expression, returns the parent postfix's top postfix, until the top-most
    /// postfix entry is found.
    ///
    /// This can be useful to traverse from an inner postfix access until the
    /// outermost access, wherein a postfix access chain finishes.
    public var topPostfixExpression: PostfixExpression {
        if let postfix = parent as? PostfixExpression {
            return postfix.topPostfixExpression
        }
        
        return self
    }
    
    /// Returns `true` if this postfix expression is the top-most in a chain of
    /// sequential postfix expressions. Also returns `true` if this expression
    /// is by itself and not contained in a postfix chain.
    public var isTopPostfixExpression: Bool {
        !(parent is PostfixExpression)
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
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        exp = try container.decodeExpression(Expression.self, forKey: .exp)
        
        let opType = try container.decode(OpType.self, forKey: .opType)
        
        switch opType {
        case .member:
            op = try container.decode(MemberPostfix.self, forKey: .op)
        case .subscript:
            op = try container.decode(SubscriptPostfix.self, forKey: .op)
        case .functionCall:
            op = try container.decode(FunctionCallPostfix.self, forKey: .op)
        }
        
        try super.init(from: container.superDecoder())
        
        exp.parent = self
        
        op.subExpressions.forEach { $0.parent = self }
        op.postfixExpression = self
        
        _subExpressions = [exp] + op.subExpressions
    }
    
    public override func copy() -> PostfixExpression {
        PostfixExpression(exp: exp.copy(), op: op.copy()).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitPostfix(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as PostfixExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpression(exp, forKey: .exp)
        try container.encode(op, forKey: .op)
        
        switch op {
        case is MemberPostfix:
            try container.encode(OpType.member, forKey: .opType)
        case is SubscriptPostfix:
            try container.encode(OpType.subscript, forKey: .opType)
        case is FunctionCallPostfix:
            try container.encode(OpType.functionCall, forKey: .opType)
        default:
            throw EncodingError.invalidValue(type(of: op),
                                             EncodingError.Context.init(
                                                codingPath:
                                                encoder.codingPath + [CodingKeys.op],
                                                debugDescription: "Unknown postfix type \(type(of: op))"))
        }
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: PostfixExpression, rhs: PostfixExpression) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.exp == rhs.exp && lhs.op == rhs.op
    }
    
    private enum CodingKeys: String, CodingKey {
        case exp
        case op
        case opType
    }
    
    enum OpType: String, Codable {
        case member
        case `subscript`
        case functionCall
    }
}
extension Expression {
    @inlinable
    public var asPostfix: PostfixExpression? {
        cast()
    }
}

/// A postfix operation of a PostfixExpression
public class Postfix: ExpressionComponent, Codable, Equatable, CustomStringConvertible {
    /// Owning postfix expression for this postfix operator
    public internal(set) weak var postfixExpression: PostfixExpression?
    
    /// Custom metadata that can be associated with this postfix node
    public var metadata: [String: Any] = [:]
    
    /// The current postfix access kind for this postfix operand
    public var optionalAccessKind: OptionalAccessKind = .none
    
    public var description: String {
        switch optionalAccessKind {
        case .none:
            return ""
        case .safeUnwrap:
            return "?"
        case .forceUnwrap:
            return "!"
        }
    }
    
    public var subExpressions: [Expression] {
        []
    }
    
    /// Resulting type for this postfix access
    public var returnType: SwiftType?
    
    fileprivate init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        
    }
    
    public func copy() -> Postfix {
        fatalError("Must be overriden by subclasses")
    }
    
    public func withOptionalAccess(kind: OptionalAccessKind) -> Postfix {
        optionalAccessKind = kind
        return self
    }
    
    public func isEqual(to other: Postfix) -> Bool {
        false
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
    
    public static func == (lhs: Postfix, rhs: Postfix) -> Bool {
        lhs.isEqual(to: rhs)
    }
    
    /// Describes the optional access type for a postfix operator
    ///
    /// - none: No optional accessing - the default state for a postfix access
    /// - safeUnwrap: A safe-unwrap access (i.e. `exp?.value`)
    /// - forceUnwrap: A force-unwrap access (i.e. `exp!.value`)
    public enum OptionalAccessKind {
        case none
        case safeUnwrap
        case forceUnwrap
    }
}

public final class MemberPostfix: Postfix {
    public let name: String
    
    public override var description: String {
        "\(super.description).\(name)"
    }
    
    public init(name: String) {
        self.name = name
        
        super.init()
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(name: container.decode(String.self, forKey: .name))
    }
    
    public override func copy() -> MemberPostfix {
        MemberPostfix(name: name).copyTypeAndMetadata(from: self)
    }
    
    public override func isEqual(to other: Postfix) -> Bool {
        switch other {
        case let rhs as MemberPostfix:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: MemberPostfix, rhs: MemberPostfix) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.optionalAccessKind == rhs.optionalAccessKind && lhs.name == rhs.name
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
}
public extension Postfix {
    static func member(_ name: String) -> MemberPostfix {
        MemberPostfix(name: name)
    }
    
    @inlinable
    var asMember: MemberPostfix? {
        self as? MemberPostfix
    }
}
// Helper casting getter extensions to postfix expression
public extension PostfixExpression {
    @inlinable
    var member: MemberPostfix? {
        op as? MemberPostfix
    }
}

public final class SubscriptPostfix: Postfix {
    private let _subExpressions: [Expression]
    public let arguments: [FunctionArgument]
    
    public override var description: String {
        "\(super.description)[\(arguments.map(\.description).joined(separator: ", "))]"
    }
    
    public override var subExpressions: [Expression] {
        _subExpressions
    }
    
    /// Gets the list of keywords for the arguments passed to this function call.
    public var argumentKeywords: [String?] {
        arguments.map(\.label)
    }
    
    public init(arguments: [FunctionArgument]) {
        self.arguments = arguments
        self._subExpressions = arguments.map(\.expression)
        
        super.init()
    }
    
    public convenience init(expression: Expression) {
        self.init(arguments: [
            FunctionArgument(label: nil, expression: expression)
        ])
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(arguments: container.decode([FunctionArgument].self, forKey: .arguments))
    }
    
    public override func copy() -> SubscriptPostfix {
        SubscriptPostfix(arguments: arguments.map { $0.copy() })
            .copyTypeAndMetadata(from: self)
    }
    
    /// Returns a new subscript call postfix with the arguments replaced to a
    /// given arguments array, while keeping argument labels and resolved type
    /// information.
    ///
    /// The number of arguments passed must match the number of arguments present
    /// in this subscript call postfix.
    ///
    /// - precondition: `expressions.count == self.arguments.count`
    public func replacingArguments(_ expressions: [Expression]) -> SubscriptPostfix {
        precondition(expressions.count == arguments.count)
        
        let newArgs: [FunctionArgument] =
            zip(arguments, expressions).map { tuple in
                let (arg, exp) = tuple
                
                return FunctionArgument(label: arg.label, expression: exp)
            }
        
        let new =
            SubscriptPostfix(arguments: newArgs)
                .copyTypeAndMetadata(from: self)
        
        return new
    }
    
    public override func isEqual(to other: Postfix) -> Bool {
        switch other {
        case let rhs as SubscriptPostfix:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(arguments, forKey: .arguments)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: SubscriptPostfix, rhs: SubscriptPostfix) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.optionalAccessKind == rhs.optionalAccessKind
            && lhs.arguments == rhs.arguments
    }
    
    private enum CodingKeys: String, CodingKey {
        case arguments
    }
}
public extension Postfix {
    static func `subscript`(_ exp: Expression) -> SubscriptPostfix {
        SubscriptPostfix(expression: exp)
    }
    
    static func `subscript`(arguments: [FunctionArgument]) -> SubscriptPostfix {
        SubscriptPostfix(arguments: arguments)
    }
    
    @inlinable
    var asSubscription: SubscriptPostfix? {
        self as? SubscriptPostfix
    }
}
// Helper casting getter extensions to postfix expression
public extension PostfixExpression {
    @inlinable
    var subscription: SubscriptPostfix? {
        op as? SubscriptPostfix
    }
}

/// Postfix access that invokes an expression as a function.
public final class FunctionCallPostfix: Postfix {
    private let _subExpressions: [Expression]
    public let arguments: [FunctionArgument]
    
    public override var description: String {
        "\(super.description)(\(arguments.map(\.description).joined(separator: ", ")))"
    }
    
    public override var subExpressions: [Expression] {
        _subExpressions
    }
    
    /// Gets the list of keywords for the arguments passed to this function call.
    public var argumentKeywords: [String?] {
        arguments.map(\.label)
    }
    
    /// A .block callable signature for this function call postfix.
    public var callableSignature: SwiftType?
    
    public init(arguments: [FunctionArgument]) {
        self.arguments = arguments
        self._subExpressions = arguments.map(\.expression)
        
        super.init()
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(arguments: container.decode([FunctionArgument].self, forKey: .arguments))
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
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(arguments, forKey: .arguments)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: FunctionCallPostfix, rhs: FunctionCallPostfix) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.optionalAccessKind == rhs.optionalAccessKind
            && lhs.arguments == rhs.arguments
    }
    
    private enum CodingKeys: String, CodingKey {
        case arguments
    }
}
public extension Postfix {
    static func functionCall(arguments: [FunctionArgument] = []) -> FunctionCallPostfix {
        FunctionCallPostfix(arguments: arguments)
    }
    
    @inlinable
    var asFunctionCall: FunctionCallPostfix? {
        self as? FunctionCallPostfix
    }
}
// Helper casting getter extensions to postfix expression
public extension PostfixExpression {
    @inlinable
    var functionCall: FunctionCallPostfix? {
        op as? FunctionCallPostfix
    }
}

/// A function argument kind from a function call expression
public struct FunctionArgument: Codable, Equatable {
    public var label: String?
    public var expression: Expression
    
    public var isLabeled: Bool {
        label != nil
    }
    
    public init(label: String?, expression: Expression) {
        self.label = label
        self.expression = expression
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.label = try container.decodeIfPresent(String.self, forKey: .label)
        self.expression = try container.decodeExpression(forKey: .expression)
    }
    
    @inlinable
    public func copy() -> FunctionArgument {
        FunctionArgument(label: label, expression: expression.copy())
    }
    
    public static func unlabeled(_ exp: Expression) -> FunctionArgument {
        FunctionArgument(label: nil, expression: exp)
    }
    
    public static func labeled(_ label: String, _ exp: Expression) -> FunctionArgument {
        FunctionArgument(label: label, expression: exp)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(label, forKey: .label)
        try container.encodeExpression(expression, forKey: .expression)
    }
    
    private enum CodingKeys: String, CodingKey {
        case label
        case expression
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

extension Postfix {
    
    @inlinable
    public func copyTypeAndMetadata(from other: Postfix) -> Self {
        self.metadata = other.metadata
        self.returnType = other.returnType
        self.optionalAccessKind = other.optionalAccessKind
        
        return self
    }
    
}

extension FunctionCallPostfix {
    
    @inlinable
    public func copyTypeAndMetadata(from other: FunctionCallPostfix) -> Self {
        _ = (self as Postfix).copyTypeAndMetadata(from: other)
        
        self.callableSignature = callableSignature
        
        return self
    }
    
}
