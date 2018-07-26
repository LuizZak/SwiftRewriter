import XCTest
import ExpressionPasses
import SwiftRewriterLib
import SwiftAST

class InitRewriterExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sut = InitRewriterExpressionPass()
    }
    
    func testEmptyIfInInit() {
        intentionContext = .initializer(InitGenerationIntention(parameters: []))
        
        assertTransform(
            statement: .compound([
                .expression(
                    Expression
                        .identifier("self")
                        .assignment(
                            op: .assign,
                            rhs: Expression
                                .identifier("super").dot("init").call())
                ),
                
                .if(.identifier("self"), body: [], else: nil),
                
                .return(.identifier("self"))
            ]),
            into: .compound([
                .expression(Expression.identifier("super").dot("init").call())
            ])
        ); assertNotifiedChange()
    }
}
