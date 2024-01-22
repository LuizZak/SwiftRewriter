public class ContinueStatement: Statement, StatementKindType {
    public var statementKind: StatementKind {
        .continue(self)
    }

    public override var isUnconditionalJump: Bool {
        true
    }
    
    public let targetLabel: String?
    
    public override convenience init() {
        self.init(targetLabel: nil)
    }
    
    public init(targetLabel: String?) {
        self.targetLabel = targetLabel
        
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        targetLabel = try container.decodeIfPresent(String.self, forKey: .targetLabel)
        
        try super.init(from: container.superDecoder())
    }
    
    @inlinable
    public override func copy() -> ContinueStatement {
        ContinueStatement(targetLabel: targetLabel).copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitContinue(self)
    }
    
    @inlinable
    public override func accept<V: StatementStatefulVisitor>(_ visitor: V, state: V.State) -> V.StmtResult {
        visitor.visitContinue(self, state: state)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as ContinueStatement:
            return targetLabel == rhs.targetLabel
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(targetLabel, forKey: .targetLabel)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case targetLabel
    }
}
public extension Statement {
    /// Returns `self as? ContinueStatement`.
    @inlinable
    var asContinue: ContinueStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `ContinueStatement` class.
    @inlinable
    var isContinue: Bool {
        asContinue != nil
    }

    /// Creates a `ContinueStatement` instance.
    static func `continue`() -> ContinueStatement {
        ContinueStatement()
    }
    
    /// Creates a `ContinueStatement` instance with the given label.
    static func `continue`(targetLabel: String?) -> ContinueStatement {
        ContinueStatement(targetLabel: targetLabel)
    }
}
