import SwiftAST
import TestCommons
import WriterTargetOutput
import XCTest

@testable import Analysis

class ControlFlowGraph_CreationTests: XCTestCase {
    func testCreateEmpty() {
        let stmt: CompoundStatement = []

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="exit"]
                    n1 -> n2
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt]
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="{end scope of CompoundStatement}"]
                    n5 [label="{exp}"]
                    n6 [label="b"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                }
                """
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
                    n2 [label="{exp}"]
                    n3 [label="b"]
                    n4 [label="{exp}"]
                    n5 [label="a"]
                    n6 [label="{end scope of DeferStatement}"]
                    n7 [label="{end scope of CompoundStatement}"]
                    n8 [label="{exp}"]
                    n9 [label="d"]
                    n10 [label="{exp}"]
                    n11 [label="c"]
                    n12 [label="{end scope of DeferStatement}"]
                    n13 [label="exit"]
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
                }
                """
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

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="{if}"]
                    n6 [label="{throw c}"]
                    n7 [label="{end scope of DoStatement}"]
                    n8 [label="{end scope of {if}}"]
                    n9 [label="{end scope of DoStatement}"]
                    n10 [label="{catch}"]
                    n11 [label="{exp}"]
                    n12 [label="d"]
                    n13 [label="{end scope of {catch}}"]
                    n14 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n14
                    n8 -> n9
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n12 -> n13
                    n13 -> n14
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
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
                    n2 [label="0"]
                    n3 [label="preIf: Int = 0"]
                    n4 [label="true"]
                    n5 [label="{if}"]
                    n6 [label="0"]
                    n7 [label="{exp}"]
                    n8 [label="ifBody: Int = 0"]
                    n9 [label="postIf"]
                    n10 [label="{end scope of {if}}"]
                    n11 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n8 -> n10
                    n9 -> n11
                    n10 -> n7
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testGenerateEndScopes_true_forStatement() {
        // TODO: Validate if end-of-scopes for loops should be ended before or
        // TODO: after the loop exits.

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
                    n2 [label="0"]
                    n3 [label="a: Int = 0"]
                    n4 [label="{for}"]
                    n5 [label="0"]
                    n6 [label="{exp}"]
                    n7 [label="c: Int = 0"]
                    n8 [label="d"]
                    n9 [label="{end scope of {for}}"]
                    n10 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n8 -> n10
                    n9 -> n4 [color="#aa3333", penwidth=0.5]
                }
                """
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="{return}"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="{return}"]
                    n5 [label="{exp}"]
                    n6 [label="b"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n7
                    n5 -> n6
                    n6 -> n7
                }
                """
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
                    n2 [label="{throw Error}"]
                    n3 [label="{end scope of DoStatement}"]
                    n4 [label="{catch}"]
                    n5 [label="{exp}"]
                    n6 [label="errorHandler"]
                    n7 [label="2"]
                    n8 [label="errorHandler = 2"]
                    n9 [label="{end scope of {catch}}"]
                    n10 [label="{exp}"]
                    n11 [label="postDo"]
                    n12 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7 [label="="]
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }


    func testCreateNestedEmptyCompoundStatementGetsFlattenedToEmptyGraph() {
        let stmt: CompoundStatement = [
            CompoundStatement(statements: [])
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="exit"]
                    n1 -> n2
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt]
        )
    }
}
