import XCTest
import Commons
import SwiftRewriterLib
import Utils

class UIGestureRecognizerCompoundTypeTests: XCTestCase {

    func testUIGestureRecognizerDefinition() {
        let type = UIGestureRecognizerCompoundType.create()
        
        assertSignature(type: type, matches: """
            class UIGestureRecognizer: NSObject {
                @_swiftrewriter(mapFrom: locationInView(_ view: UIView?) -> CGPoint)
                func location(in view: UIView?) -> CGPoint
                
                @_swiftrewriter(mapFrom: requireGestureRecognizerToFail(_ otherGestureRecognizer: UIGestureRecognizer))
                func require(toFail otherGestureRecognizer: UIGestureRecognizer)
            }
            """)
    }
}
