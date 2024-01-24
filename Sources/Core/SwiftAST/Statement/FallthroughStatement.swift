public class FallthroughStatement: Statement, StatementKindType {
    public var statementKind: StatementKind {
        .fallthrough(self)
    }

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
    
    @inlinable
    public override func accept<V: StatementStatefulVisitor>(_ visitor: V, state: V.State) -> V.StmtResult {
        visitor.visitFallthrough(self, state: state)
    }

    public override func isEqual(to other: Statement) -> Bool {
        other is FallthroughStatement
    }
}
public extension Statement {
    /// Returns `self as? FallthroughStatement`.
    @inlinable
    var asFallthrough: FallthroughStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `FallthroughStatement` class.
    @inlinable
    var isFallthrough: Bool {
        asFallthrough != nil
    }
    
    /// Creates a `FallthroughStatement` instance.
    static var `fallthrough`: FallthroughStatement {
        FallthroughStatement()
    }
}
