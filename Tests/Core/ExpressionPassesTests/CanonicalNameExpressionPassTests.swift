import KnownType
import SwiftAST
import SwiftRewriterLib
import TypeSystem
import XCTest

@testable import ExpressionPasses

class CanonicalNameExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()

        sutType = CanonicalNameExpressionPass.self

        let typeProvider = CollectionKnownTypeProvider()
        typeProvider.addCanonicalMapping(
            nonCanonical: "NonCanon",
            canonical: "Canon"
        )

        typeSystem.addKnownTypeProvider(typeProvider)
    }

    func testTransformCanonicalTypeName() {
        assertTransform(
            expression: .identifier("NonCanon"),
            into: .identifier("Canon")
        )

        assertTransform(
            expression: Expression.identifier("NonCanon").settingDefinition(
                .forType(named: "NonCanon")
            ),
            into: .identifier("Canon")
        )
    }

    func testTransformCanonicalTypeNameWithMetatypeResolvedType() {
        assertTransform(
            expression: Expression.identifier("NonCanon").typed(.metatype(for: "NonCanon")),
            into: .identifier("Canon")
        )
    }

    func testDontTransformUnknownTypeName() {
        assertNoTransform(
            expression: .identifier("Unexisting")
        )
    }

    func testDontTransformIdentifiersWhichFeaturesNonTypeDefinitions() {
        assertNoTransform(
            expression:
                Expression
                .identifier("NonCanon")
                .settingDefinition(CodeDefinition.forSetterValue(named: "setter", type: .int))
        )

        assertNoTransform(
            expression:
                Expression
                .identifier("NonCanon")
                .settingDefinition(
                    .forGlobalVariable(name: "global", isConstant: false, type: .int)
                )
        )

        assertNoTransform(
            expression:
                Expression
                .identifier("NonCanon")
                .settingDefinition(
                    .forKnownMember(
                        KnownTypeBuilder(typeName: "A")
                            .property(named: "a", type: .int)
                            .build()
                            .knownProperties[0]
                    )
                )
        )
    }

    func testDontTransformIdentifiersWhichFeaturesNonMetatypeResolvedType() {
        assertNoTransform(
            expression:
                Expression
                .identifier("NonCanon")
                .typed(.int)
        )

        assertNoTransform(
            expression:
                Expression
                .identifier("NonCanon")
                .typed(.string)
        )

        assertNoTransform(
            expression:
                Expression
                .identifier("NonCanon")
                .typed(.optional(.metatype(for: "NonCanon")))
        )
    }
}
