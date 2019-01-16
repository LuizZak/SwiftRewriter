import XCTest
@testable import SwiftRewriterLib
import Intentions
import SwiftAST
import TestCommons

class ReachingDefinitionAnalysisTests: XCTestCase {
    var controlFlowGraph: ControlFlowGraph!
    var sut: ReachingDefinitionAnalyzer!
    
    override func setUp() {
        super.setUp()
        
        sut = nil
        controlFlowGraph = nil
    }
    
    func testVarDecl() {
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .int, initialization: .constant(0)),
            .expression(Expression.identifier("a"))
        ]
        setupTest(with: body)
        
        let definitions = sut.reachingDefinitions(for: controlFlowGraph.graphNode(for: body.statements[1])!)
        
        XCTAssertEqual(definitions.count, 1)
        XCTAssertEqual(definitions.first?.definition.name, "a")
        XCTAssert(definitions.first?.definitionSite === body.statements[0])
    }
    
    func testVarDeclWithNoInitialization() {
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .int, initialization: nil),
            .expression(Expression.identifier("a"))
        ]
        setupTest(with: body)
        
        let definitions = sut.reachingDefinitions(for: controlFlowGraph.graphNode(for: body.statements[1])!)
        
        XCTAssertEqual(definitions.count, 0)
    }
    
    func testIf() {
        let body: CompoundStatement = [
            Statement.variableDeclaration(identifier: "a",
                                          type: .int,
                                          initialization: .constant(0)),
            Statement.if(
                .identifier("predicate"),
                body: [
                    .expression(
                        Expression
                            .identifier("a")
                            .assignment(op: .assign, rhs: .constant(1))
                    )
                ],
                else: nil),
            Statement.expression(.identifier("a"))
        ]
        setupTest(with: body)
        
        let definitions =
            sut.reachingDefinitions(for:
                controlFlowGraph.graphNode(for: body.statements[2])!)
        
        XCTAssertEqual(definitions.count, 2)
        XCTAssertEqual(definitions.first?.definition.name, "a")
        XCTAssert(definitions.contains { $0.definitionSite === body.statements[0].asVariableDeclaration })
        XCTAssert(definitions.contains { $0.definitionSite === body.statements[1].asIf!.body.statements[0].asExpressions?.expressions[0] })
    }
    
    func testIfElse() {
        let body: CompoundStatement = [
            Statement.variableDeclaration(identifier: "a",
                                          type: .int,
                                          initialization: nil),
            Statement.if(
                .identifier("predicate"),
                body: [
                    .expression(
                        Expression
                            .identifier("a")
                            .assignment(op: .assign, rhs: .constant(0))
                    )
                ],
                else: [
                    .expression(
                        Expression
                            .identifier("a")
                            .assignment(op: .assign, rhs: .constant(1))
                    )
                ]
            ),
            Statement.expression(.identifier("a"))
        ]
        setupTest(with: body)
        
        let definitions =
            sut.reachingDefinitions(for:
                controlFlowGraph.graphNode(for: body.statements[2])!)
        
        XCTAssertEqual(definitions.count, 2)
        XCTAssertEqual(definitions.first?.definition.name, "a")
        XCTAssert(definitions.contains { $0.definitionSite === body.statements[1].asIf!.body.statements[0].asExpressions?.expressions[0] })
        XCTAssert(definitions.contains { $0.definitionSite === body.statements[1].asIf!.elseBody!.statements[0].asExpressions?.expressions[0] })
    }
    
    func testIfLet() {
        let body: CompoundStatement = [
            Statement.ifLet(
                .identifier("a"),
                .constant(.nil),
                body: [
                    .expression(Expression.identifier("a"))
                ],
                else: [
                    .expression(Expression.identifier("a"))
                ]
            )
        ]
        setupTest(with: body)
        
        let definitions =
            sut.reachingDefinitions(for:
                controlFlowGraph.graphNode(for: body.statements[0].asIf!.body.statements[0])!)
        
        XCTAssertEqual(definitions.count, 1)
        XCTAssertEqual(definitions.first?.definition.name, "a")
        XCTAssert(definitions.first?.definitionSite === body.statements[0])
    }
    
    func testForLoop() {
        let body: CompoundStatement = [
            Statement.for(
                .identifier("a"),
                .constant(.nil),
                body: [
                    .expression(.identifier("a"))
                ])
        ]
        setupTest(with: body)
        
        let definitions =
            sut.reachingDefinitions(for:
                controlFlowGraph.graphNode(for: body.statements[0].asFor!.body.statements[0])!)
        
        XCTAssertEqual(definitions.count, 1)
        XCTAssertEqual(definitions.first?.definition.name, "a")
        XCTAssert(definitions.first?.definitionSite === body.statements[0])
    }
}

private extension ReachingDefinitionAnalysisTests {
    func setupTest(with body: CompoundStatement) {
        let typeSystem = TypeSystem.defaultTypeSystem
        
        let resolver = ExpressionTypeResolver(typeSystem: typeSystem)
        _=resolver.resolveTypes(in: body)
        
        controlFlowGraph = ControlFlowGraph.forCompoundStatement(body)
        sut = ReachingDefinitionAnalyzer(
            controlFlowGraph: controlFlowGraph,
            functionBody: FunctionBodyIntention(body: body),
            typeSystem: typeSystem
        )
    }
}
