public class WhileStatement: Statement {
    public var exp: Expression {
        didSet {
            oldValue.parent = nil
            exp.parent = self
        }
    }
    public var body: CompoundStatement {
        didSet {
            oldValue.parent = nil
            body.parent = self
        }
    }
    
    public override var children: [SyntaxNode] {
        return [exp, body]
    }
    
    public init(exp: Expression, body: CompoundStatement) {
        self.exp = exp
        self.body = body
        
        super.init()
        
        exp.parent = self
        body.parent = self
    }
    
    public override func copy() -> WhileStatement {
        return WhileStatement(exp: exp.copy(), body: body.copy()).copyMetadata(from: self)
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitWhile(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as WhileStatement:
            return exp == rhs.exp && body == rhs.body
        default:
            return false
        }
    }
}
public extension Statement {
    public var asWhile: WhileStatement? {
        return cast()
    }
}
