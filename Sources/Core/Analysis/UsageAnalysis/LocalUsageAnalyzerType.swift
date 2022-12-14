import SwiftAST
import KnownType
import Intentions
import TypeSystem

/// A refined usage analyzer capable of inspecting usages of local variables by
/// name within a method body.
public protocol LocalUsageAnalyzerType: UsageAnalyzer {
    /// Finds all usages of a local with a given name.
    /// Returns all usages of any local named `local`, even those which are shadowed
    /// by other, deeper scoped definitions.
    func findUsagesOf(
        localNamed local: String,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> [DefinitionUsage]
    
    /// Finds all usages of a local with a given name in the scope of a given
    /// `SyntaxNode`.
    /// `syntaxNode` must either be a `Statement` node, or any node which is a
    /// descendent of a `Statement` node, otherwise a fatal error is raised.
    func findUsagesOf(
        localNamed local: String,
        inScopeOf syntaxNode: SyntaxNode,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> [DefinitionUsage]
    
    /// Finds the definition of a local with a given name within the scope of a
    /// given `SyntaxNode`.
    /// `syntaxNode` must either be a `Statement` node, or any node which is a
    /// descendent of a `Statement` node, otherwise a fatal error is raised.
    /// Returns `nil`, in case no definition with the given name could be found
    /// within scope of `syntaxNode`
    func findDefinitionOf(
        localNamed local: String,
        inScopeOf syntaxNode: SyntaxNode,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> LocalCodeDefinition?
}
