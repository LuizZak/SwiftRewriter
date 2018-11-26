import XCTest
import ExpressionPasses
import SwiftRewriterLib
import SwiftAST
import TestCommons

class VariableNullabilityPromotionExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sutType = VariableNullabilityPromotionExpressionPass.self
        intentionContext = .global(
            GlobalFunctionGenerationIntention(
                signature: FunctionSignature(name: "test")
            )
        )
    }
    
    func testNonNilPromotion() {
        let statement = Statement
            .compound([
                .variableDeclaration(identifier: "a",
                                     type: SwiftType.nullabilityUnspecified("A"),
                                     initialization: Expression.identifier("_a").typed("A"))
            ])
        functionBodyContext = FunctionBodyIntention(body: statement)
        
        assertTransform(
            statement: statement,
            into: .compound([
                .variableDeclaration(identifier: "a",
                                     type: "A",
                                     initialization: Expression.identifier("_a").typed("A"))
            ])
        ); assertNotifiedChange()
    }
    
    func testDontPromoteUninitializedConstants() {
        let statement = Statement
            .compound([
                .variableDeclaration(identifier: "a",
                                     type: SwiftType.nullabilityUnspecified("A"),
                                     initialization: nil)
            ])
        functionBodyContext = FunctionBodyIntention(body: statement)
        
        assertTransform(
            statement: statement,
            into: .compound([
                .variableDeclaration(identifier: "a",
                                     type: SwiftType.nullabilityUnspecified("A"),
                                     initialization: nil)
            ])
        ); assertDidNotNotifyChange()
    }
    
    func testDontPromoteNilInitializedVariables() {
        let statement = Statement
            .compound([
                .variableDeclaration(identifier: "a",
                                     type: SwiftType.nullabilityUnspecified("A"),
                                     initialization: .constant(.nil))
                ])
        functionBodyContext = FunctionBodyIntention(body: statement)
        
        assertTransform(
            statement: statement,
            into: .compound([
                .variableDeclaration(identifier: "a",
                                     type: SwiftType.nullabilityUnspecified("A"),
                                     initialization: .constant(.nil))
                ])
        ); assertDidNotNotifyChange()
    }
    
    func testAvoidPromotingVariableLaterAssignedAsNil() {
        let statement = Statement
            .compound([
                .variableDeclaration(identifier: "a",
                                     type: SwiftType.nullabilityUnspecified("A"),
                                     initialization: Expression.identifier("_a").typed("A")),
                .expression(
                    Expression
                        .identifier("a").setDefinition(localName: "a", type: .nullabilityUnspecified("A"))
                        .assignment(op: .assign, rhs: .constant(.nil))
                )
            ])
        functionBodyContext = FunctionBodyIntention(body: statement)
        
        assertTransform(
            statement: statement,
            into: .compound([
                .variableDeclaration(identifier: "a",
                                     type: SwiftType.nullabilityUnspecified("A"),
                                     initialization: Expression.identifier("_a").typed("A")),
                .expression(
                    Expression
                        .identifier("a").setDefinition(localName: "a", type: .nullabilityUnspecified("A"))
                        .assignment(op: .assign, rhs: .constant(.nil))
                )
            ])
        ); assertDidNotNotifyChange()
    }
}
