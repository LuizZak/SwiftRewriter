public class ParensExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .parens(self)
    }

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
        "(" + exp.description + ")"
    }
    
    public init(exp: Expression) {
        self.exp = exp
        
        super.init()
        
        exp.parent = self
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        exp = try container.decodeExpression(forKey: .exp)
        
        try super.init(from: container.superDecoder())
        
        exp.parent = self
    }
    
    @inlinable
    public override func copy() -> ParensExpression {
        ParensExpression(exp: exp.copy()).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitParens(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as ParensExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpression(exp, forKey: .exp)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: ParensExpression, rhs: ParensExpression) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.exp == rhs.exp
    }
    
    private enum CodingKeys: String, CodingKey {
        case exp
    }
}
public extension Expression {
    @inlinable
    var asParens: ParensExpression? {
        cast()
    }

    @inlinable
    var isParens: Bool {
        asParens != nil
    }

    static func parens(_ exp: Expression) -> ParensExpression {
        ParensExpression(exp: exp)
    }
    
    /// Returns the first non-`ParensExpression` child expression of this syntax
    /// node.
    ///
    /// If this is not an instance of `ParensExpression`, `self` is returned
    /// instead.
    var unwrappingParens: Expression {
        if let parens = self as? ParensExpression {
            return parens.exp.unwrappingParens
        }
        
        return self
    }
}
