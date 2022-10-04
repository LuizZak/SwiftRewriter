public class AssignmentExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .assignment(self)
    }

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
        
        lhs.parent = self
        rhs.parent = self
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        lhs = try container.decodeExpression(forKey: .lhs)
        op = try container.decode(SwiftOperator.self, forKey: .op)
        rhs = try container.decodeExpression(forKey: .rhs)
        
        try super.init(from: container.superDecoder())
        
        lhs.parent = self
        rhs.parent = self
    }
    
    @inlinable
    public override func copy() -> AssignmentExpression {
        AssignmentExpression(
            lhs: lhs.copy(),
            op: op,
            rhs: rhs.copy()
        ).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitAssignment(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as AssignmentExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpression(lhs, forKey: .lhs)
        try container.encode(op, forKey: .op)
        try container.encodeExpression(rhs, forKey: .rhs)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: AssignmentExpression, rhs: AssignmentExpression) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.lhs == rhs.lhs && lhs.op == rhs.op && lhs.rhs == rhs.rhs
    }
    
    private enum CodingKeys: String, CodingKey {
        case lhs
        case op
        case rhs
    }
}
public extension Expression {
    @inlinable
    var asAssignment: AssignmentExpression? {
        cast()
    }

    @inlinable
    var isAssignment: Bool {
        asAssignment != nil
    }

    /// Creates a BinaryExpression between this expression and a right-hand-side
    /// expression.
    func assignment(op: SwiftOperator, rhs: Expression) -> AssignmentExpression {
        .assignment(lhs: self, op: op, rhs: rhs)
    }

    static func assignment(lhs: Expression, op: SwiftOperator, rhs: Expression) -> AssignmentExpression {
        AssignmentExpression(lhs: lhs, op: op, rhs: rhs)
    }
}
