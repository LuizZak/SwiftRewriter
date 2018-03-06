import XCTest
import ExpressionPasses
import SwiftRewriterLib
import SwiftAST
import TestCommons

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
        
        assertNotifiedChange()
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
        
        assertDidNotNotifyChange()
    }
    
    // MARK: - Test-not-nil-then-invoke block patterns
    
    func testSimplifyCheckThenCallConstructs() {
        // With braces
        assertTransformParsed(
            statement: """
            if (block != nil) {
                block();
            }
            """,
            into: Statement
                .expression(
                    Expression.identifier("block").optional().call()
                )
        )
        
        assertNotifiedChange()
        
        // W/out braces
        assertTransformParsed(
            statement: """
            if (block != nil)
                block();
            """,
            into: Statement
                .expression(
                    Expression.identifier("block").optional().call()
                )
        )
        
        assertNotifiedChange()
    }
    
    func testDoNotSimplifyNonBlockCheckConstructs() {
        assertTransformParsed(
            statement: """
            // Cannot simplify, since `member.prop` may return different values
            // after each invocation (i.e. a computed getter).
            // The end result may be different in behavior, then.
            if (value.member != nil) {
                value.member();
            }
            """,
            into: Statement
                .if(Expression.identifier("value").dot("member").binary(op: .unequals, rhs: .constant(.nil)),
                    body: [
                        .expression(Expression.identifier("value").dot("member").call())
                    ], else: nil)
        )
        
        assertDidNotNotifyChange()
    }
    
    func testDontAlterTestThenInvokeBlockOnIfWithElse() {
        // We can't simplify away if-statements that contain an else
        assertTransformParsed(
            statement: """
            if (block != nil) {
                block();
            } else {
                stmt();
            }
            """,
            into: Statement
                .if(Expression.identifier("block").binary(op: .unequals, rhs: .constant(.nil)),
                    body: [
                        .expression(Expression.identifier("block").call())
                    ], else: [
                        .expression(Expression.identifier("stmt").call())
                    ])
        )
        
        assertDidNotNotifyChange()
    }
}
