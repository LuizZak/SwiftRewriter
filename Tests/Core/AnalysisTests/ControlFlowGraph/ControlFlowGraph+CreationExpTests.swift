import SwiftAST
import TestCommons
import WriterTargetOutput
import XCTest

@testable import Analysis

class ControlFlowGraph_CreationExpTests: XCTestCase {
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="c"]
                    n5 [label="[a, b, c]"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="a = b"]
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
                    n2 [label="a"]
                    n3 [label="a?.b"]
                    n4 [label="c"]
                    n5 [label="a?.b = c"]
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
                    n2 [label="a"]
                    n3 [label="a?.b"]
                    n4 [label="c"]
                    n5 [label="c?.d"]
                    n6 [label="c?.d?.e"]
                    n7 [label="a?.b = c?.d?.e"]
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
                    n2 [label="{ () -> Void in < body > }"]
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
                    n2 [label="a"]
                    n3 [label="a as? Int"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="a ?? b"]
                    n5 [label="a ?? b as? Int"]
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
                    n2 [label="0"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="c"]
                    n5 [label="d"]
                    n6 [label="e"]
                    n7 [label="f"]
                    n8 [label="[a: b, c: d, e: f]"]
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
                    n2 [label="a"]
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
                    n2 [label="a"]
                    n3 [label="a()"]
                    n4 [label="(a())"]
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
                    n2 [label="a"]
                    n3 [label="a?()"]
                    n4 [label="a?()?.b"]
                    n5 [label="(a?()?.b)"]
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
                    n2 [label="a"]
                    n3 [label="a.b"]
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
                    n2 [label="a"]
                    n3 [label="a()"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="c"]
                    n5 [label="a(b, c)"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="c"]
                    n5 [label="0"]
                    n6 [label="c ?? 0"]
                    n7 [label="d"]
                    n8 [label="a(b, c ?? 0, d)"]
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
                    n2 [label="a"]
                    n3 [label="0"]
                    n4 [label="a[0]"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="0"]
                    n5 [label="b ?? 0"]
                    n6 [label="a[b ?? 0]"]
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
                    n2 [label="a"]
                    n3 [label="a?.b"]
                    n4 [label="0"]
                    n5 [label="a?.b?[0]"]
                    n6 [label="a?.b?[0]?()"]
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
                    n2 [label="a"]
                    n3 [label="-a"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="a ?? b"]
                    n5 [label="-(a ?? b)"]
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
                    n2 [label="#selector(getter: a)"]
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
                    n2 [label="a"]
                    n3 [label="MemoryLayout.size(ofValue: a)"]
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
                    n2 [label="print"]
                    n3 [label="a"]
                    n4 [label="0"]
                    n5 [label="a ?? 0"]
                    n6 [label="MemoryLayout.size(ofValue: a ?? 0)"]
                    n7 [label="print(MemoryLayout.size(ofValue: a ?? 0))"]
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
                    n2 [label="MemoryLayout<A>.size"]
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
                    n2 [label="a"]
                    n3 [label="a ? b : c"]
                    n4 [label="b"]
                    n5 [label="c"]
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
                    n2 [label="a"]
                    n3 [label="a ? b ?? c : d"]
                    n4 [label="b"]
                    n5 [label="d"]
                    n6 [label="c"]
                    n7 [label="b ?? c"]
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
                    n2 [label="a"]
                    n3 [label="{marker}"]
                    n4 [label="{marker}"]
                    n5 [label="try a"]
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
                    n2 [label="a"]
                    n3 [label="{marker}"]
                    n4 [label="{marker}"]
                    n5 [label="try? a"]
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
                    n2 [label="a"]
                    n3 [label="{marker}"]
                    n4 [label="{marker}"]
                    n5 [label="try! a"]
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
                    n2 [label="{compound}"]
                    n3 [label="{do}"]
                    n4 [label="{compound}"]
                    n5 [label="{exp}"]
                    n6 [label="a"]
                    n7 [label="try a"]
                    n8 [label="{catch}"]
                    n9 [label="{exp}"]
                    n10 [label="{compound}"]
                    n11 [label="postTry"]
                    n12 [label="{exp}"]
                    n13 [label="errorHandler"]
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
                    n2 [label="{compound}"]
                    n3 [label="{do}"]
                    n4 [label="{compound}"]
                    n5 [label="{exp}"]
                    n6 [label="a"]
                    n7 [label="try? a"]
                    n8 [label="{exp}"]
                    n9 [label="postTry"]
                    n10 [label="{catch}"]
                    n11 [label="{compound}"]
                    n12 [label="{exp}"]
                    n13 [label="errorHandler"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="c"]
                    n5 [label="b ?? c"]
                    n6 [label="try b ?? c"]
                    n7 [label="a(try b ?? c)"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="c"]
                    n5 [label="(a, b, c)"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="a ?? b"]
                    n5 [label="c"]
                    n6 [label="d"]
                    n7 [label="e"]
                    n8 [label="d && e"]
                    n9 [label="(a ?? b, c, d && e)"]
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
                    n2 [label="a"]
                    n3 [label="a is Int"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="a ?? b"]
                    n5 [label="a ?? b is Int"]
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
                    n2 [label="a"]
                    n3 [label="-a"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="a ?? b"]
                    n5 [label="-(a ?? b)"]
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
                    n2 [label="a"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="a || b"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="a ?? b"]
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="a && b"]
                    n5 [label="c"]
                    n6 [label="[a && b, c]"]
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
