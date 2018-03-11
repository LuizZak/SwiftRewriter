import SwiftAST

/// Helper functions for generating friendly textual representations of types,
/// methods and other constructs.
public enum TypeFormatter {
    /// Generates a string representation of a given method's signature
    public static func asString(method: KnownMethod, ofType type: KnownType) -> String {
        var result = ""
        
        result = type.typeName + "." + method.signature.name
        
        result += asString(parameters: method.signature.parameters)
        result += method.signature.returnType != .void ? " -> " + stringify(method.signature.returnType) : ""
        
        return result
    }
    
    /// Generates a string representation of a given property's signature, with
    /// type name, property name and property type.
    public static func asString(property: KnownProperty, ofType type: KnownType) -> String {
        var result = ""
        
        result += property.isStatic ? "static " : ""
        result += property.storage.ownership == .strong ? "" : "\(property.storage.ownership.rawValue) "
        result += type.typeName + "." + property.name + ": " + stringify(property.storage.type)
        
        return result
    }
    
    /// Generates a string representation of a given instance field's signature,
    /// with type name, property name and property type.
    public static func asString(field: InstanceVariableGenerationIntention, ofType type: KnownType) -> String {
        var result = ""
        
        result += field.isStatic ? "static " : ""
        result += field.storage.ownership == .strong ? "" : "\(field.storage.ownership.rawValue) "
        result += type.typeName + "." + field.name + ": " + stringify(field.storage.type)
        
        return result
    }
    
    /// Generates a string representation of a given extension's typename
    public static func asString(extension ext: ClassExtensionGenerationIntention) -> String {
        return
            "extension \(ext.typeName)"
                + (ext.categoryName.map { " (\($0))" } ?? "")
    }
    
    /// Generates a string representation of a given function signature.
    /// The signature's name can be optionally include during conversion.
    public static func asString(signature: FunctionSignature, includeName: Bool = false) -> String {
        var result = ""
        
        if signature.isStatic {
            result += "static "
        }
        
        if includeName {
            result += signature.name
        }
        
        result += asString(parameters: signature.parameters)
        
        if signature.returnType != .void {
            result += " -> \(signature.returnType)"
        }
        
        return result
    }
    
    /// Generates a string representation of a given set of function parameters,
    /// with parenthesis enclosing the types.
    ///
    /// Returns an empty set of parenthesis if the parameters are empty.
    public static func asString(parameters: [ParameterSignature]) -> String {
        var result = "("
        
        for (i, param) in parameters.enumerated() {
            if i > 0 {
                result += ", "
            }
            
            if param.label != param.name {
                result += "\(param.label) "
            }
            
            result += param.name
            result += ": "
            result += stringify(param.type)
        }
        
        return result + ")"
    }
    
    static func stringify(_ type: SwiftType) -> String {
        return type.description
    }
}
