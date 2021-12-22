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
        functionBodyContext = FunctionBodyIntention(body: statement)

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
        assertNotifiedChange()
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
        functionBodyContext = FunctionBodyIntention(body: statement)
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _ = resolver.resolveTypes(in: statement)

        assertTransform(
            statement: statement,
            into: .compound([
                .variableDeclaration(
                    identifier: "a",
                    type: SwiftType.nullabilityUnspecified("A"),
                    initialization: nil
                )
            ])
        )
        assertDidNotNotifyChange()
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
        functionBodyContext = FunctionBodyIntention(body: statement)
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _ = resolver.resolveTypes(in: statement)

        assertTransform(
            statement: statement,
            into: .compound([
                .variableDeclaration(
                    identifier: "a",
                    type: SwiftType.nullabilityUnspecified("A"),
                    initialization: .constant(.nil)
                )
            ])
        )
        assertDidNotNotifyChange()
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
        functionBodyContext = FunctionBodyIntention(body: statement)

        assertTransform(
            statement: statement,
            into: .compound([
                .variableDeclaration(
                    identifier: "a",
                    type: SwiftType.optional("A"),
                    ownership: .weak,
                    initialization: .identifier("_a").typed("A")
                )
            ])
        )
        assertDidNotNotifyChange()
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
        functionBodyContext = FunctionBodyIntention(body: statement)
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _ = resolver.resolveTypes(in: statement)

        assertTransform(
            statement: statement,
            into: .compound([
                .variableDeclaration(
                    identifier: "a",
                    type: SwiftType.nullabilityUnspecified("A"),
                    initialization: .identifier("_a").makeErrorTyped()
                )
            ])
        )
        assertDidNotNotifyChange()
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
        functionBodyContext = FunctionBodyIntention(body: statement)
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _ = resolver.resolveTypes(in: statement)

        assertTransform(
            statement: statement,
            into: .compound([
                .variableDeclaration(
                    identifier: "a",
                    type: .nullabilityUnspecified("A"),
                    initialization: .identifier("_a").typed("A")
                ),
                .expression(
                    .identifier("a")
                        .assignment(op: .assign, rhs: .constant(.nil))
                ),
            ])
        )
        assertDidNotNotifyChange()
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
        functionBodyContext = FunctionBodyIntention(body: statement)
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _ = resolver.resolveTypes(in: statement)

        assertTransform(
            statement: statement,
            into: .compound([
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
        )
        assertDidNotNotifyChange()
    }
}
