public class ArrayLiteralExpression: Expression {
    public var items: [Expression] {
        didSet {
            oldValue.forEach { $0.parent = nil }
            items.forEach { $0.parent = self }
        }
    }
    
    public override var subExpressions: [Expression] {
        return items
    }
    
    public override var description: String {
        return "[\(items.map { $0.description }.joined(separator: ", "))]"
    }
    
    public init(items: [Expression]) {
        self.items = items
        
        super.init()
        
        items.forEach { $0.parent = self }
    }
    
    public override func copy() -> ArrayLiteralExpression {
        return ArrayLiteralExpression(items: items.map { $0.copy() }).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitArray(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as ArrayLiteralExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public static func == (lhs: ArrayLiteralExpression, rhs: ArrayLiteralExpression) -> Bool {
        return lhs.items == rhs.items
    }
}
public extension Expression {
    public var asArray: ArrayLiteralExpression? {
        return cast()
    }
}
