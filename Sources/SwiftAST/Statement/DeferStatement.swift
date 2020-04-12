public class DeferStatement: Statement {
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
    @inlinable
    var asDefer: DeferStatement? {
        cast()
    }
}
