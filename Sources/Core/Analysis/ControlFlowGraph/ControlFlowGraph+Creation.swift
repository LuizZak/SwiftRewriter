/// This file contains the entry points to the implementations of the bottom-to-top
/// control flow graph creation algorithm. Most of the work is done by creating
/// smaller subgraph segments with loose connections representing branching paths,
/// which are eventually resolved to proper edges when subgraph segments are merged.
///
/// Special handling is performed for defer statements to ensure the proper
/// semantics of 'unwinding' are preserved across all different types of branching
/// events in a CFG, like early returns and loop continuation and breaking.

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
