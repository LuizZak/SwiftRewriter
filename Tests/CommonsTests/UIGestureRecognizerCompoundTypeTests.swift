import XCTest
import Commons
import SwiftRewriterLib
import Utils

class UIGestureRecognizerCompoundTypeTests: XCTestCase {

    func testUIGestureRecognizerDefinition() {
        let type = UIGestureRecognizerCompoundType.create()
        
        assertSignature(type: type, matches: """
            class UIGestureRecognizer: NSObject {
                // Convert from locationInView(_ view: UIView?) -> CGPoint
                func location(in view: UIView?) -> CGPoint
            }
            """)
    }
}
