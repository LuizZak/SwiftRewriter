/// An empty semicolon statement with no semantic functionality.
public class SemicolonStatement: Statement {
    public override func copy() -> SemicolonStatement {
        return SemicolonStatement().copyMetadata(from: self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        return other is SemicolonStatement
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitSemicolon(self)
    }
}
public extension Statement {
    @inlinable
    public var asSemicolon: SemicolonStatement? {
        return cast()
    }
}
