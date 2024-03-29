import SwiftAST
import SwiftRewriterLib
import TestCommons
import XCTest

@testable import ExpressionPasses

class ASTSimplifierTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()

        sutType = ASTSimplifier.self
    }

    func testSimplifyDoWithinCompound() {
        let statement =
            Statement
            .compound([
                .do([
                    .expression(
                        .identifier("a")
                    )
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
        let statement = Statement.compound([
            .do([
                .expression(
                    .identifier("a")
                )
            ]),
            .expression(.identifier("b")),
        ])   

        assertNoTransform(
            statement: statement
        )
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
        )

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
            into:
                .expression(
                    .identifier("block").optional().call()
                )
        )

        // W/out braces
        assertTransformParsed(
            statement: """
                if (block != nil)
                    block();
                """,
            into:
                .expression(
                    .identifier("block").optional().call()
                )
        )
    }

    func testDoNotSimplifyNonBlockCheckConstructs() {
        assertNoTransformParsed(
            statement: """
                // Cannot simplify, since `member.prop` may return different values
                // after each invocation (i.e. a computed getter).
                // The end result may be different in behavior, then.
                if (value.member != nil) {
                    value.member();
                }
                """
        )
    }

    func testDontAlterTestThenInvokeBlockOnIfWithElse() {
        // We can't simplify away if-statements that contain an else
        assertNoTransformParsed(
            statement: """
                if (block != nil) {
                    block();
                } else {
                    stmt();
                }
                """
        )
    }

    // MARK: - Redundant Parenthesis Removal

    /// Test simplification of redundant parenthesis on expressions
    func testSimplifyParenthesis() {
        assertTransform(
            // (0)
            expression: .parens(.constant(0)),
            // 0
            into: .constant(0)
        )
    }

    func testSimplifyParenthesisDeep() {
        assertTransform(
            // (((0)))
            expression: .parens(.parens(.parens(.constant(0)))),
            // 0
            into: .constant(0)
        )
    }

    func testSimplifyParenthesisInFunctionArguments() {
        assertTransform(
            // a((0))
            expression: .identifier("a").call([.parens(.constant(0))]),
            // a(0)
            into: .identifier("a").call([.constant(0)])
        )
    }

    func testSimplifyParenthesisInSubscriptionExpression() {
        assertTransform(
            // a[(0)]
            expression: .identifier("a").sub(.parens(.constant(0))),
            // a[0]
            into: .identifier("a").sub(.constant(0))
        )
    }

    func testSimplifyParenthesisInTopLevelExpression() {
        assertTransform(
            // { (a) }
            statement: .expression(.parens(.constant(0))),
            // { a }
            into: .expression(.constant(0))
        )
    }

    func testSimplifyParenthesisInIfExpression() {
        assertTransform(
            // if (a) { }
            statement: .if(.parens(.constant(0)), body: []),
            // if a { }
            into: .if(.constant(0), body: [])
        )
    }

    func testSimplifyParenthesisInWhileExpression() {
        assertTransform(
            // while (a) { }
            statement: .while(.parens(.constant(0)), body: []),
            // while a { }
            into: .while(.constant(0), body: [])
        )
    }

    func testSimplifyParenthesisInForExpression() {
        assertTransform(
            // for a in (0) { }
            statement: .for(.identifier("a"), .parens(.constant(0)), body: []),
            // for a in 0 { }
            into: .for(.identifier("a"), .constant(0), body: [])
        )
    }

    func testSimplifyParenthesisInSwitchExpression() {
        assertTransform(
            // switch (0) { }
            statement: .switch(.parens(.constant(0)), cases: [], default: nil),
            // switch 0 { }
            into: .switch(.constant(0), cases: [], default: nil)
        )
    }

    func testSimplifyParenthesisInSwitchCaseExpressions() {
        assertTransform(
            // switch 0 { case (0): }
            statement:
                Statement
                .switch(
                    .constant(0),
                    cases: [
                        SwitchCase(patterns: [.expression(.parens(.constant(0)))], statements: [])
                    ],
                    default: nil
                ),
            // switch 0 { case 0: }
            into:
                .switch(
                    .constant(0),
                    cases: [SwitchCase(patterns: [.expression(.constant(0))], statements: [])],
                    default: nil
                )
        )
    }

    func testDontSimplifyParenthesisInBinaryExpression() {
        assertNoTransform(
            // (0) + 1
            expression: .parens(.constant(0)).binary(op: .add, rhs: .constant(1))
        )
    }

    /// Tests that spurious break statements as the last statement of a switch
    /// case are removed (since in Swift switches automatically break at the end
    /// of a case)
    func testSimplifyBreakAsLastSwitchCaseStatement() {
        assertTransform(
            statement:
                Statement
                .switch(
                    .constant(0),
                    cases: [
                        SwitchCase(
                            patterns: [],
                            statements: [
                                Statement.expression(.identifier("stmt")),
                                Statement.break(),
                            ]
                        )
                    ],
                    defaultStatements: [
                        Statement.expression(.identifier("stmt")),
                        Statement.break(),
                    ]
                ),
            into:
                .switch(
                    .constant(0),
                    cases: [
                        SwitchCase(
                            patterns: [],
                            statements: [
                                Statement.expression(.identifier("stmt"))
                            ]
                        )
                    ],
                    defaultStatements: [
                        Statement.expression(.identifier("stmt"))
                    ]
                )
        )
    }

    /// Asserts that we don't remove break statements from empty switch cases
    func testDontRemoveBreakFromEmptyCases() {
        assertNoTransform(
            statement:
                Statement
                .switch(
                    .constant(0),
                    cases: [
                        SwitchCase(
                            patterns: [],
                            statements: [
                                Statement.break()
                            ]
                        )
                    ],
                    defaultStatements: [
                        Statement.break()
                    ]
                )
        )
    }

    func testSplitTopLevelTupleExpressions() {
        assertTransform(
            statement:
                .compound([
                    .expression(
                        .tuple([
                            .constant(1),
                            .constant(2)
                        ])
                    )
                ]),
            into:
                .compound([
                    .expression(.constant(1)),
                    .expression(.constant(2)),
                ])
        )
    }

    func testSplitTopLevelTupleExpressions_inDeferStatement() {
        assertTransform(
            statement:
                .defer([
                    .expression(
                        .tuple([
                            .identifier("a").assignment(op: .subtractAssign, rhs: .constant(1)),
                            .identifier("b").assignment(op: .subtractAssign, rhs: .constant(1)),
                        ])
                    )
                ]),
            into:
                .defer([
                    .expression(
                        .identifier("a").assignment(op: .subtractAssign, rhs: .constant(1))
                    ),
                    .expression(
                        .identifier("b").assignment(op: .subtractAssign, rhs: .constant(1))
                    ),
                ])
        )
    }

    func testSplitTopLevelTupleExpressions_inNestedDictionaryBlockExpression() {
        assertTransform(
            statement:
                .expression(
                    .dictionaryLiteral([
                        .init(
                            key: .identifier("a"), 
                            value: .block(body: [
                                .defer([
                                    .expression(
                                        .tuple([
                                            .identifier("a").assignment(op: .subtractAssign, rhs: .constant(1)),
                                            .identifier("b").assignment(op: .subtractAssign, rhs: .constant(1)),
                                        ])
                                    )
                                ])
                            ])
                        )
                    ])
                ),
            into:
                .expression(
                    .dictionaryLiteral([
                        .init(
                            key: .identifier("a"), 
                            value: .block(body: [
                                .defer([
                                    .expression(
                                        .identifier("a").assignment(op: .subtractAssign, rhs: .constant(1))
                                    ),
                                    .expression(
                                        .identifier("b").assignment(op: .subtractAssign, rhs: .constant(1))
                                    ),
                                ])
                            ])
                        )
                    ])
                )
        )
    }

    func testSplitTopLevelTupleExpressions_keepStatementLabel() {
        assertTransform(
            statement:
                .compound([
                    .expression(
                        .tuple([
                            .constant(1),
                            .constant(2)
                        ])
                    ).labeled("label")
                ]),
            into:
                .compound([
                    .expression(.constant(1)).labeled("label"),
                    .expression(.constant(2)),
                ])
        )
    }

    func testSplitTopLevelTupleExpressions_keepLeadingComments() {
        assertTransform(
            statement:
                .compound([
                    .expression(
                        .tuple([
                            .constant(1),
                            .constant(2)
                        ])
                    ).withComments(["A comment"])
                ]),
            into:
                .compound([
                    .expression(.constant(1)).withComments(["A comment"]),
                    .expression(.constant(2)),
                ])
        )
    }

    func testSplitTopLevelTupleExpressions_keepTrailingCommentsOnTrailingStatement() {
        assertTransform(
            statement:
                .compound([
                    .expression(
                        .tuple([
                            .constant(1),
                            .constant(2)
                        ])
                    ).withTrailingComment("A comment")
                ]),
            into:
                .compound([
                    .expression(.constant(1)),
                    .expression(.constant(2)).withTrailingComment("A comment"),
                ])
        )
    }
}
