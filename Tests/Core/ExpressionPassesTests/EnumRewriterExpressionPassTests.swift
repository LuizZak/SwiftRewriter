import KnownType
import SwiftAST
import SwiftRewriterLib
import TestCommons
import TypeSystem
import XCTest

@testable import ExpressionPasses

class EnumRewriterExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()

        sutType = EnumRewriterExpressionPass.self
    }

    func testReplaceEnum() {
        let en =
            KnownTypeBuilder(typeName: "Enum", supertype: nil, kind: .enum)
            .enumCase(named: "Enum_Case1")
            .build()
        typeSystem.addType(en)

        assertTransform(
            // Enum_Case1
            expression: .identifier("Enum_Case1").makeErrorTyped(),
            // Enum.Enum_Case1
            into: .identifier("Enum").dot("Enum_Case1")
        )
    }

    func testEnumReplacementExpressionResolvedTypes() {
        let enumName = "Enum"

        let en =
            KnownTypeBuilder(typeName: enumName, supertype: nil, kind: .enum)
            .enumCase(named: "Enum_Case1")
            .build()
        typeSystem.addType(en)
        let exp: SwiftAST.Expression = .identifier("Enum_Case1")

        let sut = makeSut(container: .expression(exp))
        let res = sut.apply(on: exp.makeErrorTyped(), context: makeContext(container: .expression(exp)))

        XCTAssertEqual(
            res.asPostfix?.member?
                .definition?
                .ownerType?.asTypeName,
            enumName
        )
        let definition = res.asPostfix?.exp.asIdentifier?.definition
        XCTAssertEqual((definition as? TypeCodeDefinition)?.name, enumName)
        XCTAssertEqual(
            (definition as? TypeCodeDefinition)?.type,
            .metatype(for: .typeName(enumName))
        )
        XCTAssertEqual(
            res.asPostfix?.exp.asIdentifier?.resolvedType,
            .metatype(for: .typeName(enumName))
        )
    }

    /// Make sure we don't apply any transformation on types that are resolved
    /// properly, since they may be referencing local variables or other members
    /// shadowing the global enum.
    func testDontApplyTransformationOnIdentifierWithDefinition() {
        let en =
            KnownTypeBuilder(typeName: "Enum", supertype: nil, kind: .enum)
            .enumCase(named: "Enum_Case1")
            .build()
        typeSystem.addType(en)

        let exp = Expression.identifier("Enum_Case1")
        exp.resolvedType = .int

        assertNoTransform(
            // Enum_Case1
            expression: exp
        )
    }
}
