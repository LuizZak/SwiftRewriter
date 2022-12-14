public class PostfixExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .postfix(self)
    }

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
        PostfixExpression(
            exp: exp.copy(),
            op: op.copy()
        ).copyTypeAndMetadata(from: self)
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
            throw EncodingError
                .invalidValue(
                    type(of: op),
                    EncodingError.Context.init(
                        codingPath:
                        encoder.codingPath + [CodingKeys.op],
                        debugDescription: "Unknown postfix type \(type(of: op))"
                    )
                )
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
public extension Expression {
    @inlinable
    var asPostfix: PostfixExpression? {
        cast()
    }

    @inlinable
    var isPostfix: Bool {
        asPostfix != nil
    }
    
    static func postfix(_ exp: Expression, _ op: Postfix) -> PostfixExpression {
        PostfixExpression(exp: exp, op: op)
    }
}
