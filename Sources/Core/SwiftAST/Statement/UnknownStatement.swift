public class UnknownStatement: Statement, StatementKindType {
    public var statementKind: StatementKind {
        .unknown(self)
    }

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
    
    @inlinable
    public override func accept<V: StatementStatefulVisitor>(_ visitor: V, state: V.State) -> V.StmtResult {
        visitor.visitUnknown(self, state: state)
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
    /// Returns `self as? UnknownStatement`.
    @inlinable
    var asUnknown: UnknownStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `UnknownStatement`
    /// class.
    @inlinable
    var isUnknown: Bool {
        asUnknown != nil
    }
    
    /// Creates a `UnknownStatement` instance using a given context for the
    /// unknown statement representation.
    static func unknown(_ context: UnknownASTContext) -> UnknownStatement {
        UnknownStatement(context: context)
    }
}
