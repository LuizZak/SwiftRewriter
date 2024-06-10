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
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (2)"]
                    n4 [label="exp (3)"]
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (2)"]
                    n4 [label="exp1 (3)"]
                    n5 [label="{exp} (4)"]
                    n6 [label="exp2 (5)"]
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
                    n2 [label="{compound} (1)"]
                    n3 [label="var v1: Int (2)"]
                    n4 [label="v1: Int (3)"]
                    n5 [label="var v2: Int (4)"]
                    n6 [label="v2: Int (5)"]
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
                    n2 [label="{compound} (1)"]
                    n3 [label="var v1: Int, var v2: Int (2)"]
                    n4 [label="a (3)"]
                    n5 [label="v1: Int = a (4)"]
                    n6 [label="b (5)"]
                    n7 [label="v2: Int = b (6)"]
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
                    n2 [label="{compound} (1)"]
                    n3 [label="var v1: Int (2)"]
                    n4 [label="a (3)"]
                    n5 [label="v1: Int = a (4)"]
                    n6 [label="var v2: Int (5)"]
                    n7 [label="v2: Int (6)"]
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{do} (2)"]
                    n4 [label="{compound} (3)"]
                    n5 [label="{exp} (4)"]
                    n6 [label="exp (5)"]
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
                    n2 [label="{compound} (1)"]
                    n3 [label="predicate (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="{do} (5)"]
                    n7 [label="{compound} (6)"]
                    n8 [label="{exp} (7)"]
                    n9 [label="a (8)"]
                    n10 [label="{break doLabel} (9)"]
                    n11 [label="{exp} (10)"]
                    n12 [label="b (11)"]
                    n13 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n10 -> n3 [color="#aa3333", penwidth=0.5]
                    n12 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                    n11 -> n12
                    n4 -> n13
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (2)"]
                    n4 [label="preDo (3)"]
                    n5 [label="{do} (4)"]
                    n6 [label="{compound} (5)"]
                    n7 [label="{exp} (6)"]
                    n8 [label="preError (7)"]
                    n9 [label="Error (8)"]
                    n10 [label="{throw Error} (9)"]
                    n11 [label="{catch} (12)"]
                    n12 [label="{compound} (13)"]
                    n13 [label="{exp} (14)"]
                    n14 [label="errorHandler (15)"]
                    n15 [label="{exp} (16)"]
                    n16 [label="end (17)"]
                    n17 [label="{exp} (10)"]
                    n18 [label="postError (11)"]
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
                    n18 -> n15
                    n15 -> n16
                    n17 -> n18
                    n16 -> n19
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{do} (2)"]
                    n4 [label="{compound} (3)"]
                    n5 [label="{exp} (4)"]
                    n6 [label="preError (5)"]
                    n7 [label="a (6)"]
                    n8 [label="{if} (7)"]
                    n9 [label="{compound} (8)"]
                    n10 [label="{exp} (11)"]
                    n11 [label="Error (9)"]
                    n12 [label="postError (12)"]
                    n13 [label="{throw Error} (10)"]
                    n14 [label="{exp} (17)"]
                    n15 [label="{catch} (13)"]
                    n16 [label="end (18)"]
                    n17 [label="{compound} (14)"]
                    n18 [label="{exp} (15)"]
                    n19 [label="errorHandler (16)"]
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
                    n19 -> n14
                    n13 -> n15
                    n14 -> n16
                    n15 -> n17
                    n17 -> n18
                    n18 -> n19
                    n16 -> n20
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (2)"]
                    n4 [label="preDo (3)"]
                    n5 [label="{do} (4)"]
                    n6 [label="{compound} (5)"]
                    n7 [label="{exp} (6)"]
                    n8 [label="preError (7)"]
                    n9 [label="{do} (8)"]
                    n10 [label="{compound} (9)"]
                    n11 [label="Error (10)"]
                    n12 [label="{throw Error} (11)"]
                    n13 [label="{catch} (14)"]
                    n14 [label="{compound} (15)"]
                    n15 [label="{exp} (16)"]
                    n16 [label="errorHandler (17)"]
                    n17 [label="{exp} (18)"]
                    n18 [label="end (19)"]
                    n19 [label="{exp} (12)"]
                    n20 [label="postError (13)"]
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
                    n20 -> n17
                    n17 -> n18
                    n19 -> n20
                    n18 -> n21
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (2)"]
                    n4 [label="preDo (3)"]
                    n5 [label="{do} (4)"]
                    n6 [label="{compound} (5)"]
                    n7 [label="{exp} (6)"]
                    n8 [label="preError (7)"]
                    n9 [label="Error (8)"]
                    n10 [label="{throw Error} (9)"]
                    n11 [label="{catch} (12)"]
                    n12 [label="{compound} (13)"]
                    n13 [label="{exp} (14)"]
                    n14 [label="errorHandler 1 (15)"]
                    n15 [label="{exp} (20)"]
                    n16 [label="end (21)"]
                    n17 [label="{catch} (16)"]
                    n18 [label="{compound} (17)"]
                    n19 [label="{exp} (10)"]
                    n20 [label="{exp} (18)"]
                    n21 [label="errorHandler 2 (19)"]
                    n22 [label="postError (11)"]
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
                    n21 -> n15
                    n22 -> n15
                    n15 -> n16
                    n17 -> n18
                    n18 -> n20
                    n20 -> n21
                    n19 -> n22
                    n16 -> n23
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{do} (2)"]
                    n4 [label="{compound} (3)"]
                    n5 [label="{exp} (4)"]
                    n6 [label="a (5)"]
                    n7 [label="{exp} (10)"]
                    n8 [label="c (11)"]
                    n9 [label="{catch} (6)"]
                    n10 [label="{compound} (7)"]
                    n11 [label="{exp} (8)"]
                    n12 [label="b (9)"]
                    n13 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n12 -> n7
                    n7 -> n8
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n8 -> n13
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
                    n2 [label="{compound} (1)"]
                    n3 [label="predicate (2)"]
                    n4 [label="{if} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="{exp} (5)"]
                    n7 [label="ifBody (6)"]
                    n8 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n4 -> n8
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
                    n2 [label="{compound} (1)"]
                    n3 [label="predicate (2)"]
                    n4 [label="{if} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="{compound} (7)"]
                    n7 [label="{exp} (5)"]
                    n8 [label="{exp} (8)"]
                    n9 [label="elseBody (9)"]
                    n10 [label="ifBody (6)"]
                    n11 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n8 -> n9
                    n7 -> n10
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
                    n2 [label="{compound} (1)"]
                    n3 [label="predicate (2)"]
                    n4 [label="{if} (3)"]
                    n5 [label="{compound} (7)"]
                    n6 [label="{compound} (4)"]
                    n7 [label="predicate2 (8)"]
                    n8 [label="{exp} (5)"]
                    n9 [label="{if} (9)"]
                    n10 [label="ifBody (6)"]
                    n11 [label="{compound} (10)"]
                    n12 [label="{compound} (13)"]
                    n13 [label="{exp} (11)"]
                    n14 [label="{exp} (14)"]
                    n15 [label="ifElseIfBody (12)"]
                    n16 [label="ifElseIfElseBody (15)"]
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
                    n11 -> n13
                    n12 -> n14
                    n13 -> n15
                    n14 -> n16
                    n10 -> n17
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
                    n2 [label="{compound} (1)"]
                    n3 [label="whilePredicate (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="predicate (5)"]
                    n7 [label="{if} (6)"]
                    n8 [label="{compound} (7)"]
                    n9 [label="predicateInner (8)"]
                    n10 [label="{if} (9)"]
                    n11 [label="{compound} (10)"]
                    n12 [label="{break outer} (11)"]
                    n13 [label="{exp} (12)"]
                    n14 [label="postBreak (13)"]
                    n15 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n7 -> n3 [color="#aa3333", penwidth=0.5]
                    n10 -> n3 [color="#aa3333", penwidth=0.5]
                    n12 -> n3 [color="#aa3333", penwidth=0.5]
                    n14 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n13 -> n14
                    n4 -> n15
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
                    n2 [label="{compound} (1)"]
                    n3 [label="switchExp (2)"]
                    n4 [label="{switch} (3)"]
                    n5 [label="{case patternA} (4)"]
                    n6 [label="{case patternB} (9)"]
                    n7 [label="{compound} (6)"]
                    n8 [label="{compound} (11)"]
                    n9 [label="{exp} (7)"]
                    n10 [label="{exp} (12)"]
                    n11 [label="case1 (8)"]
                    n12 [label="case2 (13)"]
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
                    n2 [label="{compound} (1)"]
                    n3 [label="switchExp (2)"]
                    n4 [label="{switch} (3)"]
                    n5 [label="{case patternA} (4)"]
                    n6 [label="{case patternB} (9)"]
                    n7 [label="{compound} (6)"]
                    n8 [label="{case patternC} (14)"]
                    n9 [label="{compound} (11)"]
                    n10 [label="{exp} (7)"]
                    n11 [label="{case patternD} (19)"]
                    n12 [label="{compound} (16)"]
                    n13 [label="{exp} (12)"]
                    n14 [label="b (8)"]
                    n15 [label="{default} (27)"]
                    n16 [label="{compound} (21)"]
                    n17 [label="{exp} (17)"]
                    n18 [label="c (13)"]
                    n19 [label="{compound} (24)"]
                    n20 [label="{exp} (22)"]
                    n21 [label="d (18)"]
                    n22 [label="{exp} (25)"]
                    n23 [label="e (23)"]
                    n24 [label="defaultCase (26)"]
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
                    n15 -> n19
                    n16 -> n20
                    n17 -> n21
                    n19 -> n22
                    n20 -> n23
                    n22 -> n24
                    n14 -> n25
                    n18 -> n25
                    n21 -> n25
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
                    n2 [label="{compound} (1)"]
                    n3 [label="a (2)"]
                    n4 [label="{switch} (3)"]
                    n5 [label="{case b} (4)"]
                    n6 [label="{case c} (7)"]
                    n7 [label="{compound} (6)"]
                    n8 [label="{case d} (10)"]
                    n9 [label="{compound} (9)"]
                    n10 [label="{default} (14)"]
                    n11 [label="{compound} (12)"]
                    n12 [label="{compound} (13)"]
                    n13 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n8
                    n6 -> n9
                    n8 -> n10
                    n8 -> n11
                    n10 -> n12
                    n7 -> n13
                    n9 -> n13
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
                    n2 [label="{compound} (1)"]
                    n3 [label="a (2)"]
                    n4 [label="{switch} (3)"]
                    n5 [label="{case b} (4)"]
                    n6 [label="{compound} (6)"]
                    n7 [label="{case c} (8)"]
                    n8 [label="{case d} (11)"]
                    n9 [label="{fallthrough} (7)"]
                    n10 [label="{compound} (10)"]
                    n11 [label="{default} (15)"]
                    n12 [label="{compound} (13)"]
                    n13 [label="{compound} (14)"]
                    n14 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n7 -> n8
                    n6 -> n9
                    n7 -> n10
                    n9 -> n10
                    n8 -> n11
                    n8 -> n12
                    n11 -> n13
                    n10 -> n14
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
                    n2 [label="{compound} (1)"]
                    n3 [label="switchExp (2)"]
                    n4 [label="{switch} (3)"]
                    n5 [label="{case []} (4)"]
                    n6 [label="{compound} (6)"]
                    n7 [label="{case []} (10)"]
                    n8 [label="{exp} (7)"]
                    n9 [label="{default} (18)"]
                    n10 [label="{compound} (12)"]
                    n11 [label="b (8)"]
                    n12 [label="{compound} (15)"]
                    n13 [label="{exp} (13)"]
                    n14 [label="{fallthrough} (9)"]
                    n15 [label="{exp} (16)"]
                    n16 [label="c (14)"]
                    n17 [label="defaultExp (17)"]
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
                    n14 -> n10
                    n8 -> n11
                    n9 -> n12
                    n10 -> n13
                    n11 -> n14
                    n12 -> n15
                    n13 -> n16
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
                    n2 [label="{compound} (1)"]
                    n3 [label="switchExp (2)"]
                    n4 [label="{switch} (3)"]
                    n5 [label="{case []} (4)"]
                    n6 [label="{compound} (6)"]
                    n7 [label="{default} (30)"]
                    n8 [label="{exp} (7)"]
                    n9 [label="{compound} (27)"]
                    n10 [label="b (8)"]
                    n11 [label="{exp} (28)"]
                    n12 [label="predicate (13)"]
                    n13 [label="defaultExp (29)"]
                    n14 [label="{if} (14)"]
                    n15 [label="{compound} (15)"]
                    n16 [label="{exp} (17)"]
                    n17 [label="d (18)"]
                    n18 [label="{break} (16)"]
                    n19 [label="{defer} (19)"]
                    n20 [label="{defer} (23)"]
                    n21 [label="{compound} (20)"]
                    n22 [label="{compound} (24)"]
                    n23 [label="{exp} (21)"]
                    n24 [label="{exp} (25)"]
                    n25 [label="c (22)"]
                    n26 [label="c (26)"]
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
                    n14 -> n15
                    n14 -> n16
                    n16 -> n17
                    n15 -> n18
                    n17 -> n19
                    n18 -> n20
                    n19 -> n21
                    n20 -> n22
                    n21 -> n23
                    n22 -> n24
                    n23 -> n25
                    n24 -> n26
                    n13 -> n27
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
                    n2 [label="{compound} (1)"]
                    n3 [label="switchExp (2)"]
                    n4 [label="{switch} (3)"]
                    n5 [label="{case b} (4)"]
                    n6 [label="{compound} (6)"]
                    n7 [label="{case f} (39)"]
                    n8 [label="{exp} (7)"]
                    n9 [label="{default} (47)"]
                    n10 [label="{compound} (41)"]
                    n11 [label="c (8)"]
                    n12 [label="{compound} (44)"]
                    n13 [label="{exp} (42)"]
                    n14 [label="predicateFallthrough (13)"]
                    n15 [label="{exp} (45)"]
                    n16 [label="g (43)"]
                    n17 [label="{if} (14)"]
                    n18 [label="defaultExp (46)"]
                    n19 [label="{compound} (15)"]
                    n20 [label="{exp} (17)"]
                    n21 [label="{fallthrough} (16)"]
                    n22 [label="e (18)"]
                    n23 [label="{defer} (31)"]
                    n24 [label="{defer} (23)"]
                    n25 [label="{compound} (32)"]
                    n26 [label="{compound} (24)"]
                    n27 [label="{exp} (33)"]
                    n28 [label="{exp} (25)"]
                    n29 [label="deferredExp (34)"]
                    n30 [label="deferredExp (26)"]
                    n31 [label="{defer} (35)"]
                    n32 [label="{defer} (27)"]
                    n33 [label="{compound} (36)"]
                    n34 [label="{compound} (28)"]
                    n35 [label="{exp} (37)"]
                    n36 [label="{exp} (29)"]
                    n37 [label="d (38)"]
                    n38 [label="d (30)"]
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
                    n37 -> n10
                    n8 -> n11
                    n9 -> n12
                    n10 -> n13
                    n11 -> n14
                    n12 -> n15
                    n13 -> n16
                    n14 -> n17
                    n15 -> n18
                    n17 -> n19
                    n17 -> n20
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
                    n16 -> n39
                    n18 -> n39
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
                    n2 [label="{compound} (1)"]
                    n3 [label="switchExp (2)"]
                    n4 [label="{switch} (3)"]
                    n5 [label="{case []} (4)"]
                    n6 [label="{compound} (6)"]
                    n7 [label="{case []} (53)"]
                    n8 [label="{exp} (7)"]
                    n9 [label="{default} (61)"]
                    n10 [label="{compound} (55)"]
                    n11 [label="b (8)"]
                    n12 [label="{compound} (58)"]
                    n13 [label="{exp} (56)"]
                    n14 [label="predicateFallthrough (13)"]
                    n15 [label="{exp} (59)"]
                    n16 [label="g (57)"]
                    n17 [label="{if} (14)"]
                    n18 [label="defaultExp (60)"]
                    n19 [label="{compound} (15)"]
                    n20 [label="{exp} (19)"]
                    n21 [label="{exp} (16)"]
                    n22 [label="e (20)"]
                    n23 [label="d (17)"]
                    n24 [label="predicateReturn (21)"]
                    n25 [label="{fallthrough} (18)"]
                    n26 [label="{if} (22)"]
                    n27 [label="{defer} (37)"]
                    n28 [label="{compound} (23)"]
                    n29 [label="{defer} (29)"]
                    n30 [label="{compound} (38)"]
                    n31 [label="{return} (24)"]
                    n32 [label="{compound} (30)"]
                    n33 [label="{exp} (39)"]
                    n34 [label="{defer} (45)"]
                    n35 [label="{exp} (31)"]
                    n36 [label="f (40)"]
                    n37 [label="{compound} (46)"]
                    n38 [label="f (32)"]
                    n39 [label="{defer} (41)"]
                    n40 [label="{exp} (47)"]
                    n41 [label="{defer} (33)"]
                    n42 [label="{compound} (42)"]
                    n43 [label="f (48)"]
                    n44 [label="{compound} (34)"]
                    n45 [label="{exp} (43)"]
                    n46 [label="{defer} (49)"]
                    n47 [label="{exp} (35)"]
                    n48 [label="deferredExp (44)"]
                    n49 [label="{compound} (50)"]
                    n50 [label="deferredExp (36)"]
                    n51 [label="{exp} (51)"]
                    n52 [label="deferredExp (52)"]
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
                    n48 -> n10
                    n8 -> n11
                    n9 -> n12
                    n10 -> n13
                    n11 -> n14
                    n12 -> n15
                    n13 -> n16
                    n14 -> n17
                    n15 -> n18
                    n17 -> n19
                    n17 -> n20
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
                    n49 -> n51
                    n51 -> n52
                    n16 -> n53
                    n18 -> n53
                    n50 -> n53
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
                    n2 [label="{compound} (1)"]
                    n3 [label="predicate (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="{exp} (5)"]
                    n7 [label="loopBody (6)"]
                    n8 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n7 -> n3 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n4 -> n8
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
                    n2 [label="{compound} (1)"]
                    n3 [label="predicate (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n5 -> n3 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
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
                    n2 [label="{compound} (1)"]
                    n3 [label="predicate (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="predicateInner (5)"]
                    n7 [label="{while} (6)"]
                    n8 [label="{compound} (7)"]
                    n9 [label="{continue outer} (8)"]
                    n10 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n7 -> n3 [color="#aa3333", penwidth=0.5]
                    n9 -> n3 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n4 -> n10
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
                    n2 [label="{compound} (1)"]
                    n3 [label="predicate (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="predicateInner (5)"]
                    n7 [label="{while} (6)"]
                    n8 [label="{compound} (7)"]
                    n9 [label="{break outer} (8)"]
                    n10 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n7 -> n3 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n4 -> n10
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
                    n2 [label="{compound} (1)"]
                    n3 [label="whilePredicate (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="ifPredicate (5)"]
                    n7 [label="{if} (6)"]
                    n8 [label="{compound} (9)"]
                    n9 [label="{compound} (7)"]
                    n10 [label="{exp} (10)"]
                    n11 [label="{break} (8)"]
                    n12 [label="preContinue (11)"]
                    n13 [label="{continue} (12)"]
                    n14 [label="{exp} (13)"]
                    n15 [label="postIf (14)"]
                    n16 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n13 -> n3 [color="#aa3333", penwidth=0.5]
                    n15 -> n3
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
                    n14 -> n15
                    n4 -> n16
                    n11 -> n16
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{compound} (2)"]
                    n4 [label="{exp} (3)"]
                    n5 [label="loopBody (4)"]
                    n6 [label="predicate (5)"]
                    n7 [label="{repeat-while} (6)"]
                    n8 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n7 -> n3 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{compound} (2)"]
                    n4 [label="predicate (3)"]
                    n5 [label="{repeat-while} (4)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n5 -> n3 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
                    n4 -> n5
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{compound} (2)"]
                    n4 [label="predicateInner (3)"]
                    n5 [label="{while} (4)"]
                    n6 [label="{compound} (5)"]
                    n7 [label="predicate (7)"]
                    n8 [label="{continue outer} (6)"]
                    n9 [label="{repeat-while} (8)"]
                    n10 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n9 -> n3 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n8 -> n7
                    n6 -> n8
                    n7 -> n9
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{compound} (2)"]
                    n4 [label="predicateInner (3)"]
                    n5 [label="{while} (4)"]
                    n6 [label="predicate (7)"]
                    n7 [label="{compound} (5)"]
                    n8 [label="{break outer} (6)"]
                    n9 [label="{repeat-while} (8)"]
                    n10 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n9 -> n3 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n7 -> n8
                    n6 -> n9
                    n8 -> n10
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{compound} (2)"]
                    n4 [label="{break} (3)"]
                    n5 [label="predicate (4)"]
                    n6 [label="{repeat-while} (5)"]
                    n7 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n6 -> n3
                    n3 -> n4
                    n5 -> n6
                    n4 -> n7
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
                    n2 [label="{compound} (1)"]
                    n3 [label="i (2)"]
                    n4 [label="{for} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="{exp} (5)"]
                    n7 [label="b (6)"]
                    n8 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n7 -> n4 [color="#aa3333", penwidth=0.5]
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n4 -> n8
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
                    n2 [label="{compound} (1)"]
                    n3 [label="i (2)"]
                    n4 [label="{for} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n5 -> n4 [color="#aa3333", penwidth=0.5]
                    n4 -> n5
                    n4 -> n6
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
                    n2 [label="{compound} (1)"]
                    n3 [label="i (2)"]
                    n4 [label="{for} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="predicateInner (5)"]
                    n7 [label="{while} (6)"]
                    n8 [label="{compound} (7)"]
                    n9 [label="{continue outer} (8)"]
                    n10 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n7 -> n4 [color="#aa3333", penwidth=0.5]
                    n9 -> n4 [color="#aa3333", penwidth=0.5]
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n4 -> n10
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
                    n2 [label="{compound} (1)"]
                    n3 [label="i (2)"]
                    n4 [label="{for} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="predicateInner (5)"]
                    n7 [label="{while} (6)"]
                    n8 [label="{compound} (7)"]
                    n9 [label="{break outer} (8)"]
                    n10 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n7 -> n4 [color="#aa3333", penwidth=0.5]
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n4 -> n10
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{return} (2)"]
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
                    n2 [label="{compound} (1)"]
                    n3 [label="exp (2)"]
                    n4 [label="{return exp} (3)"]
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
                    n2 [label="{compound} (1)"]
                    n3 [label="predicate (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="{return} (5)"]
                    n7 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n4 -> n7
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (2)"]
                    n4 [label="preReturn (3)"]
                    n5 [label="{return} (4)"]
                    n6 [label="{exp} (5)"]
                    n7 [label="postReturn (6)"]
                    n8 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n6 -> n7
                    n5 -> n8
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
                    n2 [label="{compound} (1)"]
                    n3 [label="predicate (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="Error (5)"]
                    n7 [label="{throw Error} (6)"]
                    n8 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n4 -> n8
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (2)"]
                    n4 [label="preError (3)"]
                    n5 [label="Error (4)"]
                    n6 [label="{throw Error} (5)"]
                    n7 [label="{exp} (6)"]
                    n8 [label="postError (7)"]
                    n9 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n7 -> n8
                    n6 -> n9
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (2)"]
                    n4 [label="preError (3)"]
                    n5 [label="a (4)"]
                    n6 [label="{if} (5)"]
                    n7 [label="{compound} (6)"]
                    n8 [label="{exp} (9)"]
                    n9 [label="Error (7)"]
                    n10 [label="postError (10)"]
                    n11 [label="{throw Error} (8)"]
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
                    n2 [label="{compound} (1)"]
                    n3 [label="v (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="{break} (5)"]
                    n7 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n4 -> n7
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
                    n2 [label="{compound} (1)"]
                    n3 [label="a (2)"]
                    n4 [label="{for} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="{exp} (24)"]
                    n7 [label="b (5)"]
                    n8 [label="b (25)"]
                    n9 [label="{while} (6)"]
                    n10 [label="{compound} (7)"]
                    n11 [label="predicate (12)"]
                    n12 [label="{if} (13)"]
                    n13 [label="{defer} (16)"]
                    n14 [label="{compound} (14)"]
                    n15 [label="{compound} (17)"]
                    n16 [label="{break outer} (15)"]
                    n17 [label="{exp} (18)"]
                    n18 [label="{defer} (20)"]
                    n19 [label="deferred (19)"]
                    n20 [label="{compound} (21)"]
                    n21 [label="{exp} (22)"]
                    n22 [label="deferred (23)"]
                    n23 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n9 -> n4 [color="#aa3333", penwidth=0.5]
                    n4 -> n5
                    n4 -> n6
                    n22 -> n6
                    n5 -> n7
                    n19 -> n7 [color="#aa3333", penwidth=0.5]
                    n6 -> n8
                    n7 -> n9
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
                    n20 -> n21
                    n21 -> n22
                    n8 -> n23
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
                    n2 [label="{compound} (1)"]
                    n3 [label="v (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="{continue} (5)"]
                    n7 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n6 -> n3 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n4 -> n7
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
                    n2 [label="{compound} (1)"]
                    n3 [label="v (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="{continue} (5)"]
                    n7 [label="{exp} (6)"]
                    n8 [label="v (7)"]
                    n9 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n6 -> n3 [color="#aa3333", penwidth=0.5]
                    n8 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n7 -> n8
                    n4 -> n9
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
                    n2 [label="{compound} (1)"]
                    n3 [label="a (2)"]
                    n4 [label="{for} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="b (5)"]
                    n7 [label="{while} (6)"]
                    n8 [label="{compound} (7)"]
                    n9 [label="predicate (12)"]
                    n10 [label="{if} (13)"]
                    n11 [label="{compound} (14)"]
                    n12 [label="{defer} (16)"]
                    n13 [label="{compound} (17)"]
                    n14 [label="{continue outer} (15)"]
                    n15 [label="{defer} (20)"]
                    n16 [label="{exp} (18)"]
                    n17 [label="deferred (19)"]
                    n18 [label="{compound} (21)"]
                    n19 [label="{exp} (22)"]
                    n20 [label="deferred (23)"]
                    n21 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n7 -> n4 [color="#aa3333", penwidth=0.5]
                    n20 -> n4 [color="#aa3333", penwidth=0.5]
                    n4 -> n5
                    n5 -> n6
                    n17 -> n6 [color="#aa3333", penwidth=0.5]
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                    n10 -> n11
                    n10 -> n12
                    n12 -> n13
                    n11 -> n14
                    n14 -> n15
                    n13 -> n16
                    n16 -> n17
                    n15 -> n18
                    n18 -> n19
                    n19 -> n20
                    n4 -> n21
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (8)"]
                    n4 [label="c (9)"]
                    n5 [label="{defer} (10)"]
                    n6 [label="{compound} (11)"]
                    n7 [label="{exp} (12)"]
                    n8 [label="a (13)"]
                    n9 [label="{exp} (14)"]
                    n10 [label="b (15)"]
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (2)"]
                    n4 [label="a (3)"]
                    n5 [label="{do} (4)"]
                    n6 [label="{compound} (5)"]
                    n7 [label="predicate (10)"]
                    n8 [label="{if} (11)"]
                    n9 [label="{compound} (12)"]
                    n10 [label="{exp} (15)"]
                    n11 [label="error (13)"]
                    n12 [label="c (16)"]
                    n13 [label="{throw error} (14)"]
                    n14 [label="{defer} (17)"]
                    n15 [label="{defer} (21)"]
                    n16 [label="{compound} (18)"]
                    n17 [label="{compound} (22)"]
                    n18 [label="{exp} (19)"]
                    n19 [label="{exp} (23)"]
                    n20 [label="b (20)"]
                    n21 [label="b (24)"]
                    n22 [label="{catch} (25)"]
                    n23 [label="{compound} (26)"]
                    n24 [label="{exp} (27)"]
                    n25 [label="d (28)"]
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
                    n21 -> n22
                    n22 -> n23
                    n23 -> n24
                    n24 -> n25
                    n20 -> n26
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
                    n2 [label="{compound} (1)"]
                    n3 [label="a (2)"]
                    n4 [label="{if} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="{exp} (19)"]
                    n7 [label="{exp} (11)"]
                    n8 [label="e (20)"]
                    n9 [label="d (12)"]
                    n10 [label="{defer} (13)"]
                    n11 [label="{compound} (14)"]
                    n12 [label="{exp} (15)"]
                    n13 [label="b (16)"]
                    n14 [label="{exp} (17)"]
                    n15 [label="c (18)"]
                    n16 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n15 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n12 -> n13
                    n13 -> n14
                    n14 -> n15
                    n8 -> n16
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
                    n2 [label="{compound} (1)"]
                    n3 [label="a (2)"]
                    n4 [label="{if} (3)"]
                    n5 [label="{compound} (15)"]
                    n6 [label="{compound} (4)"]
                    n7 [label="{exp} (20)"]
                    n8 [label="{exp} (9)"]
                    n9 [label="c (10)"]
                    n10 [label="e (21)"]
                    n11 [label="{defer} (11)"]
                    n12 [label="{defer} (22)"]
                    n13 [label="{compound} (12)"]
                    n14 [label="{compound} (23)"]
                    n15 [label="{exp} (13)"]
                    n16 [label="{exp} (24)"]
                    n17 [label="b (14)"]
                    n18 [label="d (25)"]
                    n19 [label="{exp} (26)"]
                    n20 [label="f (27)"]
                    n21 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n8 -> n9
                    n7 -> n10
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
                    n2 [label="{compound} (1)"]
                    n3 [label="a (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="{exp} (15)"]
                    n7 [label="{exp} (9)"]
                    n8 [label="d (16)"]
                    n9 [label="c (10)"]
                    n10 [label="{defer} (11)"]
                    n11 [label="{compound} (12)"]
                    n12 [label="{exp} (13)"]
                    n13 [label="b (14)"]
                    n14 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n13 -> n3 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n12 -> n13
                    n8 -> n14
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
                    n2 [label="{compound} (1)"]
                    n3 [label="a (2)"]
                    n4 [label="{while} (3)"]
                    n5 [label="{compound} (4)"]
                    n6 [label="{exp} (20)"]
                    n7 [label="{exp} (9)"]
                    n8 [label="d (21)"]
                    n9 [label="c (10)"]
                    n10 [label="{break} (11)"]
                    n11 [label="{defer} (16)"]
                    n12 [label="{compound} (17)"]
                    n13 [label="{exp} (18)"]
                    n14 [label="b (19)"]
                    n15 [label="{defer} (12)"]
                    n16 [label="{compound} (13)"]
                    n17 [label="{exp} (14)"]
                    n18 [label="b (15)"]
                    n19 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n18 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n14 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n12 -> n13
                    n13 -> n14
                    n15 -> n16
                    n16 -> n17
                    n17 -> n18
                    n8 -> n19
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{compound} (2)"]
                    n4 [label="{exp} (7)"]
                    n5 [label="loopBody (8)"]
                    n6 [label="{defer} (9)"]
                    n7 [label="{compound} (10)"]
                    n8 [label="{exp} (11)"]
                    n9 [label="defer (12)"]
                    n10 [label="predicate (13)"]
                    n11 [label="{repeat-while} (14)"]
                    n12 [label="exit"]
                
                    n1 -> n2
                    n2 -> n3
                    n11 -> n3 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n9
                    n9 -> n10
                    n10 -> n11
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{exp} (6)"]
                    n4 [label="b (7)"]
                    n5 [label="predicate (8)"]
                    n6 [label="{if} (9)"]
                    n7 [label="{compound} (10)"]
                    n8 [label="{exp} (17)"]
                    n9 [label="0 (11)"]
                    n10 [label="d (18)"]
                    n11 [label="{return 0} (12)"]
                    n12 [label="{defer} (19)"]
                    n13 [label="{defer} (27)"]
                    n14 [label="{compound} (20)"]
                    n15 [label="{compound} (28)"]
                    n16 [label="{exp} (21)"]
                    n17 [label="{exp} (29)"]
                    n18 [label="c (22)"]
                    n19 [label="c (30)"]
                    n20 [label="{defer} (23)"]
                    n21 [label="{defer} (31)"]
                    n22 [label="{compound} (24)"]
                    n23 [label="{compound} (32)"]
                    n24 [label="{exp} (25)"]
                    n25 [label="{exp} (33)"]
                    n26 [label="a (26)"]
                    n27 [label="a (34)"]
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
                    n2 [label="{compound} (1)"]
                    n3 [label="{do} (2)"]
                    n4 [label="{compound} (3)"]
                    n5 [label="Error (12)"]
                    n6 [label="{throw Error} (13)"]
                    n7 [label="{defer} (22)"]
                    n8 [label="{compound} (23)"]
                    n9 [label="{exp} (24)"]
                    n10 [label="defer_b (25)"]
                    n11 [label="{defer} (26)"]
                    n12 [label="{compound} (27)"]
                    n13 [label="{exp} (28)"]
                    n14 [label="defer_a (29)"]
                    n15 [label="{catch} (30)"]
                    n16 [label="{compound} (31)"]
                    n17 [label="{exp} (32)"]
                    n18 [label="errorHandler (33)"]
                    n19 [label="{exp} (34)"]
                    n20 [label="postDo (35)"]
                    n21 [label="{defer} (14)"]
                    n22 [label="{compound} (15)"]
                    n23 [label="{exp} (16)"]
                    n24 [label="defer_b (17)"]
                    n25 [label="{defer} (18)"]
                    n26 [label="{compound} (19)"]
                    n27 [label="{exp} (20)"]
                    n28 [label="defer_a (21)"]
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
                    n28 -> n19
                    n19 -> n20
                    n21 -> n22
                    n22 -> n23
                    n23 -> n24
                    n24 -> n25
                    n25 -> n26
                    n26 -> n27
                    n27 -> n28
                    n20 -> n29
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
}
