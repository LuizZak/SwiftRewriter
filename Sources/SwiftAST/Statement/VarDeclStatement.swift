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
        return decl.compactMap { $0.initialization }
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
        return VariableDeclarationsStatement(decl: decl.map { $0.copy() }).copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitVariableDeclarations(self)
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
    public var asVariableDeclaration: VariableDeclarationsStatement? {
        return cast()
    }
}

/// A variable declaration statement
public struct StatementVariableDeclaration: Codable, Equatable {
    public var identifier: String
    public var type: SwiftType
    public var ownership: Ownership
    public var isConstant: Bool
    public var initialization: Expression?
    
    public init(identifier: String,
                type: SwiftType,
                ownership: Ownership = .strong,
                isConstant: Bool = false,
                initialization: Expression? = nil) {
        
        self.identifier = identifier
        self.type = type
        self.ownership = ownership
        self.isConstant = isConstant
        self.initialization = initialization
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        try self.identifier = container.decode(String.self, forKey: .identifier)
        try self.type = container.decode(SwiftType.self, forKey: .type)
        try self.ownership = container.decode(Ownership.self, forKey: .ownership)
        try self.isConstant = container.decode(Bool.self, forKey: .isConstant)
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
        try container.encode(type, forKey: .type)
        try container.encode(ownership, forKey: .ownership)
        try container.encode(isConstant, forKey: .isConstant)
        try container.encodeExpressionIfPresent(initialization, forKey: .initialization)
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case identifier
        case type
        case ownership
        case isConstant
        case initialization
    }
}
