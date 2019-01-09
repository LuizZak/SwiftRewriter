import XCTest
import Cocoa
@testable import SwiftRewriterLib
import SwiftAST
import TestCommons

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
            """)
        XCTAssertEqual(graph.nodes.count, 2)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt])
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
            """)
        XCTAssertEqual(graph.nodes.count, 2)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt])
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
                n2 [label="exit"]
                n3 [label="exp"]
                n1 -> n3
                n3 -> n2
            }
            """)
        XCTAssertEqual(graph.nodes.count, 3)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt.statements[0], stmt])
    }
    
    func testExpressions() {
        let stmt: CompoundStatement = [
            .expression(.identifier("exp1")),
            .expression(.identifier("exp2"))
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="entry"]
                n2 [label="exit"]
                n3 [label="exp1"]
                n4 [label="exp2"]
                n1 -> n3
                n3 -> n4
                n4 -> n2
            }
            """)
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt.statements[0], stmt.statements[1], stmt])
    }
    
    func testVariableDeclaration() {
        let stmt: CompoundStatement = [
            .variableDeclaration(identifier: "v1", type: .int, initialization: nil),
            .variableDeclaration(identifier: "v2", type: .int, initialization: nil)
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="entry"]
                n2 [label="exit"]
                n3 [label="var v1: Int"]
                n4 [label="var v2: Int"]
                n1 -> n3
                n3 -> n4
                n4 -> n2
            }
            """)
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt.statements[0], stmt.statements[1], stmt])
    }
    
    func testIf() {
        let stmt: CompoundStatement = [
            Statement.variableDeclaration(identifier: "v", type: .int, initialization: nil),
            Statement.expression(Expression.identifier("v").call()),
            Statement.if(
                Expression.identifier("v").dot("didWork"),
                body: [
                    .expression(
                        Expression.identifier("print").call([.constant("Did work!")])
                    )
                ],
                else: nil)
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="entry"]
                n2 [label="exit"]
                n3 [label="print(\\"Did work!\\")"]
                n4 [label="v()"]
                n5 [label="var v: Int"]
                n6 [label="{if}"]
                n1 -> n5
                n3 -> n2
                n4 -> n6
                n5 -> n4
                n6 -> n3
                n6 -> n2
            }
            """)
        XCTAssertEqual(graph.nodes.count, 6)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }
    
    func testDoStatement() {
        let stmt: CompoundStatement = [
            Statement.variableDeclaration(identifier: "v", type: .int, initialization: nil),
            Statement.expression(Expression.identifier("v").call()),
            Statement.do([
                .expression(
                    Expression.identifier("exp")
                )
            ])
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="entry"]
                n2 [label="exit"]
                n3 [label="exp"]
                n4 [label="v()"]
                n5 [label="var v: Int"]
                n1 -> n5
                n3 -> n2
                n4 -> n3
                n5 -> n4
            }
            """)
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
                .expression(.identifier("b"))
            ]).labeled("doLabel")
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="BreakStatement"]
                n2 [label="a"]
                n3 [label="b"]
                n4 [label="entry"]
                n5 [label="exit"]
                n1 -> n5
                n2 -> n1
                n3 -> n5
                n4 -> n2
            }
            """)
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
                                ],
                                else: nil)
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
                n1 [label="ContinueStatement"]
                n2 [label="entry"]
                n3 [label="exit"]
                n4 [label="{for}"]
                n5 [label="{if}"]
                n6 [label="{while}"]
                n1 -> n4 [color="#aa3333",penwidth=0.5]
                n2 -> n4
                n4 -> n6
                n4 -> n3
                n5 -> n1
                n5 -> n6 [color="#aa3333",penwidth=0.5]
                n6 -> n5
                n6 -> n4 [color="#aa3333",penwidth=0.5]
            }
            """)
        XCTAssertEqual(graph.nodes.count, 6)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
    
    func testIfElse() {
        let stmt: CompoundStatement = [
            Statement.variableDeclaration(identifier: "v", type: .int, initialization: nil),
            Statement.expression(Expression.identifier("v").call()),
            Statement.if(
                Expression.identifier("v").dot("didWork"),
                body: [
                    .expression(
                        Expression.identifier("print").call([.constant("Did work!")])
                    )
                ],
                else: [
                    .expression(
                        Expression.identifier("print").call([.constant("Did no work")])
                    )
                ])
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="entry"]
                n2 [label="exit"]
                n3 [label="print(\\"Did no work\\")"]
                n4 [label="print(\\"Did work!\\")"]
                n5 [label="v()"]
                n6 [label="var v: Int"]
                n7 [label="{if}"]
                n1 -> n6
                n3 -> n2
                n4 -> n2
                n5 -> n7
                n6 -> n5
                n7 -> n4
                n7 -> n3
            }
            """)
        XCTAssertEqual(graph.nodes.count, 7)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }
    
    func testIfElseIf() {
        let stmt: CompoundStatement = [
            Statement.variableDeclaration(identifier: "v", type: .int, initialization: nil),
            Statement.expression(Expression.identifier("v").call()),
            Statement.if(
                Expression.identifier("v").dot("didWork"),
                body: [
                    .expression(
                        Expression.identifier("print").call([.constant("Did work!")])
                    )
                ],
                else: [
                    .if(
                        Expression.identifier("v").dot("didWork2"),
                        body: [
                            .expression(
                                Expression.identifier("print").call([.constant("Did work twice!")])
                            )
                        ],
                        else: [
                            .expression(
                                Expression.identifier("print").call([.constant("Did no work twice")])
                            )
                        ])
                ])
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="entry"]
                n2 [label="exit"]
                n3 [label="print(\\"Did no work twice\\")"]
                n4 [label="print(\\"Did work twice!\\")"]
                n5 [label="print(\\"Did work!\\")"]
                n6 [label="v()"]
                n7 [label="var v: Int"]
                n8 [label="{if}"]
                n9 [label="{if}"]
                n1 -> n7
                n3 -> n2
                n4 -> n2
                n5 -> n2
                n6 -> n8
                n7 -> n6
                n8 -> n5
                n8 -> n9
                n9 -> n4
                n9 -> n3
            }
            """)
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
                    SwitchCase(patterns: [], statements: [])
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
                n1 [label="SwitchStatement"]
                n2 [label="b"]
                n3 [label="c"]
                n4 [label="d"]
                n5 [label="entry"]
                n6 [label="exit"]
                n1 -> n2
                n1 -> n3
                n1 -> n4
                n1 -> n6
                n2 -> n6
                n3 -> n6
                n4 -> n6
                n5 -> n1
            }
            """)
        XCTAssertEqual(graph.nodes.count, 6)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 4)
    }
    
    func testEmptySwitchStatement() {
        let stmt: CompoundStatement = [
            Statement.switch(
                .identifier("a"),
                cases: [
                    SwitchCase(
                        patterns: [],
                        statements: []
                    ),
                    SwitchCase(
                        patterns: [],
                        statements: []
                    ),
                    SwitchCase(patterns: [], statements: [])
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
                n1 [label="SwitchStatement"]
                n2 [label="entry"]
                n3 [label="exit"]
                n1 -> n3
                n2 -> n1
            }
            """)
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
                        patterns: [],
                        statements: [
                            .fallthrough
                        ]
                    ),
                    SwitchCase(
                        patterns: [],
                        statements: []
                    ),
                    SwitchCase(patterns: [], statements: [])
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
                n1 [label="FallthroughStatement"]
                n2 [label="SwitchStatement"]
                n3 [label="entry"]
                n4 [label="exit"]
                n1 -> n4
                n2 -> n1
                n2 -> n4
                n3 -> n2
            }
            """)
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
                            .fallthrough
                        ]
                    ),
                    SwitchCase(
                        patterns: [],
                        statements: [
                            .expression(.identifier("c"))
                        ]
                    ),
                    SwitchCase(patterns: [], statements: [])
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
                n1 [label="FallthroughStatement"]
                n2 [label="SwitchStatement"]
                n3 [label="b"]
                n4 [label="c"]
                n5 [label="d"]
                n6 [label="entry"]
                n7 [label="exit"]
                n1 -> n4
                n2 -> n3
                n2 -> n4
                n2 -> n5
                n2 -> n7
                n3 -> n1
                n4 -> n7
                n5 -> n7
                n6 -> n2
            }
            """)
        XCTAssertEqual(graph.nodes.count, 7)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
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
                                ],
                                else: nil),
                            .expression(.identifier("d"))
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
                n1 [label="BreakStatement"]
                n2 [label="SwitchStatement"]
                n3 [label="b"]
                n4 [label="c"]
                n5 [label="d"]
                n6 [label="e"]
                n7 [label="entry"]
                n8 [label="exit"]
                n9 [label="{if}"]
                n1 -> n4
                n2 -> n3
                n2 -> n6
                n3 -> n9
                n4 -> n8
                n5 -> n4
                n6 -> n8
                n7 -> n2
                n9 -> n1
                n9 -> n5
            }
            """)
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
                                ],
                                else: nil),
                            .expression(.identifier("d")),
                            .defer([
                                .expression(.identifier("e"))
                            ])
                        ]
                    ),
                    SwitchCase(
                        patterns: [],
                        statements: [
                            .expression(.identifier("f"))
                        ]
                    )
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
                n1 [label="FallthroughStatement"]
                n2 [label="SwitchStatement"]
                n3 [label="b"]
                n4 [label="c"]
                n5 [label="d"]
                n6 [label="e"]
                n7 [label="entry"]
                n8 [label="exit"]
                n9 [label="f"]
                n10 [label="g"]
                n11 [label="{if}"]
                n1 -> n4
                n2 -> n3
                n2 -> n9
                n2 -> n10
                n3 -> n11
                n4 -> n9
                n4 -> n8
                n5 -> n6
                n6 -> n4
                n7 -> n2
                n9 -> n8
                n10 -> n8
                n11 -> n1
                n11 -> n5
            }
            """)
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
                                    .fallthrough
                                ],
                                else: nil),
                            .expression(.identifier("e")),
                            Statement.if(
                                .identifier("predicate"),
                                body: [
                                    .return(nil)
                                ],
                                else: nil),
                            .defer([
                                .expression(.identifier("f"))
                            ])
                        ]
                    ),
                    SwitchCase(
                        patterns: [],
                        statements: [
                            .expression(.identifier("g"))
                        ]
                    )
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
                n1 [label="FallthroughStatement"]
                n2 [label="SwitchStatement"]
                n3 [label="b"]
                n4 [label="c"]
                n5 [label="d"]
                n6 [label="e"]
                n7 [label="entry"]
                n8 [label="exit"]
                n9 [label="f"]
                n10 [label="g"]
                n11 [label="h"]
                n12 [label="{if}"]
                n13 [label="{if}"]
                n14 [label="{return}"]
                n1 -> n4
                n2 -> n3
                n2 -> n10
                n2 -> n11
                n3 -> n12
                n4 -> n10
                n4 -> n8
                n5 -> n1
                n6 -> n13
                n7 -> n2
                n9 -> n4
                n10 -> n8
                n11 -> n8
                n12 -> n5
                n12 -> n6
                n13 -> n14
                n13 -> n9
                n14 -> n4
            }
            """)
        XCTAssertEqual(graph.nodes.count, 14)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
    }
    
    func testWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.expression(Expression.identifier("v").call()),
            Statement.while(
                .identifier("v"),
                body: [
                    .expression(.identifier("a"))
                ]
            )
        ]
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="a"]
                n2 [label="entry"]
                n3 [label="exit"]
                n4 [label="v()"]
                n5 [label="{while}"]
                n1 -> n5 [color="#aa3333",penwidth=0.5]
                n2 -> n4
                n4 -> n5
                n5 -> n1
                n5 -> n3
            }
            """)
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
    
    func testEmptyWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.expression(Expression.identifier("v").call()),
            Statement.while(
                .identifier("v"),
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
                n2 [label="exit"]
                n3 [label="v()"]
                n4 [label="{while}"]
                n1 -> n3
                n3 -> n4
                n4 -> n4 [color="#aa3333",penwidth=0.5]
                n4 -> n2
            }
            """)
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
    
    func testDoWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.expression(Expression.identifier("v").call()),
            Statement.doWhile(
                .identifier("v"),
                body: [
                    .expression(.identifier("a"))
                ]
            )
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="a"]
                n2 [label="entry"]
                n3 [label="exit"]
                n4 [label="v()"]
                n5 [label="{do-while}"]
                n1 -> n5
                n2 -> n4
                n4 -> n1
                n5 -> n1 [color="#aa3333",penwidth=0.5]
                n5 -> n3
            }
            """)
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
    
    func testEmptyDoWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.expression(Expression.identifier("v").call()),
            Statement.doWhile(
                .identifier("v"),
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
                n2 [label="exit"]
                n3 [label="v()"]
                n4 [label="{do-while}"]
                n1 -> n3
                n3 -> n4
                n4 -> n4 [color="#aa3333",penwidth=0.5]
                n4 -> n2
            }
            """)
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
    
    func testBreakInDoWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.expression(Expression.identifier("v").call()),
            Statement.doWhile(
                .identifier("v"),
                body: [
                    .break()
                ]
            )
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="BreakStatement"]
                n2 [label="entry"]
                n3 [label="exit"]
                n4 [label="v()"]
                n5 [label="{do-while}"]
                n1 -> n3
                n2 -> n4
                n4 -> n1
                n5 -> n1
                n5 -> n3
            }
            """)
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
                ])
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="b"]
                n2 [label="entry"]
                n3 [label="exit"]
                n4 [label="{for}"]
                n1 -> n4 [color="#aa3333",penwidth=0.5]
                n2 -> n4
                n4 -> n1
                n4 -> n3
            }
            """)
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
    
    func testEmptyForLoop() {
        let stmt: CompoundStatement = [
            Statement.for(
                .identifier("i"),
                .identifier("i"),
                body: [])
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="entry"]
                n2 [label="exit"]
                n3 [label="{for}"]
                n1 -> n3
                n3 -> n3 [color="#aa3333",penwidth=0.5]
                n3 -> n2
            }
            """)
        XCTAssertEqual(graph.nodes.count, 3)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
    
    func testWhileLoopWithBreak() {
        let stmt: CompoundStatement = [
            Statement.expression(Expression.identifier("v").call()),
            Statement.while(
                .identifier("v"),
                body: [
                    .expression(.identifier("a")),
                    Statement.if(
                        .identifier("a"),
                        body: [.break()],
                        else: [
                            .expression(.identifier("b")),
                            .continue()
                        ])
                ]
            )
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="BreakStatement"]
                n2 [label="ContinueStatement"]
                n3 [label="a"]
                n4 [label="b"]
                n5 [label="entry"]
                n6 [label="exit"]
                n7 [label="v()"]
                n8 [label="{if}"]
                n9 [label="{while}"]
                n1 -> n6
                n2 -> n9 [color="#aa3333",penwidth=0.5]
                n3 -> n8
                n4 -> n2
                n5 -> n7
                n7 -> n9
                n8 -> n1
                n8 -> n4
                n9 -> n3
                n9 -> n6
            }
            """)
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
                n2 [label="exit"]
                n3 [label="{return}"]
                n4 [label="{while}"]
                n1 -> n4
                n3 -> n2
                n4 -> n3
                n4 -> n2
            }
            """)
        XCTAssertEqual(graph.nodes.count, 4)
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
                n1 [label="BreakStatement"]
                n2 [label="entry"]
                n3 [label="exit"]
                n4 [label="{while}"]
                n1 -> n3
                n2 -> n4
                n4 -> n1
                n4 -> n3
            }
            """)
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
                n1 [label="ContinueStatement"]
                n2 [label="entry"]
                n3 [label="exit"]
                n4 [label="{while}"]
                n1 -> n4 [color="#aa3333",penwidth=0.5]
                n2 -> n4
                n4 -> n1
                n4 -> n3
            }
            """)
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
                    .expression(.identifier("v"))
                ]
            )
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="ContinueStatement"]
                n2 [label="entry"]
                n3 [label="exit"]
                n4 [label="v"]
                n5 [label="{while}"]
                n1 -> n5 [color="#aa3333",penwidth=0.5]
                n2 -> n5
                n4 -> n5
                n5 -> n1
                n5 -> n3
            }
            """)
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
    
    func testDeferStatement() {
        let stmt: CompoundStatement = [
            Statement.defer([
                Statement.expression(.identifier("a")),
                Statement.expression(.identifier("b"))
            ]),
            Statement.expression(.identifier("c"))
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="a"]
                n2 [label="b"]
                n3 [label="c"]
                n4 [label="entry"]
                n5 [label="exit"]
                n1 -> n2
                n2 -> n5
                n3 -> n1
                n4 -> n3
            }
            """)
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
                        Statement.expression(.identifier("c"))
                    ]),
                    Statement.expression(.identifier("d"))
                ],
                else: nil
            ),
            Statement.expression(.identifier("e"))
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="b"]
                n2 [label="c"]
                n3 [label="d"]
                n4 [label="e"]
                n5 [label="entry"]
                n6 [label="exit"]
                n7 [label="{if}"]
                n1 -> n2
                n2 -> n4
                n3 -> n1
                n4 -> n6
                n5 -> n7
                n7 -> n3
                n7 -> n4
            }
            """)
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
                    Statement.expression(.identifier("c"))
                ],
                else: [
                    Statement.defer([
                        Statement.expression(.identifier("d"))
                    ]),
                    Statement.expression(.identifier("e"))
                ]
            ),
            Statement.expression(.identifier("f"))
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="b"]
                n2 [label="c"]
                n3 [label="d"]
                n4 [label="e"]
                n5 [label="entry"]
                n6 [label="exit"]
                n7 [label="f"]
                n8 [label="{if}"]
                n1 -> n7
                n2 -> n1
                n3 -> n7
                n4 -> n3
                n5 -> n8
                n7 -> n6
                n8 -> n2
                n8 -> n4
            }
            """)
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
                    Statement.expression(.identifier("c"))
                ]
            ),
            Statement.expression(.identifier("d"))
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="b"]
                n2 [label="c"]
                n3 [label="d"]
                n4 [label="entry"]
                n5 [label="exit"]
                n6 [label="{while}"]
                n1 -> n6 [color="#aa3333",penwidth=0.5]
                n2 -> n1
                n3 -> n5
                n4 -> n6
                n6 -> n2
                n6 -> n3
            }
            """)
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
                    Statement.break()
                ]
            ),
            Statement.expression(.identifier("d"))
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="BreakStatement"]
                n2 [label="b"]
                n3 [label="c"]
                n4 [label="d"]
                n5 [label="entry"]
                n6 [label="exit"]
                n7 [label="{while}"]
                n1 -> n2
                n2 -> n4
                n3 -> n1
                n4 -> n6
                n5 -> n7
                n7 -> n3
                n7 -> n4
            }
            """)
        XCTAssertEqual(graph.nodes.count, 7)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
    
    func testDeferStatementInDoWhileLoop() {
        let stmt: CompoundStatement = [
            Statement.expression(Expression.identifier("v").call()),
            Statement.doWhile(
                .identifier("v"),
                body: [
                    .defer([
                        .expression(.identifier("a"))
                    ]),
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
                n1 [label="a"]
                n2 [label="b"]
                n3 [label="entry"]
                n4 [label="exit"]
                n5 [label="v()"]
                n6 [label="{do-while}"]
                n1 -> n6
                n2 -> n1
                n3 -> n5
                n5 -> n2
                n6 -> n2 [color="#aa3333",penwidth=0.5]
                n6 -> n4
            }
            """)
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
                            .if(.identifier("precidate"),
                                body: [
                                    .break(targetLabel: "outer")
                                ],
                                else: nil)
                        ]
                    )
                ]
            ).labeled("outer"),
            .expression(.identifier("b"))
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="BreakStatement"]
                n2 [label="b"]
                n3 [label="deferred"]
                n4 [label="entry"]
                n5 [label="exit"]
                n6 [label="{for}"]
                n7 [label="{if}"]
                n8 [label="{while}"]
                n1 -> n3
                n2 -> n5
                n3 -> n8 [color="#aa3333",penwidth=0.5]
                n3 -> n2
                n4 -> n6
                n6 -> n8
                n6 -> n2
                n7 -> n1
                n7 -> n3
                n8 -> n7
                n8 -> n6 [color="#aa3333",penwidth=0.5]
            }
            """)
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
                            .if(.identifier("precidate"),
                                body: [
                                    .continue(targetLabel: "outer")
                                ],
                                else: nil)
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
                n1 [label="ContinueStatement"]
                n2 [label="deferred"]
                n3 [label="entry"]
                n4 [label="exit"]
                n5 [label="{for}"]
                n6 [label="{if}"]
                n7 [label="{while}"]
                n1 -> n2
                n2 -> n7 [color="#aa3333",penwidth=0.5]
                n2 -> n5 [color="#aa3333",penwidth=0.5]
                n3 -> n5
                n5 -> n7
                n5 -> n4
                n6 -> n1
                n6 -> n2
                n7 -> n6
                n7 -> n5 [color="#aa3333",penwidth=0.5]
            }
            """)
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
                ],
                else: nil
            ),
            Statement.defer([
                Statement.expression(.identifier("c"))
            ]),
            Statement.expression(.identifier("d"))
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
            digraph flow {
                n1 [label="a"]
                n2 [label="b"]
                n3 [label="c"]
                n4 [label="d"]
                n5 [label="entry"]
                n6 [label="exit"]
                n7 [label="{if}"]
                n8 [label="{return 0}"]
                n1 -> n6
                n2 -> n7
                n3 -> n1
                n4 -> n3
                n5 -> n2
                n7 -> n8
                n7 -> n4
                n8 -> n1
            }
            """)
        XCTAssertEqual(graph.nodes.count, 8)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
}

private extension ControlFlowGraphCreationTests {
    func sanitize(_ graph: ControlFlowGraph,
                  expectsUnreachable: Bool = false,
                  line: Int = #line) {
        
        if !graph.nodes.contains(where: { $0 === graph.entry }) {
            recordFailure(
                withDescription: """
                Graph's entry node is not currently present in nodes array
                """,
                inFile: #file,
                atLine: line,
                expected: true)
        }
        if !graph.nodes.contains(where: { $0 === graph.exit }) {
            recordFailure(
                withDescription: """
                Graph's exit node is not currently present in nodes array
                """,
                inFile: #file,
                atLine: line,
                expected: true)
        }
        
        if graph.entry.node !== graph.exit.node {
            recordFailure(
                withDescription: """
                Graph's entry and exit nodes must point to the same AST node
                """,
                inFile: #file,
                atLine: line,
                expected: true)
        }
        
        for edge in graph.edges {
            if !graph.containsNode(edge.start) {
                recordFailure(
                    withDescription: """
                    Edge contains reference for node that is not present in graph: \(edge.start.node)
                    """,
                    inFile: #file,
                    atLine: line,
                    expected: true)
            }
            if !graph.containsNode(edge.end) {
                recordFailure(
                    withDescription: """
                    Edge contains reference for node that is not present in graph: \(edge.end.node)
                    """,
                    inFile: #file,
                    atLine: line,
                    expected: true)
            }
        }
        
        for node in graph.nodes {
            if node is ControlFlowSubgraphNode {
                recordFailure(
                    withDescription: """
                    Found non-expanded subgraph node: \(node.node)
                    """,
                    inFile: #file,
                    atLine: line,
                    expected: true)
            }
            
            if graph.allEdges(for: node).isEmpty {
                recordFailure(
                    withDescription: """
                    Found a free node with no edges or connections: \(node.node)
                    """,
                    inFile: #file,
                    atLine: line,
                    expected: true)
                
                continue
            }
            
            if !expectsUnreachable && node !== graph.entry && graph.edges(towards: node).isEmpty {
                recordFailure(
                    withDescription: """
                    Found non-entry node that has no connections towards it: \(node.node)
                    """,
                    inFile: #file,
                    atLine: line,
                    expected: true)
            }
            
            if node !== graph.exit && graph.edges(from: node).isEmpty {
                recordFailure(
                    withDescription: """
                    Found non-exit node that has no connections from it: \(node.node)
                    """,
                    inFile: #file,
                    atLine: line,
                    expected: true)
            }
        }
    }
    
    func assertGraphviz(graph: ControlFlowGraph, matches expected: String, line: Int = #line) {
        let text = graphviz(graph: graph)
        if text == expected {
            return
        }
        
        recordFailure(withDescription: """
            Expected produced graph to be
            
            \(expected)
            
            But found:
            
            \(text.makeDifferenceMarkString(against: expected))
            """,
                      inFile: #file,
                      atLine: line,
                      expected: true)
    }
    
    func printGraphviz(graph: ControlFlowGraph) {
        let string = graphviz(graph: graph)
        print(string)
    }
    
    func graphviz(graph: ControlFlowGraph) -> String {
        let buffer = StringRewriterOutput(settings: .defaults)
        buffer.output(line: "digraph flow {")
        buffer.idented {
            var nodeIds: [ObjectIdentifier: String] = [:]
            
            var nodeDefinitions: [(node: ControlFlowGraphNode, label: String)] = []
            
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
                
                nodeDefinitions.append((node: node, label: label))
            }
            
            // Sort nodes so the result is more stable
            nodeDefinitions.sort { $0.label < $1.label }
            
            // Prepare nodes
            for (i, (node: node, label: label)) in nodeDefinitions.enumerated() {
                let id = "n\(i + 1)"
                nodeIds[ObjectIdentifier(node)] = id
                
                buffer.output(line: "\(id) [label=\"\(label)\"]")
            }
            
            // Output connections
            for (node, _) in nodeDefinitions {
                let nodeId = nodeIds[ObjectIdentifier(node)]!
                
                let edges = graph.edges(from: node)
                
                for edge in edges {
                    let target = edge.end
                    
                    let targetId = nodeIds[ObjectIdentifier(target)]!
                    buffer.outputIdentation()
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
}
