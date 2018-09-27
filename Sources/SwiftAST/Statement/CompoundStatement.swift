/// Encapsulates a compound statement, that is, a series of statements enclosed
/// within braces.
public class CompoundStatement: Statement, ExpressibleByArrayLiteral {
    /// An empty compound statement.
    public static var empty: CompoundStatement {
        return CompoundStatement()
    }
    
    public var isEmpty: Bool {
        return statements.isEmpty
    }
    
    public var statements: [Statement] = [] {
        didSet {
            oldValue.forEach { $0.parent = nil }
            statements.forEach { $0.parent = self }
        }
    }
    
    public override var children: [SyntaxNode] {
        return statements
    }
    
    public init(statements: [Statement]) {
        self.statements = statements
        
        super.init()
        
        statements.forEach { $0.parent = self }
    }
    
    public required init(arrayLiteral elements: Statement...) {
        self.statements = elements
        
        super.init()
        
        statements.forEach { $0.parent = self }
    }
    
    public override func copy() -> CompoundStatement {
        return CompoundStatement(statements: statements.map { $0.copy() }).copyMetadata(from: self)
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitCompound(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as CompoundStatement:
            return statements == rhs.statements
        default:
            return false
        }
    }
}

extension CompoundStatement: Sequence {
    public func makeIterator() -> IndexingIterator<[Statement]> {
        return statements.makeIterator()
    }
}

public extension Statement {
    public var asCompound: CompoundStatement? {
        return cast()
    }
}
