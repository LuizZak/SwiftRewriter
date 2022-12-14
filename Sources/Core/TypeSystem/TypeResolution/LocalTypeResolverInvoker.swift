import SwiftAST
import Intentions

/// A type resolver for resolving types of statement and expressions for a single
/// local context, like a function definition or global variable's initializer.
public protocol LocalTypeResolverInvoker {
    /// Resolves the type of a single expression, optionally forcing the resolution
    /// to overwrite any existing typing information.
    func resolveType(_ expression: Expression, force: Bool) -> Expression

    /// Resolves the types of a given statement's expressions recursively,
    /// optionally forcing the resolution to overwrite any existing typing
    /// information.
    func resolveTypes(in statement: Statement, force: Bool) -> Statement
}
