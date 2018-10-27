import XCTest
import ExpressionPasses
import SwiftRewriterLib
import SwiftAST
import TestCommons

class ASTSimplifierTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sutType = ASTSimplifier.self
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
        ); assertNotifiedChange()
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
        ); assertDidNotNotifyChange()
    }
    
    func testMaintainStatementLabelWhileSimplifyingSingleStatementDos() {
        let input = Statement.compound([.do([.expression(.constant(0))])])
        input.label = "label"
        
        let expected = Statement.compound([.expression(.constant(0))])
        expected.label = "label"
        
        let res = assertTransform(
            // label: { do { 0; } }
            statement: input,
            // label: { 0; }
            into: expected
        ); assertNotifiedChange()
        
        XCTAssertEqual(res.label, "label")
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
        ); assertNotifiedChange()
        
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
        ); assertNotifiedChange()
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
        ); assertDidNotNotifyChange()
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
        ); assertDidNotNotifyChange()
    }
    
    // MARK: - Redundant Parenthesis Removal
    
    /// Test simplification of redundant parenthesis on expressions
    func testSimplifyParenthesis() {
        assertTransform(
            // (0)
            expression: .parens(.constant(0)),
            // 0
            into: .constant(0)
        ); assertNotifiedChange()
    }
    
    func testSimplifyParenthesisDeep() {
        assertTransform(
            // (((0)))
            expression: .parens(.parens(.parens(.constant(0)))),
            // 0
            into: .constant(0)
        ); assertNotifiedChange()
    }
    
    func testSimplifyParenthesisInFunctionArguments() {
        assertTransform(
            // a((0))
            expression: Expression.identifier("a").call([.parens(.constant(0))]),
            // a(0)
            into: Expression.identifier("a").call([.constant(0)])
        ); assertNotifiedChange()
    }
    
    func testSimplifyParenthesisInSubscriptionExpression() {
        assertTransform(
            // a[(0)]
            expression: Expression.identifier("a").sub(.parens(.constant(0))),
            // a[0]
            into: Expression.identifier("a").sub(.constant(0))
        ); assertNotifiedChange()
    }
    
    func testSimplifyParenthesisInTopLevelExpression() {
        assertTransform(
            // { (a) }
            statement: Statement.expression(.parens(.constant(0))),
            // { a }
            into: Statement.expression(.constant(0))
        ); assertNotifiedChange()
    }
    
    func testSimplifyParenthesisInIfExpression() {
        assertTransform(
            // if (a) { }
            statement: Statement.if(.parens(.constant(0)), body: [], else: nil),
            // if a { }
            into: Statement.if(.constant(0), body: [], else: nil)
        ); assertNotifiedChange()
    }
    
    func testSimplifyParenthesisInWhileExpression() {
        assertTransform(
            // while (a) { }
            statement: Statement.while(.parens(.constant(0)), body: []),
            // while a { }
            into: Statement.while(.constant(0), body: [])
        ); assertNotifiedChange()
    }
    
    func testSimplifyParenthesisInForExpression() {
        assertTransform(
            // for a in (0) { }
            statement: Statement.for(.identifier("a"), .parens(.constant(0)), body: []),
            // for a in 0 { }
            into: Statement.for(.identifier("a"), .constant(0), body: [])
        ); assertNotifiedChange()
    }
    
    func testSimplifyParenthesisInSwitchExpression() {
        assertTransform(
            // switch (0) { }
            statement: Statement.switch(.parens(.constant(0)), cases: [], default: nil),
            // switch 0 { }
            into: Statement.switch(.constant(0), cases: [], default: nil)
        ); assertNotifiedChange()
    }
    
    func testSimplifyParenthesisInSwitchCaseExpressions() {
        assertTransform(
            // switch 0 { case (0): }
            statement: Statement
                .switch(.constant(0),
                        cases: [SwitchCase(patterns: [.expression(.parens(.constant(0)))], statements: [])],
                        default: nil),
            // switch 0 { case 0: }
            into: Statement
                .switch(.constant(0),
                        cases: [SwitchCase(patterns: [.expression(.constant(0))], statements: [])],
                        default: nil)
        ); assertNotifiedChange()
    }
    
    func testDontSimplifyParenthesisInBinaryExpression() {
        assertTransform(
            // (0) + 1
            expression: Expression.parens(.constant(0)).binary(op: .add, rhs: .constant(1)),
            // (0) + 1
            into: Expression.parens(.constant(0)).binary(op: .add, rhs: .constant(1))
        ); assertDidNotNotifyChange()
    }
    
    /// Tests that spurious break statements as the last statement of a switch
    /// case are removed (since in Swift switches automatically break at the end
    /// of a case)
    func testSimplifyBreakAsLastSwitchCaseStatement() {
        assertTransform(
            statement: Statement
                .switch(
                    .constant(0),
                    cases: [
                        SwitchCase(patterns: [], statements: [
                            Statement.expression(.identifier("stmt")),
                            Statement.break
                        ])
                    ],
                    default: [
                        Statement.expression(.identifier("stmt")),
                        Statement.break
                    ]),
            into: Statement
                .switch(
                    .constant(0),
                    cases: [
                        SwitchCase(patterns: [], statements: [
                            Statement.expression(.identifier("stmt")),
                        ])
                    ],
                    default: [
                        Statement.expression(.identifier("stmt")),
                    ])
        ); assertNotifiedChange()
    }
    
    /// Asserts that we don't remove break statements from empty switch cases
    func testDontRemoveBreakFromEmptyCases() {
        assertTransform(
            statement: Statement
                .switch(
                    .constant(0),
                    cases: [
                        SwitchCase(patterns: [], statements: [
                            Statement.break
                        ])
                    ],
                    default: [
                        Statement.break
                    ]),
            into: Statement
                .switch(
                    .constant(0),
                    cases: [
                        SwitchCase(patterns: [], statements: [
                            Statement.break
                        ])
                    ],
                    default: [
                        Statement.break
                    ])
        ); assertDidNotNotifyChange()
    }
}
