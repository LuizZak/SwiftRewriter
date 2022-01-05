import SwiftAST
import TestCommons
import WriterTargetOutput
import XCTest

@testable import Analysis

class ControlFlowGraphCreationTests: XCTestCase {
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
        XCTAssertEqual(graph.nodes.count, 2)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt]
        )
    }

    func testPruneUnreachable_true() {
        let stmt: CompoundStatement = [
            .expression(.identifier("a")),
            .return(nil),
            .expression(.identifier("b")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt, pruneUnreachable: true)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a"]
                    n3 [label="{return}"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testPruneUnreachable_false() {
        let stmt: CompoundStatement = [
            .expression(.identifier("a")),
            .return(nil),
            .expression(.identifier("b")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt, pruneUnreachable: false)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="{return}"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n4
                    n3 -> n5
                    n4 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
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
        XCTAssertEqual(graph.nodes.count, 2)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt]
        )
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
                    n2 [label="exp"]
                    n3 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 3)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt.statements[0], stmt]
        )
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
                    n2 [label="exp1"]
                    n3 [label="exp2"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt.statements[0], stmt.statements[1], stmt]
        )
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
                    n3 [label="var v2: Int"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt.statements[0], stmt.statements[1], stmt]
        )
    }

    func testIf() {
        let stmt: CompoundStatement = [
            Statement.variableDeclaration(identifier: "v", type: .int, initialization: nil),
            Statement.expression(.identifier("v").call()),
            Statement.if(
                .identifier("v").dot("didWork"),
                body: [
                    .expression(
                        .identifier("print").call([.constant("Did work!")])
                    )
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
                    n2 [label="print(\\"Did work!\\")"]
                    n3 [label="v()"]
                    n4 [label="var v: Int"]
                    n5 [label="{if}"]
                    n6 [label="exit"]
                    n1 -> n4
                    n2 -> n6
                    n3 -> n5
                    n4 -> n3
                    n5 -> n2
                    n5 -> n6
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 6)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testDoStatement() {
        let stmt: CompoundStatement = [
            Statement.variableDeclaration(identifier: "v", type: .int, initialization: nil),
            Statement.expression(.identifier("v").call()),
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
                    n2 [label="exp"]
                    n3 [label="v()"]
                    n4 [label="var v: Int"]
                    n5 [label="exit"]
                    n1 -> n4
                    n2 -> n5
                    n3 -> n2
                    n4 -> n3
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testLabeledBreakStatement() {
        let stmt: CompoundStatement = [
            Statement.do([
                .expression(.identifier("a")),
                .break(targetLabel: "doLabel"),
                .expression(.identifier("b")),
            ]).labeled("doLabel")
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="BreakStatement"]
                    n3 [label="a"]
                    n4 [label="b"]
                    n5 [label="exit"]
                    n1 -> n3
                    n2 -> n5
                    n3 -> n2
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

    func testLabeledContinueStatement() {
        let stmt: CompoundStatement = [
            Statement.for(
                .identifier("a"),
                .identifier("a"),
                body: [
                    Statement.while(
                        .identifier("b"),
                        body: [
                            Statement.if(
                                .identifier("precidate"),
                                body: [
                                    .continue(targetLabel: "outer")
                                ]
                            )
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
                    n2 [label="ContinueStatement"]
                    n3 [label="{for}"]
                    n4 [label="{if}"]
                    n5 [label="{while}"]
                    n6 [label="exit"]
                    n1 -> n3
                    n2 -> n3 [color="#aa3333",penwidth=0.5]
                    n3 -> n5
                    n3 -> n6
                    n4 -> n2
                    n4 -> n5 [color="#aa3333",penwidth=0.5]
                    n5 -> n4
                    n5 -> n3 [color="#aa3333",penwidth=0.5]
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 6)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testIfElse() {
        let stmt: CompoundStatement = [
            Statement.variableDeclaration(identifier: "v", type: .int, initialization: nil),
            Statement.expression(.identifier("v").call()),
            Statement.if(
                .identifier("v").dot("didWork"),
                body: [
                    .expression(
                        .identifier("print").call([.constant("Did work!")])
                    )
                ],
                else: [
                    .expression(
                        .identifier("print").call([.constant("Did no work")])
                    )
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
                    n2 [label="print(\\"Did no work\\")"]
                    n3 [label="print(\\"Did work!\\")"]
                    n4 [label="v()"]
                    n5 [label="var v: Int"]
                    n6 [label="{if}"]
                    n7 [label="exit"]
                    n1 -> n5
                    n2 -> n7
                    n3 -> n7
                    n4 -> n6
                    n5 -> n4
                    n6 -> n3
                    n6 -> n2
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 7)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testIfElseIf() {
        let stmt: CompoundStatement = [
            Statement.variableDeclaration(identifier: "v", type: .int, initialization: nil),
            Statement.expression(.identifier("v").call()),
            Statement.if(
                .identifier("v").dot("didWork"),
                body: [
                    .expression(
                        .identifier("print").call([.constant("Did work!")])
                    )
                ],
                else: [
                    .if(
                        .identifier("v").dot("didWork2"),
                        body: [
                            .expression(
                                .identifier("print").call([.constant("Did work twice!")])
                            )
                        ],
                        else: [
                            .expression(
                                .identifier("print").call([.constant("Did no work twice")])
                            )
                        ]
                    )
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
                    n2 [label="print(\\"Did no work twice\\")"]
                    n3 [label="print(\\"Did work twice!\\")"]
                    n4 [label="print(\\"Did work!\\")"]
                    n5 [label="v()"]
                    n6 [label="var v: Int"]
                    n7 [label="{if}"]
                    n8 [label="{if}"]
                    n9 [label="exit"]
                    n1 -> n6
                    n2 -> n9
                    n3 -> n9
                    n4 -> n9
                    n5 -> n7
                    n6 -> n5
                    n7 -> n4
                    n7 -> n8
                    n8 -> n3
                    n8 -> n2
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 9)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
    }

    func testSwitchStatement() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("a"),
                cases: [
                    SwitchCase(
                        patterns: [],
                        statements: [
                            .expression(.identifier("b"))
                        ]
                    ),
                    SwitchCase(
                        patterns: [],
                        statements: [
                            .expression(.identifier("c"))
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
                    n2 [label="SwitchStatement"]
                    n3 [label="b"]
                    n4 [label="c"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n2 -> n4
                    n3 -> n5
                    n4 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testSwitchStatementWithDefaultCase() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("a"),
                cases: [
                    SwitchCase(
                        patterns: [],
                        statements: [
                            .expression(.identifier("b"))
                        ]
                    ),
                    SwitchCase(
                        patterns: [],
                        statements: [
                            .expression(.identifier("c"))
                        ]
                    ),
                ],
                default: [
                    .expression(.identifier("d"))
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
                    n2 [label="SwitchStatement"]
                    n3 [label="b"]
                    n4 [label="c"]
                    n5 [label="d"]
                    n6 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n2 -> n4
                    n2 -> n5
                    n3 -> n6
                    n4 -> n6
                    n5 -> n6
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 6)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
    }

    func testEmptySwitchStatement() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("a"),
                cases: [
                    SwitchCase(patterns: [.identifier("b")], statements: []),
                    SwitchCase(patterns: [.identifier("c")], statements: []),
                    SwitchCase(patterns: [.identifier("d")], statements: []),
                ],
                default: []
            )
        ]
        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="SwitchStatement"]
                    n3 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 3)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testEmptySwitchStatementWithFallthrough() {
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
                default: []
            )
        ]
        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="FallthroughStatement"]
                    n3 [label="SwitchStatement"]
                    n4 [label="exit"]
                    n1 -> n3
                    n2 -> n4
                    n3 -> n2
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testSwitchStatementFallthrough() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("a"),
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
                default: [
                    .expression(.identifier("d"))
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
                    n2 [label="FallthroughStatement"]
                    n3 [label="SwitchStatement"]
                    n4 [label="b"]
                    n5 [label="c"]
                    n6 [label="d"]
                    n7 [label="exit"]
                    n1 -> n3
                    n2 -> n5
                    n3 -> n4
                    n3 -> n5
                    n3 -> n6
                    n4 -> n2
                    n5 -> n7
                    n6 -> n7
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 7)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testSwitchStatementBreakDefer() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("a"),
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
                default: [
                    .expression(.identifier("e"))
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
                    n2 [label="BreakStatement"]
                    n3 [label="SwitchStatement"]
                    n4 [label="b"]
                    n5 [label="c"]
                    n6 [label="d"]
                    n7 [label="e"]
                    n8 [label="{if}"]
                    n9 [label="exit"]
                    n1 -> n3
                    n2 -> n5
                    n3 -> n4
                    n3 -> n7
                    n4 -> n8
                    n5 -> n9
                    n6 -> n5
                    n7 -> n9
                    n8 -> n2
                    n8 -> n6
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 9)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testSwitchStatementFallthroughWithDefer() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("a"),
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
                                    .fallthrough
                                ]
                            ),
                            .expression(.identifier("d")),
                            .defer([
                                .expression(.identifier("e"))
                            ]),
                        ]
                    ),
                    SwitchCase(
                        patterns: [],
                        statements: [
                            .expression(.identifier("f"))
                        ]
                    ),
                ],
                default: [
                    .expression(.identifier("g"))
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
                    n2 [label="FallthroughStatement"]
                    n3 [label="SwitchStatement"]
                    n4 [label="b"]
                    n5 [label="c"]
                    n6 [label="d"]
                    n7 [label="e"]
                    n8 [label="f"]
                    n9 [label="g"]
                    n10 [label="{if}"]
                    n11 [label="exit"]
                    n1 -> n3
                    n2 -> n5
                    n3 -> n4
                    n3 -> n8
                    n3 -> n9
                    n4 -> n10
                    n5 -> n8
                    n5 -> n11
                    n6 -> n7
                    n7 -> n5
                    n8 -> n11
                    n9 -> n11
                    n10 -> n2
                    n10 -> n6
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 11)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
    }

    func testSwitchStatementFallthroughWithDeferInterwindedWithReturn() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("a"),
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
                                    .expression(.identifier("d")),
                                    .fallthrough,
                                ]
                            ),
                            .expression(.identifier("e")),
                            Statement.if(
                                .identifier("predicate"),
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
                default: [
                    .expression(.identifier("h"))
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
                    n2 [label="FallthroughStatement"]
                    n3 [label="SwitchStatement"]
                    n4 [label="b"]
                    n5 [label="c"]
                    n6 [label="d"]
                    n7 [label="e"]
                    n8 [label="f"]
                    n9 [label="g"]
                    n10 [label="h"]
                    n11 [label="{if}"]
                    n12 [label="{if}"]
                    n13 [label="{return}"]
                    n14 [label="exit"]
                    n1 -> n3
                    n2 -> n5
                    n3 -> n4
                    n3 -> n9
                    n3 -> n10
                    n4 -> n11
                    n5 -> n9
                    n5 -> n14
                    n6 -> n2
                    n7 -> n12
                    n8 -> n5
                    n9 -> n14
                    n10 -> n14
                    n11 -> n6
                    n11 -> n7
                    n12 -> n13
                    n12 -> n8
                    n13 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 14)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
    }

    func testWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.expression(.identifier("v").call()),
            Statement.while(
                .identifier("v"),
                body: [
                    .expression(.identifier("a"))
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
                    n2 [label="a"]
                    n3 [label="v()"]
                    n4 [label="{while}"]
                    n5 [label="exit"]
                    n1 -> n3
                    n2 -> n4 [color="#aa3333",penwidth=0.5]
                    n3 -> n4
                    n4 -> n2
                    n4 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testEmptyWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.expression(.identifier("v").call()),
            Statement.while(
                .identifier("v"),
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
                    n2 [label="v()"]
                    n3 [label="{while}"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n3 [color="#aa3333",penwidth=0.5]
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDoWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.expression(.identifier("v").call()),
            Statement.doWhile(
                .identifier("v"),
                body: [
                    .expression(.identifier("a"))
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
                    n2 [label="a"]
                    n3 [label="v()"]
                    n4 [label="{do-while}"]
                    n5 [label="exit"]
                    n1 -> n3
                    n2 -> n4
                    n3 -> n2
                    n4 -> n2 [color="#aa3333",penwidth=0.5]
                    n4 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testEmptyDoWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.expression(.identifier("v").call()),
            Statement.doWhile(
                .identifier("v"),
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
                    n2 [label="v()"]
                    n3 [label="{do-while}"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n3 [color="#aa3333",penwidth=0.5]
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testBreakInDoWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.expression(.identifier("v").call()),
            Statement.doWhile(
                .identifier("v"),
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
                    n2 [label="BreakStatement"]
                    n3 [label="v()"]
                    n4 [label="{do-while}"]
                    n5 [label="exit"]
                    n1 -> n3
                    n2 -> n5
                    n3 -> n2
                    n4 -> n2
                    n4 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 5)
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
                    n2 [label="b"]
                    n3 [label="{for}"]
                    n4 [label="exit"]
                    n1 -> n3
                    n2 -> n3 [color="#aa3333",penwidth=0.5]
                    n3 -> n2
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testEmptyForLoop() {
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
                    n2 [label="{for}"]
                    n3 [label="exit"]
                    n1 -> n2
                    n2 -> n2 [color="#aa3333",penwidth=0.5]
                    n2 -> n3
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 3)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testWhileLoopWithBreak() {
        let stmt: CompoundStatement = [
            Statement.expression(.identifier("v").call()),
            Statement.while(
                .identifier("v"),
                body: [
                    .expression(.identifier("a")),
                    Statement.if(
                        .identifier("a"),
                        body: [.break()],
                        else: [
                            .expression(.identifier("b")),
                            .continue(),
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
                    n2 [label="BreakStatement"]
                    n3 [label="ContinueStatement"]
                    n4 [label="a"]
                    n5 [label="b"]
                    n6 [label="v()"]
                    n7 [label="{if}"]
                    n8 [label="{while}"]
                    n9 [label="exit"]
                    n1 -> n6
                    n2 -> n9
                    n3 -> n8 [color="#aa3333",penwidth=0.5]
                    n4 -> n7
                    n5 -> n3
                    n6 -> n8
                    n7 -> n2
                    n7 -> n5
                    n8 -> n4
                    n8 -> n9
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 9)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testReturnStatement() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("v"),
                body: [
                    .return(nil)
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
                    n2 [label="{return}"]
                    n3 [label="{while}"]
                    n4 [label="exit"]
                    n1 -> n3
                    n2 -> n4
                    n3 -> n2
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testReturnStatement_skipRemaining() {
        let stmt: CompoundStatement = [
            .expression(.identifier("preReturn").call()),
            .return(nil),
            .expression(.identifier("postReturn").call()),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="postReturn()"]
                    n3 [label="preReturn()"]
                    n4 [label="{return}"]
                    n5 [label="exit"]
                    n1 -> n3
                    n2 -> n5
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testThrowStatement() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("v"),
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
                    n2 [label="{throw Error}"]
                    n3 [label="{while}"]
                    n4 [label="exit"]
                    n1 -> n3
                    n2 -> n4
                    n3 -> n2
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testThrowErrorFlow() {
        let stmt: CompoundStatement = [
            .expression(.identifier("preError").call()),
            .throw(.identifier("Error").call()),
            .expression(.identifier("postError").call()),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="postError()"]
                    n3 [label="preError()"]
                    n4 [label="{throw Error()}"]
                    n5 [label="exit"]
                    n1 -> n3
                    n2 -> n5
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testConditionalThrowErrorFlow() {
        let stmt: CompoundStatement = [
            .expression(.identifier("preError").call()),
            .if(.identifier("a"), body: [
                .throw(.identifier("Error").call()),
            ]),
            .expression(.identifier("postError").call()),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="postError()"]
                    n3 [label="preError()"]
                    n4 [label="{if}"]
                    n5 [label="{throw Error()}"]
                    n6 [label="exit"]
                    n1 -> n3
                    n2 -> n6
                    n3 -> n4
                    n4 -> n5
                    n4 -> n2
                    n5 -> n6
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 6)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testCatchThrowErrorFlow() {
        let stmt: CompoundStatement = [
            .expression(.identifier("preDo")),
            .do([
                .expression(.identifier("preError")),
                .throw(.identifier("Error").call()),
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
                    n2 [label="end"]
                    n3 [label="errorHandler"]
                    n4 [label="postError"]
                    n5 [label="preDo"]
                    n6 [label="preError"]
                    n7 [label="{throw Error()}"]
                    n8 [label="exit"]
                    n1 -> n5
                    n2 -> n8
                    n3 -> n2
                    n4 -> n2
                    n5 -> n6
                    n6 -> n7
                    n7 -> n3
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 8)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testCatchConditionalThrowErrorFlow() {
        let stmt: CompoundStatement = [
            .do([
                .expression(.identifier("preError")),
                .if(.identifier("a"), body: [
                    .throw(.identifier("Error").call()),
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
                    n2 [label="end"]
                    n3 [label="errorHandler"]
                    n4 [label="postError"]
                    n5 [label="preError"]
                    n6 [label="{if}"]
                    n7 [label="{throw Error()}"]
                    n8 [label="exit"]
                    n1 -> n5
                    n2 -> n8
                    n3 -> n2
                    n4 -> n2
                    n5 -> n6
                    n6 -> n7
                    n6 -> n4
                    n7 -> n3
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 8)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testCatchWithNoThrowFlow() {
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="c"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n4
                    n3 -> n4
                    n4 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
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
                    n2 [label="BreakStatement"]
                    n3 [label="{while}"]
                    n4 [label="exit"]
                    n1 -> n3
                    n2 -> n4
                    n3 -> n2
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
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
                    n2 [label="ContinueStatement"]
                    n3 [label="{while}"]
                    n4 [label="exit"]
                    n1 -> n3
                    n2 -> n3 [color="#aa3333",penwidth=0.5]
                    n3 -> n2
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testContinueStatementSkippingOverRemainingOfMethod() {
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
                    n2 [label="ContinueStatement"]
                    n3 [label="v"]
                    n4 [label="{while}"]
                    n5 [label="exit"]
                    n1 -> n4
                    n2 -> n4 [color="#aa3333",penwidth=0.5]
                    n3 -> n4
                    n4 -> n2
                    n4 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 5)
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="c"]
                    n5 [label="exit"]
                    n1 -> n4
                    n2 -> n3
                    n3 -> n5
                    n4 -> n2
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDeferStatementInIf() {
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
                    n2 [label="b"]
                    n3 [label="c"]
                    n4 [label="d"]
                    n5 [label="e"]
                    n6 [label="{if}"]
                    n7 [label="exit"]
                    n1 -> n6
                    n2 -> n3
                    n3 -> n5
                    n4 -> n2
                    n5 -> n7
                    n6 -> n4
                    n6 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 7)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDeferStatementInIfElse() {
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
                    n2 [label="b"]
                    n3 [label="c"]
                    n4 [label="d"]
                    n5 [label="e"]
                    n6 [label="f"]
                    n7 [label="{if}"]
                    n8 [label="exit"]
                    n1 -> n7
                    n2 -> n6
                    n3 -> n2
                    n4 -> n6
                    n5 -> n4
                    n6 -> n8
                    n7 -> n3
                    n7 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 8)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDeferStatementInLoop() {
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
                    n2 [label="b"]
                    n3 [label="c"]
                    n4 [label="d"]
                    n5 [label="{while}"]
                    n6 [label="exit"]
                    n1 -> n5
                    n2 -> n5 [color="#aa3333",penwidth=0.5]
                    n3 -> n2
                    n4 -> n6
                    n5 -> n3
                    n5 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 6)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDeferStatementInLoopWithBreak() {
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

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="BreakStatement"]
                    n3 [label="b"]
                    n4 [label="c"]
                    n5 [label="d"]
                    n6 [label="{while}"]
                    n7 [label="exit"]
                    n1 -> n6
                    n2 -> n3
                    n3 -> n5
                    n4 -> n2
                    n5 -> n7
                    n6 -> n4
                    n6 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 7)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testDeferStatementInDoWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.expression(.identifier("v").call()),
            Statement.doWhile(
                .identifier("v"),
                body: [
                    .defer([
                        .expression(.identifier("a"))
                    ]),
                    .expression(.identifier("b")),
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="v()"]
                    n5 [label="{do-while}"]
                    n6 [label="exit"]
                    n1 -> n4
                    n2 -> n5
                    n3 -> n2
                    n4 -> n3
                    n5 -> n3 [color="#aa3333",penwidth=0.5]
                    n5 -> n6
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 6)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testLabeledBreakLoopDefer() {
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
                                .identifier("precidate"),
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
                    n2 [label="BreakStatement"]
                    n3 [label="b"]
                    n4 [label="deferred"]
                    n5 [label="{for}"]
                    n6 [label="{if}"]
                    n7 [label="{while}"]
                    n8 [label="exit"]
                    n1 -> n5
                    n2 -> n4
                    n3 -> n8
                    n4 -> n7 [color="#aa3333",penwidth=0.5]
                    n4 -> n3
                    n5 -> n7
                    n5 -> n3
                    n6 -> n2
                    n6 -> n4
                    n7 -> n6
                    n7 -> n5 [color="#aa3333",penwidth=0.5]
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 8)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testLabeledContinueLoopDefer() {
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
                                .identifier("precidate"),
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
                    n2 [label="ContinueStatement"]
                    n3 [label="deferred"]
                    n4 [label="{for}"]
                    n5 [label="{if}"]
                    n6 [label="{while}"]
                    n7 [label="exit"]
                    n1 -> n4
                    n2 -> n3
                    n3 -> n6 [color="#aa3333",penwidth=0.5]
                    n3 -> n4 [color="#aa3333",penwidth=0.5]
                    n4 -> n6
                    n4 -> n7
                    n5 -> n2
                    n5 -> n3
                    n6 -> n5
                    n6 -> n4 [color="#aa3333",penwidth=0.5]
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 7)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testInterwindedDeferStatement() {
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
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="c"]
                    n5 [label="d"]
                    n6 [label="{if}"]
                    n7 [label="{return 0}"]
                    n8 [label="exit"]
                    n1 -> n3
                    n2 -> n8
                    n3 -> n6
                    n4 -> n2
                    n5 -> n4
                    n6 -> n7
                    n6 -> n5
                    n7 -> n2
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 8)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
}

extension ControlFlowGraphCreationTests {
    fileprivate func sanitize(
        _ graph: ControlFlowGraph,
        expectsUnreachable: Bool = false,
        line: UInt = #line
    ) {

        if !graph.nodes.contains(where: { $0 === graph.entry }) {
            XCTFail(
                """
                Graph's entry node is not currently present in nodes array
                """,
                file: #filePath,
                line: line
            )
        }
        if !graph.nodes.contains(where: { $0 === graph.exit }) {
            XCTFail(
                """
                Graph's exit node is not currently present in nodes array
                """,
                file: #filePath,
                line: line
            )
        }

        if graph.entry.node !== graph.exit.node {
            XCTFail(
                """
                Graph's entry and exit nodes must point to the same AST node
                """,
                file: #filePath,
                line: line
            )
        }

        for edge in graph.edges {
            if !graph.containsNode(edge.start) {
                XCTFail(
                    """
                    Edge contains reference for node that is not present in graph: \(edge.start.node)
                    """,
                    file: #filePath,
                    line: line
                )
            }
            if !graph.containsNode(edge.end) {
                XCTFail(
                    """
                    Edge contains reference for node that is not present in graph: \(edge.end.node)
                    """,
                    file: #filePath,
                    line: line
                )
            }
        }

        for node in graph.nodes {
            if node is ControlFlowSubgraphNode {
                XCTFail(
                    """
                    Found non-expanded subgraph node: \(node.node)
                    """,
                    file: #filePath,
                    line: line
                )
            }

            if graph.allEdges(for: node).isEmpty {
                XCTFail(
                    """
                    Found a free node with no edges or connections: \(node.node)
                    """,
                    file: #filePath,
                    line: line
                )

                continue
            }

            if !expectsUnreachable && node !== graph.entry && graph.edges(towards: node).isEmpty {
                XCTFail(
                    """
                    Found non-entry node that has no connections towards it: \(node.node)
                    """,
                    file: #filePath,
                    line: line
                )
            }

            if node !== graph.exit && graph.edges(from: node).isEmpty {
                XCTFail(
                    """
                    Found non-exit node that has no connections from it: \(node.node)
                    """,
                    file: #filePath,
                    line: line
                )
            }
        }
    }

    fileprivate func assertGraphviz(
        graph: ControlFlowGraph,
        matches expected: String,
        line: UInt = #line
    ) {
        let text = graphviz(graph: graph)

        if text == expected {
            return
        }

        XCTFail(
            """
            Expected produced graph to be

            \(expected)

            But found:

            \(text.makeDifferenceMarkString(against: expected))
            """,
            file: #filePath,
            line: line
        )
    }

    fileprivate func printGraphviz(graph: ControlFlowGraph) {
        let string = graphviz(graph: graph)
        print(string)
    }

    fileprivate func graphviz(graph: ControlFlowGraph) -> String {
        let buffer = StringRewriterOutput(settings: .defaults)
        buffer.output(line: "digraph flow {")
        buffer.indented {
            var nodeIds: [ObjectIdentifier: String] = [:]

            var nodeDefinitions: [NodeDefinition] = []

            // Prepare nodes
            for node in graph.nodes {
                var label: String = "\(type(of: node.node))"
                if node === graph.entry {
                    label = "entry"
                }
                if node === graph.exit {
                    label = "exit"
                }

                switch node.node {
                case let exp as ExpressionsStatement:
                    label = exp.expressions[0].description
                    label = label.replacingOccurrences(of: "\"", with: "\\\"")

                case is IfStatement:
                    label = "{if}"

                case is ForStatement:
                    label = "{for}"

                case is WhileStatement:
                    label = "{while}"

                case is DoWhileStatement:
                    label = "{do-while}"

                case let ret as ReturnStatement:
                    if let exp = ret.exp {
                        label = "{return \(exp)}"
                    } else {
                        label = "{return}"
                    }

                case let stmt as ThrowStatement:
                    label = "{throw \(stmt.exp)}"

                case let varDecl as VariableDeclarationsStatement:
                    label = varDecl.decl.map { decl -> String in
                        var declLabel = decl.isConstant ? "let " : "var "
                        declLabel += decl.identifier
                        declLabel += ": \(decl.type)"

                        return declLabel
                    }.joined(separator: "\n")

                default:
                    break
                }

                nodeDefinitions.append(NodeDefinition(node: node, label: label))
            }

            // Sort nodes so the result is more stable
            nodeDefinitions.sort { (n1, n2) -> Bool in
                if n1.node === graph.entry {
                    return true
                }
                if n2.node === graph.entry {
                    return false
                }
                if n1.node === graph.exit {
                    return false
                }
                if n2.node === graph.exit {
                    return true
                }

                return n1.label < n2.label
            }

            // Prepare nodes
            for (i, definition) in nodeDefinitions.enumerated() {
                let id = "n\(i + 1)"
                nodeIds[ObjectIdentifier(definition.node)] = id

                buffer.output(line: "\(id) [label=\"\(definition.label)\"]")
            }

            // Output connections
            for definition in nodeDefinitions {
                let node = definition.node

                let nodeId = nodeIds[ObjectIdentifier(node)]!

                let edges = graph.edges(from: node)

                for edge in edges {
                    let target = edge.end

                    let targetId = nodeIds[ObjectIdentifier(target)]!
                    buffer.outputIndentation()
                    buffer.outputInline("\(nodeId) -> \(targetId)")
                    if edge.isBackEdge {
                        buffer.outputInline(" [color=\"#aa3333\",penwidth=0.5]")
                    }
                    buffer.outputLineFeed()
                }
            }
        }
        buffer.output(line: "}")

        return buffer.buffer.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private struct NodeDefinition {
        var node: ControlFlowGraphNode
        var label: String
    }
}
