import XCTest
import Commons
import SwiftRewriterLib
import Utils

class UIGestureRecognizerCompoundTypeTests: XCTestCase {

    func testUIGestureRecognizerDefinition() {
        let type = UIGestureRecognizerCompoundType.create()
        
        XCTAssert(type.nonCanonicalNames.isEmpty)
        XCTAssertEqual(type.transformations.count, 2)
        
        assertSignature(type: type, matches: """
            class UIGestureRecognizer: NSObject {
                @_swiftrewriter(mapFrom: locationInView(_:))
                func location(in view: UIView?) -> CGPoint
                
                @_swiftrewriter(mapFrom: requireGestureRecognizerToFail(_:))
                func require(toFail otherGestureRecognizer: UIGestureRecognizer)
            }
            """)
    }
}
