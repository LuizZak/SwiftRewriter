import XCTest
import SwiftRewriterLib
import SwiftAST

class TypeFormatterTests: XCTestCase {
    func testAsStringMethodFromType() {
        let type =
            KnownTypeBuilder(typeName: "A")
                .addingMethod(withSignature:
                    FunctionSignature(name: "a",
                                      parameters: [ParameterSignature(label: "_", name: "a", type: .int)],
                                      returnType: .void,
                                      isStatic: false)
        ).build()
        
        XCTAssertEqual(
            "A.a(_ a: Int)",
            TypeFormatter.asString(method: type.knownMethods[0], ofType: type)
        )
    }
    
    func testAsStringPropertyFromType() {
        let type =
            KnownTypeBuilder(typeName: "A")
                .addingProperty(named: "a", type: .int)
                .build()
        
        XCTAssertEqual(
            "A.a: Int",
            TypeFormatter.asString(property: type.knownProperties[0], ofType: type)
        )
    }
    
    func testAsStringFieldFromType() {
        let type =
            KnownTypeBuilder(typeName: "A")
                .build()
        
        let field =
            InstanceVariableGenerationIntention(
                name: "a",
                storage: ValueStorage(type: .int,
                                      ownership: .strong,
                                      isConstant: false)
        )
        
        XCTAssertEqual(
            "A.a: Int",
            TypeFormatter.asString(field: field, ofType: type)
        )
    }
    
    func testAsStringExtension() {
        let extA = ClassExtensionGenerationIntention(typeName: "A")
        let extB = ClassExtensionGenerationIntention(typeName: "B")
        extB.categoryName = "Category"
        
        XCTAssertEqual("extension A", TypeFormatter.asString(extension: extA))
        XCTAssertEqual("extension B (Category)", TypeFormatter.asString(extension: extB))
    }
}
