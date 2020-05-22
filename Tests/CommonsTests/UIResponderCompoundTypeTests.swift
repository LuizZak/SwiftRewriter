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
                var next: UIResponder? { get }
                var undoManager: UndoManager? { get }
                var editingInteractionConfiguration: UIEditingInteractionConfiguration { get }
                var canBecomeFirstResponder: Bool { get }
                var keyCommands: [UIKeyCommand]? { get }
                var canResignFirstResponder: Bool { get }
                
                @_swiftrewriter(renameFrom: "firstResponder")
                var isFirstResponder: Bool { get }
                var inputView: UIView? { get }
                var inputAccessoryView: UIView? { get }
                var inputAssistantItem: UITextInputAssistantItem { get }
                var inputViewController: UIInputViewController? { get }
                var inputAccessoryViewController: UIInputViewController? { get }
                var textInputMode: UITextInputMode? { get }
                var textInputContextIdentifier: String? { get }
                var userActivity: NSUserActivity?
                
                func becomeFirstResponder() -> Bool
                func resignFirstResponder() -> Bool
                func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
                func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
                func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
                func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
                func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>)
                func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?)
                func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?)
                func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?)
                func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?)
                func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
                func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
                func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
                func remoteControlReceived(with event: UIEvent?)
                func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
                func target(forAction action: Selector, withSender sender: Any?) -> Any?
                func buildMenu(with builder: UIMenuBuilder)
                func validate(_ command: UICommand)
                static func clearTextInputContextIdentifier(_ identifier: String)
                func reloadInputViews()
                func updateUserActivityState(_ activity: NSUserActivity)
                func restoreUserActivityState(_ activity: NSUserActivity)
            }
            """)
    }
}
