import SwiftAST
import KnownType

/// A code scope that stores definitions gathered during function body analysis.
/// Is used only during statement rewriting phase.
public protocol CodeScope: DefinitionsSource {
    /// Records a definition on this code scope, optionally specifying whether
    /// any conflicting definitions within this scope should be overwritten.
    func recordDefinition(_ definition: CodeDefinition, overwrite: Bool)

    /// Records a list of definitions on this code scope, optionally specifying
    /// whether any conflicting definitions within this scope should be overwritten.
    func recordDefinitions(_ definitions: [CodeDefinition], overwrite: Bool)

    /// Removes all local definitions within this scope.
    func removeLocalDefinitions()
}

/// A no-op code scope to return when requesting code scope for statements that
/// are not contained within a valid compound statement.
class EmptyCodeScope: CodeScope {
    func firstDefinition(named name: String) -> CodeDefinition? {
        nil
    }

    func firstDefinition(where predicate: (CodeDefinition) -> Bool) -> CodeDefinition? {
        nil
    }

    func functionDefinitions(matching identifier: FunctionIdentifier) -> [CodeDefinition] {
        []
    }

    func functionDefinitions(named name: String) -> [CodeDefinition] {
        []
    }

    func functionDefinitions(where predicate: (CodeDefinition) -> Bool) -> [CodeDefinition] {
        []
    }

    func localDefinitions() -> [CodeDefinition] {
        []
    }

    func recordDefinition(_ definition: CodeDefinition, overwrite: Bool) {

    }

    func recordDefinitions(_ definitions: [CodeDefinition], overwrite: Bool) {

    }

    func removeLocalDefinitions() {

    }
}
