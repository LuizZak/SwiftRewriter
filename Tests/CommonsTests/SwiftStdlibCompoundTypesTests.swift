import XCTest
import Commons
import SwiftRewriterLib
import Utils

class SwiftStdlibCompoundTypesTests: XCTestCase {
    func testArrayDefinition() {
        let type = SwiftStdlibCompoundTypes.array.create()
        
        XCTAssert(type.nonCanonicalNames.isEmpty)
        XCTAssertEqual(type.transformations.count, 3)
        
        assertSignature(type: type, matches: """
            struct Array {
                var count: Int { get }
                
                
                @_swiftrewriter(mapFrom: addObject(_:))
                mutating func append(_ value: T)
                
                @_swiftrewriter(mapFrom: removeObject(_:))
                mutating func remove(_ value: T)
                
                @_swiftrewriter(mapFrom: containsObject(_:))
                func contains(_ value: T) -> Bool
            }
            """)
    }
}
