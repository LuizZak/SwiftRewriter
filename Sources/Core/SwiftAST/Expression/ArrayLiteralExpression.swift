public class ArrayLiteralExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .arrayLiteral(self)
    }

    public var items: [Expression] {
        didSet {
            oldValue.forEach { $0.parent = nil }
            items.forEach { $0.parent = self }
        }
    }
    
    public override var subExpressions: [Expression] {
        items
    }
    
    public override var description: String {
        "[\(items.map(\.description).joined(separator: ", "))]"
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
    
    @inlinable
    public override func copy() -> ArrayLiteralExpression {
        ArrayLiteralExpression(items: items.map { $0.copy() }).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitArray(self)
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
        if lhs === rhs {
            return true
        }
        
        return lhs.items == rhs.items
    }
    
    private enum CodingKeys: String, CodingKey {
        case items
    }
}
public extension Expression {
    @inlinable
    var asArray: ArrayLiteralExpression? {
        cast()
    }

    @inlinable
    var isArray: Bool {
        asArray != nil
    }
    
    static func arrayLiteral(_ array: [Expression]) -> ArrayLiteralExpression {
        ArrayLiteralExpression(items: array)
    }
}
