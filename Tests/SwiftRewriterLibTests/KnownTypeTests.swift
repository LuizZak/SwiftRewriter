import XCTest
import SwiftRewriterLib

class KnownTypeTests: XCTestCase {
    func testConstructorSearchesThroughSupertypes() {
        let type1 = KnownTypeBuilder(typeName: "A").addingConstructor().build()
        let type2 = KnownTypeBuilder(typeName: "B", supertype: type1).build()
        let type3 = KnownTypeBuilder(typeName: "C", supertype: type2).build()
        
        XCTAssertNotNil(type1.constructor(withArgumentLabels: []))
        XCTAssertNotNil(type2.constructor(withArgumentLabels: []))
        XCTAssertNotNil(type3.constructor(withArgumentLabels: []))
    }
    
    func testConstructorCannotSearchTypeNamedSupertypes() {
        let type1 = KnownTypeBuilder(typeName: "A").addingConstructor().build()
        let type2 = KnownTypeBuilder(typeName: "B", supertype: type1).build()
        let type3 = KnownTypeBuilder(typeName: "C", supertype: "B").build()
        
        XCTAssertNotNil(type1.constructor(withArgumentLabels: []))
        XCTAssertNotNil(type2.constructor(withArgumentLabels: []))
        XCTAssertNil(type3.constructor(withArgumentLabels: []))
    }
}
