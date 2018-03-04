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
        let exp: Expression = .postfix(.identifier("a"), .functionCall())
        exp.subExpressions[0].resolvedType =
            .optional(.block(returnType: .void, parameters: []))
        
        assertTransform(
            // { a() }
            statement: .expression(exp),
            // { a?() }
            into: .expression(.postfix(.identifier("a"), .optionalAccess(.functionCall())))
        )
    }
    
    func testTopLevelBlockInvocationOnImplicitlyUnwrapped() {
        // a()
        let exp: Expression = .postfix(.identifier("a"), .functionCall())
        exp.subExpressions[0].resolvedType =
            .implicitUnwrappedOptional(.block(returnType: .void, parameters: []))
        
        assertTransform(
            // { a() }
            statement: .expression(exp),
            // { a?() }
            into: .expression(.postfix(.identifier("a"), .optionalAccess(.functionCall())))
        )
    }
    
    func testNestedMemberOptionalMethodInvocation() {
        // a.b()
        //   ^~~ b is (() -> Void)?
        let exp: Expression = .postfix(.postfix(.identifier("a"), .member("b")), .functionCall())
        exp.asPostfix?.exp.asPostfix?.resolvedType =
            .optional(.block(returnType: .void, parameters: []))
        
        assertTransform(
            // { a.b() }
            statement: .expression(exp),
            // { a.b?() }
            into: .expression(.postfix(.postfix(.identifier("a"), .member("b")), .optionalAccess(.functionCall())))
        )
    }
    
    // Test negative cases where it's not supposed to do anything
    
    func testIgnoreNonOptionalValues() {
        let exp: Expression = .postfix(.identifier("a"), .functionCall())
        exp.subExpressions[0].resolvedType =
            .block(returnType: .void, parameters: [])
        
        assertTransform(
            // { a() }
            statement: .expression(exp),
            // { a() }
            into: .expression(.postfix(.identifier("a"), .functionCall()))
        )
    }
    
    func testDontModifyExpressionsInsideOtherExpressions() {
        // a(b())
        let exp: Expression = .postfix(.identifier("a"),
                                       .functionCall(arguments: [.unlabeled(.postfix(.identifier("b"), .functionCall()))])
        )
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
        )
    }
}
