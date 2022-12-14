import SwiftAST
import KnownType

extension TypeFormatter {

    /// Generates a string representation of the given function body carrying
    /// intention.
    public static func asString(
        intention: FunctionBodyCarryingIntention
    ) -> String {
        
        switch intention {
        case .method(let intention):
            if let type = intention.type {
                return asString(method: intention, ofType: type)
            } else {
                return asString(signature: intention.signature)
            }
        
        case .initializer(let intention):
            return asString(initializer: intention)
        
        case .deinit(let intention):
            if let type = intention.type {
                return asString(knownType: type) + ".deinit"
            } else {
                return "<unknown>.deinit"
            }
        
        case .global(let intention):
            return intention.name
        
        case .propertyGetter(let intention, _):
            if let type = intention.type {
                return asString(property: intention, ofType: type)
            } else {
                return intention.name
            }
        
        case .propertySetter(let intention, _):
            if let type = intention.type {
                return asString(property: intention, ofType: type)
            } else {
                return intention.name
            }
        
        case .subscriptGetter(let intention, _):
            if let type = intention.type {
                return asString(subscript: intention, ofType: type)
            } else {
                return "<unknown>.subscript"
            }
        
        case .subscriptSetter(let intention, _):
            if let type = intention.type {
                return asString(subscript: intention, ofType: type)
            } else {
                return "<unknown>.subscript"
            }
        
        case .propertyInitializer(let intention, _):
            if let type = intention.type {
                return asString(property: intention, ofType: type)
            } else {
                return intention.name
            }

        case .globalVariable(let intention, _):
            return intention.name
        }
    }
    
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
        "extension \(ext.typeName)"
            + (ext.categoryName.map { " (\($0))" } ?? "")
    }
    
}
