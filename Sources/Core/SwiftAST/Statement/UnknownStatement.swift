public class UnknownStatement: Statement {
    public var context: UnknownASTContext
    
    public init(context: UnknownASTContext) {
        self.context = context
        
        super.init()
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        try self.init(context: UnknownASTContext(context: container.decode(String.self)))
    }
    
    @inlinable
    public override func copy() -> UnknownStatement {
        UnknownStatement(context: context).copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitUnknown(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        other is UnknownStatement
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        try container.encode(context.context)
    }
}
public extension Statement {
    @inlinable
    var asUnknown: UnknownStatement? {
        cast()
    }
}
