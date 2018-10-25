public class UnknownExpression: Expression {
    public var context: UnknownASTContext
    
    public override var description: String {
        return context.description
    }
    
    public init(context: UnknownASTContext) {
        self.context = context
        
        super.init()
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        try self.init(context: UnknownASTContext(context: container.decode(String.self)))
    }
    
    public override func copy() -> UnknownExpression {
        return UnknownExpression(context: context).copyTypeAndMetadata(from: self)
    }
    
    public override func accept<V: ExpressionVisitor>(_ visitor: V) -> V.ExprResult {
        return visitor.visitUnknown(self)
    }
    
    public override func isEqual(to other: Expression) -> Bool {
        return other is UnknownExpression
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        try container.encode(context.context)
    }
    
    public static func == (lhs: UnknownExpression, rhs: UnknownExpression) -> Bool {
        return true
    }
}
public extension Expression {
    public var asUnknown: UnknownExpression? {
        return cast()
    }
}
