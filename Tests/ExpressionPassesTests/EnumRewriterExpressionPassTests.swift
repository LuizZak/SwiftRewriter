import XCTest
import TestCommons
import SwiftRewriterLib
import SwiftAST
import ExpressionPasses

class EnumRewriterExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sut = EnumRewriterExpressionPass()
    }
    
    func testReplaceEnum() {
        let en =
            KnownTypeBuilder(typeName: "Enum", supertype: nil, kind: .enum)
                .addingProperty(named: "Enum_Case1", type: .int, isStatic: true)
                .build()
        typeSystem.addType(en)
        
        assertTransform(
            expression: .identifier("Enum_Case1"),
            into: Expression.identifier("Enum").dot("Enum_Case1")
        )
    }
    
    func testEnumReplacementExpressionResolvedTypes() {
        let enumName = "Enum"
        
        let en =
            KnownTypeBuilder(typeName: enumName, supertype: nil, kind: .enum)
                .addingProperty(named: "Enum_Case1", type: .int, isStatic: true)
                .build()
        typeSystem.addType(en)
        
        let res = sut.apply(on: .identifier("Enum_Case1"), context: makeContext())
        
        XCTAssertEqual(
            res.asPostfix?.member?
                .memberDefinition?
                .ownerType?.typeName, enumName)
        XCTAssertEqual(res.asPostfix?.exp.asIdentifier?.definition?.typeName, enumName)
        XCTAssertEqual(res.asPostfix?.exp.asIdentifier?.resolvedType, .metatype(for: .typeName(enumName)))
    }
}
