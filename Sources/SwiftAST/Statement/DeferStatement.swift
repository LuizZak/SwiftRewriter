public class DeferStatement: Statement {
    public var body: CompoundStatement {
        didSet {
            oldValue.parent = nil
            body.parent = self
        }
    }
    
    public override var children: [SyntaxNode] {
        return [body]
    }
    
    public init(body: CompoundStatement) {
        self.body = body
        
        super.init()
        
        body.parent = self
    }
    
    public override func copy() -> DeferStatement {
        return DeferStatement(body: body.copy()).copyMetadata(from: self)
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitDefer(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as DeferStatement:
            return body == rhs.body
        default:
            return false
        }
    }
}
public extension Statement {
    public var asDefer: DeferStatement? {
        return cast()
    }
}
