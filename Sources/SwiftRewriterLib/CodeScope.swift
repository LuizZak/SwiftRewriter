import SwiftAST

private let _codeScopeKey = "_codeScopeKey"
private let _identifierDefinitionKey = "_identifierDefinitionKey"

/// Protocol for statements that feature code scoping.
public protocol CodeScopeNode: CodeScope {
    var definitions: CodeScope { get }
}

public extension CodeScopeNode where Self: SyntaxNode {
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
        
        return nearestScopeThatIsNotSelf?.definition(named: name)
    }
    
    public func allDefinitions() -> [CodeDefinition] {
        return definitions.allDefinitions()
    }
    
    public func recordDefinition(_ definition: CodeDefinition) {
        definitions.recordDefinition(definition)
    }
    
    public func recordDefinitions(_ definitions: [CodeDefinition]) {
        self.definitions.recordDefinitions(definitions)
    }
    
    public func removeAllDefinitions() {
        definitions.removeAllDefinitions()
    }
}

public extension SyntaxNode {
    /// Finds the nearest definition scope in the hierarchy chain for this syntax
    /// node.
    public var nearestScope: CodeScopeNode? {
        var parent: SyntaxNode? = self
        while let p = parent {
            if let scope = p as? CodeScopeNode {
                return scope
            }
            
            parent = p.parent
        }
        
        return nil
    }
    
    /// Finds the nearest definition scope in the hierarchy chain for this syntax
    /// node which is not `self`
    internal var nearestScopeThatIsNotSelf: CodeScopeNode? {
        var parent: SyntaxNode? = self
        while let p = parent {
            parent = p.parent
            
            if p !== self, let scope = p as? CodeScopeNode {
                return scope
            }
        }
        
        return nil
    }
}

extension CompoundStatement: CodeScopeNode { }
extension BlockLiteralExpression: CodeScopeNode { }

/// A no-op code scope to return when requesting code scope for statements that
/// are not contained within a valid compound statement.
class EmptyCodeScope: CodeScope {
    func definition(named name: String) -> CodeDefinition? {
        return nil
    }
    func allDefinitions() -> [CodeDefinition] {
        return []
    }
    func recordDefinition(_ definition: CodeDefinition) { }
    func recordDefinitions(_ definitions: [CodeDefinition]) { }
    func removeAllDefinitions() { }
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
    func recordDefinitions(_ definitions: [CodeDefinition])
    func removeAllDefinitions()
}

public struct ArrayDefinitionsSource: DefinitionsSource {
    private var definitionsByName: [String: CodeDefinition] = [:]
    private var definitions: [CodeDefinition]
    
    public init(definitions: [CodeDefinition] = []) {
        self.definitions = definitions
        self.definitionsByName = definitions.groupBy({ $0.name }).mapValues({ $0[0] })
    }
    
    public func definition(named name: String) -> CodeDefinition? {
        return definitionsByName[name]
    }
    
    public func allDefinitions() -> [CodeDefinition] {
        return definitions
    }
}

/// A definitions source composed of individual definition sources composed as
/// a single definition source.
public class CompoundDefinitionsSource: DefinitionsSource {
    private var sources: [DefinitionsSource]
    
    public init() {
        sources = []
    }
    
    public init(sources: [DefinitionsSource]) {
        self.sources = sources
    }
    
    public func addSource(_ definitionSource: DefinitionsSource) {
        sources.append(definitionSource)
    }
    
    public func definition(named name: String) -> CodeDefinition? {
        for source in sources {
            if let def = source.definition(named: name) {
                return def
            }
        }
        
        return nil
    }
    
    public func allDefinitions() -> [CodeDefinition] {
        return sources.flatMap { $0.allDefinitions() }
    }
}

/// A default implementation of a code scope
public final class DefaultCodeScope: CodeScope {
    private var definitionsByName: [String: CodeDefinition] = [:]
    internal var definitions: [CodeDefinition]
    
    public init(definitions: [CodeDefinition] = []) {
        self.definitions = definitions
        self.definitionsByName = definitions.groupBy({ $0.name }).mapValues({ $0[0] })
    }
    
    public func definition(named name: String) -> CodeDefinition? {
        return definitionsByName[name]
    }
    
    public func allDefinitions() -> [CodeDefinition] {
        return definitions
    }
    
    public func recordDefinition(_ definition: CodeDefinition) {
        definitions.append(definition)
        definitionsByName[definition.name] = definition
    }
    
    public func recordDefinitions(_ definitions: [CodeDefinition]) {
        self.definitions.append(contentsOf: definitions)
    }
    
    public func removeAllDefinitions() {
        definitions.removeAll()
        definitionsByName.removeAll()
    }
}

/// Specifies a definition for a global function or variable, or a local variable
/// of a function.
public class CodeDefinition {
    public var name: String {
        get {
            return kind.name
        }
        set {
            kind.name = newValue
        }
    }
    
    public var kind: Kind
    
    /// Gets the type signature for this definition.
    /// In case this is a function definition, the type represents the closure
    /// signature of the function.
    public var type: SwiftType {
        switch kind {
        case .variable(_, let storage):
            return storage.type
        case .function(let signature):
            return signature.swiftClosureType
        }
    }
    
    public convenience init(variableNamed name: String, type: SwiftType) {
        self.init(variableNamed: name,
                  storage: ValueStorage(type: type, ownership: .strong, isConstant: false))
    }
    
    public init(variableNamed name: String, storage: ValueStorage) {
        kind = .variable(name: name, storage: storage)
    }
    
    public init(functionSignature: FunctionSignature) {
        kind = .function(signature: functionSignature)
    }
    
    public enum Kind {
        case variable(name: String, storage: ValueStorage)
        case function(signature: FunctionSignature)
        
        public var name: String {
            get {
                switch self {
                case .variable(let name, _):
                    return name
                case .function(let signature):
                    return signature.name
                }
            }
            set {
                switch self {
                case .variable(_, let storage):
                    self = .variable(name: newValue, storage: storage)
                case .function(var signature):
                    signature.name = newValue
                    self = .function(signature: signature)
                }
            }
        }
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
