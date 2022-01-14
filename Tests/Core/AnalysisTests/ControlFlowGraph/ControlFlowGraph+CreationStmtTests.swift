import SwiftAST
import TestCommons
import WriterTargetOutput
import XCTest

@testable import Analysis

class ControlFlowGraph_CreationStmtTests: XCTestCase {
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

    func testExpression() {
        let stmt: CompoundStatement = [
            .expression(.identifier("exp"))
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{exp}"]
                    n4 [label="exp"]
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

    func testExpressions() {
        let stmt: CompoundStatement = [
            .expression(.identifier("exp1")),
            .expression(.identifier("exp2")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{exp}"]
                    n4 [label="exp1"]
                    n5 [label="{exp}"]
                    n6 [label="exp2"]
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

    func testVariableDeclaration() {
        let stmt: CompoundStatement = [
            .variableDeclaration(identifier: "v1", type: .int, initialization: nil),
            .variableDeclaration(identifier: "v2", type: .int, initialization: nil),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="var v1: Int"]
                    n4 [label="v1: Int"]
                    n5 [label="var v2: Int"]
                    n6 [label="v2: Int"]
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

    func testVariableDeclaration_multipleDeclarations() {
        let stmt: CompoundStatement = [
            .variableDeclarations([
                .init(identifier: "v1", type: .int, initialization: .identifier("a")),
                .init(identifier: "v2", type: .int, initialization: .identifier("b")),
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
                    n3 [label="var v1: Int, var v2: Int"]
                    n4 [label="a"]
                    n5 [label="v1: Int = a"]
                    n6 [label="b"]
                    n7 [label="v2: Int = b"]
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

    func testVariableDeclaration_initialization() {
        let stmt: CompoundStatement = [
            .variableDeclaration(identifier: "v1", type: .int, initialization: .identifier("a")),
            .variableDeclaration(identifier: "v2", type: .int, initialization: nil),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="var v1: Int"]
                    n4 [label="a"]
                    n5 [label="v1: Int = a"]
                    n6 [label="var v2: Int"]
                    n7 [label="v2: Int"]
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

    func testDoStatement() {
        let stmt: CompoundStatement = [
            Statement.do([
                .expression(
                    .identifier("exp")
                )
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
                    n6 [label="exp"]
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

    func testDoStatement_labeledBreak() {
        let stmt: CompoundStatement = [
            .while(.identifier("predicate"), body: [
                Statement.do([
                    .expression(.identifier("a")),
                    .break(targetLabel: "doLabel"),
                    .expression(.identifier("b")),
                ]).labeled("doLabel"),
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
                    n3 [label="predicate"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="{do}"]
                    n7 [label="{compound}"]
                    n8 [label="{exp}"]
                    n9 [label="a"]
                    n10 [label="{break doLabel}"]
                    n11 [label="{exp}"]
                    n12 [label="b"]
                    n13 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n13
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                    n10 -> n3 [color="#aa3333", penwidth=0.5]
                    n11 -> n12
                    n12 -> n3
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDoStatement_catchErrorFlow() {
        let stmt: CompoundStatement = [
            .expression(.identifier("preDo")),
            .do([
                .expression(.identifier("preError")),
                .throw(.identifier("Error")),
                .expression(.identifier("postError")),
            ]).catch([
                .expression(.identifier("errorHandler")),
            ]),
            .expression(.identifier("end")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{exp}"]
                    n4 [label="preDo"]
                    n5 [label="{do}"]
                    n6 [label="{compound}"]
                    n7 [label="{exp}"]
                    n8 [label="preError"]
                    n9 [label="Error"]
                    n10 [label="{throw Error}"]
                    n11 [label="{catch}"]
                    n12 [label="{compound}"]
                    n13 [label="{exp}"]
                    n14 [label="errorHandler"]
                    n15 [label="{exp}"]
                    n16 [label="end"]
                    n17 [label="{exp}"]
                    n18 [label="postError"]
                    n19 [label="exit"]
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
                    n16 -> n19
                    n17 -> n18
                    n18 -> n15
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDoStatement_catchConditionalErrorFlow() {
        let stmt: CompoundStatement = [
            .do([
                .expression(.identifier("preError")),
                .if(.identifier("a"), body: [
                    .throw(.identifier("Error")),
                ]),
                .expression(.identifier("postError")),
            ]).catch([
                .expression(.identifier("errorHandler")),
            ]),
            .expression(.identifier("end")),
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
                    n6 [label="preError"]
                    n7 [label="a"]
                    n8 [label="{if}"]
                    n9 [label="{compound}"]
                    n10 [label="{exp}"]
                    n11 [label="Error"]
                    n12 [label="postError"]
                    n13 [label="{throw Error}"]
                    n14 [label="{exp}"]
                    n15 [label="{catch}"]
                    n16 [label="end"]
                    n17 [label="{compound}"]
                    n18 [label="{exp}"]
                    n19 [label="errorHandler"]
                    n20 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n8 -> n10
                    n9 -> n11
                    n10 -> n12
                    n11 -> n13
                    n12 -> n14
                    n13 -> n15
                    n14 -> n16
                    n15 -> n17
                    n16 -> n20
                    n17 -> n18
                    n18 -> n19
                    n19 -> n14
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDoStatement_catchNestedErrorFlow() {
        let stmt: CompoundStatement = [
            .expression(.identifier("preDo")),
            .do([
                .expression(.identifier("preError")),
                .do([
                    .throw(.identifier("Error")),
                ]),
                .expression(.identifier("postError")),
            ]).catch([
                .expression(.identifier("errorHandler")),
            ]),
            .expression(.identifier("end")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{exp}"]
                    n4 [label="preDo"]
                    n5 [label="{do}"]
                    n6 [label="{compound}"]
                    n7 [label="{exp}"]
                    n8 [label="preError"]
                    n9 [label="{do}"]
                    n10 [label="{compound}"]
                    n11 [label="Error"]
                    n12 [label="{throw Error}"]
                    n13 [label="{catch}"]
                    n14 [label="{compound}"]
                    n15 [label="{exp}"]
                    n16 [label="errorHandler"]
                    n17 [label="{exp}"]
                    n18 [label="end"]
                    n19 [label="{exp}"]
                    n20 [label="postError"]
                    n21 [label="exit"]
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
                    n18 -> n21
                    n19 -> n20
                    n20 -> n17
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDoStatement_multipleCatchFlow() {
        // TODO: Support catch skipping depending on catch block's pattern.

        let stmt: CompoundStatement = [
            .expression(.identifier("preDo")),
            .do([
                .expression(.identifier("preError")),
                .throw(.identifier("Error")),
                .expression(.identifier("postError")),
            ]).catch([
                .expression(.identifier("errorHandler 1")),
            ]).catch([
                .expression(.identifier("errorHandler 2")),
            ]),
            .expression(.identifier("end")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{exp}"]
                    n4 [label="preDo"]
                    n5 [label="{do}"]
                    n6 [label="{compound}"]
                    n7 [label="{exp}"]
                    n8 [label="preError"]
                    n9 [label="Error"]
                    n10 [label="{throw Error}"]
                    n11 [label="{catch}"]
                    n12 [label="{compound}"]
                    n13 [label="{exp}"]
                    n14 [label="errorHandler 1"]
                    n15 [label="{exp}"]
                    n16 [label="end"]
                    n17 [label="{catch}"]
                    n18 [label="{compound}"]
                    n19 [label="{exp}"]
                    n20 [label="{exp}"]
                    n21 [label="errorHandler 2"]
                    n22 [label="postError"]
                    n23 [label="exit"]
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
                    n16 -> n23
                    n17 -> n18
                    n18 -> n20
                    n19 -> n22
                    n20 -> n21
                    n21 -> n15
                    n22 -> n15
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDoStatement_catchWithNoError() {
        let stmt: CompoundStatement = [
            .do([
                .expression(.identifier("a")),
            ]).catch([
                .expression(.identifier("b")),
            ]),
            .expression(.identifier("c")),
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
                    n7 [label="{exp}"]
                    n8 [label="c"]
                    n9 [label="{catch}"]
                    n10 [label="{compound}"]
                    n11 [label="{exp}"]
                    n12 [label="b"]
                    n13 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n13
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n12 -> n7
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testIf() {
        let stmt: CompoundStatement = [
            Statement.if(
                .identifier("predicate"),
                body: [
                    .expression(.identifier("ifBody")),
                ]
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="predicate"]
                    n4 [label="{if}"]
                    n5 [label="{compound}"]
                    n6 [label="{exp}"]
                    n7 [label="ifBody"]
                    n8 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n8
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testIf_withElse() {
        let stmt: CompoundStatement = [
            Statement.if(
                .identifier("predicate"),
                body: [
                    .expression(.identifier("ifBody")),
                ],
                else: [
                    .expression(.identifier("elseBody")),
                ]
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="predicate"]
                    n4 [label="{if}"]
                    n5 [label="{compound}"]
                    n6 [label="{compound}"]
                    n7 [label="{exp}"]
                    n8 [label="{exp}"]
                    n9 [label="elseBody"]
                    n10 [label="ifBody"]
                    n11 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n10
                    n8 -> n9
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

    func testIf_withElseIf() {
        let stmt: CompoundStatement = [
            .if(
                .identifier("predicate"),
                body: [
                    .expression(.identifier("ifBody")),
                ],
                else: [
                    .if(
                        .identifier("predicate2"),
                        body: [
                            .expression(.identifier("ifElseIfBody")),
                        ],
                        else: [
                            .expression(.identifier("ifElseIfElseBody")),
                        ]
                    ),
                ]
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="predicate"]
                    n4 [label="{if}"]
                    n5 [label="{compound}"]
                    n6 [label="{compound}"]
                    n7 [label="predicate2"]
                    n8 [label="{exp}"]
                    n9 [label="{if}"]
                    n10 [label="ifBody"]
                    n11 [label="{compound}"]
                    n12 [label="{compound}"]
                    n13 [label="{exp}"]
                    n14 [label="{exp}"]
                    n15 [label="ifElseIfBody"]
                    n16 [label="ifElseIfElseBody"]
                    n17 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n8 -> n10
                    n9 -> n11
                    n9 -> n12
                    n10 -> n17
                    n11 -> n13
                    n12 -> n14
                    n13 -> n15
                    n14 -> n16
                    n15 -> n17
                    n16 -> n17
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
    }

    func testIf_labeledBreak() {
        let stmt: CompoundStatement = [
            .while(.identifier("whilePredicate"), body: [
                .if(
                    .identifier("predicate"),
                    body: [
                        .if(.identifier("predicateInner"), body: [
                            .break(targetLabel: "outer"),
                            .expression(.identifier("postBreak")),
                        ]),
                    ]
                ).labeled("outer"),
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
                    n3 [label="whilePredicate"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="predicate"]
                    n7 [label="{if}"]
                    n8 [label="{compound}"]
                    n9 [label="predicateInner"]
                    n10 [label="{if}"]
                    n11 [label="{compound}"]
                    n12 [label="{break outer}"]
                    n13 [label="{exp}"]
                    n14 [label="postBreak"]
                    n15 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n15
                    n5 -> n6
                    n6 -> n7
                    n7 -> n3 [color="#aa3333", penwidth=0.5]
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                    n10 -> n3 [color="#aa3333", penwidth=0.5]
                    n10 -> n11
                    n11 -> n12
                    n12 -> n3 [color="#aa3333", penwidth=0.5]
                    n13 -> n14
                    n14 -> n3
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testSwitchStatement() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("switchExp"),
                cases: [
                    SwitchCase(
                        patterns: [
                            .identifier("patternA")
                        ],
                        statements: [
                            .expression(.identifier("case1"))
                        ]
                    ),
                    SwitchCase(
                        patterns: [
                            .identifier("patternB")
                        ],
                        statements: [
                            .expression(.identifier("case2"))
                        ]
                    ),
                ],
                default: nil
            )
        ]
        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="switchExp"]
                    n4 [label="{switch}"]
                    n5 [label="{case patternA}"]
                    n6 [label="{case patternB}"]
                    n7 [label="{compound}"]
                    n8 [label="{compound}"]
                    n9 [label="{exp}"]
                    n10 [label="{exp}"]
                    n11 [label="case1"]
                    n12 [label="case2"]
                    n13 [label="exit"]
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
                    n10 -> n12
                    n11 -> n13
                    n12 -> n13
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testSwitchStatement_withDefaultCase() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("switchExp"),
                cases: [
                    SwitchCase(
                        patterns: [.identifier("patternA")],
                        statements: [
                            .expression(.identifier("b"))
                        ]
                    ),
                    SwitchCase(
                        patterns: [.identifier("patternB")],
                        statements: [
                            .expression(.identifier("c"))
                        ]
                    ),
                    SwitchCase(
                        patterns: [.identifier("patternC")],
                        statements: [
                            .expression(.identifier("d"))
                        ]
                    ),
                    SwitchCase(
                        patterns: [.identifier("patternD")],
                        statements: [
                            .expression(.identifier("e"))
                        ]
                    ),
                ],
                defaultStatements: [
                    .expression(.identifier("defaultCase"))
                ]
            )
        ]
        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="switchExp"]
                    n4 [label="{switch}"]
                    n5 [label="{case patternA}"]
                    n6 [label="{case patternB}"]
                    n7 [label="{compound}"]
                    n8 [label="{case patternC}"]
                    n9 [label="{compound}"]
                    n10 [label="{exp}"]
                    n11 [label="{case patternD}"]
                    n12 [label="{compound}"]
                    n13 [label="{exp}"]
                    n14 [label="b"]
                    n15 [label="{default}"]
                    n16 [label="{compound}"]
                    n17 [label="{exp}"]
                    n18 [label="c"]
                    n19 [label="{compound}"]
                    n20 [label="{exp}"]
                    n21 [label="d"]
                    n22 [label="{exp}"]
                    n23 [label="e"]
                    n24 [label="defaultCase"]
                    n25 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n8
                    n6 -> n9
                    n7 -> n10
                    n8 -> n11
                    n8 -> n12
                    n9 -> n13
                    n10 -> n14
                    n11 -> n15
                    n11 -> n16
                    n12 -> n17
                    n13 -> n18
                    n14 -> n25
                    n15 -> n19
                    n16 -> n20
                    n17 -> n21
                    n18 -> n25
                    n19 -> n22
                    n20 -> n23
                    n21 -> n25
                    n22 -> n24
                    n23 -> n25
                    n24 -> n25
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 5)
    }

    func testSwitchStatement_emptyCases() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("a"),
                cases: [
                    SwitchCase(patterns: [.identifier("b")], statements: []),
                    SwitchCase(patterns: [.identifier("c")], statements: []),
                    SwitchCase(patterns: [.identifier("d")], statements: []),
                ],
                defaultStatements: []
            )
        ]
        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="a"]
                    n4 [label="{switch}"]
                    n5 [label="{case b}"]
                    n6 [label="{case c}"]
                    n7 [label="{compound}"]
                    n8 [label="{case d}"]
                    n9 [label="{compound}"]
                    n10 [label="{default}"]
                    n11 [label="{compound}"]
                    n12 [label="{compound}"]
                    n13 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n8
                    n6 -> n9
                    n7 -> n13
                    n8 -> n10
                    n8 -> n11
                    n9 -> n13
                    n10 -> n12
                    n11 -> n13
                    n12 -> n13
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 4)
    }

    func testSwitchStatement_emptyCasesWithFallthrough() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("a"),
                cases: [
                    SwitchCase(
                        patterns: [.identifier("b")],
                        statements: [
                            .fallthrough
                        ]
                    ),
                    SwitchCase(patterns: [.identifier("c")], statements: []),
                    SwitchCase(patterns: [.identifier("d")], statements: []),
                ],
                defaultStatements: []
            )
        ]
        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="a"]
                    n4 [label="{switch}"]
                    n5 [label="{case b}"]
                    n6 [label="{compound}"]
                    n7 [label="{case c}"]
                    n8 [label="{case d}"]
                    n9 [label="{fallthrough}"]
                    n10 [label="{compound}"]
                    n11 [label="{default}"]
                    n12 [label="{compound}"]
                    n13 [label="{compound}"]
                    n14 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n9
                    n7 -> n8
                    n7 -> n10
                    n8 -> n11
                    n8 -> n12
                    n9 -> n10
                    n10 -> n14
                    n11 -> n13
                    n12 -> n14
                    n13 -> n14
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
    }

    func testSwitchStatement_fallthrough() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("switchExp"),
                cases: [
                    SwitchCase(
                        patterns: [],
                        statements: [
                            .expression(.identifier("b")),
                            .fallthrough,
                        ]
                    ),
                    SwitchCase(
                        patterns: [],
                        statements: [
                            .expression(.identifier("c"))
                        ]
                    ),
                ],
                defaultStatements: [
                    .expression(.identifier("defaultExp"))
                ]
            )
        ]
        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="switchExp"]
                    n4 [label="{switch}"]
                    n5 [label="{case []}"]
                    n6 [label="{compound}"]
                    n7 [label="{case []}"]
                    n8 [label="{exp}"]
                    n9 [label="{default}"]
                    n10 [label="{compound}"]
                    n11 [label="b"]
                    n12 [label="{compound}"]
                    n13 [label="{exp}"]
                    n14 [label="{fallthrough}"]
                    n15 [label="{exp}"]
                    n16 [label="c"]
                    n17 [label="defaultExp"]
                    n18 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n7 -> n10
                    n8 -> n11
                    n9 -> n12
                    n10 -> n13
                    n11 -> n14
                    n12 -> n15
                    n13 -> n16
                    n14 -> n10
                    n15 -> n17
                    n16 -> n18
                    n17 -> n18
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testSwitchStatement_breakDefer() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("switchExp"),
                cases: [
                    SwitchCase(
                        patterns: [],
                        statements: [
                            .expression(.identifier("b")),
                            .defer([
                                .expression(.identifier("c"))
                            ]),
                            Statement.if(
                                .identifier("predicate"),
                                body: [
                                    .break()
                                ]
                            ),
                            .expression(.identifier("d")),
                        ]
                    )
                ],
                defaultStatements: [
                    .expression(.identifier("defaultExp"))
                ]
            )
        ]
        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="switchExp"]
                    n4 [label="{switch}"]
                    n5 [label="{case []}"]
                    n6 [label="{compound}"]
                    n7 [label="{default}"]
                    n8 [label="{exp}"]
                    n9 [label="{compound}"]
                    n10 [label="b"]
                    n11 [label="{exp}"]
                    n12 [label="predicate"]
                    n13 [label="defaultExp"]
                    n14 [label="{if}"]
                    n15 [label="{compound}"]
                    n16 [label="{exp}"]
                    n17 [label="d"]
                    n18 [label="{break}"]
                    n19 [label="{defer}"]
                    n20 [label="{defer}"]
                    n21 [label="{compound}"]
                    n22 [label="{compound}"]
                    n23 [label="{exp}"]
                    n24 [label="{exp}"]
                    n25 [label="c"]
                    n26 [label="c"]
                    n27 [label="exit"]
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
                    n10 -> n12
                    n11 -> n13
                    n12 -> n14
                    n13 -> n27
                    n14 -> n15
                    n14 -> n16
                    n15 -> n18
                    n16 -> n17
                    n17 -> n19
                    n18 -> n20
                    n19 -> n21
                    n20 -> n22
                    n21 -> n23
                    n22 -> n24
                    n23 -> n25
                    n24 -> n26
                    n25 -> n27
                    n26 -> n27
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
    }

    func testSwitchStatement_fallthroughWithDefer() {
        /*
        switch switchExp {
        case a:
            c

            defer {
                d
            }

            if predicateFallthrough {
                fallthrough
            }

            e

            defer {
                deferredExp
            }

        case f:
            g

        default:
            defaultExp
        }
        */
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("switchExp"),
                cases: [
                    SwitchCase(
                        patterns: [.identifier("b")],
                        statements: [
                            .expression(.identifier("c")),
                            .defer([
                                .expression(.identifier("d"))
                            ]),
                            Statement.if(
                                .identifier("predicateFallthrough"),
                                body: [
                                    .fallthrough
                                ]
                            ),
                            .expression(.identifier("e")),
                            .defer([
                                .expression(.identifier("deferredExp"))
                            ]),
                        ]
                    ),
                    SwitchCase(
                        patterns: [.identifier("f")],
                        statements: [
                            .expression(.identifier("g"))
                        ]
                    ),
                ],
                defaultStatements: [
                    .expression(.identifier("defaultExp"))
                ]
            )
        ]
        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="switchExp"]
                    n4 [label="{switch}"]
                    n5 [label="{case b}"]
                    n6 [label="{compound}"]
                    n7 [label="{case f}"]
                    n8 [label="{exp}"]
                    n9 [label="{default}"]
                    n10 [label="{compound}"]
                    n11 [label="c"]
                    n12 [label="{compound}"]
                    n13 [label="{exp}"]
                    n14 [label="predicateFallthrough"]
                    n15 [label="{exp}"]
                    n16 [label="g"]
                    n17 [label="{if}"]
                    n18 [label="defaultExp"]
                    n19 [label="{compound}"]
                    n20 [label="{exp}"]
                    n21 [label="{fallthrough}"]
                    n22 [label="e"]
                    n23 [label="{defer}"]
                    n24 [label="{defer}"]
                    n25 [label="{compound}"]
                    n26 [label="{compound}"]
                    n27 [label="{exp}"]
                    n28 [label="{exp}"]
                    n29 [label="deferredExp"]
                    n30 [label="deferredExp"]
                    n31 [label="{defer}"]
                    n32 [label="{defer}"]
                    n33 [label="{compound}"]
                    n34 [label="{compound}"]
                    n35 [label="{exp}"]
                    n36 [label="{exp}"]
                    n37 [label="d"]
                    n38 [label="d"]
                    n39 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n7 -> n10
                    n8 -> n11
                    n9 -> n12
                    n10 -> n13
                    n11 -> n14
                    n12 -> n15
                    n13 -> n16
                    n14 -> n17
                    n15 -> n18
                    n16 -> n39
                    n17 -> n19
                    n17 -> n20
                    n18 -> n39
                    n19 -> n21
                    n20 -> n22
                    n21 -> n23
                    n22 -> n24
                    n23 -> n25
                    n24 -> n26
                    n25 -> n27
                    n26 -> n28
                    n27 -> n29
                    n28 -> n30
                    n29 -> n31
                    n30 -> n32
                    n31 -> n33
                    n32 -> n34
                    n33 -> n35
                    n34 -> n36
                    n35 -> n37
                    n36 -> n38
                    n37 -> n10
                    n38 -> n39
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
    }

    func testSwitchStatement_fallthroughWithDeferInterwovenWithReturn() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("switchExp"),
                cases: [
                    SwitchCase(
                        patterns: [],
                        statements: [
                            .expression(.identifier("b")),
                            .defer([
                                .expression(.identifier("deferredExp"))
                            ]),
                            Statement.if(
                                .identifier("predicateFallthrough"),
                                body: [
                                    .expression(.identifier("d")),
                                    .fallthrough,
                                ]
                            ),
                            .expression(.identifier("e")),
                            Statement.if(
                                .identifier("predicateReturn"),
                                body: [
                                    .return(nil)
                                ]
                            ),
                            .defer([
                                .expression(.identifier("f"))
                            ]),
                        ]
                    ),
                    SwitchCase(
                        patterns: [],
                        statements: [
                            .expression(.identifier("g"))
                        ]
                    ),
                ],
                defaultStatements: [
                    .expression(.identifier("defaultExp"))
                ]
            )
        ]
        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="switchExp"]
                    n4 [label="{switch}"]
                    n5 [label="{case []}"]
                    n6 [label="{compound}"]
                    n7 [label="{case []}"]
                    n8 [label="{exp}"]
                    n9 [label="{default}"]
                    n10 [label="{compound}"]
                    n11 [label="b"]
                    n12 [label="{compound}"]
                    n13 [label="{exp}"]
                    n14 [label="predicateFallthrough"]
                    n15 [label="{exp}"]
                    n16 [label="g"]
                    n17 [label="{if}"]
                    n18 [label="defaultExp"]
                    n19 [label="{compound}"]
                    n20 [label="{exp}"]
                    n21 [label="{exp}"]
                    n22 [label="e"]
                    n23 [label="d"]
                    n24 [label="predicateReturn"]
                    n25 [label="{fallthrough}"]
                    n26 [label="{if}"]
                    n27 [label="{defer}"]
                    n28 [label="{compound}"]
                    n29 [label="{defer}"]
                    n30 [label="{compound}"]
                    n31 [label="{return}"]
                    n32 [label="{compound}"]
                    n33 [label="{exp}"]
                    n34 [label="{defer}"]
                    n35 [label="{exp}"]
                    n36 [label="f"]
                    n37 [label="{compound}"]
                    n38 [label="f"]
                    n39 [label="{defer}"]
                    n40 [label="{exp}"]
                    n41 [label="{defer}"]
                    n42 [label="{compound}"]
                    n43 [label="f"]
                    n44 [label="{compound}"]
                    n45 [label="{exp}"]
                    n46 [label="{defer}"]
                    n47 [label="{exp}"]
                    n48 [label="deferredExp"]
                    n49 [label="{compound}"]
                    n50 [label="deferredExp"]
                    n51 [label="{exp}"]
                    n52 [label="deferredExp"]
                    n53 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n7 -> n10
                    n8 -> n11
                    n9 -> n12
                    n10 -> n13
                    n11 -> n14
                    n12 -> n15
                    n13 -> n16
                    n14 -> n17
                    n15 -> n18
                    n16 -> n53
                    n17 -> n19
                    n17 -> n20
                    n18 -> n53
                    n19 -> n21
                    n20 -> n22
                    n21 -> n23
                    n22 -> n24
                    n23 -> n25
                    n24 -> n26
                    n25 -> n27
                    n26 -> n28
                    n26 -> n29
                    n27 -> n30
                    n28 -> n31
                    n29 -> n32
                    n30 -> n33
                    n31 -> n34
                    n32 -> n35
                    n33 -> n36
                    n34 -> n37
                    n35 -> n38
                    n36 -> n39
                    n37 -> n40
                    n38 -> n41
                    n39 -> n42
                    n40 -> n43
                    n41 -> n44
                    n42 -> n45
                    n43 -> n46
                    n44 -> n47
                    n45 -> n48
                    n46 -> n49
                    n47 -> n50
                    n48 -> n10
                    n49 -> n51
                    n50 -> n53
                    n51 -> n52
                    n52 -> n53
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 4)
    }

    func testWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("predicate"),
                body: [
                    .expression(.identifier("loopBody"))
                ]
            ),
        ]
        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="predicate"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="{exp}"]
                    n7 [label="loopBody"]
                    n8 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n8
                    n5 -> n6
                    n6 -> n7
                    n7 -> n3 [color="#aa3333", penwidth=0.5]
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testWhileLoop_empty() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("predicate"),
                body: []
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="predicate"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n3 [color="#aa3333", penwidth=0.5]
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testWhileLoop_labeledContinue() {
        let stmt: CompoundStatement = [
            .while(
                .identifier("predicate"),
                body: [
                    .while(.identifier("predicateInner"), body: [
                        .continue(targetLabel: "outer")
                    ]),
                ]
            ).labeled("outer"),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="predicate"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="predicateInner"]
                    n7 [label="{while}"]
                    n8 [label="{compound}"]
                    n9 [label="{continue outer}"]
                    n10 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n10
                    n5 -> n6
                    n6 -> n7
                    n7 -> n3 [color="#aa3333", penwidth=0.5]
                    n7 -> n8
                    n8 -> n9
                    n9 -> n3 [color="#aa3333", penwidth=0.5]
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testWhileLoop_labeledBreak() {
        let stmt: CompoundStatement = [
            .while(
                .identifier("predicate"),
                body: [
                    .while(.identifier("predicateInner"), body: [
                        .break(targetLabel: "outer")
                    ]),
                ]
            ).labeled("outer"),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="predicate"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="predicateInner"]
                    n7 [label="{while}"]
                    n8 [label="{compound}"]
                    n9 [label="{break outer}"]
                    n10 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n10
                    n5 -> n6
                    n6 -> n7
                    n7 -> n3 [color="#aa3333", penwidth=0.5]
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testWhileLoop_withBreakAndContinuePaths() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("whilePredicate"),
                body: [
                    .if(
                        .identifier("ifPredicate"),
                        body: [.break()],
                        else: [
                            .expression(.identifier("preContinue")),
                            .continue(),
                        ]
                    ),
                    .expression(.identifier("postIf"))
                ]
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="whilePredicate"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="ifPredicate"]
                    n7 [label="{if}"]
                    n8 [label="{compound}"]
                    n9 [label="{compound}"]
                    n10 [label="{exp}"]
                    n11 [label="{break}"]
                    n12 [label="preContinue"]
                    n13 [label="{continue}"]
                    n14 [label="{exp}"]
                    n15 [label="postIf"]
                    n16 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n16
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n7 -> n9
                    n8 -> n10
                    n9 -> n11
                    n10 -> n12
                    n11 -> n16
                    n12 -> n13
                    n13 -> n3 [color="#aa3333", penwidth=0.5]
                    n14 -> n15
                    n15 -> n3
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testRepeatWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.repeatWhile(
                .identifier("predicate"),
                body: [
                    .expression(.identifier("loopBody"))
                ]
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{compound}"]
                    n4 [label="{exp}"]
                    n5 [label="loopBody"]
                    n6 [label="predicate"]
                    n7 [label="{repeat-while}"]
                    n8 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n3 [color="#aa3333", penwidth=0.5]
                    n7 -> n8
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testRepeatWhileLoop_empty() {
        let stmt: CompoundStatement = [
            Statement.repeatWhile(
                .identifier("predicate"),
                body: []
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{compound}"]
                    n4 [label="predicate"]
                    n5 [label="{repeat-while}"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n3 [color="#aa3333", penwidth=0.5]
                    n5 -> n6
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testRepeatWhileLoop_labeledContinue() {
        let stmt: CompoundStatement = [
            .repeatWhile(
                .identifier("predicate"),
                body: [
                    .while(.identifier("predicateInner"), body: [
                        .continue(targetLabel: "outer"),
                    ]),
                ]
            ).labeled("outer"),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{compound}"]
                    n4 [label="predicateInner"]
                    n5 [label="{while}"]
                    n6 [label="{compound}"]
                    n7 [label="predicate"]
                    n8 [label="{continue outer}"]
                    n9 [label="{repeat-while}"]
                    n10 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n8 -> n7
                    n9 -> n3 [color="#aa3333", penwidth=0.5]
                    n9 -> n10
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testRepeatWhileLoop_labeledBreak() {
        let stmt: CompoundStatement = [
            .repeatWhile(
                .identifier("predicate"),
                body: [
                    .while(.identifier("predicateInner"), body: [
                        .break(targetLabel: "outer"),
                    ]),
                ]
            ).labeled("outer"),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{compound}"]
                    n4 [label="predicateInner"]
                    n5 [label="{while}"]
                    n6 [label="predicate"]
                    n7 [label="{compound}"]
                    n8 [label="{break outer}"]
                    n9 [label="{repeat-while}"]
                    n10 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n9
                    n7 -> n8
                    n8 -> n10
                    n9 -> n3 [color="#aa3333", penwidth=0.5]
                    n9 -> n10
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testRepeatWhileLoop_break() {
        let stmt: CompoundStatement = [
            Statement.repeatWhile(
                .identifier("predicate"),
                body: [
                    .break()
                ]
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{compound}"]
                    n4 [label="{break}"]
                    n5 [label="predicate"]
                    n6 [label="{repeat-while}"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n7
                    n5 -> n6
                    n6 -> n3
                    n6 -> n7
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testForLoop() {
        let stmt: CompoundStatement = [
            Statement.for(
                .identifier("i"),
                .identifier("i"),
                body: [
                    .expression(.identifier("b"))
                ]
            )
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="i"]
                    n4 [label="{for}"]
                    n5 [label="{compound}"]
                    n6 [label="{exp}"]
                    n7 [label="b"]
                    n8 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n8
                    n5 -> n6
                    n6 -> n7
                    n7 -> n4 [color="#aa3333", penwidth=0.5]
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testForLoop_empty() {
        let stmt: CompoundStatement = [
            Statement.for(
                .identifier("i"),
                .identifier("i"),
                body: []
            )
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="i"]
                    n4 [label="{for}"]
                    n5 [label="{compound}"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n4 [color="#aa3333", penwidth=0.5]
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testForLoop_labeledContinue() {
        let stmt: CompoundStatement = [
            Statement.for(
                .identifier("i"),
                .identifier("i"),
                body: [
                    .while(.identifier("predicateInner"), body: [
                        .continue(targetLabel: "outer")
                    ]),
                ]
            ).labeled("outer"),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="i"]
                    n4 [label="{for}"]
                    n5 [label="{compound}"]
                    n6 [label="predicateInner"]
                    n7 [label="{while}"]
                    n8 [label="{compound}"]
                    n9 [label="{continue outer}"]
                    n10 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n10
                    n5 -> n6
                    n6 -> n7
                    n7 -> n4 [color="#aa3333", penwidth=0.5]
                    n7 -> n8
                    n8 -> n9
                    n9 -> n4 [color="#aa3333", penwidth=0.5]
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testForLoop_labeledBreak() {
        let stmt: CompoundStatement = [
            Statement.for(
                .identifier("i"),
                .identifier("i"),
                body: [
                    .while(.identifier("predicateInner"), body: [
                        .break(targetLabel: "outer")
                    ]),
                ]
            ).labeled("outer"),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="i"]
                    n4 [label="{for}"]
                    n5 [label="{compound}"]
                    n6 [label="predicateInner"]
                    n7 [label="{while}"]
                    n8 [label="{compound}"]
                    n9 [label="{break outer}"]
                    n10 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n10
                    n5 -> n6
                    n6 -> n7
                    n7 -> n4 [color="#aa3333", penwidth=0.5]
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testReturnStatement() {
        let stmt: CompoundStatement = [
            .return(nil),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{return}"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testReturnStatement_withExpression() {
        let stmt: CompoundStatement = [
            .return(.identifier("exp")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="exp"]
                    n4 [label="{return exp}"]
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

    func testReturnStatement_inLoop() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("predicate"),
                body: [
                    .return(nil),
                ]
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="predicate"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="{return}"]
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
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testReturnStatement_skipRemaining() {
        let stmt: CompoundStatement = [
            .expression(.identifier("preReturn")),
            .return(nil),
            .expression(.identifier("postReturn")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{exp}"]
                    n4 [label="preReturn"]
                    n5 [label="{return}"]
                    n6 [label="{exp}"]
                    n7 [label="postReturn"]
                    n8 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n8
                    n6 -> n7
                    n7 -> n8
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testThrowStatement() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("predicate"),
                body: [
                    .throw(.identifier("Error"))
                ]
            )
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="predicate"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="Error"]
                    n7 [label="{throw Error}"]
                    n8 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n8
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testThrowStatement_errorFlow() {
        let stmt: CompoundStatement = [
            .expression(.identifier("preError")),
            .throw(.identifier("Error")),
            .expression(.identifier("postError")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{exp}"]
                    n4 [label="preError"]
                    n5 [label="Error"]
                    n6 [label="{throw Error}"]
                    n7 [label="{exp}"]
                    n8 [label="postError"]
                    n9 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n9
                    n7 -> n8
                    n8 -> n9
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testThrowStatement_conditionalErrorFlow() {
        let stmt: CompoundStatement = [
            .expression(.identifier("preError")),
            .if(.identifier("a"), body: [
                .throw(.identifier("Error")),
            ]),
            .expression(.identifier("postError")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{exp}"]
                    n4 [label="preError"]
                    n5 [label="a"]
                    n6 [label="{if}"]
                    n7 [label="{compound}"]
                    n8 [label="{exp}"]
                    n9 [label="Error"]
                    n10 [label="postError"]
                    n11 [label="{throw Error}"]
                    n12 [label="exit"]
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
                    n11 -> n12
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testBreakStatement() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("v"),
                body: [
                    .break()
                ]
            )
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="v"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="{break}"]
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
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testBreak_labeled_loopDefer() {
        let stmt: CompoundStatement = [
            Statement.for(
                .identifier("a"),
                .identifier("a"),
                body: [
                    Statement.while(
                        .identifier("b"),
                        body: [
                            .defer([
                                .expression(.identifier("deferred"))
                            ]),
                            .if(
                                .identifier("predicate"),
                                body: [
                                    .break(targetLabel: "outer")
                                ]
                            ),
                        ]
                    )
                ]
            ).labeled("outer"),
            .expression(.identifier("b")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="a"]
                    n4 [label="{for}"]
                    n5 [label="{compound}"]
                    n6 [label="{exp}"]
                    n7 [label="b"]
                    n8 [label="b"]
                    n9 [label="{while}"]
                    n10 [label="{compound}"]
                    n11 [label="predicate"]
                    n12 [label="{if}"]
                    n13 [label="{defer}"]
                    n14 [label="{compound}"]
                    n15 [label="{compound}"]
                    n16 [label="{break outer}"]
                    n17 [label="{exp}"]
                    n18 [label="{defer}"]
                    n19 [label="deferred"]
                    n20 [label="{compound}"]
                    n21 [label="{exp}"]
                    n22 [label="deferred"]
                    n23 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n8 -> n23
                    n9 -> n4 [color="#aa3333", penwidth=0.5]
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n12 -> n13
                    n12 -> n14
                    n13 -> n15
                    n14 -> n16
                    n15 -> n17
                    n16 -> n18
                    n17 -> n19
                    n18 -> n20
                    n19 -> n7 [color="#aa3333", penwidth=0.5]
                    n20 -> n21
                    n21 -> n22
                    n22 -> n6
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testContinueStatement() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("v"),
                body: [
                    .continue()
                ]
            )
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="v"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="{continue}"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n7
                    n5 -> n6
                    n6 -> n3 [color="#aa3333", penwidth=0.5]
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testContinueStatement_skippingOverRemainingOfMethod() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("v"),
                body: [
                    .continue(),
                    .expression(.identifier("v")),
                ]
            )
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="v"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="{continue}"]
                    n7 [label="{exp}"]
                    n8 [label="v"]
                    n9 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n9
                    n5 -> n6
                    n6 -> n3 [color="#aa3333", penwidth=0.5]
                    n7 -> n8
                    n8 -> n3
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testContinue_labeled_loopDefer() {
        let stmt: CompoundStatement = [
            Statement.for(
                .identifier("a"),
                .identifier("a"),
                body: [
                    Statement.while(
                        .identifier("b"),
                        body: [
                            .defer([
                                .expression(.identifier("deferred"))
                            ]),
                            .if(
                                .identifier("predicate"),
                                body: [
                                    .continue(targetLabel: "outer")
                                ]
                            ),
                        ]
                    )
                ]
            ).labeled("outer")
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="a"]
                    n4 [label="{for}"]
                    n5 [label="{compound}"]
                    n6 [label="b"]
                    n7 [label="{while}"]
                    n8 [label="{compound}"]
                    n9 [label="predicate"]
                    n10 [label="{if}"]
                    n11 [label="{compound}"]
                    n12 [label="{defer}"]
                    n13 [label="{compound}"]
                    n14 [label="{continue outer}"]
                    n15 [label="{defer}"]
                    n16 [label="{exp}"]
                    n17 [label="deferred"]
                    n18 [label="{compound}"]
                    n19 [label="{exp}"]
                    n20 [label="deferred"]
                    n21 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n21
                    n5 -> n6
                    n6 -> n7
                    n7 -> n4 [color="#aa3333", penwidth=0.5]
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                    n10 -> n11
                    n10 -> n12
                    n11 -> n14
                    n12 -> n13
                    n13 -> n16
                    n14 -> n15
                    n15 -> n18
                    n16 -> n17
                    n17 -> n6 [color="#aa3333", penwidth=0.5]
                    n18 -> n19
                    n19 -> n20
                    n20 -> n4 [color="#aa3333", penwidth=0.5]
                }
                """
        )
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDeferStatement() {
        let stmt: CompoundStatement = [
            Statement.defer([
                Statement.expression(.identifier("a")),
                Statement.expression(.identifier("b")),
            ]),
            Statement.expression(.identifier("c")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{exp}"]
                    n4 [label="c"]
                    n5 [label="{defer}"]
                    n6 [label="{compound}"]
                    n7 [label="{exp}"]
                    n8 [label="a"]
                    n9 [label="{exp}"]
                    n10 [label="b"]
                    n11 [label="exit"]
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
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDeferStatement_multiplePaths() {
        let stmt: CompoundStatement = [
            .expression(.identifier("a")),
            .do([
                .defer([
                    .expression(.identifier("b")),
                ]),
                .if(.identifier("predicate"), body: [
                    .throw(.identifier("error")),
                ]),
                .expression(.identifier("c")),
            ]).catch([
                .expression(.identifier("d")),
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
                    n3 [label="{exp}"]
                    n4 [label="a"]
                    n5 [label="{do}"]
                    n6 [label="{compound}"]
                    n7 [label="predicate"]
                    n8 [label="{if}"]
                    n9 [label="{compound}"]
                    n10 [label="{exp}"]
                    n11 [label="error"]
                    n12 [label="c"]
                    n13 [label="{throw error}"]
                    n14 [label="{defer}"]
                    n15 [label="{defer}"]
                    n16 [label="{compound}"]
                    n17 [label="{compound}"]
                    n18 [label="{exp}"]
                    n19 [label="{exp}"]
                    n20 [label="b"]
                    n21 [label="b"]
                    n22 [label="{catch}"]
                    n23 [label="{compound}"]
                    n24 [label="{exp}"]
                    n25 [label="d"]
                    n26 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n8 -> n10
                    n9 -> n11
                    n10 -> n12
                    n11 -> n13
                    n12 -> n14
                    n13 -> n15
                    n14 -> n16
                    n15 -> n17
                    n16 -> n18
                    n17 -> n19
                    n18 -> n20
                    n19 -> n21
                    n20 -> n26
                    n21 -> n22
                    n22 -> n23
                    n23 -> n24
                    n24 -> n25
                    n25 -> n26
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testDeferStatement_inIf() {
        let stmt: CompoundStatement = [
            Statement.if(
                .identifier("a"),
                body: [
                    Statement.defer([
                        Statement.expression(.identifier("b")),
                        Statement.expression(.identifier("c")),
                    ]),
                    Statement.expression(.identifier("d")),
                ]
            ),
            Statement.expression(.identifier("e")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="a"]
                    n4 [label="{if}"]
                    n5 [label="{compound}"]
                    n6 [label="{exp}"]
                    n7 [label="{exp}"]
                    n8 [label="e"]
                    n9 [label="d"]
                    n10 [label="{defer}"]
                    n11 [label="{compound}"]
                    n12 [label="{exp}"]
                    n13 [label="b"]
                    n14 [label="{exp}"]
                    n15 [label="c"]
                    n16 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n8 -> n16
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n12 -> n13
                    n13 -> n14
                    n14 -> n15
                    n15 -> n6
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDeferStatement_inIfElse() {
        let stmt: CompoundStatement = [
            Statement.if(
                .identifier("a"),
                body: [
                    Statement.defer([
                        Statement.expression(.identifier("b"))
                    ]),
                    Statement.expression(.identifier("c")),
                ],
                else: [
                    Statement.defer([
                        Statement.expression(.identifier("d"))
                    ]),
                    Statement.expression(.identifier("e")),
                ]
            ),
            Statement.expression(.identifier("f")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="a"]
                    n4 [label="{if}"]
                    n5 [label="{compound}"]
                    n6 [label="{compound}"]
                    n7 [label="{exp}"]
                    n8 [label="{exp}"]
                    n9 [label="c"]
                    n10 [label="e"]
                    n11 [label="{defer}"]
                    n12 [label="{defer}"]
                    n13 [label="{compound}"]
                    n14 [label="{compound}"]
                    n15 [label="{exp}"]
                    n16 [label="{exp}"]
                    n17 [label="b"]
                    n18 [label="d"]
                    n19 [label="{exp}"]
                    n20 [label="f"]
                    n21 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n8 -> n10
                    n9 -> n11
                    n10 -> n12
                    n11 -> n13
                    n12 -> n14
                    n13 -> n15
                    n14 -> n16
                    n15 -> n17
                    n16 -> n18
                    n17 -> n19
                    n18 -> n19
                    n19 -> n20
                    n20 -> n21
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDeferStatement_inLoop() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("a"),
                body: [
                    Statement.defer([
                        Statement.expression(.identifier("b"))
                    ]),
                    Statement.expression(.identifier("c")),
                ]
            ),
            Statement.expression(.identifier("d")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="a"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="{exp}"]
                    n7 [label="{exp}"]
                    n8 [label="d"]
                    n9 [label="c"]
                    n10 [label="{defer}"]
                    n11 [label="{compound}"]
                    n12 [label="{exp}"]
                    n13 [label="b"]
                    n14 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n8 -> n14
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n12 -> n13
                    n13 -> n3 [color="#aa3333", penwidth=0.5]
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDeferStatement_inLoopWithBreak() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("a"),
                body: [
                    Statement.defer([
                        Statement.expression(.identifier("b"))
                    ]),
                    Statement.expression(.identifier("c")),
                    Statement.break(),
                ]
            ),
            Statement.expression(.identifier("d")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="a"]
                    n4 [label="{while}"]
                    n5 [label="{compound}"]
                    n6 [label="{exp}"]
                    n7 [label="{exp}"]
                    n8 [label="d"]
                    n9 [label="c"]
                    n10 [label="{break}"]
                    n11 [label="{defer}"]
                    n12 [label="{compound}"]
                    n13 [label="{exp}"]
                    n14 [label="b"]
                    n15 [label="{defer}"]
                    n16 [label="{compound}"]
                    n17 [label="{exp}"]
                    n18 [label="b"]
                    n19 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n8 -> n19
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n12 -> n13
                    n13 -> n14
                    n14 -> n6
                    n15 -> n16
                    n16 -> n17
                    n17 -> n18
                    n18 -> n3
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDeferStatement_inRepeatWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.repeatWhile(
                .identifier("predicate"),
                body: [
                    .defer([
                        .expression(.identifier("defer"))
                    ]),
                    .expression(.identifier("loopBody")),
                ]
            ),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{compound}"]
                    n4 [label="{exp}"]
                    n5 [label="loopBody"]
                    n6 [label="{defer}"]
                    n7 [label="{compound}"]
                    n8 [label="{exp}"]
                    n9 [label="defer"]
                    n10 [label="predicate"]
                    n11 [label="{repeat-while}"]
                    n12 [label="exit"]
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
                    n11 -> n3 [color="#aa3333", penwidth=0.5]
                    n11 -> n12
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDeferStatement_interwoven() {
        let stmt: CompoundStatement = [
            Statement.defer([
                Statement.expression(.identifier("a"))
            ]),
            Statement.expression(.identifier("b")),
            Statement.if(
                .identifier("predicate"),
                body: [
                    .return(.constant(0))
                ]
            ),
            Statement.defer([
                Statement.expression(.identifier("c"))
            ]),
            Statement.expression(.identifier("d")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="{compound}"]
                    n3 [label="{exp}"]
                    n4 [label="b"]
                    n5 [label="predicate"]
                    n6 [label="{if}"]
                    n7 [label="{compound}"]
                    n8 [label="{exp}"]
                    n9 [label="0"]
                    n10 [label="d"]
                    n11 [label="{return 0}"]
                    n12 [label="{defer}"]
                    n13 [label="{defer}"]
                    n14 [label="{compound}"]
                    n15 [label="{compound}"]
                    n16 [label="{exp}"]
                    n17 [label="{exp}"]
                    n18 [label="c"]
                    n19 [label="c"]
                    n20 [label="{defer}"]
                    n21 [label="{defer}"]
                    n22 [label="{compound}"]
                    n23 [label="{compound}"]
                    n24 [label="{exp}"]
                    n25 [label="{exp}"]
                    n26 [label="a"]
                    n27 [label="a"]
                    n28 [label="exit"]
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
                    n13 -> n15
                    n14 -> n16
                    n15 -> n17
                    n16 -> n18
                    n17 -> n19
                    n18 -> n20
                    n19 -> n21
                    n20 -> n22
                    n21 -> n23
                    n22 -> n24
                    n23 -> n25
                    n24 -> n26
                    n25 -> n27
                    n26 -> n28
                    n27 -> n28
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testDeferStatement_orderingOnJumps() {
        let stmt: CompoundStatement = [
            .do([
                .defer([
                    .expression(.identifier("defer_a")),
                ]),
                .defer([
                    .expression(.identifier("defer_b")),
                ]),
                .throw(.identifier("Error")),
            ]).catch([
                .expression(.identifier("errorHandler")),
            ]),
            .expression(.identifier("postDo")),
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
                    n5 [label="Error"]
                    n6 [label="{throw Error}"]
                    n7 [label="{defer}"]
                    n8 [label="{compound}"]
                    n9 [label="{exp}"]
                    n10 [label="defer_b"]
                    n11 [label="{defer}"]
                    n12 [label="{compound}"]
                    n13 [label="{exp}"]
                    n14 [label="defer_a"]
                    n15 [label="{catch}"]
                    n16 [label="{compound}"]
                    n17 [label="{exp}"]
                    n18 [label="errorHandler"]
                    n19 [label="{exp}"]
                    n20 [label="postDo"]
                    n21 [label="{defer}"]
                    n22 [label="{compound}"]
                    n23 [label="{exp}"]
                    n24 [label="defer_b"]
                    n25 [label="{defer}"]
                    n26 [label="{compound}"]
                    n27 [label="{exp}"]
                    n28 [label="defer_a"]
                    n29 [label="exit"]
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
                    n20 -> n29
                    n21 -> n22
                    n22 -> n23
                    n23 -> n24
                    n24 -> n25
                    n25 -> n26
                    n26 -> n27
                    n27 -> n28
                    n28 -> n19
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
}
