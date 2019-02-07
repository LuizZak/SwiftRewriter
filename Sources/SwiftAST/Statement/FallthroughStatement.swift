public class FallthroughStatement: Statement {
    public override var isUnconditionalJump: Bool {
        return true
    }
    
    @inlinable
    public override func copy() -> FallthroughStatement {
        return FallthroughStatement().copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitFallthrough(self)
    }

    public override func isEqual(to other: Statement) -> Bool {
        return other is FallthroughStatement
    }
}
public extension Statement {
    @inlinable
    var asFallthrough: FallthroughStatement? {
        return cast()
    }
}
