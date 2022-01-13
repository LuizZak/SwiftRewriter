import SwiftAST
import TestCommons
import WriterTargetOutput
import XCTest

@testable import Analysis

class ControlFlowGraph_CreationStmtTests: XCTestCase {
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
                    n2 [label="{exp}"]
                    n3 [label="exp"]
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
                    n2 [label="{exp}"]
                    n3 [label="exp1"]
                    n4 [label="{exp}"]
                    n5 [label="exp2"]
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
                    n2 [label="var v1: Int"]
                    n3 [label="v1: Int"]
                    n4 [label="var v2: Int"]
                    n5 [label="v2: Int"]
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
                    n2 [label="var v1: Int, var v2: Int"]
                    n3 [label="a"]
                    n4 [label="v1: Int = a"]
                    n5 [label="b"]
                    n6 [label="v2: Int = b"]
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
                    n2 [label="var v1: Int"]
                    n3 [label="a"]
                    n4 [label="v1: Int = a"]
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
                    n2 [label="{do}"]
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
                    n2 [label="predicate"]
                    n3 [label="{while}"]
                    n4 [label="{do}"]
                    n5 [label="{exp}"]
                    n6 [label="a"]
                    n7 [label="{break doLabel}"]
                    n8 [label="{exp}"]
                    n9 [label="b"]
                    n10 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n10
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n2 [color="#aa3333", penwidth=0.5]
                    n8 -> n9
                    n9 -> n2
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
                    n2 [label="{exp}"]
                    n3 [label="preDo"]
                    n4 [label="{do}"]
                    n5 [label="{exp}"]
                    n6 [label="preError"]
                    n7 [label="Error"]
                    n8 [label="{throw Error}"]
                    n9 [label="{catch}"]
                    n10 [label="{exp}"]
                    n11 [label="errorHandler"]
                    n12 [label="{exp}"]
                    n13 [label="end"]
                    n14 [label="{exp}"]
                    n15 [label="postError"]
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
                    n13 -> n16
                    n14 -> n15
                    n15 -> n12
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
                    n2 [label="{do}"]
                    n3 [label="{exp}"]
                    n4 [label="preError"]
                    n5 [label="a"]
                    n6 [label="{if}"]
                    n7 [label="Error"]
                    n8 [label="{exp}"]
                    n9 [label="{throw Error}"]
                    n10 [label="postError"]
                    n11 [label="{catch}"]
                    n12 [label="{exp}"]
                    n13 [label="{exp}"]
                    n14 [label="end"]
                    n15 [label="errorHandler"]
                    n16 [label="exit"]
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
                    n15 -> n12
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
                    n2 [label="{exp}"]
                    n3 [label="preDo"]
                    n4 [label="{do}"]
                    n5 [label="{exp}"]
                    n6 [label="preError"]
                    n7 [label="{do}"]
                    n8 [label="Error"]
                    n9 [label="{throw Error}"]
                    n10 [label="{catch}"]
                    n11 [label="{exp}"]
                    n12 [label="errorHandler"]
                    n13 [label="{exp}"]
                    n14 [label="end"]
                    n15 [label="{exp}"]
                    n16 [label="postError"]
                    n17 [label="exit"]
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
                    n14 -> n17
                    n15 -> n16
                    n16 -> n13
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
                    n2 [label="{exp}"]
                    n3 [label="preDo"]
                    n4 [label="{do}"]
                    n5 [label="{exp}"]
                    n6 [label="preError"]
                    n7 [label="Error"]
                    n8 [label="{throw Error}"]
                    n9 [label="{catch}"]
                    n10 [label="{exp}"]
                    n11 [label="errorHandler 1"]
                    n12 [label="{exp}"]
                    n13 [label="end"]
                    n14 [label="{catch}"]
                    n15 [label="{exp}"]
                    n16 [label="{exp}"]
                    n17 [label="errorHandler 2"]
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
                    n13 -> n19
                    n14 -> n16
                    n15 -> n18
                    n16 -> n17
                    n17 -> n12
                    n18 -> n12
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
                    n2 [label="{do}"]
                    n3 [label="{exp}"]
                    n4 [label="a"]
                    n5 [label="{exp}"]
                    n6 [label="c"]
                    n7 [label="{catch}"]
                    n8 [label="{exp}"]
                    n9 [label="b"]
                    n10 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n10
                    n7 -> n8
                    n8 -> n9
                    n9 -> n5
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
            matches: #"""
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="predicate"]
                    n3 [label="{if}"]
                    n4 [label="{exp}"]
                    n5 [label="ifBody"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n6
                    n4 -> n5
                    n5 -> n6
                }
                """#
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
            matches: #"""
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="predicate"]
                    n3 [label="{if}"]
                    n4 [label="{exp}"]
                    n5 [label="{exp}"]
                    n6 [label="elseBody"]
                    n7 [label="ifBody"]
                    n8 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n7
                    n5 -> n6
                    n6 -> n8
                    n7 -> n8
                }
                """#
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
            matches: #"""
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="predicate"]
                    n3 [label="{if}"]
                    n4 [label="predicate2"]
                    n5 [label="{exp}"]
                    n6 [label="{if}"]
                    n7 [label="ifBody"]
                    n8 [label="{exp}"]
                    n9 [label="{exp}"]
                    n10 [label="ifElseIfBody"]
                    n11 [label="ifElseIfElseBody"]
                    n12 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n6 -> n9
                    n7 -> n12
                    n8 -> n10
                    n9 -> n11
                    n10 -> n12
                    n11 -> n12
                }
                """#
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
            matches: #"""
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="whilePredicate"]
                    n3 [label="{while}"]
                    n4 [label="predicate"]
                    n5 [label="{if}"]
                    n6 [label="predicateInner"]
                    n7 [label="{if}"]
                    n8 [label="{break outer}"]
                    n9 [label="{exp}"]
                    n10 [label="postBreak"]
                    n11 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n11
                    n4 -> n5
                    n5 -> n2 [color="#aa3333", penwidth=0.5]
                    n5 -> n6
                    n6 -> n7
                    n7 -> n2 [color="#aa3333", penwidth=0.5]
                    n7 -> n8
                    n8 -> n2 [color="#aa3333", penwidth=0.5]
                    n9 -> n10
                    n10 -> n2
                }
                """#
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
                    n2 [label="switchExp"]
                    n3 [label="{switch}"]
                    n4 [label="{case patternA}"]
                    n5 [label="{case patternB}"]
                    n6 [label="{exp}"]
                    n7 [label="{exp}"]
                    n8 [label="case1"]
                    n9 [label="case2"]
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
                    n9 -> n10
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
                    n2 [label="switchExp"]
                    n3 [label="{switch}"]
                    n4 [label="{case patternA}"]
                    n5 [label="{case patternB}"]
                    n6 [label="{exp}"]
                    n7 [label="{case patternC}"]
                    n8 [label="{exp}"]
                    n9 [label="b"]
                    n10 [label="{case patternD}"]
                    n11 [label="{exp}"]
                    n12 [label="c"]
                    n13 [label="{default}"]
                    n14 [label="{exp}"]
                    n15 [label="d"]
                    n16 [label="{exp}"]
                    n17 [label="e"]
                    n18 [label="defaultCase"]
                    n19 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n5 -> n8
                    n6 -> n9
                    n7 -> n10
                    n7 -> n11
                    n8 -> n12
                    n9 -> n19
                    n10 -> n13
                    n10 -> n14
                    n11 -> n15
                    n12 -> n19
                    n13 -> n16
                    n14 -> n17
                    n15 -> n19
                    n16 -> n18
                    n17 -> n19
                    n18 -> n19
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
                    n2 [label="a"]
                    n3 [label="{switch}"]
                    n4 [label="{case b}"]
                    n5 [label="{case c}"]
                    n6 [label="{case d}"]
                    n7 [label="{default}"]
                    n8 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n8
                    n5 -> n6
                    n5 -> n8
                    n6 -> n7
                    n6 -> n8
                    n7 -> n8
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
                    n2 [label="a"]
                    n3 [label="{switch}"]
                    n4 [label="{case b}"]
                    n5 [label="{case c}"]
                    n6 [label="{fallthrough}"]
                    n7 [label="{case d}"]
                    n8 [label="{default}"]
                    n9 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n5 -> n9
                    n6 -> n9
                    n7 -> n8
                    n7 -> n9
                    n8 -> n9
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 4)
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
                    n2 [label="switchExp"]
                    n3 [label="{switch}"]
                    n4 [label="{case []}"]
                    n5 [label="{exp}"]
                    n6 [label="{case []}"]
                    n7 [label="b"]
                    n8 [label="{default}"]
                    n9 [label="{exp}"]
                    n10 [label="{fallthrough}"]
                    n11 [label="{exp}"]
                    n12 [label="c"]
                    n13 [label="defaultExp"]
                    n14 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n6 -> n9
                    n7 -> n10
                    n8 -> n11
                    n9 -> n12
                    n10 -> n9
                    n11 -> n13
                    n12 -> n14
                    n13 -> n14
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
                    n2 [label="switchExp"]
                    n3 [label="{switch}"]
                    n4 [label="{case []}"]
                    n5 [label="{exp}"]
                    n6 [label="{default}"]
                    n7 [label="b"]
                    n8 [label="{exp}"]
                    n9 [label="predicate"]
                    n10 [label="defaultExp"]
                    n11 [label="{if}"]
                    n12 [label="{exp}"]
                    n13 [label="{break}"]
                    n14 [label="d"]
                    n15 [label="{defer}"]
                    n16 [label="{defer}"]
                    n17 [label="{exp}"]
                    n18 [label="{exp}"]
                    n19 [label="c"]
                    n20 [label="c"]
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
                    n10 -> n21
                    n11 -> n12
                    n11 -> n13
                    n12 -> n14
                    n13 -> n15
                    n14 -> n16
                    n15 -> n17
                    n16 -> n18
                    n17 -> n19
                    n18 -> n20
                    n19 -> n21
                    n20 -> n21
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
                    n2 [label="switchExp"]
                    n3 [label="{switch}"]
                    n4 [label="{case b}"]
                    n5 [label="{exp}"]
                    n6 [label="{case f}"]
                    n7 [label="c"]
                    n8 [label="{default}"]
                    n9 [label="{exp}"]
                    n10 [label="predicateFallthrough"]
                    n11 [label="{exp}"]
                    n12 [label="g"]
                    n13 [label="{if}"]
                    n14 [label="defaultExp"]
                    n15 [label="{fallthrough}"]
                    n16 [label="{exp}"]
                    n17 [label="{defer}"]
                    n18 [label="e"]
                    n19 [label="{exp}"]
                    n20 [label="{defer}"]
                    n21 [label="d"]
                    n22 [label="{exp}"]
                    n23 [label="{defer}"]
                    n24 [label="deferredExp"]
                    n25 [label="{exp}"]
                    n26 [label="{defer}"]
                    n27 [label="deferredExp"]
                    n28 [label="{exp}"]
                    n29 [label="d"]
                    n30 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n6 -> n9
                    n7 -> n10
                    n8 -> n11
                    n9 -> n12
                    n10 -> n13
                    n11 -> n14
                    n12 -> n30
                    n13 -> n15
                    n13 -> n16
                    n14 -> n30
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
                    n27 -> n9
                    n28 -> n29
                    n29 -> n30
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
                    n2 [label="switchExp"]
                    n3 [label="{switch}"]
                    n4 [label="{case []}"]
                    n5 [label="{exp}"]
                    n6 [label="{case []}"]
                    n7 [label="b"]
                    n8 [label="{default}"]
                    n9 [label="{exp}"]
                    n10 [label="predicateFallthrough"]
                    n11 [label="{exp}"]
                    n12 [label="g"]
                    n13 [label="{if}"]
                    n14 [label="defaultExp"]
                    n15 [label="{exp}"]
                    n16 [label="{exp}"]
                    n17 [label="d"]
                    n18 [label="e"]
                    n19 [label="{fallthrough}"]
                    n20 [label="predicateReturn"]
                    n21 [label="{defer}"]
                    n22 [label="{if}"]
                    n23 [label="{exp}"]
                    n24 [label="{return}"]
                    n25 [label="{defer}"]
                    n26 [label="deferredExp"]
                    n27 [label="{defer}"]
                    n28 [label="{exp}"]
                    n29 [label="{defer}"]
                    n30 [label="{exp}"]
                    n31 [label="f"]
                    n32 [label="deferredExp"]
                    n33 [label="{exp}"]
                    n34 [label="{defer}"]
                    n35 [label="f"]
                    n36 [label="{defer}"]
                    n37 [label="{exp}"]
                    n38 [label="{exp}"]
                    n39 [label="deferredExp"]
                    n40 [label="f"]
                    n41 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n6 -> n9
                    n7 -> n10
                    n8 -> n11
                    n9 -> n12
                    n10 -> n13
                    n11 -> n14
                    n12 -> n41
                    n13 -> n15
                    n13 -> n16
                    n14 -> n41
                    n15 -> n17
                    n16 -> n18
                    n17 -> n19
                    n18 -> n20
                    n19 -> n21
                    n20 -> n22
                    n21 -> n23
                    n22 -> n24
                    n22 -> n25
                    n23 -> n26
                    n24 -> n27
                    n25 -> n28
                    n26 -> n29
                    n27 -> n30
                    n28 -> n31
                    n29 -> n33
                    n30 -> n32
                    n31 -> n34
                    n32 -> n36
                    n33 -> n35
                    n34 -> n37
                    n35 -> n9
                    n36 -> n38
                    n37 -> n39
                    n38 -> n40
                    n39 -> n41
                    n40 -> n41
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
                    n2 [label="predicate"]
                    n3 [label="{while}"]
                    n4 [label="{exp}"]
                    n5 [label="loopBody"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n6
                    n4 -> n5
                    n5 -> n2 [color="#aa3333", penwidth=0.5]
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
                    n2 [label="predicate"]
                    n3 [label="{while}"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n2 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
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
                    n2 [label="predicate"]
                    n3 [label="{while}"]
                    n4 [label="predicateInner"]
                    n5 [label="{while}"]
                    n6 [label="{continue outer}"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n7
                    n4 -> n5
                    n5 -> n2 [color="#aa3333", penwidth=0.5]
                    n5 -> n6
                    n6 -> n2 [color="#aa3333", penwidth=0.5]
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
                    n2 [label="predicate"]
                    n3 [label="{while}"]
                    n4 [label="predicateInner"]
                    n5 [label="{while}"]
                    n6 [label="{break outer}"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n7
                    n4 -> n5
                    n5 -> n2 [color="#aa3333", penwidth=0.5]
                    n5 -> n6
                    n6 -> n7
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
                    n2 [label="whilePredicate"]
                    n3 [label="{while}"]
                    n4 [label="ifPredicate"]
                    n5 [label="{if}"]
                    n6 [label="{exp}"]
                    n7 [label="{break}"]
                    n8 [label="preContinue"]
                    n9 [label="{continue}"]
                    n10 [label="{exp}"]
                    n11 [label="postIf"]
                    n12 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n12
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n12
                    n8 -> n9
                    n9 -> n2 [color="#aa3333", penwidth=0.5]
                    n10 -> n11
                    n11 -> n2
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
                    n2 [label="{exp}"]
                    n3 [label="loopBody"]
                    n4 [label="predicate"]
                    n5 [label="{repeat-while}"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n2 [color="#aa3333", penwidth=0.5]
                    n5 -> n6
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
                    n2 [label="predicate"]
                    n3 [label="{repeat-while}"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n2 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
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
                    n2 [label="predicateInner"]
                    n3 [label="{while}"]
                    n4 [label="{continue outer}"]
                    n5 [label="predicate"]
                    n6 [label="{repeat-while}"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n5
                    n5 -> n6
                    n6 -> n2 [color="#aa3333", penwidth=0.5]
                    n6 -> n7
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
                    n2 [label="predicateInner"]
                    n3 [label="{while}"]
                    n4 [label="predicate"]
                    n5 [label="{break outer}"]
                    n6 [label="{repeat-while}"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n2 [color="#aa3333", penwidth=0.5]
                    n6 -> n7
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
                    n2 [label="{break}"]
                    n3 [label="predicate"]
                    n4 [label="{repeat-while}"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n5
                    n3 -> n4
                    n4 -> n2
                    n4 -> n5
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
                    n2 [label="i"]
                    n3 [label="{for}"]
                    n4 [label="{exp}"]
                    n5 [label="b"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n6
                    n4 -> n5
                    n5 -> n3 [color="#aa3333", penwidth=0.5]
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
                    n2 [label="i"]
                    n3 [label="{for}"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n3 [color="#aa3333", penwidth=0.5]
                    n3 -> n4
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
                    n2 [label="i"]
                    n3 [label="{for}"]
                    n4 [label="predicateInner"]
                    n5 [label="{while}"]
                    n6 [label="{continue outer}"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n7
                    n4 -> n5
                    n5 -> n3 [color="#aa3333", penwidth=0.5]
                    n5 -> n6
                    n6 -> n3 [color="#aa3333", penwidth=0.5]
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
                    n2 [label="i"]
                    n3 [label="{for}"]
                    n4 [label="predicateInner"]
                    n5 [label="{while}"]
                    n6 [label="{break outer}"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n7
                    n4 -> n5
                    n5 -> n3 [color="#aa3333", penwidth=0.5]
                    n5 -> n6
                    n6 -> n7
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
                    n2 [label="{return}"]
                    n3 [label="exit"]
                    n1 -> n2
                    n2 -> n3
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
                    n2 [label="exp"]
                    n3 [label="{return exp}"]
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
                    n2 [label="predicate"]
                    n3 [label="{while}"]
                    n4 [label="{return}"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n5
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
                    n2 [label="{exp}"]
                    n3 [label="preReturn"]
                    n4 [label="{return}"]
                    n5 [label="{exp}"]
                    n6 [label="postReturn"]
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
                    n2 [label="predicate"]
                    n3 [label="{while}"]
                    n4 [label="Error"]
                    n5 [label="{throw Error}"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n6
                    n4 -> n5
                    n5 -> n6
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
                    n2 [label="{exp}"]
                    n3 [label="preError"]
                    n4 [label="Error"]
                    n5 [label="{throw Error}"]
                    n6 [label="{exp}"]
                    n7 [label="postError"]
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
                    n2 [label="{exp}"]
                    n3 [label="preError"]
                    n4 [label="a"]
                    n5 [label="{if}"]
                    n6 [label="Error"]
                    n7 [label="{exp}"]
                    n8 [label="postError"]
                    n9 [label="{throw Error}"]
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
                    n9 -> n10
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
                    n2 [label="v"]
                    n3 [label="{while}"]
                    n4 [label="{break}"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n5
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
                    n2 [label="a"]
                    n3 [label="{for}"]
                    n4 [label="b"]
                    n5 [label="{exp}"]
                    n6 [label="{while}"]
                    n7 [label="b"]
                    n8 [label="predicate"]
                    n9 [label="{if}"]
                    n10 [label="{defer}"]
                    n11 [label="{break outer}"]
                    n12 [label="{exp}"]
                    n13 [label="{defer}"]
                    n14 [label="deferred"]
                    n15 [label="{exp}"]
                    n16 [label="deferred"]
                    n17 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n3 [color="#aa3333", penwidth=0.5]
                    n6 -> n8
                    n7 -> n17
                    n8 -> n9
                    n9 -> n10
                    n9 -> n11
                    n10 -> n12
                    n11 -> n13
                    n12 -> n14
                    n13 -> n15
                    n14 -> n4 [color="#aa3333", penwidth=0.5]
                    n15 -> n16
                    n16 -> n5
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
                    n2 [label="v"]
                    n3 [label="{while}"]
                    n4 [label="{continue}"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n2 [color="#aa3333", penwidth=0.5]
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
                    n2 [label="v"]
                    n3 [label="{while}"]
                    n4 [label="{continue}"]
                    n5 [label="{exp}"]
                    n6 [label="v"]
                    n7 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n7
                    n4 -> n2 [color="#aa3333", penwidth=0.5]
                    n5 -> n6
                    n6 -> n2
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
                    n2 [label="a"]
                    n3 [label="{for}"]
                    n4 [label="b"]
                    n5 [label="{while}"]
                    n6 [label="predicate"]
                    n7 [label="{if}"]
                    n8 [label="{defer}"]
                    n9 [label="{continue outer}"]
                    n10 [label="{exp}"]
                    n11 [label="{defer}"]
                    n12 [label="deferred"]
                    n13 [label="{exp}"]
                    n14 [label="deferred"]
                    n15 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n15
                    n4 -> n5
                    n5 -> n3 [color="#aa3333", penwidth=0.5]
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n7 -> n9
                    n8 -> n10
                    n9 -> n11
                    n10 -> n12
                    n11 -> n13
                    n12 -> n4 [color="#aa3333", penwidth=0.5]
                    n13 -> n14
                    n14 -> n3 [color="#aa3333", penwidth=0.5]
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
                    n2 [label="{exp}"]
                    n3 [label="c"]
                    n4 [label="{defer}"]
                    n5 [label="{exp}"]
                    n6 [label="a"]
                    n7 [label="{exp}"]
                    n8 [label="b"]
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
                    n2 [label="{exp}"]
                    n3 [label="a"]
                    n4 [label="{do}"]
                    n5 [label="predicate"]
                    n6 [label="{if}"]
                    n7 [label="error"]
                    n8 [label="{exp}"]
                    n9 [label="{throw error}"]
                    n10 [label="c"]
                    n11 [label="{defer}"]
                    n12 [label="{defer}"]
                    n13 [label="{exp}"]
                    n14 [label="{exp}"]
                    n15 [label="b"]
                    n16 [label="b"]
                    n17 [label="{catch}"]
                    n18 [label="{exp}"]
                    n19 [label="d"]
                    n20 [label="exit"]
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
                    n16 -> n20
                    n17 -> n18
                    n18 -> n19
                    n19 -> n20
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
                    n2 [label="a"]
                    n3 [label="{if}"]
                    n4 [label="{exp}"]
                    n5 [label="{exp}"]
                    n6 [label="d"]
                    n7 [label="e"]
                    n8 [label="{defer}"]
                    n9 [label="{exp}"]
                    n10 [label="b"]
                    n11 [label="{exp}"]
                    n12 [label="c"]
                    n13 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n13
                    n8 -> n9
                    n9 -> n10
                    n10 -> n11
                    n11 -> n12
                    n12 -> n5
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
                    n2 [label="a"]
                    n3 [label="{if}"]
                    n4 [label="{exp}"]
                    n5 [label="{exp}"]
                    n6 [label="c"]
                    n7 [label="e"]
                    n8 [label="{defer}"]
                    n9 [label="{defer}"]
                    n10 [label="{exp}"]
                    n11 [label="{exp}"]
                    n12 [label="b"]
                    n13 [label="d"]
                    n14 [label="{exp}"]
                    n15 [label="f"]
                    n16 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n9
                    n8 -> n10
                    n9 -> n11
                    n10 -> n12
                    n11 -> n13
                    n12 -> n14
                    n13 -> n14
                    n14 -> n15
                    n15 -> n16
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
                    n2 [label="a"]
                    n3 [label="{while}"]
                    n4 [label="{exp}"]
                    n5 [label="{exp}"]
                    n6 [label="c"]
                    n7 [label="d"]
                    n8 [label="{defer}"]
                    n9 [label="{exp}"]
                    n10 [label="b"]
                    n11 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n11
                    n8 -> n9
                    n9 -> n10
                    n10 -> n2 [color="#aa3333", penwidth=0.5]
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
                    n2 [label="a"]
                    n3 [label="{while}"]
                    n4 [label="{exp}"]
                    n5 [label="{exp}"]
                    n6 [label="c"]
                    n7 [label="d"]
                    n8 [label="{break}"]
                    n9 [label="{defer}"]
                    n10 [label="{exp}"]
                    n11 [label="b"]
                    n12 [label="{defer}"]
                    n13 [label="{exp}"]
                    n14 [label="b"]
                    n15 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n3 -> n5
                    n4 -> n6
                    n5 -> n7
                    n6 -> n8
                    n7 -> n15
                    n8 -> n9
                    n9 -> n10
                    n10 -> n11
                    n11 -> n5
                    n12 -> n13
                    n13 -> n14
                    n14 -> n2
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
                    n2 [label="{exp}"]
                    n3 [label="loopBody"]
                    n4 [label="{defer}"]
                    n5 [label="{exp}"]
                    n6 [label="defer"]
                    n7 [label="predicate"]
                    n8 [label="{repeat-while}"]
                    n9 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n6 -> n7
                    n7 -> n8
                    n8 -> n2 [color="#aa3333", penwidth=0.5]
                    n8 -> n9
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
                    n2 [label="{exp}"]
                    n3 [label="b"]
                    n4 [label="predicate"]
                    n5 [label="{if}"]
                    n6 [label="0"]
                    n7 [label="{exp}"]
                    n8 [label="d"]
                    n9 [label="{return 0}"]
                    n10 [label="{defer}"]
                    n11 [label="{defer}"]
                    n12 [label="{exp}"]
                    n13 [label="{exp}"]
                    n14 [label="a"]
                    n15 [label="c"]
                    n16 [label="{defer}"]
                    n17 [label="{defer}"]
                    n18 [label="{exp}"]
                    n19 [label="{exp}"]
                    n20 [label="a"]
                    n21 [label="c"]
                    n22 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                    n4 -> n5
                    n5 -> n6
                    n5 -> n7
                    n6 -> n9
                    n7 -> n8
                    n8 -> n10
                    n9 -> n11
                    n10 -> n12
                    n11 -> n13
                    n12 -> n15
                    n13 -> n14
                    n14 -> n17
                    n15 -> n16
                    n16 -> n18
                    n17 -> n19
                    n18 -> n20
                    n19 -> n21
                    n20 -> n22
                    n21 -> n22
                }
                """
        )
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }
}
