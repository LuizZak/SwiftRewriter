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
        if structType == "BOOL" {
            return "Bool"
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
        return swiftType(forObjcType: type)
    }
}
