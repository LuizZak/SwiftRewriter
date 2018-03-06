import XCTest
import SwiftAST

class SyntaxNodeRewriterTests: XCTestCase {
    /// Tests that a pass of a bare syntax rewriter doesn't accidentally modifies
    /// the syntax tree when it should otherwise not.
    func testRewriterKeepsSyntaxTreeEqual() {
        let makeNode: () -> Statement = {
            Statement.compound([
                .if(Expression.identifier("a"),
                    body: [
                        .expressions([
                            Expression.identifier("a").optional().call(),
                            Expression.identifier("a").optional().sub(.identifier("b"))
                        ])
                    ],
                    else: nil),
                .while(Expression.identifier("a"),
                       body: [
                        .break
                    ]),
                .for(.identifier("i"), .arrayLiteral([.constant(1), .constant(2), .constant(3)]),
                     body: [
                        .continue
                    ])
            ])
        }
        
        let sut = SyntaxNodeRewriter()
        
        XCTAssertEqual(sut.visitStatement(makeNode()), makeNode())
    }
}
