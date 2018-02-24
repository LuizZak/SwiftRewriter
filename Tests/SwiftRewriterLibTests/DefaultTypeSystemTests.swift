import XCTest
import SwiftAST
import SwiftRewriterLib

class DefaultTypeSystemTests: XCTestCase {
    var sut: DefaultTypeSystem!
    
    override func setUp() {
        sut = DefaultTypeSystem()
    }
    
    func testNSObjectDefinition() {
        guard let type = sut.knownTypeWithName("NSObject") else {
            XCTFail("Expected NSObject to be present")
            return
        }
        
        XCTAssertNotNil(type.constructor(withArgumentLabels: []),
                        "Missing NSObject's default parameterless constructor")
    }
    
    func testNSArrayDefinition() {
        guard let type = sut.knownTypeWithName("NSArray") else {
            XCTFail("Expected NSArray to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.typeName, "NSObject")
        XCTAssertNotNil(type.constructor(withArgumentLabels: []),
                        "Missing NSArray's default parameterless constructor")
    }
    
    func testNSMutableArrayDefinition() {
        guard let type = sut.knownTypeWithName("NSMutableArray") else {
            XCTFail("Expected NSMutableArray to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.typeName, "NSArray")
//        XCTAssertNotNil(type.constructor(withArgumentLabels: []),
//                        "Missing NSMutableArray's default parameterless constructor")
    }
}
