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
            expression: Expression.identifier("Enum_Case1").makeErrorTyped(),
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
        
        let res = sut.apply(on: Expression.identifier("Enum_Case1").makeErrorTyped(), context: makeContext())
        
        XCTAssertEqual(
            res.asPostfix?.member?
                .memberDefinition?
                .ownerType?.typeName, enumName)
        XCTAssertEqual(res.asPostfix?.exp.asIdentifier?.definition?.typeName, enumName)
        XCTAssertEqual(res.asPostfix?.exp.asIdentifier?.resolvedType, .metatype(for: .typeName(enumName)))
    }
    
    /// Make sure we don't apply any transformation on types that are resolved
    /// properly, since they may be referencing local variables or other members
    /// shadowing the global enum.
    func testDontApplyTransformationOnIdentifierWithDefinition() {
        let en =
            KnownTypeBuilder(typeName: "Enum", supertype: nil, kind: .enum)
                .addingProperty(named: "Enum_Case1", type: .int, isStatic: true)
                .build()
        typeSystem.addType(en)
        
        let exp = Expression.identifier("Enum_Case1")
        exp.resolvedType = .int
        
        assertTransform(
            expression: exp,
            into: .identifier("Enum_Case1")
        )
    }
}
