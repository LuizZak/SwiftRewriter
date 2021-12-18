public class VariableDeclarationsStatement: Statement {
    public var decl: [StatementVariableDeclaration] {
        didSet {
            oldValue.forEach {
                $0.initialization?.parent = nil
            }
            decl.forEach {
                $0.initialization?.parent = self
            }
        }
    }
    
    public override var children: [SyntaxNode] {
        decl.compactMap(\.initialization)
    }
    
    public init(decl: [StatementVariableDeclaration]) {
        self.decl = decl
        
        super.init()
        
        decl.forEach {
            $0.initialization?.parent = self
        }
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        decl = try container.decode([StatementVariableDeclaration].self, forKey: .decl)
        
        try super.init(from: container.superDecoder())
        
        decl.forEach {
            $0.initialization?.parent = self
        }
    }
    
    @inlinable
    public override func copy() -> VariableDeclarationsStatement {
        VariableDeclarationsStatement(decl: decl.map { $0.copy() }).copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitVariableDeclarations(self)
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
    @inlinable
    var asVariableDeclaration: VariableDeclarationsStatement? {
        cast()
    }
}

/// A variable declaration statement
public struct StatementVariableDeclaration: Codable, Equatable {
    public var identifier: String
    public var storage: ValueStorage
    public var initialization: Expression?
    
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
    
    public init(identifier: String,
                storage: ValueStorage,
                initialization: Expression? = nil) {
        
        self.identifier = identifier
        self.storage = storage
        self.initialization = initialization
    }
    
    public init(identifier: String,
                type: SwiftType,
                ownership: Ownership = .strong,
                isConstant: Bool = false,
                initialization: Expression? = nil) {
        
        self.init(identifier: identifier,
                  storage: ValueStorage(type: type,
                                        ownership: ownership,
                                        isConstant: isConstant),
                  initialization: initialization)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.identifier = container.decode(String.self, forKey: .identifier)
        try self.storage = container.decode(ValueStorage.self, forKey: .storage)
        try self.initialization = container.decodeExpressionIfPresent(forKey: .initialization)
    }
    
    public func copy() -> StatementVariableDeclaration {
        var new = self
        new.initialization = self.initialization?.copy()
        return new
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(storage, forKey: .storage)
        try container.encodeExpressionIfPresent(initialization, forKey: .initialization)
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case identifier
        case storage
        case initialization
    }
}
