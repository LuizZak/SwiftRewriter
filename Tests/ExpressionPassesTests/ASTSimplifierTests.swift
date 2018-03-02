import XCTest
import ExpressionPasses
import SwiftRewriterLib
import SwiftAST

class ASTSimplifierTests: ExpressionPassTestCase {
    override func setUp() {
        sut = ASTSimplifier()
    }
    
    func testSimplifyDoWithinCompound() {
        let statement = Statement
            .compound([
                .do([
                    .expression(
                        .identifier("a"))
                    ])
                ]
            )
        
        assertTransform(
            statement: statement,
            into: .compound([
                    .expression(.identifier("a"))
                ]
            )
        )
    }
    
    func testDoesNotSimplifyDoWithinCompoundWithExtraStatements() {
        let statement = Statement
            .compound([
                .do([
                    .expression(
                        .identifier("a"))
                    ]),
                .expression(.identifier("b"))
                ]
            )
        
        assertTransform(
            statement: statement,
            into: .compound([
                .do([
                    .expression(
                        .identifier("a"))
                    ]),
                .expression(.identifier("b"))
                ]
            )
        )
    }
}
