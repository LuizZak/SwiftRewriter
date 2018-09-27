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
    
    public override var literalExpressionKind: LiteralExpressionKind? {
        return exp.literalExpressionKind
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
