import SwiftAST
import TestCommons
import WriterTargetOutput
import XCTest

@testable import Analysis

class ControlFlowGraph_CreationExpTests: XCTestCase {
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

    func testExpression_arrayLiteral() {
        let exp: Expression = .arrayLiteral([
                .identifier("a"),
                .identifier("b"),
                .identifier("c"),
            ])

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="c (3)"]
                    n5 [label="[a, b, c] (4)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_assignment() {
        let exp: Expression =
            .identifier("a").assignment(op: .assign, rhs: .identifier("b"))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="a = b (3)"]
                    n5 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_assignment_optionalShortCircuiting() {
        let exp: Expression =
            .identifier("a").optional().dot("b").assignment(op: .assign, rhs: .identifier("c"))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="a?.b (3)"]
                    n4 [label="c (4)"]
                    n5 [label="a?.b = c (5)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n3 -> n6
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_assignment_optionalShortCircuiting_rightSide() {
        let exp: Expression =
            .identifier("a").optional().dot("b").assignment(op: .assign, rhs: .identifier("c").optional().dot("d").optional().dot("e"))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="a?.b (3)"]
                    n4 [label="c (4)"]
                    n5 [label="c?.d (6)"]
                    n6 [label="c?.d?.e (8)"]
                    n7 [label="a?.b = c?.d?.e (9)"]
                    n8 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n7
                    n3 -> n8
                    n7 -> n8
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_blockLiteral() {
        let exp: Expression =
            .block(body: [])

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{ () -> Void in < body > } (1)"]
                    n3 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_cast() {
        let exp: Expression =
            .cast(.identifier("a"), type: .int)

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="a as? Int (2)"]
                    n4 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_cast_shortCircuit() {
        let exp: Expression =
            .cast(.identifier("a").binary(op: .nullCoalesce, rhs: .identifier("b")), type: .int)

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="a ?? b (4)"]
                    n5 [label="a ?? b as? Int (5)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n2 -> n4
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_constant() {
        let exp: Expression =
            .constant(0)

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="0 (1)"]
                    n3 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_dictionaryLiteral() {
        let exp: Expression =
            .dictionaryLiteral([
                .identifier("a"): .identifier("b"),
                .identifier("c"): .identifier("d"),
                .identifier("e"): .identifier("f"),
            ])

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="c (3)"]
                    n5 [label="d (4)"]
                    n6 [label="e (5)"]
                    n7 [label="f (6)"]
                    n8 [label="[a: b, c: d, e: f] (7)"]
                    n9 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_identifier() {
        let exp: Expression =
            .identifier("a")

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_parens() {
        let exp: Expression =
            .parens(.identifier("a").call())

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="a() (2)"]
                    n4 [label="(a()) (3)"]
                    n5 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_parens_shortCircuit() {
        let exp: Expression =
            .parens(.identifier("a").optional().call().optional().dot("b"))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="a?() (3)"]
                    n4 [label="a?()?.b (5)"]
                    n5 [label="(a?()?.b) (6)"]
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
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_postfix_member() {
        let exp: Expression =
            .identifier("a").dot("b")

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="a.b (2)"]
                    n4 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_postfix_call_noArguments() {
        let exp: Expression =
            .identifier("a").call()

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="a() (2)"]
                    n4 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_postfix_call_withArguments() {
        let exp: Expression =
            .identifier("a").call([.identifier("b"), .identifier("c")])

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="c (3)"]
                    n5 [label="a(b, c) (4)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_postfix_call_withArguments_shortCircuit() {
        let exp: Expression =
            .identifier("a").call([.identifier("b"), .identifier("c").binary(op: .nullCoalesce, rhs: .constant(0)), .identifier("d")])

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="c (3)"]
                    n5 [label="0 (4)"]
                    n6 [label="c ?? 0 (6)"]
                    n7 [label="d (7)"]
                    n8 [label="a(b, c ?? 0, d) (8)"]
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
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_postfix_subscript() {
        let exp: Expression =
            .identifier("a").sub(.constant(0))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="0 (2)"]
                    n4 [label="a[0] (3)"]
                    n5 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_postfix_subscript_shortCircuit() {
        let exp: Expression =
            .identifier("a").sub(.identifier("b").binary(op: .nullCoalesce, rhs: .constant(0)))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="0 (3)"]
                    n5 [label="b ?? 0 (5)"]
                    n6 [label="a[b ?? 0] (6)"]
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
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_postfix_optional() {
        let exp: Expression =
            .identifier("a").optional().dot("b").optional().sub(.constant(0)).optional().call()

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="a?.b (3)"]
                    n4 [label="0 (4)"]
                    n5 [label="a?.b?[0] (6)"]
                    n6 [label="a?.b?[0]?() (8)"]
                    n7 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n3 -> n7
                    n5 -> n7
                    n6 -> n7
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
    }

    func testExpression_prefix() {
        let exp: Expression =
            .prefix(op: .subtract, .identifier("a"))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="-a (2)"]
                    n4 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_prefix_shortCircuit() {
        let exp: Expression =
            .prefix(op: .subtract, .identifier("a").binary(op: .nullCoalesce, rhs: .identifier("b")))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="a ?? b (4)"]
                    n5 [label="-(a ?? b) (5)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n2 -> n4
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_selector() {
        let exp: Expression =
            .selector(getter: "a")

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="#selector(getter: a) (1)"]
                    n3 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_sizeOf_expression() {
        let exp: Expression =
            .sizeof(.identifier("a"))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (2)"]
                    n3 [label="MemoryLayout.size(ofValue: a) (1)"]
                    n4 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_sizeOf_expression_shortCircuit() {
        let exp: Expression =
            .identifier("print").call([.sizeof(.identifier("a").binary(op: .nullCoalesce, rhs: .constant(0)))])

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="print (1)"]
                    n3 [label="a (3)"]
                    n4 [label="0 (4)"]
                    n5 [label="a ?? 0 (6)"]
                    n6 [label="MemoryLayout.size(ofValue: a ?? 0) (2)"]
                    n7 [label="print(MemoryLayout.size(ofValue: a ?? 0)) (7)"]
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
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_sizeOf_type() {
        let exp: Expression =
            .sizeof(type: "A")

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="MemoryLayout<A>.size (1)"]
                    n3 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_ternaryExpression() {
        let exp: Expression =
            .ternary(
                .identifier("a"),
                true: .identifier("b"),
                false: .identifier("c")
            )

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="a ? b : c (4)"]
                    n4 [label="b (2)"]
                    n5 [label="c (3)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n6
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_ternaryExpression_shortCircuit() {
        let exp: Expression =
            .ternary(
                .identifier("a"),
                true: .identifier("b").binary(op: .nullCoalesce, rhs: .identifier("c")),
                false: .identifier("d")
            )

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="a ? b ?? c : d (7)"]
                    n4 [label="b (2)"]
                    n5 [label="d (6)"]
                    n6 [label="c (3)"]
                    n7 [label="b ?? c (5)"]
                    n8 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n6
                    n4 -> n7
                    n6 -> n7
                    n5 -> n8
                    n7 -> n8
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_try() {
        let exp: Expression =
            .try(.identifier("a"))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="{marker}"]
                    n4 [label="{marker}"]
                    n5 [label="try a (2)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_try_optional() {
        let exp: Expression =
            .try(.identifier("a"), mode: .optional)

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="{marker}"]
                    n4 [label="{marker}"]
                    n5 [label="try? a (2)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_try_forced() {
        let exp: Expression =
            .try(.identifier("a"), mode: .forced)

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="{marker}"]
                    n4 [label="{marker}"]
                    n5 [label="try! a (2)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{do} (2)"]
                    n4 [label="{compound} (3)"]
                    n5 [label="{exp} (4)"]
                    n6 [label="a (5)"]
                    n7 [label="try a (6)"]
                    n8 [label="{catch} (9)"]
                    n9 [label="{exp} (7)"]
                    n10 [label="{compound} (10)"]
                    n11 [label="postTry (8)"]
                    n12 [label="{exp} (11)"]
                    n13 [label="errorHandler (12)"]
                    n14 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n7 -> n9
                    n8 -> n10
                    n9 -> n11
                    n10 -> n12
                    n12 -> n13
                    n11 -> n14
                    n13 -> n14
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{do} (2)"]
                    n4 [label="{compound} (3)"]
                    n5 [label="{exp} (4)"]
                    n6 [label="a (5)"]
                    n7 [label="try? a (6)"]
                    n8 [label="{exp} (7)"]
                    n9 [label="postTry (8)"]
                    n10 [label="{catch} (9)"]
                    n11 [label="{compound} (10)"]
                    n12 [label="{exp} (11)"]
                    n13 [label="errorHandler (12)"]
                    n14 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n10 -> n11
                    n11 -> n12
                    n12 -> n13
                    n9 -> n14
                    n13 -> n14
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_try_shortCircuit() {
        let exp: Expression =
            .identifier("a").call([
                .try(.identifier("b").binary(op: .nullCoalesce, rhs: .identifier("c")))
            ])

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="c (3)"]
                    n5 [label="b ?? c (5)"]
                    n6 [label="try b ?? c (6)"]
                    n7 [label="a(try b ?? c) (7)"]
                    n8 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n6 -> n8
                    n7 -> n8
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testExpression_tuple() {
        let exp: Expression =
            .tuple([
                .identifier("a"),
                .identifier("b"),
                .identifier("c"),
            ])

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="c (3)"]
                    n5 [label="(a, b, c) (4)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_tuple_shortCircuit() {
        let exp: Expression =
            .tuple([
                .identifier("a").binary(op: .nullCoalesce, rhs: .identifier("b")),
                .identifier("c"),
                .identifier("d").binary(op: .and, rhs: .identifier("e")),
            ])

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="a ?? b (4)"]
                    n5 [label="c (5)"]
                    n6 [label="d (6)"]
                    n7 [label="e (7)"]
                    n8 [label="d && e (9)"]
                    n9 [label="(a ?? b, c, d && e) (10)"]
                    n10 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n2 -> n4
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n6 -> n8
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_typeCheck() {
        let exp: Expression =
            .typeCheck(.identifier("a"), type: .int)

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="a is Int (2)"]
                    n4 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_typeCheck_shortCircuit() {
        let exp: Expression =
            .typeCheck(.identifier("a").binary(op: .nullCoalesce, rhs: .identifier("b")), type: .int)

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="a ?? b (4)"]
                    n5 [label="a ?? b is Int (5)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n2 -> n4
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_unary() {
        let exp: Expression =
            .unary(op: .subtract, .identifier("a"))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="-a (2)"]
                    n4 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_unary_shortCircuit() {
        let exp: Expression =
            .unary(op: .subtract, .identifier("a").binary(op: .nullCoalesce, rhs: .identifier("b")))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="a ?? b (4)"]
                    n5 [label="-(a ?? b) (5)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n2 -> n4
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testExpression_unknown() {
        let exp: Expression =
            .unknown(.init(context: "a"))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func tesShortCircuit_andOperand() {
        let exp: Expression =
            .identifier("a").binary(op: .and, rhs: .identifier("b"))

        let graph = ControlFlowGraph.forExpression(exp)

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
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testShortCircuit_orOperand() {
        let exp: Expression =
            .identifier("a").binary(op: .or, rhs: .identifier("b"))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="a || b (4)"]
                    n5 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n2 -> n4
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testShortCircuit_nullCoalesceOperand() {
        let exp: Expression =
            .identifier("a").binary(op: .nullCoalesce, rhs: .identifier("b"))

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="a ?? b (4)"]
                    n5 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n2 -> n4
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testShortCircuit_nestedExpression() {
        let exp: Expression =
            .arrayLiteral([
                .identifier("a").binary(op: .and, rhs: .identifier("b")),
                .identifier("c"),
            ])

        let graph = ControlFlowGraph.forExpression(exp)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a (1)"]
                    n3 [label="b (2)"]
                    n4 [label="a && b (4)"]
                    n5 [label="c (5)"]
                    n6 [label="[a && b, c] (6)"]
                    n7 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n2 -> n4
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                }
                """
        )
        XCTAssert(graph.entry.node === exp)
        XCTAssert(graph.exit.node === exp)
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
