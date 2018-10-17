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
        return !(parent is PostfixExpression)
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

/// A postfix operation of a PostfixExpression
public class Postfix: ExpressionComponent, Equatable, CustomStringConvertible {
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
        return []
    }
    
    /// Resulting type for this postfix access
    public var returnType: SwiftType?
    
    fileprivate init() {
        
    }
    
    public func copy() -> Postfix {
        fatalError("Must be overriden by subclasses")
    }
    
    public func withOptionalAccess(kind: OptionalAccessKind) -> Postfix {
        optionalAccessKind = kind
        return self
    }
    
    public func isEqual(to other: Postfix) -> Bool {
        return false
    }
    
    public static func == (lhs: Postfix, rhs: Postfix) -> Bool {
        return lhs.isEqual(to: rhs)
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
        return lhs.optionalAccessKind == rhs.optionalAccessKind && lhs.name == rhs.name
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
        sub.optionalAccessKind = optionalAccessKind
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
        return lhs.optionalAccessKind == rhs.optionalAccessKind && lhs.expression == rhs.expression
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
    private let _subExpressions: [Expression]
    public let arguments: [FunctionArgument]
    
    public override var description: String {
        return super.description + "(" + arguments.map { $0.description }.joined(separator: ", ") + ")"
    }
    
    public override var subExpressions: [Expression] {
        return _subExpressions
    }
    
    /// Gets the list of keywords for the arguments passed to this function call.
    public var argumentKeywords: [String?] {
        return arguments.map { $0.label }
    }
    
    /// A .block callable signature for this function call postfix.
    public var callableSignature: SwiftType?
    
    public init(arguments: [FunctionArgument]) {
        self.arguments = arguments
        self._subExpressions = arguments.map { $0.expression }
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
        return lhs.optionalAccessKind == rhs.optionalAccessKind && lhs.arguments == rhs.arguments
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

extension FunctionArgument: CustomStringConvertible {
    public var description: String {
        if let label = label {
            return "\(label): \(expression)"
        }
        
        return expression.description
    }
}

extension Postfix {
    
    public func copyTypeAndMetadata(from other: Postfix) -> Self {
        self.metadata = other.metadata
        self.returnType = other.returnType
        self.optionalAccessKind = other.optionalAccessKind
        
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
