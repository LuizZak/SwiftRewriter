public class BlockLiteralExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .blockLiteral(self)
    }

    public var parameters: [BlockParameter]
    public var returnType: SwiftType
    public var body: CompoundStatement {
        didSet { oldValue.parent = nil; body.parent = self }
    }

    public override var children: [SyntaxNode] {
        [body]
    }
    
    public override var description: String {
        var buff = "{ "
        
        buff += "("
        buff += parameters.map(\.description).joined(separator: ", ")
        buff += ") -> "
        buff += returnType.description
        buff += " in "
        
        buff += "< body >"
        
        buff += " }"
        
        return buff
    }
    
    public override var requiresParens: Bool {
        true
    }
    
    public init(parameters: [BlockParameter], returnType: SwiftType, body: CompoundStatement) {
        self.parameters = parameters
        self.returnType = returnType
        self.body = body
        
        super.init()
        
        self.body.parent = self
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        parameters = try container.decode([BlockParameter].self, forKey: .parameters)
        returnType = try container.decode(SwiftType.self, forKey: .returnType)
        body = try container.decodeStatement(CompoundStatement.self, forKey: .body)
        
        try super.init(from: container.superDecoder())
        
        self.body.parent = self
    }
    
    @inlinable
    public override func copy() -> BlockLiteralExpression {
        BlockLiteralExpression(
            parameters: parameters,
            returnType: returnType,
            body: body.copy()
        ).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitBlock(self)
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
        if lhs === rhs {
            return true
        }
        
        return lhs.parameters == rhs.parameters &&
            lhs.returnType == rhs.returnType &&
            lhs.body == rhs.body
    }
    
    private enum CodingKeys: String, CodingKey {
        case parameters
        case returnType
        case body
    }
}
public extension Expression {
    @inlinable
    var asBlock: BlockLiteralExpression? {
        cast()
    }

    @inlinable
    var isBlock: Bool {
        asBlock != nil
    }
    
    static func block(
        parameters: [BlockParameter] = [],
        `return` returnType: SwiftType = .void,
        body: CompoundStatement
    ) -> BlockLiteralExpression {
        
        BlockLiteralExpression(parameters: parameters, returnType: returnType, body: body)
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
        "\(self.name): \(type)"
    }
}
