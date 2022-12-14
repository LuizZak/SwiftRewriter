public class TernaryExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .ternary(self)
    }

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
        [exp, ifTrue, ifFalse]
    }
    
    public override var isLiteralExpression: Bool {
        ifTrue.isLiteralExpression && ifFalse.isLiteralExpression
    }
    
    public override var description: String {
        exp.description + " ? " + ifTrue.description + " : " + ifFalse.description
    }
    
    public override var requiresParens: Bool {
        true
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
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        exp = try container.decodeExpression(forKey: .exp)
        ifTrue = try container.decodeExpression(forKey: .ifTrue)
        ifFalse = try container.decodeExpression(forKey: .ifFalse)
        
        try super.init(from: container.superDecoder())
        
        exp.parent = self
        ifTrue.parent = self
        ifFalse.parent = self
    }
    
    @inlinable
    public override func copy() -> TernaryExpression {
        TernaryExpression(
                exp: exp.copy(),
                ifTrue: ifTrue.copy(),
                ifFalse: ifFalse.copy()
            ).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitTernary(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as TernaryExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpression(exp, forKey: .exp)
        try container.encodeExpression(ifTrue, forKey: .ifTrue)
        try container.encodeExpression(ifFalse, forKey: .ifFalse)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: TernaryExpression, rhs: TernaryExpression) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.exp == rhs.exp
            && lhs.ifTrue == rhs.ifTrue
            && lhs.ifFalse == rhs.ifFalse
    }
    
    private enum CodingKeys: String, CodingKey {
        case exp
        case ifTrue
        case ifFalse
    }
}
public extension Expression {
    @inlinable
    var asTernary: TernaryExpression? {
        cast()
    }

    @inlinable
    var isTernary: Bool {
        asTernary != nil
    }

    static func ternary(
        _ exp: Expression,
        `true` ifTrue: Expression,
        `false` ifFalse: Expression
    ) -> TernaryExpression {
        TernaryExpression(exp: exp, ifTrue: ifTrue, ifFalse: ifFalse)
    }
}
