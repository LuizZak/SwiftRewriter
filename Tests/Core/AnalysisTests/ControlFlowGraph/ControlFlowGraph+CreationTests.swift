import SwiftAST
import TestCommons
import WriterTargetOutput
import Intentions
import XCTest

@testable import Analysis

class ControlFlowGraph_CreationTests: XCTestCase {
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

    func testCreateEmpty() {
        let stmt: CompoundStatement = []

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound} (1)"]
                    n3 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                }
                """,
            syntaxNode: stmt
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt, stmt]
        )
    }

    func testGenerateEndScopes_true() {
        let stmt: CompoundStatement = [
            .compound([
                .expression(.identifier("a")),
            ]),
            .expression(.identifier("b")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(
            stmt,
            options: .init(generateEndScopes: true)
        )

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound} (1)"]
                    n3 [label="{compound} (2)"]
                    n4 [label="{exp} (3)"]
                    n5 [label="a (4)"]
                    n6 [label="{end scope of {compound} (5)}"]
                    n7 [label="{exp} (6)"]
                    n8 [label="b (7)"]
                    n9 [label="{end scope of {compound} (8)}"]
                    n10 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                }
                """,
            syntaxNode: stmt
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testGenerateEndScopes_true_defers() {
        let stmt: CompoundStatement = [
            .compound([
                .defer([
                    .expression(.identifier("a")),
                ]),
                .expression(.identifier("b")),
            ]),
            .defer([
                .expression(.identifier("c")),
            ]),
            .expression(.identifier("d")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(
            stmt,
            options: .init(generateEndScopes: true)
        )

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound} (1)"]
                    n3 [label="{compound} (2)"]
                    n4 [label="{exp} (8)"]
                    n5 [label="b (9)"]
                    n6 [label="{defer} (10)"]
                    n7 [label="{compound} (11)"]
                    n8 [label="{exp} (12)"]
                    n9 [label="a (13)"]
                    n10 [label="{end scope of {defer} (14)}"]
                    n11 [label="{end scope of {compound} (15)}"]
                    n12 [label="{exp} (21)"]
                    n13 [label="d (22)"]
                    n14 [label="{defer} (23)"]
                    n15 [label="{compound} (24)"]
                    n16 [label="{exp} (25)"]
                    n17 [label="c (26)"]
                    n18 [label="{end scope of {defer} (27)}"]
                    n19 [label="{end scope of {compound} (28)}"]
                    n20 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n12 -> n13
                    n13 -> n14
                    n14 -> n15
                    n15 -> n16
                    n16 -> n17
                    n17 -> n18
                    n18 -> n19
                    n19 -> n20
                }
                """,
            syntaxNode: stmt
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testGenerateEndScopes_true_errorFlow() {
        let stmt: CompoundStatement = [
            .do([
                .expression(.identifier("a")),
                .if(.identifier("b"), body:[
                    .throw(.identifier("c")),
                ]),
            ]).catch([
                .expression(.identifier("d")),
            ]),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(
            stmt,
            options: .init(generateEndScopes: true)
        )

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound} (1)"]
                    n3 [label="{do} (2)"]
                    n4 [label="{compound} (3)"]
                    n5 [label="{exp} (4)"]
                    n6 [label="a (5)"]
                    n7 [label="b (6)"]
                    n8 [label="{if} (7)"]
                    n9 [label="{compound} (8)"]
                    n10 [label="{end scope of {do} (13)}"]
                    n11 [label="c (9)"]
                    n12 [label="{end scope of {compound} (20)}"]
                    n13 [label="{throw c} (10)"]
                    n14 [label="{end scope of {if} (12)}"]
                    n15 [label="{end scope of {do} (14)}"]
                    n16 [label="{catch} (15)"]
                    n17 [label="{compound} (16)"]
                    n18 [label="{exp} (17)"]
                    n19 [label="d (18)"]
                    n20 [label="{end scope of {catch} (19)}"]
                    n21 [label="{end scope of {if} (11)}"]
                    n22 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n8 -> n10
                    n21 -> n10
                    n9 -> n11
                    n10 -> n12
                    n20 -> n12
                    n11 -> n13
                    n13 -> n14
                    n14 -> n15
                    n15 -> n16
                    n16 -> n17
                    n17 -> n18
                    n18 -> n19
                    n19 -> n20
                    n12 -> n22
                }
                """,
            syntaxNode: stmt
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testGenerateEndScopes_true_ifStatement() {
        let stmt: CompoundStatement = [
            .variableDeclaration(identifier: "preIf", type: .int, initialization: .constant(0)),
            .if(.constant(true), body: [
                .variableDeclaration(identifier: "ifBody", type: .int, initialization: .constant(0)),
            ]),
            .expression(.identifier("postIf")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(
            stmt,
            options: .init(generateEndScopes: true)
        )

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound} (1)"]
                    n3 [label="var preIf: Int (2)"]
                    n4 [label="0 (3)"]
                    n5 [label="preIf: Int = 0 (4)"]
                    n6 [label="true (5)"]
                    n7 [label="{if} (6)"]
                    n8 [label="{compound} (7)"]
                    n9 [label="{exp} (12)"]
                    n10 [label="var ifBody: Int (8)"]
                    n11 [label="postIf (13)"]
                    n12 [label="0 (9)"]
                    n13 [label="{end scope of {compound} (14)}"]
                    n14 [label="ifBody: Int = 0 (10)"]
                    n15 [label="{end scope of {if} (11)}"]
                    n16 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n7 -> n9
                    n15 -> n9
                    n8 -> n10
                    n9 -> n11
                    n10 -> n12
                    n11 -> n13
                    n12 -> n14
                    n14 -> n15
                    n13 -> n16
                }
                """,
            syntaxNode: stmt
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testGenerateEndScopes_true_forStatement() {
        let stmt: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .int, initialization: .constant(0)),
            .for(.identifier("a"), .identifier("b"), body: [
                .variableDeclaration(identifier: "c", type: .int, initialization: .constant(0)),
            ]),
            .expression(.identifier("d")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(
            stmt,
            options: .init(generateEndScopes: true)
        )

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound} (1)"]
                    n3 [label="var a: Int (2)"]
                    n4 [label="0 (3)"]
                    n5 [label="a: Int = 0 (4)"]
                    n6 [label="b (5)"]
                    n7 [label="{for} (6)"]
                    n8 [label="{compound} (7)"]
                    n9 [label="{exp} (12)"]
                    n10 [label="var c: Int (8)"]
                    n11 [label="d (13)"]
                    n12 [label="0 (9)"]
                    n13 [label="{end scope of {compound} (14)}"]
                    n14 [label="c: Int = 0 (10)"]
                    n15 [label="{end scope of {for} (11)}"]
                    n16 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n15 -> n7 [color="#aa3333", penwidth=0.5]
                    n7 -> n8
                    n7 -> n9
                    n8 -> n10
                    n9 -> n11
                    n10 -> n12
                    n11 -> n13
                    n12 -> n14
                    n14 -> n15
                    n13 -> n16
                }
                """,
            syntaxNode: stmt
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testPruneUnreachable_true() {
        let stmt: CompoundStatement = [
            .expression(.identifier("a")),
            .return(nil),
            .expression(.identifier("b")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(
            stmt,
            options: .init(pruneUnreachable: true)
        )

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (2)"]
                    n4 [label="a (3)"]
                    n5 [label="{return} (4)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """,
            syntaxNode: stmt
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testPruneUnreachable_false() {
        let stmt: CompoundStatement = [
            .expression(.identifier("a")),
            .return(nil),
            .expression(.identifier("b")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(
            stmt,
            options: .init(pruneUnreachable: false)
        )

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (2)"]
                    n4 [label="a (3)"]
                    n5 [label="{return} (4)"]
                    n6 [label="{exp} (5)"]
                    n7 [label="b (6)"]
                    n8 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n6 -> n7
                    n5 -> n8
                    n7 -> n8
                }
                """,
            syntaxNode: stmt
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testGenerateEndScopes_true_pruneUnreachable_true_errorFlow_unconditionalError_dontLeaveDanglingBranches() {
        let stmt: CompoundStatement = [
            .do([
                .throw(.identifier("Error")),
                .expression(.identifier("postError").assignment(op: .assign, rhs: .constant(1))),
            ]).catch([
                .expression(.identifier("errorHandler").assignment(op: .assign, rhs: .constant(2))),
            ]),
            .expression(.identifier("postDo")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(
            stmt,
            options: .init(generateEndScopes: true, pruneUnreachable: true)
        )

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound} (1)"]
                    n3 [label="{do} (2)"]
                    n4 [label="{compound} (3)"]
                    n5 [label="Error (4)"]
                    n6 [label="{throw Error} (5)"]
                    n7 [label="{end scope of {do} (11)}"]
                    n8 [label="{catch} (12)"]
                    n9 [label="{compound} (13)"]
                    n10 [label="{exp} (14)"]
                    n11 [label="errorHandler (15)"]
                    n12 [label="2 (16)"]
                    n13 [label="errorHandler = 2 (17)"]
                    n14 [label="{end scope of {catch} (18)}"]
                    n15 [label="{exp} (19)"]
                    n16 [label="postDo (20)"]
                    n17 [label="{end scope of {compound} (21)}"]
                    n18 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n12 -> n13
                    n13 -> n14
                    n14 -> n15
                    n15 -> n16
                    n16 -> n17
                    n17 -> n18
                }
                """,
            syntaxNode: stmt
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (2)"]
                    n4 [label="a (3)"]
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
                    n2 [label="{compound} (1)"]
                    n3 [label="a (2)"]
                    n4 [label="{if} (3)"]
                    n5 [label="b (7)"]
                    n6 [label="{compound} (4)"]
                    n7 [label="Error (5)"]
                    n8 [label="{return b} (8)"]
                    n9 [label="{marker}"]
                    n10 [label="{throw Error} (6)"]
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
