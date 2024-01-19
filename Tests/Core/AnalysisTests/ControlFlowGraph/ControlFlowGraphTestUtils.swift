import SwiftAST
import WriterTargetOutput
import SwiftSyntax
import SwiftParser
import XCTest
import TestCommons
import GraphvizLib

@testable import Analysis

internal func sanitize(
    _ graph: ControlFlowGraph,
    expectsUnreachable: Bool = false,
    expectsNonExitEndNodes: Bool = false,
    file: StaticString = #filePath,
    line: UInt = #line
) {

    if !graph.nodes.contains(where: { $0 === graph.entry }) {
        XCTFail(
            """
            Graph's entry node is not currently present in nodes array
            """,
            file: file,
            line: line
        )
    }
    if !graph.nodes.contains(where: { $0 === graph.exit }) {
        XCTFail(
            """
            Graph's exit node is not currently present in nodes array
            """,
            file: file,
            line: line
        )
    }

    if graph.entry.node !== graph.exit.node {
        XCTFail(
            """
            Graph's entry and exit nodes must point to the same AST node
            """,
            file: file,
            line: line
        )
    }

    for edge in graph.edges {
        if !graph.containsNode(edge.start) {
            XCTFail(
                """
                Edge contains reference for node that is not present in graph: \(edge.start.node)
                """,
                file: file,
                line: line
            )
        }
        if !graph.containsNode(edge.end) {
            XCTFail(
                """
                Edge contains reference for node that is not present in graph: \(edge.end.node)
                """,
                file: file,
                line: line
            )
        }
    }

    for node in graph.nodes {
        if node is ControlFlowSubgraphNode {
            XCTFail(
                """
                Found non-expanded subgraph node: \(node.node)
                """,
                file: file,
                line: line
            )
        }

        if graph.allEdges(for: node).isEmpty && node !== graph.entry && node !== graph.exit {
            XCTFail(
                """
                Found a free node with no edges or connections: \(node.node)
                """,
                file: file,
                line: line
            )

            continue
        }

        if !expectsUnreachable && node !== graph.entry && graph.edges(towards: node).isEmpty {
            XCTFail(
                """
                Found non-entry node that has no connections towards it: \(node.node)
                """,
                file: file,
                line: line
            )
        }

        if !expectsNonExitEndNodes && node !== graph.exit && graph.edges(from: node).isEmpty {
            XCTFail(
                """
                Found non-exit node that has no connections from it: \(node.node)
                """,
                file: file,
                line: line
            )
        }
    }
}
