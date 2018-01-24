import GrammarModels

/// Provides type-transforming support for a Swift rewritter
public class TypeMapper {
    let context: TypeContext
    
    public init(context: TypeContext) {
        self.context = context
    }
    
    public func swiftType(forObjcType type: ObjcType) -> String {
        switch type {
        case .struct(let str):
            return swiftType(forObjcStructType: str)
            
        case .id(let protocols):
            return swiftType(forIdWithProtocols: protocols)
            
        case let .generic(name, parameters):
            return swiftType(forGenericObjcType: name, parameters: parameters)
            
        case .pointer(let type):
            return swiftType(forObjcPointerType: type)
        }
    }
    
    private func swiftType(forObjcStructType structType: String) -> String {
        // Check scalars first
        if let scalar = TypeMapper._scalarMappings[structType] {
            return scalar
        }
        
        return ""
    }
    
    private func swiftType(forIdWithProtocols protocols: [String]) -> String {
        return ""
    }
    
    private func swiftType(forGenericObjcType name: String, parameters: [ObjcType]) -> String {
        return ""
    }
    
    private func swiftType(forObjcPointerType type: ObjcType) -> String {
        if case .struct(let inner) = type {
            if let ptr = TypeMapper._pointerMappings[inner] {
                return ptr
            }
        }
        
        return swiftType(forObjcType: type)
    }
    
    private static let _scalarMappings: [String: String] = [
        "BOOL": "Bool",
        "NSInteger": "Int",
        "NSUInteger": "UInt",
        "CGFloat": "CGFloat"
    ]
    
    /// For mapping pointer-reference structs (could be Objc-C classes) into
    /// known Swift types
    private static let _pointerMappings: [String: String] = [
        "NSObject": "NSObject",
        "NSNumber": "NSNumber",
        "NSArray": "Array",
        "NSString": "String"
    ]
}
