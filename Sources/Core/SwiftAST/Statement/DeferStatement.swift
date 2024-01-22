public class DeferStatement: Statement, StatementKindType {
    public var statementKind: StatementKind {
        .defer(self)
    }

    public var body: CompoundStatement {
        didSet {
            oldValue.parent = nil
            body.parent = self
        }
    }
    
    public override var children: [SyntaxNode] {
        [body]
    }
    
    public init(body: CompoundStatement) {
        self.body = body
        
        super.init()
        
        body.parent = self
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let body = try container.decodeStatement(CompoundStatement.self, forKey: .body)
        
        self.body = body
        
        try super.init(from: container.superDecoder())
        
        body.parent = self
    }
    
    @inlinable
    public override func copy() -> DeferStatement {
        DeferStatement(body: body.copy()).copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitDefer(self)
    }
    
    @inlinable
    public override func accept<V: StatementStatefulVisitor>(_ visitor: V, state: V.State) -> V.StmtResult {
        visitor.visitDefer(self, state: state)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as DeferStatement:
            return body == rhs.body
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeStatement(body, forKey: .body)
        
        try super.encode(to: container.superEncoder())
    }
    private enum CodingKeys: String, CodingKey {
        case body
    }
}
public extension Statement {
    /// Returns `self as? DeferStatement`.
    @inlinable
    var asDefer: DeferStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `DeferStatement` class.
    @inlinable
    var isDefer: Bool {
        asDefer != nil
    }
    
    /// Creates a `DeferStatement` instance using the given compound statement as
    /// its body.
    static func `defer`(_ stmt: CompoundStatement) -> DeferStatement {
        DeferStatement(body: stmt)
    }
}
