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
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        items = try container.decodeExpressions(forKey: .items)
        
        try super.init(from: container.superDecoder())
        
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
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpressions(items, forKey: .items)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: ArrayLiteralExpression, rhs: ArrayLiteralExpression) -> Bool {
        return lhs.items == rhs.items
    }
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
}
public extension Expression {
    public var asArray: ArrayLiteralExpression? {
        return cast()
    }
}
