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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="c"]
                    n6 [label="[a, b, c]"]
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="a = b"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_assignment_optionalShortCircuiting() {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("a").optional().dot("b").assignment(op: .assign, rhs: .identifier("c"))
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="a?.b"]
                    n5 [label="c"]
                    n6 [label="a?.b = c"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n7
                    n5 -> n6
                    n6 -> n7
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_assignment_optionalShortCircuiting_rightSide() {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("a").optional().dot("b").assignment(op: .assign, rhs: .identifier("c").optional().dot("d").optional().dot("e"))
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="a?.b"]
                    n5 [label="c"]
                    n6 [label="c?.d"]
                    n7 [label="c?.d?.e"]
                    n8 [label="a?.b = c?.d?.e"]
                    n9 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n9
                    n5 -> n6
                    n6 -> n7
                    n6 -> n8
                    n7 -> n8
                    n8 -> n9
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_blockLiteral() {
        let stmt: CompoundStatement = [
            .expression(
                .block(body: [])
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="{ () -> Void in < body > }"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_cast() {
        let stmt: CompoundStatement = [
            .expression(
                .cast(.identifier("a"), type: .int)
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="a as? Int"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_cast_shortCircuit() {
        let stmt: CompoundStatement = [
            .expression(
                .cast(.identifier("a").binary(op: .nullCoalesce, rhs: .identifier("b")), type: .int)
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="a ?? b"]
                    n6 [label="a ?? b as? Int"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
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

    func testExpression_constant() {
        let stmt: CompoundStatement = [
            .expression(
                .constant(0)
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="0"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_dictionaryLiteral() {
        let stmt: CompoundStatement = [
            .expression(
                .dictionaryLiteral([
                    .identifier("a"): .identifier("b"),
                    .identifier("c"): .identifier("d"),
                    .identifier("e"): .identifier("f"),
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="c"]
                    n6 [label="d"]
                    n7 [label="e"]
                    n8 [label="f"]
                    n9 [label="[a: b, c: d, e: f]"]
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
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_identifier() {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("a")
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_parens() {
        let stmt: CompoundStatement = [
            .expression(
                .parens(.identifier("a").call())
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="a()"]
                    n5 [label="(a())"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_parens_shortCircuit() {
        let stmt: CompoundStatement = [
            .expression(
                .parens(.identifier("a").optional().call().optional().dot("b"))
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="a?()"]
                    n5 [label="a?()?.b"]
                    n6 [label="(a?()?.b)"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
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

    func testExpression_postfix_member() {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("a").dot("b")
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="a.b"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_postfix_call_noArguments() {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("a").call()
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="a()"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_postfix_call_withArguments() {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("a").call([.identifier("b"), .identifier("c")])
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="c"]
                    n6 [label="a(b, c)"]
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

    func testExpression_postfix_call_withArguments_shortCircuit() {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("a").call([.identifier("b"), .identifier("c").binary(op: .nullCoalesce, rhs: .constant(0)), .identifier("d")])
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="c"]
                    n6 [label="0"]
                    n7 [label="c ?? 0"]
                    n8 [label="d"]
                    n9 [label="a(b, c ?? 0, d)"]
                    n10 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_postfix_subscript() {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("a").sub(.constant(0))
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="0"]
                    n5 [label="a[0]"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_postfix_subscript_shortCircuit() {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("a").sub(.identifier("b").binary(op: .nullCoalesce, rhs: .constant(0)))
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="0"]
                    n6 [label="b ?? 0"]
                    n7 [label="a[b ?? 0]"]
                    n8 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
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

    func testExpression_postfix_optional() {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("a").optional().dot("b").optional().sub(.constant(0)).optional().call()
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="a?.b"]
                    n5 [label="0"]
                    n6 [label="a?.b?[0]"]
                    n7 [label="a?.b?[0]?()"]
                    n8 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n8
                    n5 -> n6
                    n6 -> n7
                    n6 -> n8
                    n7 -> n8
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
    }

    func testExpression_prefix() {
        let stmt: CompoundStatement = [
            .expression(
                .prefix(op: .subtract, .identifier("a"))
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="-a"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_prefix_shortCircuit() {
        let stmt: CompoundStatement = [
            .expression(
                .prefix(op: .subtract, .identifier("a").binary(op: .nullCoalesce, rhs: .identifier("b")))
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="a ?? b"]
                    n6 [label="-(a ?? b)"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
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

    func testExpression_selector() {
        let stmt: CompoundStatement = [
            .expression(
                .selector(getter: "a")
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="#selector(getter: a)"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_sizeOf_expression() {
        let stmt: CompoundStatement = [
            .expression(
                .sizeof(.identifier("a"))
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="MemoryLayout.size(ofValue: a)"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_sizeOf_expression_shortCircuit() {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("print").call([.sizeof(.identifier("a").binary(op: .nullCoalesce, rhs: .constant(0)))])
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="print"]
                    n4 [label="a"]
                    n5 [label="0"]
                    n6 [label="a ?? 0"]
                    n7 [label="MemoryLayout.size(ofValue: a ?? 0)"]
                    n8 [label="print(MemoryLayout.size(ofValue: a ?? 0))"]
                    n9 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_sizeOf_type() {
        let stmt: CompoundStatement = [
            .expression(
                .sizeof(type: "A")
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="MemoryLayout<A>.size"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="a ? b : c"]
                    n5 [label="b"]
                    n6 [label="c"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n7
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_ternaryExpression_shortCircuit() {
        let stmt: CompoundStatement = [
            .expression(
                .ternary(
                    .identifier("a"),
                    true: .identifier("b").binary(op: .nullCoalesce, rhs: .identifier("c")),
                    false: .identifier("d")
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="a ? b ?? c : d"]
                    n5 [label="b"]
                    n6 [label="d"]
                    n7 [label="c"]
                    n8 [label="b ?? c"]
                    n9 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n5 -> n8
                    n6 -> n9
                    n7 -> n8
                    n8 -> n9
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_try() {
        let stmt: CompoundStatement = [
            .expression(
                .try(.identifier("a"))
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="try a"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_try_optional() {
        let stmt: CompoundStatement = [
            .expression(
                .try(.identifier("a"), mode: .optional)
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="try? a"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_try_forced() {
        let stmt: CompoundStatement = [
            .expression(
                .try(.identifier("a"), mode: .forced)
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="try! a"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_try_errorFlow() {
        let stmt: CompoundStatement = [
            .do([
                .expression(
                    .try(.identifier("a"))
                ),
                .expression(.identifier("postTry")),
            ]).catch([
                .expression(.identifier("errorHandler")),
            ]),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{do}"]
                    n3 [label="{exp}"]
                    n4 [label="a"]
                    n5 [label="try a"]
                    n6 [label="{catch}"]
                    n7 [label="{exp}"]
                    n8 [label="{exp}"]
                    n9 [label="postTry"]
                    n10 [label="errorHandler"]
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
                    n10 -> n11
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_try_optional_noErrorFlow() {
        let stmt: CompoundStatement = [
            .do([
                .expression(
                    .try(.identifier("a"), mode: .optional)
                ),
                .expression(.identifier("postTry")),
            ]).catch([
                .expression(.identifier("errorHandler")),
            ]),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{do}"]
                    n3 [label="{exp}"]
                    n4 [label="a"]
                    n5 [label="try? a"]
                    n6 [label="{exp}"]
                    n7 [label="postTry"]
                    n8 [label="{catch}"]
                    n9 [label="{exp}"]
                    n10 [label="errorHandler"]
                    n11 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n11
                    n8 -> n9
                    n9 -> n10
                    n10 -> n11
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_try_shortCircuit() {
        let stmt: CompoundStatement = [
            .expression(
                .identifier("a").call([
                    .try(.identifier("b").binary(op: .nullCoalesce, rhs: .identifier("c")))
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="c"]
                    n6 [label="b ?? c"]
                    n7 [label="try b ?? c"]
                    n8 [label="a(try b ?? c)"]
                    n9 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n7 -> n9
                    n8 -> n9
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_tuple() {
        let stmt: CompoundStatement = [
            .expression(
                .tuple([
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="c"]
                    n6 [label="(a, b, c)"]
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

    func testExpression_tuple_shortCircuit() {
        let stmt: CompoundStatement = [
            .expression(
                .tuple([
                    .identifier("a").binary(op: .nullCoalesce, rhs: .identifier("b")),
                    .identifier("c"),
                    .identifier("d").binary(op: .and, rhs: .identifier("e")),
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="a ?? b"]
                    n6 [label="c"]
                    n7 [label="d"]
                    n8 [label="e"]
                    n9 [label="d && e"]
                    n10 [label="(a ?? b, c, d && e)"]
                    n11 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n7 -> n9
                    n8 -> n9
                    n9 -> n10
                    n10 -> n11
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_typeCheck() {
        let stmt: CompoundStatement = [
            .expression(
                .typeCheck(.identifier("a"), type: .int)
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="a is Int"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_typeCheck_shortCircuit() {
        let stmt: CompoundStatement = [
            .expression(
                .typeCheck(.identifier("a").binary(op: .nullCoalesce, rhs: .identifier("b")), type: .int)
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="a ?? b"]
                    n6 [label="a ?? b is Int"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
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

    func testExpression_unary() {
        let stmt: CompoundStatement = [
            .expression(
                .unary(op: .subtract, .identifier("a"))
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="-a"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_unary_shortCircuit() {
        let stmt: CompoundStatement = [
            .expression(
                .unary(op: .subtract, .identifier("a").binary(op: .nullCoalesce, rhs: .identifier("b")))
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="a ?? b"]
                    n6 [label="-(a ?? b)"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
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

    func testExpression_unknown() {
        let stmt: CompoundStatement = [
            .expression(
                .unknown(.init(context: "a"))
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func tesShortCircuit_andOperand() {
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="a && b"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testShortCircuit_orOperand() {
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="a || b"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testShortCircuit_nullCoalesceOperand() {
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="a ?? b"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testShortCircuit_nestedExpression() {
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="a && b"]
                    n6 [label="c"]
                    n7 [label="[a && b, c]"]
                    n8 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
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

    #if false // For testing behavior of Swift expression control flow

    func testThing() {
        func returnsState(line: UInt = #line, column: UInt = #column) -> State {
            print(#function, line, column)
            return State()
        }

        func returnsMaybeState(_ value: State?, line: UInt = #line, column: UInt = #column) -> State? {
            print(#function, line, column)
            return value
        }

        func sideEffect(label: String, result: Bool = true, line: UInt = #line, column: UInt = #column) -> Int {
            print(#function, line, column)
            return 0
        }

        print(returnsState().state[returnsState()].field)
    }

    private class State: Hashable {
        var field: Int = 0
        var state: State {
            return self
        }

        subscript(value: State) -> State {
            return self
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
        }

        static func == (lhs: State, rhs: State) -> Bool {
            lhs === rhs
        }
    }

    #endif
}