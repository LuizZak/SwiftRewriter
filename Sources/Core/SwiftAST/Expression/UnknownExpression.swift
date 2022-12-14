public class UnknownExpression: Expression, ExpressionKindType {
    public var expressionKind: ExpressionKind {
        .unknown(self)
    }

    public var context: UnknownASTContext
    
    public override var description: String {
        context.description
    }
    
    public init(context: UnknownASTContext) {
        self.context = context
        
        super.init()
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        context =
            try UnknownASTContext(context:
                container.decode(String.self, forKey: .context))
        
        try super.init(from: container.superDecoder())
    }
    
    @inlinable
    public override func copy() -> UnknownExpression {
        UnknownExpression(context: context).copyTypeAndMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        visitor.visitUnknown(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        other is UnknownExpression
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(context.context, forKey: .context)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: UnknownExpression, rhs: UnknownExpression) -> Bool {
        true
    }
    
    private enum CodingKeys: String, CodingKey {
        case context
    }
}
public extension Expression {
    @inlinable
    var asUnknown: UnknownExpression? {
        cast()
    }

    @inlinable
    var isUnknown: Bool {
        asUnknown != nil
    }
    
    static func unknown(_ exp: UnknownASTContext) -> UnknownExpression {
        UnknownExpression(context: exp)
    }
}
