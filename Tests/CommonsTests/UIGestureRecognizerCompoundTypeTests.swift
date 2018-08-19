import XCTest
import Commons
import SwiftRewriterLib
import Utils

class UIGestureRecognizerCompoundTypeTests: XCTestCase {

    func testUIGestureRecognizerDefinition() {
        let type = UIGestureRecognizerCompoundType.create()
        
        assertSignature(type: type, matches: """
            class UIGestureRecognizer: NSObject {
                func location(in view: UIView?) -> CGPoint
            }
            """)
    }
}
