/// This file contains the entry points to the implementations of the bottom-to-top
/// control flow graph creation algorithm. Most of the work is done by creating
/// smaller subgraph segments with loose connections representing branching paths,
/// which are eventually resolved to proper edges when subgraph segments are merged.
///
/// Special handling is performed for defer statements to ensure the proper
/// semantics of 'unwinding' are preserved across all different types of branching
/// events in a CFG, like early returns and loop continuation and breaking.

import SwiftAST
import Intentions
import TypeSystem

public extension ControlFlowGraph {
    /// Options that can be specified during generation of control flow graphs.
    struct GenerationOptions {
        public static var `default`: Self = Self()

        /// If `true`, generates marker nodes between code scope changes.
        public var generateEndScopes: Bool

        /// If `true`, prunes the resulting CFG so that nodes that are unreachable
        /// from the entry node are removed from the graph.
        public var pruneUnreachable: Bool

        public init(
            generateEndScopes: Bool = false,
            pruneUnreachable: Bool = false
        ) {
            self.generateEndScopes = generateEndScopes
            self.pruneUnreachable = pruneUnreachable
        }
    }

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

        var counter = 1
        let visitor = CFGVisitor(options: options, nextId: {
            defer { counter += 1 }
            return counter
        })
        var result = visitor.visitCompound(body.body)

        if !keepUnresolvedJumps {
            result = _finalizeGraph(result, entry: body.body)
        } else {
            result = _adjustEntryExitPoint(in: result, entry: body.body)
        }

        result.graph.markBackEdges()

        if options.pruneUnreachable {
            result.graph.prune()
        }

        return result
    }

    /// Creates a control flow graph for a given compound statement.
    /// The entry and exit points for the resulting graph will be the compound
    /// statement itself, with its inner nodes being the statements contained
    /// within.
    static func forCompoundStatement(
        _ compoundStatement: CompoundStatement,
        options: GenerationOptions = .default
    ) -> ControlFlowGraph {

        var counter = 1
        let visitor = CFGVisitor(options: options, nextId: {
            defer { counter += 1 }
            return counter
        })
        let result = visitor.visitCompound(compoundStatement)

        let graph = _finalizeGraph(result, entry: compoundStatement).graph

        graph.markBackEdges()

        if options.pruneUnreachable {
            graph.prune()
        }

        return graph
    }

    /// Creates a control flow graph for a given expression.
    /// The entry and exit points for the resulting graph will be the expression
    /// itself, with its inner nodes being the sub expressions contained within.
    ///
    /// Block literals are not traversed during CFG creation.
    static func forExpression(
        _ expression: Expression,
        options: GenerationOptions = .default
    ) -> ControlFlowGraph {

        var counter = 1
        let visitor = CFGVisitor(options: options, nextId: {
            defer { counter += 1 }
            return counter
        })
        let result = visitor.visitExpression(expression)

        let graph = _finalizeGraph(result, entry: expression).graph

        graph.markBackEdges()

        if options.pruneUnreachable {
            graph.prune()
        }

        return graph
    }

    private static func _finalizeGraph(
        _ result: CFGVisitResult,
        entry: SyntaxNode
    ) -> CFGVisitResult {

        var result = result
        result.resolveJumpsToExit(kind: .throw)
        result.resolveJumpsToExit(kind: .return)
        result.resolveJumpsToExit(kind: .expressionShortCircuit)

        return _adjustEntryExitPoint(in: result, entry: entry)
    }

    private static func _adjustEntryExitPoint(
        in result: CFGVisitResult,
        entry: SyntaxNode
    ) -> CFGVisitResult {

        let graph = result.graph

        // Adjust entry/exit nodes to be the same node
        if graph.entry.node !== entry {
            let newEntry = ControlFlowGraphEntryNode(node: entry)
            graph.addNode(newEntry)

            graph.redirectExits(for: graph.entry, to: newEntry)
            graph.removeNode(graph.entry)
            graph.entry = newEntry
        }
        if graph.exit.node !== entry {
            let newExit = ControlFlowGraphExitNode(node: entry)
            graph.addNode(newExit)

            graph.redirectEntries(for: graph.exit, to: newExit)
            graph.removeNode(graph.exit)
            graph.exit = newExit
        }

        return result
    }
}
