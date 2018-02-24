import SwiftAST

private let _codeScopeKey = "_codeScopeKey"
private let _identifierDefinitionKey = "_identifierDefinitionKey"

/// Protocol for statements that feature code scoping.
public protocol CodeScopeStatement: CodeScope {
    var definitions: CodeScope { get }
}

public extension CodeScopeStatement where Self: Statement {
    public var definitions: CodeScope {
        if let scope = metadata[_codeScopeKey] as? CodeScope {
            return scope
        }
        let scope = DefaultCodeScope()
        metadata[_codeScopeKey] = scope
        
        return scope
    }
    
    public func definition(named name: String) -> CodeDefinition? {
        if let def = definitions.definition(named: name) {
            return def
        }
        
        return nearestScope.definition(named: name)
    }
    
    public func recordDefinition(_ definition: CodeDefinition) {
        definitions.recordDefinition(definition)
    }
    
    public func removeAllDefinitions() {
        definitions.removeAllDefinitions()
    }
}

public extension SyntaxNode {
    /// Finds the nearest definition scope in the hierarchy chain for this syntax
    /// node.
    public var nearestScope: CodeScope {
        var parent: SyntaxNode? = self
        while let p = parent {
            parent = p.parent
            
            if let compound = p as? CompoundStatement {
                return compound.definitions
            }
        }
        
        return EmptyCodeScope()
    }
}

extension CompoundStatement: CodeScopeStatement { }

public protocol CodeScopeStack {
    func pushScope(_ context: Context)
    func popScope()
}

/// A no-op code scope to return when requesting code scope for statements that
/// are not contained within a valid compound statement.
class EmptyCodeScope: CodeScope {
    func definition(named name: String) -> CodeDefinition? {
        return nil
    }
    func recordDefinition(_ definition: CodeDefinition) {
        
    }
    func removeAllDefinitions() {
        
    }
}

class DefaultCodeScopeStack: CodeScope {
    var scopes: [DefaultCodeScope] = []
    
    func pushScope(_ context: Context) {
        scopes.append(DefaultCodeScope())
    }
    
    func popScope() {
        _=scopes.popLast()
    }
    
    func definition(named name: String) -> CodeDefinition? {
        for scope in scopes.reversed() {
            if let def = scope.definition(named: name) {
                return def
            }
        }
        
        return nil
    }
    
    func recordDefinition(_ definition: CodeDefinition) {
        scopes.last?.recordDefinition(definition)
    }
    
    func removeAllDefinitions() {
        for scope in scopes {
            scope.removeAllDefinitions()
        }
    }
}

/// A code scope that stores definitions gathered during function body analysis.
/// Is used only during statement rewriting phase.
public protocol CodeScope {
    func definition(named name: String) -> CodeDefinition?
    func recordDefinition(_ definition: CodeDefinition)
    func removeAllDefinitions()
}

class DefaultCodeScope: CodeScope {
    internal var definitions: [CodeDefinition] = []
    
    public func definition(named name: String) -> CodeDefinition? {
        return definitions.first { $0.name == name }
    }
    
    public func recordDefinition(_ definition: CodeDefinition) {
        definitions.append(definition)
    }
    
    func removeAllDefinitions() {
        definitions.removeAll()
    }
}

/// Specifies a definition for a local variable of a function.
public class CodeDefinition {
    public var name: String
    public var storage: ValueStorage
    
    public var type: SwiftType {
        return storage.type
    }
    
    public var isConstant: Bool {
        return storage.isConstant
    }
    
    public var ownership: Ownership {
        return storage.ownership
    }
    
    public init(name: String, type: SwiftType) {
        self.name = name
        self.storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
    }
    
    public init(name: String, storage: ValueStorage) {
        self.name = name
        self.storage = storage
    }
}

public extension IdentifierExpression {
    /// Gets the definition this identifier references.
    /// To gather definitions to identifiers, use a `ExpressionTypeResolver` on
    /// the syntax tree this identifier is contained in.
    public var definition: Definition? {
        get {
            return metadata[_identifierDefinitionKey] as? Definition
        }
        set {
            metadata[_identifierDefinitionKey] = newValue
        }
    }
    
    public enum Definition {
        case local(CodeDefinition)
        case type(named: String)
        
        public var local: CodeDefinition? {
            switch self {
            case .local(let def):
                return def
            case .type:
                return nil
            }
        }
        
        public var typeName: String? {
            switch self {
            case .local:
                return nil
            case .type(let name):
                return name
            }
        }
    }
}
