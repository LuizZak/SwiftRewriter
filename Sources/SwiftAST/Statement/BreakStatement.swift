public class BreakStatement: Statement {
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
    public override func copy() -> BreakStatement {
        BreakStatement(targetLabel: targetLabel).copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitBreak(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as BreakStatement:
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
    @inlinable
    var asBreak: BreakStatement? {
        cast()
    }
}
