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
}
