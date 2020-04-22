public class FallthroughStatement: Statement {
    public override var isUnconditionalJump: Bool {
        true
    }
    
    public override func copy() -> FallthroughStatement {
        FallthroughStatement().copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitFallthrough(self)
    }

    public override func isEqual(to other: Statement) -> Bool {
        other is FallthroughStatement
    }
}
public extension Statement {
    @inlinable
    var asFallthrough: FallthroughStatement? {
        cast()
    }
}
