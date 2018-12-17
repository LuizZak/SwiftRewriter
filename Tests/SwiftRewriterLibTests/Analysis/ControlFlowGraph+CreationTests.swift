import XCTest
@testable import SwiftRewriterLib
import SwiftAST
import TestCommons

class ControlFlowGraphCreationTests: XCTestCase {
    func testCreateEmpty() {
        let stmt: CompoundStatement = []
        let graph = ControlFlowGraph.forCompoundStatement(stmt)
        
        sanitize(graph)
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
        XCTAssertEqual(graph.nodes.count, 2)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt])
    }
    
    func testCreateWhileLoop() {
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
        XCTAssertEqual(graph.nodes.count, 5)
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
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
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
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
    }
    
    func testCreateIfElse() {
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
        XCTAssertEqual(graph.nodes.count, 7)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 3)
    }
}

private extension ControlFlowGraphCreationTests {
    func sanitize(_ graph: ControlFlowGraph, line: Int = #line) {
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
            
            if node !== graph.entry && graph.edges(towards: node).isEmpty {
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
}
