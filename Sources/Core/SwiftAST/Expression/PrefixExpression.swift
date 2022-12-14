public class PrefixExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .prefix(self)
    }

    public var op: SwiftOperator
    public var exp: Expression {
        didSet { oldValue.parent = nil; exp.parent = self; }
    }
    
    public override var subExpressions: [Expression] {
        [exp]
    }
    
    public override var isLiteralExpression: Bool {
        exp.isLiteralExpression
    }
    
    public override var literalExpressionKind: LiteralExpressionKind? {
        exp.literalExpressionKind
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
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        op = try container.decode(SwiftOperator.self, forKey: .op)
        exp = try container.decodeExpression(Expression.self, forKey: .exp)
        
        try super.init(from: container.superDecoder())
        
        exp.parent = self
    }
    
    @inlinable
    public override func copy() -> PrefixExpression {
        PrefixExpression(op: op, exp: exp.copy()).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitPrefix(self)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(op, forKey: .op)
        try container.encodeExpression(exp, forKey: .exp)
        
        try super.encode(to: container.superEncoder())
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
        if lhs === rhs {
            return true
        }
        
        return lhs.op == rhs.op && lhs.exp == rhs.exp
    }
    
    private enum CodingKeys: String, CodingKey {
        case exp
        case op
    }
}
public extension Expression {
    @inlinable
    var asPrefix: PrefixExpression? {
        cast()
    }

    @inlinable
    var isPrefix: Bool {
        asPrefix != nil
    }

    static func prefix(op: SwiftOperator, _ exp: Expression) -> PrefixExpression {
        PrefixExpression(op: op, exp: exp)
    }
}
