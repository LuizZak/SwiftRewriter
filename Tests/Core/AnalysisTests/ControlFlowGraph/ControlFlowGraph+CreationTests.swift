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
                    n7 [label="{end scope of CompoundStatement}"]
                    n8 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
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
                    n4 [label="{defer}"]
                    n5 [label="{exp}"]
                    n6 [label="a"]
                    n7 [label="{end scope of {defer}}"]
                    n8 [label="{end scope of CompoundStatement}"]
                    n9 [label="{exp}"]
                    n10 [label="d"]
                    n11 [label="{defer}"]
                    n12 [label="{exp}"]
                    n13 [label="c"]
                    n14 [label="{end scope of {defer}}"]
                    n15 [label="{end scope of CompoundStatement}"]
                    n16 [label="exit"]
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

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{do}"]
                    n3 [label="{exp}"]
                    n4 [label="a"]
                    n5 [label="b"]
                    n6 [label="{if}"]
                    n7 [label="c"]
                    n8 [label="{end scope of {do}}"]
                    n9 [label="{throw c}"]
                    n10 [label="{end scope of CompoundStatement}"]
                    n11 [label="{end scope of {if}}"]
                    n12 [label="{end scope of {do}}"]
                    n13 [label="{catch}"]
                    n14 [label="{exp}"]
                    n15 [label="d"]
                    n16 [label="{end scope of {catch}}"]
                    n17 [label="{end scope of {if}}"]
                    n18 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n6 -> n8
                    n7 -> n9
                    n8 -> n10
                    n9 -> n11
                    n10 -> n18
                    n11 -> n12
                    n12 -> n13
                    n13 -> n14
                    n14 -> n15
                    n15 -> n16
                    n16 -> n10
                    n17 -> n8
                }
                """
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
                    n2 [label="var preIf: Int"]
                    n3 [label="0"]
                    n4 [label="preIf: Int = 0"]
                    n5 [label="true"]
                    n6 [label="{if}"]
                    n7 [label="var ifBody: Int"]
                    n8 [label="{exp}"]
                    n9 [label="0"]
                    n10 [label="postIf"]
                    n11 [label="ifBody: Int = 0"]
                    n12 [label="{end scope of CompoundStatement}"]
                    n13 [label="{end scope of {if}}"]
                    n14 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n6 -> n8
                    n7 -> n9
                    n8 -> n10
                    n9 -> n11
                    n10 -> n12
                    n11 -> n13
                    n12 -> n14
                    n13 -> n8
                }
                """
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
                    n2 [label="var a: Int"]
                    n3 [label="0"]
                    n4 [label="a: Int = 0"]
                    n5 [label="b"]
                    n6 [label="{for}"]
                    n7 [label="var c: Int"]
                    n8 [label="{exp}"]
                    n9 [label="0"]
                    n10 [label="d"]
                    n11 [label="c: Int = 0"]
                    n12 [label="{end scope of CompoundStatement}"]
                    n13 [label="{end scope of {for}}"]
                    n14 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n6 -> n8
                    n7 -> n9
                    n8 -> n10
                    n9 -> n11
                    n10 -> n12
                    n11 -> n13
                    n12 -> n14
                    n13 -> n6 [color="#aa3333", penwidth=0.5]
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
                    n2 [label="{do}"]
                    n3 [label="Error"]
                    n4 [label="{throw Error}"]
                    n5 [label="{end scope of {do}}"]
                    n6 [label="{catch}"]
                    n7 [label="{exp}"]
                    n8 [label="errorHandler"]
                    n9 [label="2"]
                    n10 [label="errorHandler = 2"]
                    n11 [label="{end scope of {catch}}"]
                    n12 [label="{exp}"]
                    n13 [label="postDo"]
                    n14 [label="{end scope of CompoundStatement}"]
                    n15 [label="exit"]
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
