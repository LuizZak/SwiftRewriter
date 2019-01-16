import XCTest
import SwiftAST
import KnownType
import SwiftRewriterLib

class SwiftASTReaderContextTests: XCTestCase {
    var typeSystem: TypeSystem!
    var typeContext: KnownType!
    var sut: SwiftASTReaderContext!
    
    override func setUp() {
        super.setUp()
        
        typeSystem = TypeSystem()
        typeContext = KnownTypeBuilder(typeName: "TestType").build()
        sut = SwiftASTReaderContext(typeSystem: typeSystem, typeContext: typeContext)
    }

    func testTypePropertyOrFieldNamedWithProperty() {
        typeContext =
            KnownTypeBuilder(typeName: "TestType")
                .property(named: "test", type: .int)
                .build()
        sut = SwiftASTReaderContext(typeSystem: typeSystem, typeContext: typeContext)
        
        let prop = sut.typePropertyOrFieldNamed("test")
        
        XCTAssertNotNil(prop)
    }
    
    func testTypePropertyOrFieldNamedWithField() {
        typeContext =
            KnownTypeBuilder(typeName: "TestType")
                .field(named: "test", type: .int)
                .build()
        sut = SwiftASTReaderContext(typeSystem: typeSystem, typeContext: typeContext)
        
        let field = sut.typePropertyOrFieldNamed("test")
        
        XCTAssertNotNil(field)
    }
}
