import SwiftAST
import TestCommons

@testable import ExpressionPasses

class NilValueTransformationsPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()

        sutType = NilValueTransformationsPass.self
    }

    func testTopLevelBlockInvocation() {
        // a()
        let exp = Expression.identifier("a").call()

        exp.subExpressions[0].resolvedType =
            .optional(.swiftBlock(returnType: .void, parameters: []))

        assertTransform(
            // { a() }
            statement: .expression(exp),
            // { a?() }
            into: .expression(.identifier("a").optional().call())
        )
    }

    func testTopLevelBlockInvocationOnImplicitlyUnwrapped() {
        // a()
        let exp = Expression.identifier("a").call()
        exp.subExpressions[0].resolvedType =
            .implicitUnwrappedOptional(.swiftBlock(returnType: .void, parameters: []))

        assertTransform(
            // { a() }
            statement: .expression(exp),
            // { a?() }
            into: .expression(.identifier("a").optional().call())
        )
    }

    func testNestedMemberOptionalMethodInvocation() {
        // a.b()
        //   ^~~ b is (() -> Void)?
        let exp = Expression.identifier("a").dot("b").call()

        exp.asPostfix?.exp.asPostfix?.resolvedType = .optional(
            .swiftBlock(returnType: .void, parameters: [])
        )

        exp.asPostfix?.exp.asPostfix?.op.returnType = .optional(
            .swiftBlock(returnType: .void, parameters: [])
        )

        assertTransform(
            // { a.b() }
            statement: .expression(exp),
            // { a.b?() }
            into: .expression(.identifier("a").dot("b").optional().call())
        )
    }

    func testConditionalMemberAccess() {
        // a.b
        let exp = Expression.identifier("a").dot("b")

        exp.asPostfix?.exp.resolvedType = .optional(.typeName("A"))
        exp.asPostfix?.op.returnType = .optional(.typeName("A"))
        exp.resolvedType = .optional(.typeName("Int"))

        assertTransform(
            // { a.b }
            statement: .expression(exp),
            // { a?.b }
            into: .expression(.identifier("a").optional().dot("b"))
        )
    }

    func testConditionalMemberAccessNested() {
        // a.b.c
        let exp = Expression.identifier("a").dot("b").dot("c")

        exp.asPostfix?.exp.asPostfix?.exp.resolvedType = .optional(.typeName("B"))
        exp.asPostfix?.exp.asPostfix?.op.returnType = .typeName("B")
        exp.asPostfix?.exp.resolvedType = .optional(.typeName("A"))
        exp.asPostfix?.op.returnType = .typeName("B")
        exp.resolvedType = .optional(.typeName("Int"))

        assertTransform(
            // { a.b.c }
            statement: .expression(exp),
            // { a?.b.c }
            into: .expression(.identifier("a").optional().dot("b").dot("c"))
        )
    }

    // Test negative cases where it's not supposed to do anything

    func testIgnoreImplicitlyUnwrappedMemberAccess() {
        // a.b
        let exp = Expression.identifier("a").dot("b")

        exp.asPostfix?.exp.resolvedType = .implicitUnwrappedOptional(.typeName("A"))
        exp.resolvedType = .optional(.typeName("Int"))

        assertNoTransform(
            // { a.b }
            statement: .expression(exp)
        )
    }

    func testIgnoreNonOptionalValues() {
        let exp =
            Expression
            .identifier("a").call()

        exp.subExpressions[0].resolvedType =
            .swiftBlock(returnType: .void, parameters: [])

        assertNoTransform(
            // { a() }
            statement: .expression(exp)
        )
    }

    func testModifyExpressionsInsideOtherExpressions() {
        // a(b())
        let exp =
            Expression
            .identifier("a").call([.unlabeled(.postfix(.identifier("b"), .functionCall()))])

        exp.subExpressions[1].subExpressions[0].resolvedType =
            .optional(.swiftBlock(returnType: .void, parameters: []))

        assertTransform(
            // { a(b()) }
            statement: .expression(exp),
            // { a(b?()) }
            into: .expression(
                Expression
                    .identifier("a").call([
                        .unlabeled(.identifier("b").optional().call())
                    ])
            )
        )
    }

    func testModifyChainedMemberAccessAndMethodCallsWithinParameters() {
        // a(b.c())
        let inner = Expression.identifier("b").dot("c").call()
        inner.exp.asPostfix?.exp.resolvedType = .optional(.typeName("B"))
        inner.exp.asPostfix?.op.returnType = .typeName("C")

        let exp = Expression.identifier("a").call([inner])
        exp.op.returnType = .swiftBlock(returnType: .void, parameters: [])
        exp.subExpressions[0].resolvedType = .swiftBlock(returnType: .void, parameters: [])

        assertTransform(
            // { a(b.c()) }
            statement: .expression(exp),
            // { a(b?.c()) }
            into: .expression(
                Expression
                    .identifier("a").call([
                        Expression.identifier("b").optional().dot("c").call()
                    ])
            )
        )
    }

    func testLookIntoBlockExpressionsForPotentialChanges() {
        let nilBlock = Expression.identifier("block2").call()
        nilBlock.asPostfix?.exp.resolvedType = .optional(
            .swiftBlock(returnType: .void, parameters: [])
        )

        let exp =
            Expression
            .identifier("takesBlock")
            .call([
                .unlabeled(
                    .block(body: [
                        .expression(
                            Expression
                                .identifier("block1")
                                .call()
                        ),
                        .expression(
                            Expression
                                .identifier("block2")
                                .call([
                                    .unlabeled(
                                        Expression.block(
                                            body: [
                                                .expression(nilBlock)
                                            ])
                                    )
                                ])
                        ),
                    ])
                )
            ])

        assertTransform(
            // takesBlock({ block1(); block2() })
            expression: exp,
            // takesBlock({ block1(); block2?() })
            into:
                .identifier("takesBlock")
                .call([
                    .unlabeled(
                        .block(body: [
                            .expression(.identifier("block1").call()),
                            .expression(
                                .identifier("block2")
                                    .call([
                                        .unlabeled(
                                            .block(
                                                body: [
                                                    .expression(
                                                        .identifier("block2").optional().call()
                                                    )
                                                ])
                                        )
                                    ]
                                    )
                            ),
                        ])
                    )
                ])
        )
    }

    func testLookupIntoChainedBlockExpressions() {
        let makeCallback: (Bool, Int) -> Expression = { (coalesced, argCount) in
            let exp: Expression

            let params = (0..<argCount).map {
                FunctionArgument.unlabeled(.constant(.int($0, .decimal)))
            }

            if coalesced {
                exp = .identifier("callback").optional().call(params)
            }
            else {
                exp = .identifier("callback").call(params)
            }

            exp.asPostfix?.exp.resolvedType = .optional(
                .swiftBlock(returnType: .void, parameters: [])
            )

            return exp
        }

        let exp =
            Expression
            .identifier("self").dot("member").call()
            .dot("then").call([
                .unlabeled(
                    .block(body: [
                        .expression(makeCallback( /* coalesced: */false, /* argCount: */ 0))
                    ])
                )
            ])
            .dot("then").call([
                .unlabeled(
                    .block(body: [
                        .expression(makeCallback( /* coalesced: */false, /* argCount: */ 1))
                    ])
                )
            ])
            .dot("always").call([
                .unlabeled(
                    .block(body: [
                        .expression(makeCallback( /* coalesced: */false, /* argCount: */ 2))
                    ])
                )
            ])

        assertTransform(
            // self.member().then({
            //    callback()
            // }).then({
            //    callback(1)
            // }).always({
            //    callback(1, 2)
            // })
            expression: exp,
            // self.member().then({
            //    callback?()
            // }).then({
            //    callback?(1)
            // }).always({
            //    callback?(1, 2)
            // })
            into:
                .identifier("self")
                .dot("member").call()
                .dot("then").call([
                    .unlabeled(
                        .block(body: [
                            .expression(makeCallback(/* coalesced: */true, /* argCount: */ 0))
                        ])
                    )
                ])
                .dot("then").call([
                    .unlabeled(
                        .block(body: [
                            .expression(makeCallback(/* coalesced: */true, /* argCount: */ 1))
                        ])
                    )
                ])
                .dot("always").call([
                    .unlabeled(
                        .block(body: [
                            .expression(makeCallback(/* coalesced: */true, /* argCount: */ 2))
                        ])
                    )
                ])
        )
    }

    func testAssignmentIntoOptionalValue() {
        // a.b = c
        let exp = Expression.identifier("a").dot("b").assignment(op: .assign, rhs: .identifier("c"))
        let expected = Expression.identifier("a").optional().dot("b").assignment(
            op: .assign,
            rhs: .identifier("c")
        )
        exp.lhs.subExpressions[0].resolvedType = .optional(.typeName("A"))

        assertTransform(
            // { a.b = c }
            statement: .expression(exp),
            // { a?.b = c }
            into: .expression(expected)
        )
    }
}
