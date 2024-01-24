public class ForStatement: Statement, StatementKindType {
    /// Cache of children nodes
    private var _childrenNodes: [SyntaxNode] = []
    
    public var statementKind: StatementKind {
        .for(self)
    }

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
        _childrenNodes
    }
    
    public override var isLabelableStatementType: Bool {
        return true
    }
    
    public init(pattern: Pattern, exp: Expression, body: CompoundStatement) {
        self.pattern = pattern
        self.exp = exp
        self.body = body
        
        super.init()
        
        pattern.setParent(self)
        exp.parent = self
        body.parent = self

        reloadChildrenNodes()
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        pattern = try container.decode(Pattern.self, forKey: .pattern)
        exp = try container.decodeExpression(forKey: .exp)
        body = try container.decodeStatement(CompoundStatement.self, forKey: .body)
        
        try super.init(from: container.superDecoder())
        
        pattern.setParent(self)
        exp.parent = self
        body.parent = self
        
        reloadChildrenNodes()
    }
    
    @inlinable
    public override func copy() -> ForStatement {
        ForStatement(pattern: pattern.copy(), exp: exp.copy(), body: body.copy())
            .copyMetadata(from: self)
    }
    
    private func reloadChildrenNodes() {
        _childrenNodes.removeAll()

        pattern.collect(expressions: &_childrenNodes)
        _childrenNodes.append(exp)
        _childrenNodes.append(body)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitFor(self)
    }
    
    @inlinable
    public override func accept<V: StatementStatefulVisitor>(_ visitor: V, state: V.State) -> V.StmtResult {
        visitor.visitFor(self, state: state)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as ForStatement:
            return pattern == rhs.pattern && exp == rhs.exp && body == rhs.body
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(pattern, forKey: .pattern)
        try container.encodeExpression(exp, forKey: .exp)
        try container.encodeStatement(body, forKey: .body)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case pattern
        case exp
        case body
    }
}
public extension Statement {
    /// Returns `self as? ForStatement`.
    @inlinable
    var asFor: ForStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `ForStatement`
    /// class.
    @inlinable
    var isFor: Bool {
        asFor != nil
    }
    
    /// Creates a `ForStatement` instance using the given pattern and expression
    /// and compound statement as its body.
    static func `for`(_ pattern: Pattern, _ exp: Expression, body: CompoundStatement) -> ForStatement {
        ForStatement(pattern: pattern, exp: exp, body: body)
    }
}
