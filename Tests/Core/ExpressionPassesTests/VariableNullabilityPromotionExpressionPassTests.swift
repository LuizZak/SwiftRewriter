import Intentions
import SwiftAST
import SwiftRewriterLib
import TestCommons
import TypeSystem
import XCTest

@testable import ExpressionPasses

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
        let statement =
            Statement
            .compound([
                .variableDeclaration(
                    identifier: "a",
                    type: .nullabilityUnspecified("A"),
                    initialization: .identifier("_a").typed("A")
                )
            ])

        assertTransform(
            statement: statement,
            into: .compound([
                .variableDeclaration(
                    identifier: "a",
                    type: "A",
                    initialization: .identifier("_a").typed("A")
                )
            ])
        )
    }

    func testDontPromoteUninitializedConstants() {
        let statement =
            Statement
            .compound([
                .variableDeclaration(
                    identifier: "a",
                    type: SwiftType.nullabilityUnspecified("A"),
                    initialization: nil
                )
            ])
        
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _ = resolver.resolveTypes(in: statement)

        assertNoTransform(
            statement: statement
        )
    }

    func testDontPromoteNilInitializedVariables() {
        let statement =
            Statement
            .compound([
                .variableDeclaration(
                    identifier: "a",
                    type: SwiftType.nullabilityUnspecified("A"),
                    initialization: .constant(.nil)
                )
            ])
        
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _ = resolver.resolveTypes(in: statement)

        assertNoTransform(
            statement: statement
        )
    }

    func testDontPromoteWeakVariables() {
        let statement =
            Statement
            .compound([
                .variableDeclaration(
                    identifier: "a",
                    type: SwiftType.optional("A"),
                    ownership: .weak,
                    initialization: .identifier("_a").typed("A")
                )
            ])

        assertNoTransform(
            statement: statement
        )
    }

    func testDontPromoteErrorTypedInitializedVariables() {
        let statement =
            Statement
            .compound([
                .variableDeclaration(
                    identifier: "a",
                    type: SwiftType.nullabilityUnspecified("A"),
                    initialization: .identifier("_a").makeErrorTyped()
                )
            ])
        
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _ = resolver.resolveTypes(in: statement)

        assertNoTransform(
            statement: statement
        )
    }

    func testAvoidPromotingVariableLaterAssignedAsNil() {
        let statement =
            Statement
            .compound([
                .variableDeclaration(
                    identifier: "a",
                    type: SwiftType.nullabilityUnspecified("A"),
                    initialization: .identifier("_a").typed("A")
                ),
                .expression(
                    .identifier("a")
                        .assignment(op: .assign, rhs: .constant(.nil))
                ),
            ])
        
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _ = resolver.resolveTypes(in: statement)

        assertNoTransform(
            statement: statement
        )
    }

    func testAvoidPromotingVariableInitializedAsNilAndLaterAssignedAsNonNil() {
        let statement =
            Statement
            .compound([
                .variableDeclaration(
                    identifier: "a",
                    type: .nullabilityUnspecified("A"),
                    initialization: .constant(.nil)
                ),
                .expression(
                    .identifier("a")
                        .assignment(op: .assign, rhs: .identifier("_a").typed("A"))
                ),
            ])
        
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _ = resolver.resolveTypes(in: statement)

        assertNoTransform(
            statement: statement
        )
    }
}
