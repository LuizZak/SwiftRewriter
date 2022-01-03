import SwiftAST
import KnownType

private let _codeScopeKey = "_codeScopeKey"
private let _identifierDefinitionKey = "_identifierDefinitionKey"

/// Protocol for statements that feature code scoping.
public protocol CodeScopeNode: CodeScope {
    var definitions: CodeScope { get }
}

public extension CodeScopeNode where Self: SyntaxNode {
    var definitions: CodeScope {
        if let scope = metadata[_codeScopeKey] as? CodeScope {
            return scope
        }
        let scope = DefaultCodeScope()
        metadata[_codeScopeKey] = scope
        
        return scope
    }
    
    func firstDefinition(named name: String) -> CodeDefinition? {
        if let def = definitions.firstDefinition(named: name) {
            return def
        }
        
        return nearestScopeThatIsNotSelf?.firstDefinition(named: name)
    }
    
    func functionDefinitions(matching identifier: FunctionIdentifier) -> [CodeDefinition] {
        let defs =
            nearestScopeThatIsNotSelf?
                .functionDefinitions(matching: identifier)
                    ?? []
        
        return definitions.functionDefinitions(matching: identifier) + defs
    }
    
    func allDefinitions() -> [CodeDefinition] {
        definitions.allDefinitions()
    }
    
    func recordDefinition(_ definition: CodeDefinition, overwrite: Bool) {
        definitions.recordDefinition(definition, overwrite: overwrite)
    }
    
    func recordDefinitions(_ definitions: [CodeDefinition], overwrite: Bool) {
        self.definitions.recordDefinitions(definitions, overwrite: overwrite)
    }
    
    func removeAllDefinitions() {
        definitions.removeAllDefinitions()
    }
}

public extension SyntaxNode {
    /// Finds the nearest definition scope in the hierarchy chain for this syntax
    /// node.
    var nearestScope: CodeScopeNode? {
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
        parent?.nearestScope
    }
}

extension CompoundStatement: CodeScopeNode { }
extension BlockLiteralExpression: CodeScopeNode { }

public extension IdentifierExpression {
    /// Gets the definition this identifier references.
    /// To gather definitions to identifiers, use a `ExpressionTypeResolver` on
    /// the syntax tree this identifier is contained in.
    var definition: CodeDefinition? {
        get {
            metadata[_identifierDefinitionKey] as? CodeDefinition
        }
        set {
            metadata[_identifierDefinitionKey] = newValue
        }
    }
    
    func settingDefinition(_ definition: CodeDefinition) -> IdentifierExpression {
        let new = copy()
        new.definition = definition
        return new
    }
}

public extension MemberPostfix {
    /// Gets the member this member postfix operation references
    var memberDefinition: KnownMember? {
        get {
            metadata[_identifierDefinitionKey] as? KnownMember
        }
        set {
            metadata[_identifierDefinitionKey] = newValue
        }
    }
}
