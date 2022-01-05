public class DoStatement: Statement, StatementKindType {
    public var statementKind: StatementKind {
        .do(self)
    }

    public var body: CompoundStatement {
        didSet {
            oldValue.parent = nil
            body.parent = self
        }
    }
    
    public override var children: [SyntaxNode] {
        [body] + catchBlocks.flatMap { $0.children }
    }
    
    public override var isLabelableStatementType: Bool {
        return true
    }

    /// A list of catch blocks appended to the end of this `DoStatement`.
    public var catchBlocks: [CatchBlock] {
        didSet {
            oldValue.forEach { $0.setParent(nil) }
            catchBlocks.forEach { $0.setParent(self) }
        }
    }
    
    public init(body: CompoundStatement, catchBlocks: [CatchBlock] = []) {
        self.body = body
        self.catchBlocks = catchBlocks
        
        super.init()
        
        body.parent = self
        catchBlocks.forEach { $0.setParent(self) }
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        body = try container.decodeStatement(CompoundStatement.self, forKey: .body)
        catchBlocks = try container.decode([CatchBlock].self, forKey: .catchBlocks)
        
        try super.init(from: container.superDecoder())
        
        body.parent = self
        catchBlocks.forEach { $0.setParent(self) }
    }
    
    @inlinable
    public override func copy() -> DoStatement {
        DoStatement(
            body: body.copy(),
            catchBlocks: catchBlocks.map { $0.copy() }
        ).copyMetadata(from: self)
    }

    /// Returns a copy of this `DoStatement` with a `CatchBlock` appended at the end.
    public func `catch`(pattern: Pattern? = nil, _ body: CompoundStatement) -> DoStatement {
        let copy = copy()
        copy.catchBlocks.append(
            .init(pattern: pattern, body: body)
        )
        return copy
    }

    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitDo(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as DoStatement:
            return body == rhs.body && catchBlocks == rhs.catchBlocks
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeStatement(body, forKey: .body)
        try container.encode(catchBlocks, forKey: .catchBlocks)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case body
        case catchBlocks
    }
}
public extension Statement {
    /// Returns `self as? DoStatement`.
    @inlinable
    var asDoStatement: DoStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `DoStatement` class.
    @inlinable
    var isDoStatement: Bool? {
        asDoStatement != nil
    }
    
    /// Creates a `DoStatement` instance using the given compound statement as
    /// its body.
    static func `do`(_ stmt: CompoundStatement) -> DoStatement {
        DoStatement(body: stmt)
    }
}

/// A catch block for a `DoStatement`
public struct CatchBlock: Codable, Equatable {
    /// An optional pattern to match against caught errors.
    public var pattern: Pattern?

    /// The body of this catch block.
    public var body: CompoundStatement
    
    fileprivate var children: [SyntaxNode] {
        var result: [SyntaxNode] = []

        if let pattern = pattern {
            pattern.collect(expressions: &result)
        }
        result.append(body)

        return result
    }

    public init(pattern: Pattern? = nil, body: CompoundStatement) {
        self.pattern = pattern
        self.body = body
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        pattern = try container.decode(Pattern.self, forKey: .pattern)
        body = try container.decodeStatement(CompoundStatement.self, forKey: .body)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(pattern, forKey: .pattern)
        try container.encodeStatement(body, forKey: .body)
    }

    fileprivate func setParent(_ parent: SyntaxNode?) {
        pattern?.setParent(parent)
        body.parent = parent
    }

    @usableFromInline
    internal func copy() -> CatchBlock {
        CatchBlock(pattern: pattern?.copy(), body: body.copy())
    }
    
    private enum CodingKeys: String, CodingKey {
        case pattern
        case body
    }
}
