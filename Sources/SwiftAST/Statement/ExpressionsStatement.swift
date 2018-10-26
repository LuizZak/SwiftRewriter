public class ExpressionsStatement: Statement {
    public var expressions: [Expression] {
        didSet {
            oldValue.forEach { $0.parent = self }
            expressions.forEach { $0.parent = self }
        }
    }
    
    public override var children: [SyntaxNode] {
        return expressions
    }
    
    public init(expressions: [Expression]) {
        self.expressions = expressions
        
        super.init()
        
        expressions.forEach { $0.parent = self }
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(expressions: container.decodeExpressions(forKey: .expressions))
    }
    
    public override func copy() -> ExpressionsStatement {
        return
            ExpressionsStatement(expressions: expressions.map { $0.copy() })
                .copyMetadata(from: self)
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitExpressions(self)
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
    
    public enum CodingKeys: String, CodingKey {
        case expressions
    }
}
public extension Statement {
    public var asExpressions: ExpressionsStatement? {
        return cast()
    }
}
