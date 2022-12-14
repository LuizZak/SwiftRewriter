public class CastExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .cast(self)
    }

    public var exp: Expression {
        didSet { oldValue.parent = nil; exp.parent = self }
    }
    public var type: SwiftType
    public var isOptionalCast: Bool
    
    public override var subExpressions: [Expression] {
        [exp]
    }
    
    public override var description: String {
        "\(exp) \(isOptionalCast ? "as?" : "as") \(type)"
    }
    
    public override var requiresParens: Bool {
        true
    }
    
    public init(exp: Expression, type: SwiftType, isOptionalCast: Bool = true) {
        self.exp = exp
        self.type = type
        self.isOptionalCast = isOptionalCast
        
        super.init()
        
        exp.parent = self
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        exp = try container.decodeExpression(forKey: .exp)
        type = try container.decode(SwiftType.self, forKey: .type)
        isOptionalCast = try container.decode(Bool.self, forKey: .isOptionalCast)
        
        try super.init(from: container.superDecoder())
        
        exp.parent = self
    }
    
    @inlinable
    public override func copy() -> CastExpression {
        CastExpression(exp: exp.copy(), type: type).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitCast(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as CastExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpression(exp, forKey: .exp)
        try container.encode(type, forKey: .type)
        try container.encode(isOptionalCast, forKey: .isOptionalCast)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: CastExpression, rhs: CastExpression) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.exp == rhs.exp &&
            lhs.type == rhs.type &&
            lhs.isOptionalCast == rhs.isOptionalCast
    }
    
    private enum CodingKeys: String, CodingKey {
        case exp
        case type
        case isOptionalCast
    }
}
public extension Expression {
    @inlinable
    var asCast: CastExpression? {
        cast()
    }

    @inlinable
    var isCast: Bool {
        asCast != nil
    }
    
    /// Creates a type-cast expression with this expression
    func casted(to type: SwiftType, optional: Bool = true) -> CastExpression {
        .cast(expressionToBuild, type: type, isOptionalCast: optional)
    }
    
    static func cast(_ exp: Expression, type: SwiftType, isOptionalCast: Bool = true) -> CastExpression {
        CastExpression(exp: exp, type: type, isOptionalCast: isOptionalCast)
    }
}

extension CastExpression {
    
    public func copyTypeAndMetadata(from other: CastExpression) -> Self {
        _ = (self as Expression).copyTypeAndMetadata(from: other)
        self.isOptionalCast = other.isOptionalCast
        
        return self
    }
    
}
