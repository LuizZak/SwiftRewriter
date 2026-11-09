import SwiftAST
import SwiftCFG
import Intentions
import TypeSystem

public extension ControlFlowGraph {
    /// Returns a `CFGVisitResult` object containing information about a given
    /// function body.
    ///
    /// The resulting CFG can optionally be left with unresolved top-level jumps
    /// so they can be analyzed at a later point.
    static func forFunctionBody(
        _ body: FunctionBodyIntention,
        keepUnresolvedJumps: Bool,
        options: GenerationOptions = .default
    ) -> CFGVisitResult {

        return Self.forFunctionBody(
            body.body,
            keepUnresolvedJumps: keepUnresolvedJumps,
            options: options
        )
    }
}
