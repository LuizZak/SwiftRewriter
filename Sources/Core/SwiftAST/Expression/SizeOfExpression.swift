public class SizeOfExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .sizeOf(self)
    }

    public var value: Value {
        didSet {
            switch oldValue {
            case .expression(let exp):
                exp.parent = nil
            case .type: break
            }
            
            switch value {
            case .expression(let exp):
                exp.parent = self
            case .type: break
            }
        }
    }
    
    /// If this `SizeOfExpression`'s value is an expression input value, returns
    /// that expression, otherwise returns `nil`
    public var exp: Expression? {
        switch value {
        case .expression(let exp):
            return exp
        case .type:
            return nil
        }
    }
    
    public override var subExpressions: [Expression] {
        switch value {
        case .expression(let exp):
            return [exp]
        case .type:
            return []
        }
    }
    
    public override var description: String {
        switch value {
        case .expression(let exp):
            return "MemoryLayout.size(ofValue: \(exp))"
        case .type(let type):
            return "MemoryLayout<\(type)>.size"
        }
    }
    
    public init(value: Value) {
        self.value = value
        
        super.init()
        
        switch value {
        case .expression(let exp):
            exp.parent = self
        case .type: break
        }
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        value = try container.decode(Value.self, forKey: .value)
        
        try super.init(from: container.superDecoder())
        
        switch value {
        case .expression(let exp):
            exp.parent = self
        case .type: break
        }
    }
    
    @inlinable
    public override func copy() -> SizeOfExpression {
        SizeOfExpression(value: value.copy()).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V>(_ visitor: V) -> V.ExprResult where V : ExpressionVisitor {
        visitor.visitSizeOf(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as SizeOfExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(value, forKey: .value)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: SizeOfExpression, rhs: SizeOfExpression) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.value == rhs.value
    }
    
    /// Inner expression value for this SizeOfExpression
    public enum Value: Codable, Equatable {
        case type(SwiftType)
        case expression(Expression)
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let discriminator = try container.decode(String.self, forKey: .discriminator)
            
            switch discriminator {
            case "type":
                try self = .type(container.decode(SwiftType.self, forKey: .payload))
            case "expression":
                try self = .expression(container.decodeExpression(forKey: .payload))
            default:
                throw DecodingError.dataCorruptedError(
                    forKey: CodingKeys.discriminator,
                    in: container,
                    debugDescription: "Invalid discriminator tag \(discriminator)")
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case .type(let value):
                try container.encode("type", forKey: .discriminator)
                try container.encode(value, forKey: .payload)
                
            case .expression(let value):
                try container.encode("expression", forKey: .discriminator)
                try container.encodeExpression(value, forKey: .payload)
            }
        }
        
        public func copy() -> Value {
            switch self {
            case .type:
                return self
            case .expression(let exp):
                return .expression(exp.copy())
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case discriminator = "kind"
            case payload
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case value
    }
}
public extension Expression {
    @inlinable
    var asSizeOf: SizeOfExpression? {
        cast()
    }

    @inlinable
    var isSizeOf: Bool {
        asSizeOf != nil
    }
    
    static func sizeof(_ exp: Expression) -> SizeOfExpression {
        SizeOfExpression(value: .expression(exp))
    }
    
    static func sizeof(type: SwiftType) -> SizeOfExpression {
        SizeOfExpression(value: .type(type))
    }
}
