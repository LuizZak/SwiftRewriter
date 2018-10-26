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
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(exp: container.decodeExpressionIfPresent(forKey: .exp))
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
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpressionIfPresent(exp, forKey: .exp)
        
        try super.encode(to: container.superEncoder())
    }
    
    public enum CodingKeys: String, CodingKey {
        case exp
    }
}
public extension Statement {
    public var asReturn: ReturnStatement? {
        return cast()
    }
}
