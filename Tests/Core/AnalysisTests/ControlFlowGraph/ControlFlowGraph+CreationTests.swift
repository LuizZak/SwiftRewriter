import XCTest
import SwiftAST
import SwiftCFG
import TestCommons
import WriterTargetOutput
import Intentions

@testable import Analysis

class ControlFlowGraph_CreationTests: XCTestCase {
    override func setUp() {
        // recordMode = true
    }

    override class func tearDown() {
        super.tearDown()

        do {
            try updateAllRecordedGraphviz()
        } catch {
            print("Error updating test list: \(error)")
        }
    }

    override func tearDownWithError() throws {
        try throwErrorIfInGraphvizRecordMode()

        try super.tearDownWithError()
    }

    func testCreateFromFunctionBody() {
        let stmt: CompoundStatement = [
            .expression(.identifier("a")),
        ]
        let body = FunctionBodyIntention(body: stmt)

        let result = ControlFlowGraph.forFunctionBody(body, keepUnresolvedJumps: false)

        let graph = result.graph
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{exp}"]
                    n4 [label="a"]
                    n5 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """,
            syntaxNode: stmt
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testCreateFromFunctionBody_keepUnresolvedJumps() {
        let stmt: CompoundStatement = [
            .if(.identifier("a"), body: [
                .throw(.identifier("Error")),
            ]),
            .return(.identifier("b")),
        ]
        let body = FunctionBodyIntention(body: stmt)

        let result = ControlFlowGraph
            .forFunctionBody(
                body,
                keepUnresolvedJumps: true
            )

        let graph = result.graph
        sanitize(graph, expectsUnreachable: true, expectsNonExitEndNodes: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="a"]
                    n4 [label="{if}"]
                    n5 [label="b"]
                    n6 [label="{compound}"]
                    n7 [label="Error"]
                    n8 [label="{return b}"]
                    n9 [label="{marker}"]
                    n10 [label="{throw Error}"]
                    n11 [label="{marker}"]
                    n12 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n6 -> n7
                    n5 -> n8
                    n8 -> n9
                    n7 -> n10
                    n10 -> n11
                }
                """,
            syntaxNode: stmt
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 0)
        XCTAssertEqual(result.unresolvedJumps.count, 2)
        XCTAssertEqual(result.unresolvedJumps(ofKind: .throw).count, 1)
        XCTAssertEqual(result.unresolvedJumps(ofKind: .return).count, 1)
    }
}
