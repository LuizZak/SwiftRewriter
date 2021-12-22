import SwiftAST
import XCTest

class SyntaxNodeRewriterTests: XCTestCase {
    /// Tests that a pass of a bare syntax rewriter doesn't accidentally modifies
    /// the syntax tree when it should otherwise not.
    func testRewriterKeepsSyntaxTreeEqual() {
        let makeNode: () -> Statement = {
            Statement.compound([
                .if(
                    Expression.identifier("a"),
                    body: [
                        .expressions([
                            Expression.identifier("a").optional().call(),
                            Expression.identifier("a").optional().sub(.identifier("b")),
                        ])
                    ]
                ),
                .while(
                    Expression.identifier("a"),
                    body: [
                        .break()
                    ]
                ),
                .for(
                    .identifier("i"),
                    .arrayLiteral([.constant(1), .constant(2), .constant(3)]),
                    body: [
                        .continue()
                    ]
                ),
            ])
        }

        let sut = SyntaxNodeRewriter()

        XCTAssertEqual(sut.visitStatement(makeNode()), makeNode())
    }

    /// Tests Postfix.returnType & FunctionCallPostfix.callableSignature metadata
    /// information is kept when traversing a syntax tree  and visiting a function
    /// call postfix node
    func testRewriterKeepsFunctionCallPostfixInformation() {
        let makeNode: () -> Expression = {
            Expression
                .identifier("a")
                .optional()
                .call(
                    [.identifier("b")],
                    type: .int,
                    callableSignature: .swiftBlock(returnType: .int, parameters: [.typeName("b")])
                )
        }
        let sut = SyntaxNodeRewriter()

        let result = sut.visitExpression(makeNode())

        XCTAssertEqual(result.asPostfix?.op.optionalAccessKind, .safeUnwrap)
        XCTAssertEqual(result.asPostfix?.functionCall?.returnType, .int)
        XCTAssertEqual(
            result.asPostfix?.functionCall?.callableSignature,
            .swiftBlock(returnType: .int, parameters: [.typeName("b")])
        )
    }

    /// Tests Postfix.returnType metadata information is kept when traversing a
    /// syntax tree and visiting a subscription postfix node
    func testRewriterKeepsSubscriptInformation() {
        let makeNode: () -> Expression = {
            Expression.identifier("a").optional().sub(.identifier("b"), type: .int)
        }
        let sut = SyntaxNodeRewriter()

        let result = sut.visitExpression(makeNode())

        XCTAssertEqual(result.asPostfix?.subscription?.returnType, .int)
        XCTAssertEqual(result.asPostfix?.op.optionalAccessKind, .safeUnwrap)
    }

    /// Tests Postfix.returnType metadata information is kept when traversing a
    /// syntax tree and visiting a member access postfix node
    func testRewriterKeepsMemberInformation() {
        let makeNode: () -> Expression = {
            Expression.identifier("a").optional().dot("b", type: .int)
        }
        let sut = SyntaxNodeRewriter()

        let result = sut.visitExpression(makeNode())

        XCTAssertEqual(result.asPostfix?.member?.returnType, .int)
        XCTAssertEqual(result.asPostfix?.op.optionalAccessKind, .safeUnwrap)
    }
}
