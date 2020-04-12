public class ReturnStatement: Statement {
    public override var isUnconditionalJump: Bool {
        true
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
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        exp = try container.decodeExpressionIfPresent(forKey: .exp)
        
        try super.init(from: container.superDecoder())
        
        exp?.parent = self
    }
    
    @inlinable
    public override func copy() -> ReturnStatement {
        ReturnStatement(exp: exp?.copy()).copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitReturn(self)
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
    
    private enum CodingKeys: String, CodingKey {
        case exp
    }
}
public extension Statement {
    @inlinable
    var asReturn: ReturnStatement? {
        cast()
    }
}
