import SwiftAST
import SwiftRewriterLib

public enum UIResponderCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        return makeType(from: typeString(), typeName: "UIResponder")
    }
    
    static func typeString() -> String {
        let type = """
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
            """
        
        return type
    }
}
