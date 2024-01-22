public class ExpressionsStatement: Statement, StatementKindType {
    public var statementKind: StatementKind {
        .expressions(self)
    }

    public var expressions: [Expression] {
        didSet {
            oldValue.forEach { $0.parent = self }
            expressions.forEach { $0.parent = self }
        }
    }

    public override var children: [SyntaxNode] {
        expressions
    }
    
    public init(expressions: [Expression]) {
        self.expressions = expressions
        
        super.init()
        
        expressions.forEach { $0.parent = self }
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        expressions = try container.decodeExpressions(forKey: .expressions)
        
        try super.init(from: container.superDecoder())
        
        expressions.forEach { $0.parent = self }
    }
    
    @inlinable
    public override func copy() -> ExpressionsStatement {
        ExpressionsStatement(expressions: expressions.map { $0.copy() })
            .copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitExpressions(self)
    }
    
    @inlinable
    public override func accept<V: StatementStatefulVisitor>(_ visitor: V, state: V.State) -> V.StmtResult {
        visitor.visitExpressions(self, state: state)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as ExpressionsStatement:
            return expressions == rhs.expressions
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpressions(expressions, forKey: .expressions)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case expressions
    }
}
public extension Statement {
    /// Returns `self as? ExpressionsStatement`.
    @inlinable
    var asExpressions: ExpressionsStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `ExpressionsStatement` class.
    @inlinable
    var isExpressions: Bool {
        asExpressions != nil
    }

    /// Creates a `ExpressionsStatement` instance for the given expression list.
    static func expressions(_ exp: [Expression]) -> ExpressionsStatement {
        ExpressionsStatement(expressions: exp)
    }

    /// Creates a `ExpressionsStatement` instance for the given expression.
    static func expression(_ expr: Expression) -> ExpressionsStatement {
        .expressions([expr])
    }
}
