import XCTest
@testable import SwiftRewriterLib
import SwiftAST
import TestCommons

class ControlFlowGraphCreationTests: XCTestCase {
    func testCreateEmpty() {
        let stmt: CompoundStatement = []
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        printGraphviz(graph: graph)
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
        printGraphviz(graph: graph)
        XCTAssertEqual(graph.nodes.count, 2)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt])
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
        printGraphviz(graph: graph)
        XCTAssertEqual(graph.nodes.count, 6)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
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
        printGraphviz(graph: graph)
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
        printGraphviz(graph: graph)
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
                    SwitchCase(patterns: [], statements: [])
                ],
                default: [
                    .expression(.identifier("c"))
                ]
            )
        ]
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        printGraphviz(graph: graph)
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
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
        printGraphviz(graph: graph)
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
        printGraphviz(graph: graph)
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.backEdges(towards: graph.graphNode(for: stmt.statements[1])!).count, 1)
        XCTAssertEqual(graph.backEdges(from: graph.graphNode(for: stmt.statements[1])!).count, 1)
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
        printGraphviz(graph: graph)
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.backEdges(from: graph.graphNode(for: stmt.statements[1])!).count, 1)
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
        printGraphviz(graph: graph)
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.backEdges(towards: graph.graphNode(for: stmt.statements[1])!).count, 1)
        XCTAssertEqual(graph.backEdges(from: graph.graphNode(for: stmt.statements[1])!).count, 1)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
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
        printGraphviz(graph: graph)
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
        printGraphviz(graph: graph)
        XCTAssertEqual(graph.nodes.count, 3)
        XCTAssertEqual(graph.backEdges(towards: graph.graphNode(for: stmt.statements[0])!).count, 1)
        XCTAssertEqual(graph.backEdges(from: graph.graphNode(for: stmt.statements[0])!).count, 1)
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
                        body: [.break],
                        else: [
                            .expression(.identifier("b")),
                            .continue
                        ])
                ]
            )
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        printGraphviz(graph: graph)
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
        printGraphviz(graph: graph)
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }
    
    func testBreakStatement() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("v"),
                body: [
                    .break
                ]
            )
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        printGraphviz(graph: graph)
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }
    
    func testContinueStatement() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("v"),
                body: [
                    .continue
                ]
            )
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
        printGraphviz(graph: graph)
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }
    
    func testContinueStatementSkippingOverRemainingOfMethod() {
        let stmt: CompoundStatement = [
            Statement.while(
                .identifier("v"),
                body: [
                    .continue,
                    .expression(.identifier("v"))
                ]
            )
        ]
        
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph, expectsUnreachable: true)
        printGraphviz(graph: graph)
        XCTAssertEqual(graph.nodes.count, 5)
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
        
        for node in graph.nodes {
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
    
    func printGraphviz(graph: ControlFlowGraph) {
        let buffer = StringRewriterOutput(settings: .defaults)
        buffer.output(line: "digraph flow {")
        buffer.idented {
            var nodeIds: [ObjectIdentifier: String] = [:]
            
            // Prepare nodes
            for (i, node) in graph.nodes.enumerated() {
                let id = "n\(i + 1)"
                nodeIds[ObjectIdentifier(node)] = id
                
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
                
                buffer.output(line: "\(id) [label=\"\(label)\"]")
            }
            
            // Output connections
            for node in graph.nodes {
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
        
        print(buffer.buffer)
    }
}
