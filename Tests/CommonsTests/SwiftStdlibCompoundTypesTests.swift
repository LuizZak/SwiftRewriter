import XCTest
import Commons
import SwiftRewriterLib
import Utils

class SwiftStdlibCompoundTypesTests: XCTestCase {
    func testArrayDefinition() {
        let type = SwiftStdlibCompoundTypes.array.create()
        
        XCTAssert(type.nonCanonicalNames.isEmpty)
        XCTAssertEqual(type.transformations.count, 6)
        
        assertSignature(type: type, matches: """
            struct Array {
                var count: Int { get }
                
                
                @_swiftrewriter(mapFrom: addObject(_:))
                mutating func append(_ value: T)
                
                @_swiftrewriter(mapFrom: addObjects(from:))
                mutating func append(contentsOf sequence: S)
                
                @_swiftrewriter(mapFrom: removeObject(_:))
                mutating func remove(_ value: T)
                
                @_swiftrewriter(mapFrom: removeAllObjects(_:))
                mutating func removeAll()
                
                @_swiftrewriter(mapFrom: indexOfObject(_:))
                func index(of value: T) -> Int
                
                @_swiftrewriter(mapFrom: containsObject(_:))
                func contains(_ value: T) -> Bool
            }
            """)
    }
}
