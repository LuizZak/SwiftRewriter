public class ConstantExpression: Expression, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .constant(self)
    }

    public var constant: Constant
    
    public override var isLiteralExpression: Bool {
        if constant.isInteger {
            return true
        }
        
        switch constant {
        case .boolean, .nil, .float, .string:
            return true
        default:
            return false
        }
    }
    
    public override var literalExpressionKind: LiteralExpressionKind? {
        switch constant {
        case .int:
            return .integer
        case .float:
            return .float
        case .boolean:
            return .boolean
        case .string:
            return .string
        case .nil:
            return .nil
        default:
            return nil
        }
    }
    
    public override var description: String {
        constant.description
    }
    
    public init(constant: Constant) {
        self.constant = constant
        
        super.init()
    }
    
    public required init(stringLiteral value: String) {
        constant = .string(value)
        
        super.init()
    }
    public required init(integerLiteral value: Int) {
        constant = .int(value, .decimal)
        
        super.init()
    }
    public required init(floatLiteral value: Float) {
        constant = .float(value)
        
        super.init()
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        constant = try container.decode(Constant.self, forKey: .constant)
        
        try super.init(from: container.superDecoder())
    }
    
    @inlinable
    public override func copy() -> ConstantExpression {
        ConstantExpression(constant: constant).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitConstant(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as ConstantExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(constant, forKey: .constant)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: ConstantExpression, rhs: ConstantExpression) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.constant == rhs.constant
    }
    
    private enum CodingKeys: String, CodingKey {
        case constant
    }
}
public extension Expression {
    @inlinable
    var asConstant: ConstantExpression? {
        cast()
    }

    @inlinable
    var isConstant: Bool {
        asConstant != nil
    }
    
    static func constant(_ constant: Constant) -> ConstantExpression {
        ConstantExpression(constant: constant)
    }
}

/// Represents one of the recognized compile-time constant value types.
public enum Constant: Codable, Equatable {
    case float(Float)
    case double(Double)
    case boolean(Bool)
    case int(Int, IntegerType)
    case string(String)
    case rawConstant(String)
    case `nil`
    
    /// Returns an integer value if this constant represents one, or nil, in case
    /// it does not.
    public var integerValue: Int? {
        switch self {
        case .int(let i, _):
            return i
        default:
            return nil
        }
    }
    
    /// Returns `true` if this constant represents an integer value.
    public var isInteger: Bool {
        switch self {
        case .int:
            return true
        default:
            return false
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let discriminator = try container.decode(Discriminator.self, forKey: .discriminator)
        
        switch discriminator {
        case .float:
            try self = .float(container.decode(Float.self, forKey: .payload0))
        
        case .double:
            try self = .double(container.decode(Double.self, forKey: .payload0))
            
        case .boolean:
            try self = .boolean(container.decode(Bool.self, forKey: .payload0))
            
        case .int:
            try self = .int(container.decode(Int.self, forKey: .payload0),
                            container.decode(IntegerType.self, forKey: .payload1))
            
        case .string:
            try self = .string(container.decode(String.self, forKey: .payload0))
            
        case .rawConstant:
            try self = .rawConstant(container.decode(String.self, forKey: .payload0))
            
        case .nil:
            self = .nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .float(let value):
            try container.encode(Discriminator.float, forKey: .discriminator)
            try container.encode(value, forKey: .payload0)
        
        case .double(let value):
            try container.encode(Discriminator.double, forKey: .discriminator)
            try container.encode(value, forKey: .payload0)
            
        case .boolean(let value):
            try container.encode(Discriminator.boolean, forKey: .discriminator)
            try container.encode(value, forKey: .payload0)
            
        case let .int(value, type):
            try container.encode(Discriminator.int, forKey: .discriminator)
            try container.encode(value, forKey: .payload0)
            try container.encode(type, forKey: .payload1)
            
        case .string(let value):
            try container.encode(Discriminator.string, forKey: .discriminator)
            try container.encode(value, forKey: .payload0)
            
        case .rawConstant(let value):
            try container.encode(Discriminator.rawConstant, forKey: .discriminator)
            try container.encode(value, forKey: .payload0)
            
        case .nil:
            try container.encode(Discriminator.nil, forKey: .discriminator)
        }
    }
    
    public static func decimal(_ value: Int) -> Constant {
        .int(value, .decimal)
    }
    
    public static func binary(_ value: Int) -> Constant {
        .int(value, .binary)
    }
    
    public static func octal(_ value: Int) -> Constant {
        .int(value, .octal)
    }
    
    public static func hexadecimal(_ value: Int) -> Constant {
        .int(value, .hexadecimal)
    }
    
    /// Defines how a raw integer value constant is displayed.
    /// Does not affect the stored integer constant value, only the display
    /// format.
    public enum IntegerType: String, Codable {
        case decimal
        case binary
        case octal
        case hexadecimal
    }
    
    private enum Discriminator: String, Codable {
        case float
        case double
        case boolean
        case int
        case string
        case rawConstant
        case `nil`
    }
    
    private enum CodingKeys: String, CodingKey {
        case discriminator = "kind"
        case payload0
        case payload1
    }
}

/// Specifies one of the possible literal types
public enum LiteralExpressionKind: Hashable {
    case integer
    case float
    case string
    case boolean
    case `nil`
}

extension Constant: CustomStringConvertible {
    public var description: String {
        switch self {
        case .float(let fl):
            return fl.description
        
        case .double(let dbl):
            return dbl.description
            
        case .boolean(let bool):
            return bool.description
            
        case let .int(int, category):
            
            switch category {
            case .decimal:
                return int.description
            case .binary:
                return "0b" + String(int, radix: 2)
            case .octal:
                return "0o" + String(int, radix: 8)
            case .hexadecimal:
                return "0x" + String(int, radix: 16, uppercase: false)
            }
            
        case .string(let str):
            return "\"\(str)\""
            
        case .rawConstant(let str):
            return str
            
        case .nil:
            return "nil"
        }
    }
}

// MARK: - Literal initialiation
extension Constant: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value, .decimal)
    }
}

extension Constant: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Float) {
        self = .float(value)
    }
}

extension Constant: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .boolean(value)
    }
}

extension Constant: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}
