public class ReturnStatement: Statement {
    public override var isUnconditionalJump: Bool {
        return true
    }
    
    public var exp: Expression? {
        didSet {
            oldValue?.parent = nil
            exp?.parent = self
        }
    }
    
    public override var children: [SyntaxNode] {
        if let exp = exp {
            return [exp]
        }
        
        return []
    }
    
    public init(exp: Expression? = nil) {
        self.exp = exp
        
        super.init()
        
        exp?.parent = self
    }
    
    public override func copy() -> ReturnStatement {
        return ReturnStatement(exp: exp?.copy()).copyMetadata(from: self)
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitReturn(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as ReturnStatement:
            return exp == rhs.exp
        default:
            return false
        }
    }
}
public extension Statement {
    public var asReturn: ReturnStatement? {
        return cast()
    }
}
