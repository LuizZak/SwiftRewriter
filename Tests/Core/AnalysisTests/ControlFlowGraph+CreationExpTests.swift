import SwiftAST
import TestCommons
import WriterTargetOutput
import XCTest

@testable import Analysis

class ControlFlowGraph_CreationExpTests: XCTestCase {
    func testExpression_arrayLiteral() {
        let stmt: CompoundStatement = [
            .expression(
                .arrayLiteral([
                    .identifier("a"),
                    .identifier("b"),
                    .identifier("c"),
                ])
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="[a, b, c]"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="c"]
                    n6 [label="exit"]
                    n1 -> n3
                    n2 -> n6
                    n3 -> n4
                    n4 -> n5
                    n5 -> n2
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 6)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_assignment() {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("a").assignment(op: .assign, rhs: .identifier("b"))
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="[a, b, c]"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="c"]
                    n6 [label="exit"]
                    n1 -> n3
                    n2 -> n6
                    n3 -> n4
                    n4 -> n5
                    n5 -> n2
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_shortCircuit_andOperand() {
        let stmt: CompoundStatement = [
            .expression(.identifier("a").binary(op: .and, rhs: .identifier("b"))),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3 [label="&&"]
                    n2 -> n4
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_shortCircuit_orOperand() {
        let stmt: CompoundStatement = [
            .expression(.identifier("a").binary(op: .or, rhs: .identifier("b"))),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3 [label="||"]
                    n2 -> n4
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_shortCircuit_nullCoalesceOperand() {
        let stmt: CompoundStatement = [
            .expression(.identifier("a").binary(op: .nullCoalesce, rhs: .identifier("b"))),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3 [label="??"]
                    n2 -> n4
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testShortCircuitNestedExpression() {
        let stmt: CompoundStatement = [
            .expression(.arrayLiteral([
                .identifier("a").binary(op: .and, rhs: .identifier("b")),
                .identifier("c"),
            ])),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3 [label="&&"]
                    n2 -> n4
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_ternaryExpression() {
        let stmt: CompoundStatement = [
            .expression(
                .ternary(
                    .identifier("a"),
                    true: .identifier("b"),
                    false: .identifier("c")
                )
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="c"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3 [label="true"]
                    n2 -> n4 [label="false"]
                    n3 -> n5
                    n4 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testThing() {
        var counter: Int = 0

        func maybe() -> Bool {
            return false
        }

        func sideEffect(label: String, result: Bool = true) -> Bool {
            print("\(label) \(counter)")
            counter += 1
            return result
        }

        let result: [Bool] = [
            sideEffect(label: "a", result: false) && sideEffect(label: "b"),
            sideEffect(label: "c"),
        ]

        print(result)
    }
}
