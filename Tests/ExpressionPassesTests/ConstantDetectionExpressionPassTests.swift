import XCTest
import ExpressionPasses
import SwiftRewriterLib
import SwiftAST

class ConstantDetectionExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sutType = ConstantDetectionExpressionPass.self
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
}
