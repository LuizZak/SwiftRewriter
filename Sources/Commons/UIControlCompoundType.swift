import SwiftAST

// swiftlint:disable line_length
public class UIControlCompoundType {
    private static var singleton = makeType(from: typeString(), typeName: "UIControl")
    
    public static func create() -> CompoundedMappingType {
        singleton
    }
    
    static func typeString() -> String {
        let string = """
            class UIControl: UIView {
                @_swiftrewriter(renameFrom: enabled)
                var isEnabled: Bool
                @_swiftrewriter(renameFrom: selected)
                var isSelected: Bool
                @_swiftrewriter(renameFrom: highlighted)
                var isHighlighted: Bool
                var contentVerticalAlignment: UIControlContentVerticalAlignment
                var contentHorizontalAlignment: UIControlContentHorizontalAlignment
                var effectiveContentHorizontalAlignment: UIControlContentHorizontalAlignment { get }
                var state: UIControlState { get }
                var isTracking: Bool { get }
                var isTouchInside: Bool { get }
                var allTargets: Set<AnyHashable> { get }
                var allControlEvents: UIControlEvents { get }
                
                func beginTracking(with touch: UITouch, with event: UIEvent?) -> Bool
                func continueTracking(with touch: UITouch, with event: UIEvent?) -> Bool
                func endTracking(with touch: UITouch?, with event: UIEvent?)
                func cancelTracking(with event: UIEvent?)
                func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents)
                func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControlEvents)
                func actions(forTarget target: Any?, forControlEvent controlEvent: UIControlEvents) -> [String]?
                func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?)
                func sendActions(for controlEvents: UIControlEvents)
            }
            """

        return string
    }
}
