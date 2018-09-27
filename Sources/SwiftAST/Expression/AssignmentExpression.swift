public class AssignmentExpression: Expression {
    public var lhs: Expression {
        didSet { oldValue.parent = nil; lhs.parent = self; }
    }
    public var op: SwiftOperator
    public var rhs: Expression {
        didSet { oldValue.parent = nil; rhs.parent = self; }
    }
    
    public override var subExpressions: [Expression] {
        return [lhs, rhs]
    }
    
    public override var requiresParens: Bool {
        return true
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
    
    public override func copy() -> AssignmentExpression {
        return
            AssignmentExpression(
                lhs: lhs.copy(),
                op: op,
                rhs: rhs.copy()
            ).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitAssignment(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as AssignmentExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: AssignmentExpression, rhs: AssignmentExpression) -> Bool {
        return lhs.lhs == rhs.lhs && lhs.op == rhs.op && lhs.rhs == rhs.rhs
    }
}
public extension Expression {
    public var asAssignment: AssignmentExpression? {
        return cast()
    }
}
