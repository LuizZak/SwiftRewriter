import XCTest
import SwiftAST
import KnownType
import TypeSystem

@testable import ObjectiveCFrontend

class ObjectiveCASTReaderContextTests: XCTestCase {
    var typeSystem: TypeSystem!
    var typeContext: KnownType!
    var sut: ObjectiveCASTReaderContext!
    
    override func setUp() {
        super.setUp()
        
        typeSystem = TypeSystem()
        typeContext = KnownTypeBuilder(typeName: "TestType").build()
        sut = ObjectiveCASTReaderContext(typeSystem: typeSystem,
                                    typeContext: typeContext,
                                    comments: [])
    }

    func testTypePropertyOrFieldNamedWithProperty() {
        typeContext =
            KnownTypeBuilder(typeName: "TestType")
                .property(named: "test", type: .int)
                .build()
        sut = ObjectiveCASTReaderContext(typeSystem: typeSystem,
                                    typeContext: typeContext,
                                    comments: [])
        
        let prop = sut.typePropertyOrFieldNamed("test")
        
        XCTAssertNotNil(prop)
    }
    
    func testTypePropertyOrFieldNamedWithField() {
        typeContext =
            KnownTypeBuilder(typeName: "TestType")
                .field(named: "test", type: .int)
                .build()
        sut = ObjectiveCASTReaderContext(typeSystem: typeSystem,
                                    typeContext: typeContext,
                                    comments: [])
        
        let field = sut.typePropertyOrFieldNamed("test")
        
        XCTAssertNotNil(field)
    }
}
