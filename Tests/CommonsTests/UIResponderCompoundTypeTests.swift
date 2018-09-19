import XCTest
import Commons
import SwiftRewriterLib
import Utils

class UIResponderCompoundTypeTests: XCTestCase {
    
    func testUIResponderCompoundTypeDefinition() {
        let type = UIResponderCompoundType.create()
        
        XCTAssert(type.nonCanonicalNames.isEmpty)
        XCTAssertEqual(type.transformations.count, 1)
        
        assertSignature(type: type, matches: """
            class UIResponder: NSObject, UIResponderStandardEditActions {
                var canBecomeFirstResponder: Bool { get }
                var canResignFirstResponder: Bool { get }
                
                @_swiftrewriter(renameFrom: firstResponder)
                var isFirstResponder: UIResponder? { get }
                var undoManager: UndoManager? { get }
                
                func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
                func resignFirstResponder() -> Bool
                func target(forAction action: Selector, withSender sender: Any?) -> Any?
                func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?)
                func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?)
                func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?)
                func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?)
                func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?)
                func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?)
                func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?)
                func remoteControlReceived(with event: UIEvent?)
                func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
                func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
                func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
                func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>)
                func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
            }
            """)
    }
}
