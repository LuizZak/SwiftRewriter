public class TypeCheckExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .typeCheck(self)
    }

    public var exp: Expression {
        didSet { oldValue.parent = nil; exp.parent = self }
    }
    public var type: SwiftType
    
    public override var subExpressions: [Expression] {
        [exp]
    }
    
    public override var description: String {
        "\(exp) is \(type)"
    }
    
    public override var requiresParens: Bool {
        true
    }
    
    public init(exp: Expression, type: SwiftType) {
        self.exp = exp
        self.type = type
        
        super.init()
        
        exp.parent = self
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        exp = try container.decodeExpression(forKey: .exp)
        type = try container.decode(SwiftType.self, forKey: .type)
        
        try super.init(from: container.superDecoder())
        
        exp.parent = self
    }
    
    @inlinable
    public override func copy() -> TypeCheckExpression {
        TypeCheckExpression(exp: exp.copy(), type: type).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitTypeCheck(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as TypeCheckExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpression(exp, forKey: .exp)
        try container.encode(type, forKey: .type)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: TypeCheckExpression, rhs: TypeCheckExpression) -> Bool {
        if lhs === rhs {
            return true
        }

        return lhs.exp == rhs.exp && lhs.type == rhs.type
    }
    
    private enum CodingKeys: String, CodingKey {
        case exp
        case type
        case isOptionalCast
    }
}
public extension Expression {
    @inlinable
    var asTypeCheck: TypeCheckExpression? {
        cast()
    }

    @inlinable
    var isTypeCheck: Bool {
        asTypeCheck != nil
    }

    func typeCheck(as type: SwiftType) -> TypeCheckExpression {
        .typeCheck(self, type: type)
    }
    
    static func typeCheck(_ exp: Expression, type: SwiftType) -> TypeCheckExpression {
        TypeCheckExpression(exp: exp, type: type)
    }
}
