public class SelectorExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .selector(self)
    }

    public var kind: Kind
    
    public override var description: String {
        func typeNamePrefix(_ type: SwiftType?) -> String {
            if let type = type {
                return "\(type)."
            }
            return ""
        }
        
        switch kind {
        case let .function(type, identifier):
            return "#selector(\(typeNamePrefix(type))\(identifier))"
            
        case let .getter(type, property):
            return "#selector(getter: \(typeNamePrefix(type))\(property))"
            
        case let .setter(type, property):
            return "#selector(setter: \(typeNamePrefix(type))\(property))"
        }
    }
    
    public convenience init(type: SwiftType, functionIdentifier: FunctionIdentifier) {
        self.init(kind: .function(type: type, identifier: functionIdentifier))
    }
    
    public convenience init(functionIdentifier: FunctionIdentifier) {
        self.init(kind: .function(type: nil, identifier: functionIdentifier))
    }
    
    public convenience init(getter: String) {
        self.init(kind: .getter(type: nil, property: getter))
    }
    
    public convenience init(type: SwiftType, getter: String) {
        self.init(kind: .getter(type: type, property: getter))
    }
    
    public convenience init(setter: String) {
        self.init(kind: .setter(type: nil, property: setter))
    }
    
    public convenience init(type: SwiftType, setter: String) {
        self.init(kind: .setter(type: type, property: setter))
    }
    
    public init(kind: Kind) {
        self.kind = kind
        
        super.init()
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        kind = try container.decode(Kind.self, forKey: .kind)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func copy() -> SelectorExpression {
        SelectorExpression(kind: kind).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V>(_ visitor: V) -> V.ExprResult where V : ExpressionVisitor {
        visitor.visitSelector(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as SelectorExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(kind, forKey: .kind)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: SelectorExpression, rhs: SelectorExpression) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.kind == rhs.kind
    }
    
    public enum Kind: Equatable, Codable {
        case function(type: SwiftType?, identifier: FunctionIdentifier)
        case getter(type: SwiftType?, property: String)
        case setter(type: SwiftType?, property: String)
        
        public init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            
            switch try container.decode(Int.self) {
            case 0:
                let type = try container.decode(SwiftType?.self)
                let identifier = try container.decode(FunctionIdentifier.self)
                
                self = .function(type: type, identifier: identifier)
                
            case 1:
                let type = try container.decode(SwiftType?.self)
                let property = try container.decode(String.self)
                
                self = .getter(type: type, property: property)
                
            case 2:
                let type = try container.decode(SwiftType?.self)
                let property = try container.decode(String.self)
                
                self = .setter(type: type, property: property)
                
            default:
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Expected Selector kind discriminator 0, 1 or 2"
                )
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            
            switch self {
            case let .function(type, identifier):
                try container.encode(0)
                try container.encode(type)
                try container.encode(identifier)
                
            case let .getter(type, property):
                try container.encode(1)
                try container.encode(type)
                try container.encode(property)
                
            case let .setter(type, property):
                try container.encode(2)
                try container.encode(type)
                try container.encode(property)
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case kind
        case functionIdentifier
    }
}
public extension Expression {
    @inlinable
    var asSelector: SelectorExpression? {
        cast()
    }

    @inlinable
    var isSelector: Bool {
        asSelector != nil
    }
    
    static func selector(_ identifier: FunctionIdentifier) -> SelectorExpression {
        SelectorExpression(functionIdentifier: identifier)
    }
    static func selector(_ type: SwiftType, _ identifier: FunctionIdentifier) -> SelectorExpression {
        SelectorExpression(type: type, functionIdentifier: identifier)
    }
    
    static func selector(getter: String) -> SelectorExpression {
        SelectorExpression(getter: getter)
    }
    static func selector(_ type: SwiftType, getter: String) -> SelectorExpression {
        SelectorExpression(type: type, getter: getter)
    }
    
    static func selector(setter: String) -> SelectorExpression {
        SelectorExpression(setter: setter)
    }
    static func selector(_ type: SwiftType, setter: String) -> SelectorExpression {
        SelectorExpression(type: type, setter: setter)
    }
}
