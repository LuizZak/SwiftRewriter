import XCTest
import ExpressionPasses
import SwiftRewriterLib
import SwiftAST

class LocalConstantPromotionExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sutType = LocalConstantPromotionExpressionPass.self
        intentionContext = .global(
            GlobalFunctionGenerationIntention(
                signature: FunctionSignature(name: "test")
            )
        )
    }
    
    func testDetectTrivialLetConstant() {
        let body: CompoundStatement = [
            Statement.variableDeclaration(identifier: "test",
                                          type: .int,
                                          initialization: .constant(0))
        ]
        functionBodyContext = FunctionBodyIntention(body: body)
        
        assertTransform(
            statement: body,
            into: CompoundStatement(statements: [
                Statement.variableDeclaration(identifier: "test",
                                              type: .int,
                                              isConstant: true,
                                              initialization: .constant(0))
            ])
        ); assertNotifiedChange()
    }
    
    func testNonConstantCase() {
        let body: CompoundStatement = [
            Statement.variableDeclaration(identifier: "test",
                                          type: .int,
                                          initialization: .constant(0)),
            Statement.expression(
                Expression
                    .identifier("test")
                    .assignment(op: .equals, rhs: .constant(1))
            )
        ]
        functionBodyContext = FunctionBodyIntention(body: body)
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _=resolver.resolveTypes(in: body)
        
        assertTransform(
            statement: body,
            into: CompoundStatement(statements: [
                Statement.variableDeclaration(identifier: "test",
                                              type: .int,
                                              isConstant: false,
                                              initialization: .constant(0)),
                Statement.expression(
                    Expression
                        .identifier("test")
                        .assignment(op: .equals, rhs: .constant(1)))
            ])
        ); assertDidNotNotifyChange()
    }
}
