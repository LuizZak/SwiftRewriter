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
    
    public override func copy() -> VariableDeclarationsStatement {
        return VariableDeclarationsStatement(decl: decl.map { $0.copy() }).copyMetadata(from: self)
    }
    
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
}
public extension Statement {
    public var asVariableDeclaration: VariableDeclarationsStatement? {
        return cast()
    }
}

/// A variable declaration statement
public struct StatementVariableDeclaration: Equatable {
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
    
    public func copy() -> StatementVariableDeclaration {
        var new = self
        new.initialization = self.initialization?.copy()
        return new
    }
}
