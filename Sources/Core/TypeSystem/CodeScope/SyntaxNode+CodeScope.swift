import SwiftAST
import KnownType

private let _codeScopeKey = "_codeScopeKey"
private let _identifierDefinitionKey = "_identifierDefinitionKey"
private let _identifierReadOnlyUsageKey = "_identifierReadOnlyUsageKey"

/// Protocol for statements that feature code scoping.
public protocol CodeScopeNode: SyntaxNode, CodeScope {
    var definitions: CodeScope { get }
}

/// Protocol for syntax nodes that can reference code definitions.
public protocol DefinitionReferenceNode: SyntaxNode {
    /// Gets the definition this node references.
    ///
    /// To gather definitions to nodes, use a `ExpressionTypeResolver` on the
    /// syntax tree this node is contained in.
    var definition: CodeDefinition? { get }

    /// Gets a value specifying whether the definition referenced by this node is
    /// being read or written into.
    ///
    /// Result of this property is invalid if `self.definition` is `nil`
    var isReadOnlyUsage: Bool { get }
}

public extension CodeScopeNode {
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

    func functionDefinitions(named name: String) -> [CodeDefinition] {
        let defs =
            nearestScopeThatIsNotSelf?
                .functionDefinitions(named: name)
                    ?? []

        return definitions.functionDefinitions(named: name) + defs
    }

    func localDefinitions() -> [CodeDefinition] {
        definitions.localDefinitions()
    }

    func recordDefinition(_ definition: CodeDefinition, overwrite: Bool) {
        definitions.recordDefinition(definition, overwrite: overwrite)
    }

    func recordDefinitions(_ definitions: [CodeDefinition], overwrite: Bool) {
        self.definitions.recordDefinitions(definitions, overwrite: overwrite)
    }

    func removeLocalDefinitions() {
        definitions.removeLocalDefinitions()
    }
}

extension CodeScopeNodeType {
    /// Attempts to type-cast this node type to `CodeScopeNode`.
    ///
    /// If casting fails, a runtime exception is raised.
    public var codeScope: CodeScope {
        if let scoped = self as? CodeScopeNode {
            return scoped
        }

        fatalError("Node type \(type(of: self)) is not a CodeScopeNode type.")
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
// extension CatchBlock: CodeScopeNode { }
extension SwitchCase: CodeScopeNode { }
extension SwitchDefaultCase: CodeScopeNode { }

extension IdentifierExpression: DefinitionReferenceNode {
    /// Gets the definition this identifier references.
    /// To gather definitions to identifiers, use a `ExpressionTypeResolver` on
    /// the syntax tree this identifier is contained in.
    public var definition: CodeDefinition? {
        get {
            metadata[_identifierDefinitionKey] as? CodeDefinition
        }
        set {
            metadata[_identifierDefinitionKey] = newValue
        }
    }

    public var isReadOnlyUsage: Bool {
        get {
            (metadata[_identifierReadOnlyUsageKey] as? Bool) ?? false
        }
        set {
            metadata[_identifierReadOnlyUsageKey] = newValue
        }
    }

    /// Returns a copy of this `IdentifierExpression` with a given definition
    /// associated with the copy.
    public func settingDefinition(_ definition: CodeDefinition) -> IdentifierExpression {
        let new = copy()
        new.definition = definition
        return new
    }
}

public extension Postfix {
    /// Gets the member this postfix operation references
    var definition: KnownMember? {
        get {
            metadata[_identifierDefinitionKey] as? KnownMember
        }
        set {
            metadata[_identifierDefinitionKey] = newValue
        }
    }
}
