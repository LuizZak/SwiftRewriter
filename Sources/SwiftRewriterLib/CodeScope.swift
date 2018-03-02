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
    
    public func allDefinitions() -> [CodeDefinition] {
        return definitions.allDefinitions()
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
    func allDefinitions() -> [CodeDefinition] {
        return []
    }
    func recordDefinition(_ definition: CodeDefinition) {
        
    }
    func removeAllDefinitions() {
        
    }
}

/// An object that can provide definitions for a type resolver
public protocol DefinitionsSource {
    func definition(named name: String) -> CodeDefinition?
    
    /// Returns all definitions from this local scope only
    func allDefinitions() -> [CodeDefinition]
}

/// A code scope that stores definitions gathered during function body analysis.
/// Is used only during statement rewriting phase.
public protocol CodeScope: DefinitionsSource {
    func recordDefinition(_ definition: CodeDefinition)
    func removeAllDefinitions()
}

/// A default implementation of a code scope
public class DefaultCodeScope: CodeScope {
    internal var definitions: [CodeDefinition]
    
    public init(definitions: [CodeDefinition] = []) {
        self.definitions = definitions
    }
    
    public func definition(named name: String) -> CodeDefinition? {
        return definitions.first { $0.name == name }
    }
    
    public func allDefinitions() -> [CodeDefinition] {
        return definitions
    }
    
    public func recordDefinition(_ definition: CodeDefinition) {
        definitions.append(definition)
    }
    
    public func removeAllDefinitions() {
        definitions.removeAll()
    }
}

/// Specifies a definition for a local variable of a function.
public class CodeDefinition {
    public var name: String
    public var storage: ValueStorage
    
    /// An optionally associated intention value
    public var intention: Intention?
    
    public var type: SwiftType {
        return storage.type
    }
    
    public var isConstant: Bool {
        return storage.isConstant
    }
    
    public var ownership: Ownership {
        return storage.ownership
    }
    
    public init(name: String, type: SwiftType, intention: Intention?) {
        self.name = name
        self.storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        self.intention = intention
    }
    
    public init(name: String, storage: ValueStorage, intention: Intention?) {
        self.name = name
        self.storage = storage
        self.intention = intention
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
        case global(CodeDefinition)
        case local(CodeDefinition)
        case member(type: KnownType, member: KnownMember)
        case type(named: String)
        
        public var global: CodeDefinition? {
            switch self {
            case .global(let def):
                return def
            case .local, .type, .member:
                return nil
            }
        }
        
        public var local: CodeDefinition? {
            switch self {
            case .local(let def):
                return def
            case .type, .member, .global:
                return nil
            }
        }
        
        public var typeName: String? {
            switch self {
            case .type(let name):
                return name
            case .local, .member, .global:
                return nil
            }
        }
        
        public var member: (type: KnownType, member: KnownMember)? {
            switch self {
            case let .member(type, member):
                return (type, member)
            case .local, .type, .global:
                return nil
            }
        }
    }
}

public extension MemberPostfix {
    /// Gets the member this member postfix operation references
    public var memberDefinition: KnownMember? {
        get {
            return metadata[_identifierDefinitionKey] as? KnownMember
        }
        set {
            metadata[_identifierDefinitionKey] = newValue
        }
    }
}
