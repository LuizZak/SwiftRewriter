import XCTest
import TestCommons
import SwiftAST
import KnownType
import SwiftRewriterLib
import TypeSystem

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
        
        let sut = makeSut()
        let res = sut.apply(on:.identifier("Enum_Case1").makeErrorTyped(), context: makeContext())
        
        XCTAssertEqual(
            res.asPostfix?.member?
                .memberDefinition?
                .ownerType?.asTypeName, enumName)
        let definition = res.asPostfix?.exp.asIdentifier?.definition
        XCTAssertEqual((definition as? TypeCodeDefinition)?.name, enumName)
        XCTAssertEqual((definition as? TypeCodeDefinition)?.type, .metatype(for: .typeName(enumName)))
        XCTAssertEqual(res.asPostfix?.exp.asIdentifier?.resolvedType, .metatype(for: .typeName(enumName)))
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
        
        assertTransform(
            // Enum_Case1
            expression: exp,
            // Enum_Case1
            into: .identifier("Enum_Case1")
        )
    }
}
