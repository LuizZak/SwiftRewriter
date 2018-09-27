public class ForStatement: Statement {
    /// Cache of children nodes
    private var _childrenNodes: [SyntaxNode] = []
    
    public var pattern: Pattern {
        didSet {
            oldValue.setParent(nil)
            pattern.setParent(self)
            
            reloadChildrenNodes()
        }
    }
    public var exp: Expression {
        didSet {
            oldValue.parent = nil
            exp.parent = self
            
            reloadChildrenNodes()
        }
    }
    public var body: CompoundStatement {
        didSet {
            oldValue.parent = nil
            body.parent = self
            
            reloadChildrenNodes()
        }
    }
    
    public override var children: [SyntaxNode] {
        return _childrenNodes
    }
    
    public init(pattern: Pattern, exp: Expression, body: CompoundStatement) {
        self.pattern = pattern
        self.exp = exp
        self.body = body
        
        super.init()
        
        pattern.setParent(self)
        exp.parent = self
        body.parent = self
    }
    
    public override func copy() -> ForStatement {
        return
            ForStatement(pattern: pattern.copy(), exp: exp.copy(), body: body.copy())
                .copyMetadata(from: self)
    }
    
    private func reloadChildrenNodes() {
        _childrenNodes.removeAll()
        
        _childrenNodes.append(exp)
        
        pattern.collect(expressions: &_childrenNodes)
        
        _childrenNodes.append(body)
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitFor(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as ForStatement:
            return pattern == rhs.pattern && exp == rhs.exp && body == rhs.body
        default:
            return false
        }
    }
}
public extension Statement {
    public var asFor: ForStatement? {
        return cast()
    }
}
