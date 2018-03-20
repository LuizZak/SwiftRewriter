import XCTest
import SwiftAST

class SwiftTypeTests: XCTestCase {
    func testWithSameOptionalityAs() {
        XCTAssertEqual(
            SwiftType.int.withSameOptionalityAs(.any),
            .int
        )
        XCTAssertEqual(
            SwiftType.int.withSameOptionalityAs(.optional(.any)),
            .optional(.int)
        )
        XCTAssertEqual(
            SwiftType.int.withSameOptionalityAs(.optional(.implicitUnwrappedOptional(.any))),
            .optional(.implicitUnwrappedOptional(.int))
        )
        XCTAssertEqual(
            SwiftType.optional(.int).withSameOptionalityAs(.any),
            .int
        )
        XCTAssertEqual(
            SwiftType.optional(.int).withSameOptionalityAs(.optional(.implicitUnwrappedOptional(.any))),
            .optional(.implicitUnwrappedOptional(.int))
        )
    }
    
    func testEncode() throws {
        let type = SwiftType.block(returnType: .void, parameters: [.array(.string)])
        
        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)
        
        XCTAssertEqual(type, decoded)
    }
    
    func testEncodeEmptyTuple() throws {
        let type = SwiftType.tuple([])
        
        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)
        
        XCTAssertEqual(type, decoded)
    }
    
    func testEncodeSingleTypeTuple() throws {
        let type = SwiftType.tuple([.int])
        
        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)
        
        XCTAssertEqual(type, decoded)
    }
    
    func testEncodeTwoTypedTuple() throws {
        let type = SwiftType.tuple([.int, .string])
        
        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)
        
        XCTAssertEqual(type, decoded)
    }
    
    func testEncodeNAryTypedTuple() throws {
        let type = SwiftType.tuple([.int, .string, .float, .double, .any])
        
        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)
        
        XCTAssertEqual(type, decoded)
    }
}
