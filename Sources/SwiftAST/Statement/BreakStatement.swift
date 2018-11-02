public class BreakStatement: Statement {
    public override var isUnconditionalJump: Bool {
        return true
    }
    
    public override func copy() -> BreakStatement {
        return BreakStatement().copyMetadata(from: self)
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitBreak(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        return other is BreakStatement
    }
}
public extension Statement {
    @inlinable
    public var asBreak: BreakStatement? {
        return cast()
    }
}
