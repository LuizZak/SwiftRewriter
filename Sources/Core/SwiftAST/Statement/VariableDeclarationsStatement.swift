public class VariableDeclarationsStatement: Statement, StatementKindType, CustomStringConvertible {
    public var statementKind: StatementKind {
        .variableDeclarations(self)
    }

    public var decl: [StatementVariableDeclaration] {
        didSet {
            oldValue.forEach {
                $0.parent = nil
            }
            decl.forEach {
                $0.parent = self
            }
        }
    }
    
    public override var children: [SyntaxNode] {
        decl
    }

    public var description: String {
        decl.map(\.description).joined(separator: ", ")
    }
    
    public init(decl: [StatementVariableDeclaration]) {
        self.decl = decl
        
        super.init()
        
        decl.forEach {
            $0.parent = self
        }
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        decl = try container.decode([StatementVariableDeclaration].self, forKey: .decl)
        
        try super.init(from: container.superDecoder())
        
        decl.forEach {
            $0.parent = self
        }
    }
    
    @inlinable
    public override func copy() -> VariableDeclarationsStatement {
        VariableDeclarationsStatement(
            decl: decl.map { $0.copy() }
        ).copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitVariableDeclarations(self)
    }
    
    @inlinable
    public override func accept<V: StatementStatefulVisitor>(_ visitor: V, state: V.State) -> V.StmtResult {
        visitor.visitVariableDeclarations(self, state: state)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as VariableDeclarationsStatement:
            return decl == rhs.decl
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(decl, forKey: .decl)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case decl
    }
}
public extension Statement {
    /// Returns `self as? VariableDeclarationsStatement`.
    @inlinable
    var asVariableDeclaration: VariableDeclarationsStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `VariableDeclarationsStatement`
    /// class.
    @inlinable
    var isVariableDeclaration: Bool {
        asVariableDeclaration != nil
    }

    /// Creates a `VariableDeclarationsStatement` instance using the given list
    /// of variable declarations.
    static func variableDeclarations(_ decl: [StatementVariableDeclaration]) -> VariableDeclarationsStatement {
        VariableDeclarationsStatement(decl: decl)
    }

    /// Creates a `VariableDeclarationsStatement` instance for a single variable
    /// definition with the given parameters.
    static func variableDeclaration(
        identifier: String,
        type: SwiftType,
        ownership: Ownership = .strong,
        isConstant: Bool = false,
        initialization: Expression?
    ) -> VariableDeclarationsStatement {
        
        .variableDeclarations([
            .init(
                identifier: identifier,
                type: type,
                ownership: ownership,
                isConstant: isConstant,
                initialization: initialization
            )
        ])
    }
}

/// A variable declaration statement
public class StatementVariableDeclaration: SyntaxNode, Codable, Equatable, CustomStringConvertible {
    public var identifier: String
    public var storage: ValueStorage
    public var initialization: Expression? {
        didSet {
            oldValue?.parent = nil
            initialization?.parent = self
        }
    }
    
    public var type: SwiftType {
        get {
            storage.type
        }
        set {
            storage.type = newValue
        }
    }
    public var ownership: Ownership {
        get {
            storage.ownership
        }
        set {
            storage.ownership = newValue
        }
    }
    public var isConstant: Bool {
        get {
            storage.isConstant
        }
        set {
            storage.isConstant = newValue
        }
    }

    public override var children: [SyntaxNode] {
        if let exp = initialization {
            return [exp]
        }

        return []
    }

    public var description: String {
        if let exp = initialization {
            return "\(identifier): \(type) = \(exp)"
        }

        return "\(identifier): \(type)"
    }
    
    public init(
        identifier: String,
        storage: ValueStorage,
        initialization: Expression? = nil
    ) {
        self.identifier = identifier
        self.storage = storage
        self.initialization = initialization

        super.init()

        initialization?.parent = self
    }
    
    public convenience init(
        identifier: String,
        type: SwiftType,
        ownership: Ownership = .strong,
        isConstant: Bool = false,
        initialization: Expression? = nil
    ) {
        self.init(
            identifier: identifier,
            storage: ValueStorage(
                type: type,
                ownership: ownership,
                isConstant: isConstant
            ),
            initialization: initialization
        )
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.identifier = container.decode(String.self, forKey: .identifier)
        try self.storage = container.decode(ValueStorage.self, forKey: .storage)
        try self.initialization = container.decodeExpressionIfPresent(forKey: .initialization)

        super.init()

        initialization?.parent = self
    }
    
    public override func copy() -> StatementVariableDeclaration {
        return .init(
            identifier: identifier,
            storage: storage,
            initialization: initialization?.copy()
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(storage, forKey: .storage)
        try container.encodeExpressionIfPresent(initialization, forKey: .initialization)
    }

    public static func == (lhs: StatementVariableDeclaration, rhs: StatementVariableDeclaration) -> Bool {
        lhs === rhs || (lhs.identifier == rhs.identifier && lhs.storage == rhs.storage && lhs.initialization == rhs.initialization)
    }
    
    private enum CodingKeys: String, CodingKey {
        case identifier
        case storage
        case initialization
    }
}
