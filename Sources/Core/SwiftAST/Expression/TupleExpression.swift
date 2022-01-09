public class TupleExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .tuple(self)
    }

    public var elements: [Expression] {
        didSet {
            oldValue.forEach { $0.parent = nil }
            elements.forEach { $0.parent = self }
        }
    }
    
    public override var subExpressions: [Expression] {
        elements
    }
    
    public override var description: String {
        "(\(elements.map(\.description).joined(separator: ", ")))"
    }
    
    public init(elements: [Expression]) {
        self.elements = elements
        
        super.init()
        
        elements.forEach { $0.parent = self }
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        elements = try container.decodeExpressions(forKey: .elements)
        
        try super.init(from: container.superDecoder())
        
        elements.forEach { $0.parent = self }
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitTuple(self)
    }
    
    @inlinable
    public override func copy() -> Expression {
        TupleExpression(elements: elements.map { $0.copy() }).copyTypeAndMetadata(from: self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as TupleExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpressions(elements, forKey: .elements)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: TupleExpression, rhs: TupleExpression) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.elements == rhs.elements
    }
    
    private enum CodingKeys: String, CodingKey {
        case elements
    }
}
public extension Expression {
    @inlinable
    var asTuple: TupleExpression? {
        cast()
    }

    @inlinable
    var isTuple: Bool {
        asTuple != nil
    }
    
    static func tuple(_ elements: [Expression]) -> TupleExpression {
        TupleExpression(elements: elements)
    }
}
