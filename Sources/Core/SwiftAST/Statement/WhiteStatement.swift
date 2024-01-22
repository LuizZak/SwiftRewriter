public class WhileStatement: Statement, StatementKindType {
    public var statementKind: StatementKind {
        .while(self)
    }

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
        [exp, body]
    }
    
    public override var isLabelableStatementType: Bool {
        return true
    }
    
    public init(exp: Expression, body: CompoundStatement) {
        self.exp = exp
        self.body = body
        
        super.init()
        
        exp.parent = self
        body.parent = self
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        exp = try container.decodeExpression(forKey: .exp)
        body = try container.decodeStatement(CompoundStatement.self, forKey: .body)
        
        try super.init(from: container.superDecoder())
        
        exp.parent = self
        body.parent = self
    }
    
    @inlinable
    public override func copy() -> WhileStatement {
        WhileStatement(exp: exp.copy(), body: body.copy()).copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitWhile(self)
    }
    
    @inlinable
    public override func accept<V: StatementStatefulVisitor>(_ visitor: V, state: V.State) -> V.StmtResult {
        visitor.visitWhile(self, state: state)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as WhileStatement:
            return exp == rhs.exp && body == rhs.body
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpression(exp, forKey: .exp)
        try container.encodeStatement(body, forKey: .body)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case exp
        case body
    }
}
public extension Statement {
    /// Returns `self as? WhileStatement`.
    @inlinable
    var asWhile: WhileStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `WhileStatement`
    /// class.
    @inlinable
    var isWhile: Bool {
        asWhile != nil
    }
    
    /// Creates a `WhileStatement` instance using the given condition expression
    /// and compound statement as its body.
    static func `while`(_ exp: Expression, body: CompoundStatement) -> WhileStatement {
        WhileStatement(exp: exp, body: body)
    }
}
