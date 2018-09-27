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
    
    public override var literalExpressionKind: LiteralExpressionKind? {
        return exp.literalExpressionKind
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
