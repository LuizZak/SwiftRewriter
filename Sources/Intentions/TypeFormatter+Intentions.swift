import SwiftAST
import KnownType

extension TypeFormatter {
    
    /// Generates a string representation of a given instance field's signature,
    /// with type name, property name and property type.
    public static func asString(field: InstanceVariableGenerationIntention,
                                ofType type: KnownType,
                                withTypeName typeName: Bool = true,
                                includeVarKeyword: Bool = false) -> String {
        
        var result = ""
        
        result += field.isStatic ? "static " : ""
        result += field.storage.ownership == .strong ? "" : "\(field.storage.ownership.rawValue) "
        
        if includeVarKeyword {
            result += field.isConstant ? "let " : "var "
        }
        
        if typeName {
            result += type.typeName + "."
        }
        
        result += field.name + ": " + stringify(field.storage.type)
        
        return result
    }
    
    /// Generates a string representation of a given extension's typename
    public static func asString(extension ext: ClassExtensionGenerationIntention) -> String {
        return
            "extension \(ext.typeName)"
                + (ext.categoryName.map { " (\($0))" } ?? "")
    }
    
}
