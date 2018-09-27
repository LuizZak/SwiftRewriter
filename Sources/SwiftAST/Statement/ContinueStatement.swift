public class ContinueStatement: Statement {
    public override var isUnconditionalJump: Bool {
        return true
    }
    
    public override func copy() -> ContinueStatement {
        return ContinueStatement().copyMetadata(from: self)
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitContinue(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        return other is ContinueStatement
    }
}
public extension Statement {
    public var asContinue: ContinueStatement? {
        return cast()
    }
}
