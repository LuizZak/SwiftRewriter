public class IdentifierExpression: Expression, ExpressibleByStringLiteral, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .identifier(self)
    }

    public var identifier: String
    
    public override var description: String {
        identifier
    }
    
    public required init(stringLiteral value: String) {
        self.identifier = value
        
        super.init()
    }
    
    public init(identifier: String) {
        self.identifier = identifier
        
        super.init()
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        
        try super.init(from: container.superDecoder())
    }
    
    @inlinable
    public override func copy() -> IdentifierExpression {
        IdentifierExpression(identifier: identifier).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitIdentifier(self)
    }
    
    @inlinable
    public override func isEqual(to other: Expression) -> Bool {
        switch other {
        case let rhs as IdentifierExpression:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier, forKey: .identifier)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: IdentifierExpression, rhs: IdentifierExpression) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.identifier == rhs.identifier
    }
    
    private enum CodingKeys: String, CodingKey {
        case identifier
    }
}
public extension Expression {
    @inlinable
    var asIdentifier: IdentifierExpression? {
        cast()
    }

    @inlinable
    var isIdentifier: Bool {
        asIdentifier != nil
    }

    static func identifier(_ ident: String) -> IdentifierExpression {
        IdentifierExpression(identifier: ident)
    }
}
