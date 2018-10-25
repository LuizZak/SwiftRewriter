public class BlockLiteralExpression: Expression {
    public var parameters: [BlockParameter]
    public var returnType: SwiftType
    public var body: CompoundStatement {
        didSet { oldValue.parent = nil; body.parent = self }
    }
    
    public override var description: String {
        var buff = "{ "
        
        buff += "("
        buff += parameters.map { $0.description }.joined(separator: ", ")
        buff += ") -> "
        buff += returnType.description
        buff += " in "
        
        buff += "< body >"
        
        buff += " }"
        
        return buff
    }
    
    public override var requiresParens: Bool {
        return true
    }
    
    public init(parameters: [BlockParameter], returnType: SwiftType, body: CompoundStatement) {
        self.parameters = parameters
        self.returnType = returnType
        self.body = body
        
        super.init()
        
        self.body.parent = self
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(
            parameters: container.decode([BlockParameter].self, forKey: .parameters),
            returnType: container.decode(SwiftType.self, forKey: .returnType),
            body: container.decodeStatement(CompoundStatement.self, forKey: .body))
    }
    
    public override func copy() -> BlockLiteralExpression {
        return BlockLiteralExpression(parameters: parameters,
                                      returnType: returnType,
                                      body: body.copy()).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitBlock(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as BlockLiteralExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(parameters, forKey: .parameters)
        try container.encode(returnType, forKey: .returnType)
        try container.encodeStatement(body, forKey: .body)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: BlockLiteralExpression, rhs: BlockLiteralExpression) -> Bool {
        return lhs.parameters == rhs.parameters &&
            lhs.returnType == rhs.returnType &&
            lhs.body == rhs.body
    }
    
    public enum CodingKeys: String, CodingKey {
        case parameters
        case returnType
        case body
    }
}
public extension Expression {
    public var asBlock: BlockLiteralExpression? {
        return cast()
    }
}

public struct BlockParameter: Codable, Equatable {
    public var name: String
    public var type: SwiftType
    
    public init(name: String, type: SwiftType) {
        self.name = name
        self.type = type
    }
}

extension BlockParameter: CustomStringConvertible {
    public var description: String {
        return "\(self.name): \(type)"
    }
}
