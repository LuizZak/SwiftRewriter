import ExpressionPasses
import SwiftAST
import TestCommons

class NilValueTransformationsPasTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        sut = NilValueTransformationsPass()
    }
    
    func testTopLevelBlockInvocation() {
        // a()
        let exp = Expression.identifier("a").call()
        
        exp.subExpressions[0].resolvedType =
            .optional(.block(returnType: .void, parameters: []))
        
        assertTransform(
            // { a() }
            statement: .expression(exp),
            // { a?() }
            into: .expression(.postfix(.identifier("a"), .optionalAccess(.functionCall())))
        ); assertNotifiedChange()
    }
    
    func testTopLevelBlockInvocationOnImplicitlyUnwrapped() {
        // a()
        let exp = Expression.identifier("a").call()
        exp.subExpressions[0].resolvedType =
            .implicitUnwrappedOptional(.block(returnType: .void, parameters: []))
        
        assertTransform(
            // { a() }
            statement: .expression(exp),
            // { a?() }
            into: .expression(.postfix(.identifier("a"), .optionalAccess(.functionCall())))
        ); assertNotifiedChange()
    }
    
    func testNestedMemberOptionalMethodInvocation() {
        // a.b()
        //   ^~~ b is (() -> Void)?
        let exp = Expression.identifier("a").dot("b").call()
        
        exp.asPostfix?.exp.asPostfix?.resolvedType =
            .optional(.block(returnType: .void, parameters: []))
        
        assertTransform(
            // { a.b() }
            statement: .expression(exp),
            // { a.b?() }
            into: .expression(.postfix(.postfix(.identifier("a"), .member("b")), .optionalAccess(.functionCall())))
        ); assertNotifiedChange()
    }
    
    func testConditionalMemberAccess() {
        // a.b
        let exp = Expression.identifier("a").dot("b")
        
        exp.asPostfix?.exp.resolvedType = .optional(.typeName("A"))
        exp.resolvedType = .optional(.typeName("Int"))
        
        assertTransform(
            // { a.b }
            statement: .expression(exp),
            // { a?.b }
            into: .expression(Expression.identifier("a").optional().dot("b"))
        ); assertNotifiedChange()
    }
    
    func testConditionalMemberAccessNested() {
        // a.b.c
        let exp = Expression.identifier("a").dot("b").dot("c")
        
        exp.asPostfix?.exp.asPostfix?.exp.resolvedType = .optional(.typeName("B"))
        exp.asPostfix?.exp.resolvedType = .optional(.typeName("A"))
        exp.resolvedType = .optional(.typeName("Int"))
        
        assertTransform(
            // { a.b.c }
            statement: .expression(exp),
            // { a?.b.c }
            into: .expression(Expression.identifier("a").optional().dot("b").dot("c"))
        ); assertNotifiedChange()
    }
    
    // Test negative cases where it's not supposed to do anything
    
    func testIgnoreImplicitlyUnwrappedMemberAccess() {
        // a.b
        let exp = Expression.identifier("a").dot("b")
        
        exp.asPostfix?.exp.resolvedType = .implicitUnwrappedOptional(.typeName("A"))
        exp.resolvedType = .optional(.typeName("Int"))
        
        assertTransform(
            // { a.b }
            statement: .expression(exp),
            // { a.b }
            into: .expression(Expression.identifier("a").dot("b"))
        ); assertDidNotNotifyChange()
    }
    
    func testIgnoreNonOptionalValues() {
        let exp = Expression
            .identifier("a").call()
        
        exp.subExpressions[0].resolvedType =
            .block(returnType: .void, parameters: [])
        
        assertTransform(
            // { a() }
            statement: .expression(exp),
            // { a() }
            into: .expression(.postfix(.identifier("a"), .functionCall()))
        ); assertDidNotNotifyChange()
    }
    
    func testDontModifyExpressionsInsideOtherExpressions() {
        // a(b())
        let exp = Expression
            .identifier("a").call(arguments: [.unlabeled(.postfix(.identifier("b"), .functionCall()))])
        
        exp.subExpressions[1].subExpressions[0].resolvedType =
            .optional(.block(returnType: .void, parameters: []))
        
        assertTransform(
            // { a(b()) }
            statement: .expression(exp),
            // { a(b()) }
            into: .expression(
                .postfix(.identifier("a"),
                         .functionCall(arguments:
                            [.unlabeled(.postfix(.identifier("b"),
                                                .functionCall()))]
                    )
                )
            )
        ); assertDidNotNotifyChange()
    }
    
    func testLookIntoBlockExpressionsForPotentialChanges() {
        let nilBlock = Expression.identifier("block2").call()
        nilBlock.asPostfix?.exp.resolvedType = .optional(.block(returnType: .void, parameters: []))
        
        let exp = Expression
            .identifier("takesBlock")
            .call(arguments: [
                .unlabeled(
                    .block(parameters: [],
                           return: .void,
                           body: [
                            .expression(
                                Expression
                                    .identifier("block1")
                                    .call()
                            ),
                            .expression(
                                Expression
                                    .identifier("block2")
                                    .call(arguments: [
                                        .unlabeled(
                                            Expression.block(
                                                parameters: [],
                                                return: .void,
                                                body: [
                                                    .expression(nilBlock)
                                                ]))
                                        ])
                            )
                        ])
                )
                ])
        
        assertTransform(
            // takesBlock({ block1(); block2() })
            expression: exp,
            // takesBlock({ block1(); block2?() })
            into: Expression
                .identifier("takesBlock")
                .call(arguments: [
                    .unlabeled(
                        .block(parameters: [],
                               return: .void,
                               body: [
                                .expression(Expression.identifier("block1").call()),
                                .expression(
                                    Expression
                                        .identifier("block2")
                                        .call(arguments: [
                                            .unlabeled(
                                                Expression.block(
                                                    parameters: [],
                                                    return: .void,
                                                    body: [
                                                        .expression(Expression.identifier("block2").optional().call())
                                                    ]))
                                            ])
                                )
                            ])
                    )
                    ]))
    }
    
    func testLookupIntoChainedBlockExpressions() {
        let makeCallback: (Bool, Int) -> Expression = { (collesced, argCount) in
            let exp: Expression
            
            let params = (0..<argCount).map {
                FunctionArgument.unlabeled(.constant(.int($0)))
            }
            
            if collesced {
                exp = Expression.identifier("callback").optional().call(arguments: params)
            } else {
                exp = Expression.identifier("callback").call(arguments: params)
            }
            
            exp.asPostfix?.exp.resolvedType = .optional(.block(returnType: .void, parameters: []))
            
            return exp
        }
        
        let exp = Expression
            .identifier("self").dot("member").call()
            .dot("then").call(arguments: [
                .unlabeled(
                    .block(parameters: [],
                           return: .void,
                           body: [
                            .expression(makeCallback(/* coallesced: */ false, /* argCount: */ 0))
                        ]))
                ])
            .dot("then").call(arguments: [
                .unlabeled(
                    .block(parameters: [],
                           return: .void,
                           body: [
                            .expression(makeCallback(/* coallesced: */ false, /* argCount: */ 1))
                        ]))
                ])
            .dot("always").call(arguments: [
                .unlabeled(
                    .block(parameters: [],
                           return: .void,
                           body: [
                            .expression(makeCallback(/* coallesced: */ false, /* argCount: */ 2))
                        ]))
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
            into: Expression
                .identifier("self")
                .dot("member").call()
                .dot("then").call(arguments: [
                    .unlabeled(
                        .block(parameters: [],
                               return: .void,
                               body: [
                                .expression(makeCallback(/* coallesced: */ true, /* argCount: */ 0))
                            ]))
                    ])
                .dot("then").call(arguments: [
                    .unlabeled(
                        .block(parameters: [],
                               return: .void,
                               body: [
                                .expression(makeCallback(/* coallesced: */ true, /* argCount: */ 1))
                            ]))
                    ])
                .dot("always").call(arguments: [
                    .unlabeled(
                        .block(parameters: [],
                               return: .void,
                               body: [
                                .expression(makeCallback(/* coallesced: */ true, /* argCount: */ 2))
                            ]))
                    ])
        )
    }
}
