import SwiftAST

private var _codeScopeKey = "_codeScopeKey"

/// Protocol for statements that feature code scoping
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
}

/// A code scope that stores definitions
public protocol CodeScope {
    func definition(named name: String) -> CodeDefinition?
    func recordDefinition(_ definition: CodeDefinition)
}

class DefaultCodeScope: CodeScope {
    internal var definitions: [CodeDefinition] = []
    
    public func definition(named name: String) -> CodeDefinition? {
        return definitions.first { $0.name == name }
    }
    
    public func recordDefinition(_ definition: CodeDefinition) {
        definitions.append(definition)
    }
}

public struct CodeDefinition {
    public var name: String
    public var type: SwiftType
    
    public init(name: String, type: SwiftType) {
        self.name = name
        self.type = type
    }
}
