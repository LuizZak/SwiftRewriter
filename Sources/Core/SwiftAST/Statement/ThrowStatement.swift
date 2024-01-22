public class ThrowStatement: Statement, StatementKindType {
    public var statementKind: StatementKind {
        .throw(self)
    }

    public override var isUnconditionalJump: Bool {
        true
    }
    
    public var exp: Expression {
        didSet {
            oldValue.parent = nil
            exp.parent = self
        }
    }
    
    public override var children: [SyntaxNode] {
        return [exp]
    }
    
    public init(exp: Expression) {
        self.exp = exp
        
        super.init()
        
        exp.parent = self
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        exp = try container.decodeExpression(forKey: .exp)
        
        try super.init(from: container.superDecoder())
        
        exp.parent = self
    }
    
    @inlinable
    public override func copy() -> ThrowStatement {
        ThrowStatement(exp: exp.copy()).copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitThrow(self)
    }
    
    @inlinable
    public override func accept<V: StatementStatefulVisitor>(_ visitor: V, state: V.State) -> V.StmtResult {
        visitor.visitThrow(self, state: state)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as ThrowStatement:
            return exp == rhs.exp
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpression(exp, forKey: .exp)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case exp
    }
}
public extension Statement {
    /// Returns `self as? ThrowStatement`.
    @inlinable
    var asThrow: ThrowStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `ThrowStatement`
    /// class.
    @inlinable
    var isThrow: Bool {
        asThrow != nil
    }

    /// Creates a `ThrowStatement` instance using the given expression as the
    /// thrown error expression.
    static func `throw`(_ exp: Expression) -> ThrowStatement {
        .init(exp: exp)
    }
}
