/// Encapsulates a compound statement, that is, a series of statements enclosed
/// within braces.
public class CompoundStatement: Statement, ExpressibleByArrayLiteral, StatementKindType {
    public var statementKind: StatementKind {
        .compound(self)
    }

    private var _statements: [Statement] = []

    /// An empty compound statement.
    public static var empty: CompoundStatement {
        CompoundStatement()
    }
    
    /// Returns `true` if this compound statement has no statements within.
    public var isEmpty: Bool {
        statements.isEmpty
    }
    
    public var statements: [Statement] {
        get {
            return _statements
        }
        set {
            _statements.forEach { $0.parent = nil }
            _statements = newValue
            _statements.forEach { $0.parent = self }
        }
    }
    
    public override var children: [SyntaxNode] {
        statements
    }
    
    public init(statements: [Statement]) {
        self._statements = statements
        
        super.init()
        
        statements.forEach { $0.parent = self }
    }
    
    public required init(arrayLiteral elements: Statement...) {
        self._statements = elements
        
        super.init()
        
        statements.forEach { $0.parent = self }
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _statements = try container.decodeStatements(forKey: .statements)
        
        try super.init(from: container.superDecoder())
        
        statements.forEach { $0.parent = self }
    }

    /// Appends a new statement at the end of this compound statement's statement
    /// list.
    public func appendStatement(_ statement: Statement) {
        _statements.append(statement)
        statement.parent = self
    }
    
    @inlinable
    public override func copy() -> CompoundStatement {
        CompoundStatement(statements: statements.map { $0.copy() }).copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitCompound(self)
    }
    
    @inlinable
    public override func accept<V: StatementStatefulVisitor>(_ visitor: V, state: V.State) -> V.StmtResult {
        visitor.visitCompound(self, state: state)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as CompoundStatement:
            return statements == rhs.statements
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeStatements(statements, forKey: .statements)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case statements
    }
}

extension CompoundStatement: Sequence {
    public func makeIterator() -> IndexingIterator<[Statement]> {
        statements.makeIterator()
    }
}

public extension Statement {
    /// Returns `self as? CompoundStatement`.
    @inlinable
    var asCompound: CompoundStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `CompoundStatement` class.
    @inlinable
    var isCompound: Bool {
        asCompound != nil
    }
    
    /// Creates a `CompoundStatement` instance using the given statement list as
    /// its body.
    static func compound(_ cpd: [Statement]) -> CompoundStatement {
        CompoundStatement(statements: cpd)
    }
}
