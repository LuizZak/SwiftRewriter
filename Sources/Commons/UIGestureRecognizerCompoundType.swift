import SwiftAST
import SwiftRewriterLib

public enum UIGestureRecognizerCompoundType {
    private static var singleton = makeType(from: typeString(), typeName: "UIGestureRecognizer")
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func typeString() -> String {
        let type = """
            class UIGestureRecognizer: NSObject {
                @_swiftrewriter(mapFrom: locationInView(_:))
                func location(in view: UIView?) -> CGPoint
                
                @_swiftrewriter(mapFrom: requireGestureRecognizerToFail(_:))
                func require(toFail otherGestureRecognizer: UIGestureRecognizer)
            }
            """
        
        return type
    }
}
