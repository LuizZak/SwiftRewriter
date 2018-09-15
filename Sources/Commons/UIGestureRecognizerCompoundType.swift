import SwiftAST
import SwiftRewriterLib

public enum UIGestureRecognizerCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let string = typeString()
        
        do {
            let incomplete = try SwiftClassInterfaceParser.parseDeclaration(from: string)
            let type = try incomplete.toCompoundedKnownType()
            
            return type
        } catch {
            fatalError(
                "Found error while parsing UIGestureRecognizer class interface: \(error)"
            )
        }
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
