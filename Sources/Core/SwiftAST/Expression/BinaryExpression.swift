public class BinaryExpression: Expression {
    public var lhs: Expression {
        didSet { oldValue.parent = nil; lhs.parent = self; }
    }
    public var op: SwiftOperator
    public var rhs: Expression {
        didSet { oldValue.parent = nil; rhs.parent = self; }
    }
    
    public override var subExpressions: [Expression] {
        [lhs, rhs]
    }
    
    public override var isLiteralExpression: Bool {
        lhs.isLiteralExpression && rhs.isLiteralExpression
    }
    
    public override var requiresParens: Bool {
        true
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
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        lhs = try container.decodeExpression(forKey: .lhs)
        op = try container.decode(SwiftOperator.self, forKey: .op)
        rhs = try container.decodeExpression(forKey: .rhs)
        
        try super.init(from: container.superDecoder())
        
        lhs.parent = self
        rhs.parent = self
    }
    
    @inlinable
    public override func copy() -> BinaryExpression {
        BinaryExpression(
                lhs: lhs.copy(),
                op: op,
                rhs: rhs.copy()
            ).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitBinary(self)
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
        if lhs === rhs {
            return true
        }
        
        return lhs.lhs == rhs.lhs && lhs.op == rhs.op && lhs.rhs == rhs.rhs
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpression(lhs, forKey: .lhs)
        try container.encode(op, forKey: .op)
        try container.encodeExpression(rhs, forKey: .rhs)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case lhs
        case op
        case rhs
    }
}
extension Expression {
    @inlinable
    public var asBinary: BinaryExpression? {
        cast()
    }
}
