public class UnknownStatement: Statement {
    public var context: UnknownASTContext
    
    public init(context: UnknownASTContext) {
        self.context = context
    }
    
    public override func copy() -> UnknownStatement {
        return UnknownStatement(context: context).copyMetadata(from: self)
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitUnknown(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        return other is UnknownStatement
    }
}
public extension Statement {
    public var asUnknown: UnknownStatement? {
        return cast()
    }
}
