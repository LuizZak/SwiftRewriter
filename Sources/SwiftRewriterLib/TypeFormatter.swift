import SwiftAST

/// Helper functions for generating friendly textual representations of types,
/// methods and other constructs.
public enum TypeFormatter {
    /// Generates a string representation of a given known type
    public static func asString(knownType type: KnownType) -> String {
        
        let o = StringRewriterOutput(settings: .defaults)
        
        var _onFirstAnnotation = true
        
        let outputAttributes: ([KnownAttribute], Bool) -> Void = { attr, sameLine in
            guard !attr.isEmpty else {
                return
            }
            
            if !_onFirstAnnotation {
                o.output(line: "")
            }
            
            _onFirstAnnotation = false
            
            if sameLine {
                o.outputIdentation()
                
                let line = attr.map(stringify).joined(separator: " ")
                o.outputInlineWithSpace(line, style: .keyword)
            } else {
                for attr in attr {
                    o.output(line: stringify(attr), style: .attribute)
                }
            }
        }
        
        outputAttributes(type.knownAttributes, false)
        
        if type.isExtension {
            o.outputInline("extension \(type.typeName)")
        } else {
            o.outputInline("\(type.kind.rawValue) \(type.typeName)")
        }
        
        var inheritances: [String] = []
        
        if let supertype = type.supertype {
            inheritances.append(supertype.asTypeName)
        }
        if let rawValue = type.knownTrait(KnownTypeTraits.enumRawValue) {
            inheritances.append(stringify(rawValue))
        }
        for conformance in type.knownProtocolConformances {
            inheritances.append(conformance.protocolName)
        }
        
        if !inheritances.isEmpty {
            o.outputInline(": \(inheritances.joined(separator: ", "))")
        }
        
        o.outputInline(" {")
        o.outputLineFeed()
        
        // Type body
        o.idented {
            let outputAnnotations: ([String]) -> Void = { annotations in
                guard !annotations.isEmpty else {
                    return
                }
                
                if !_onFirstAnnotation {
                    o.output(line: "")
                }
                
                _onFirstAnnotation = false
                
                for annotation in annotations {
                    o.output(line: "// \(annotation)", style: .comment)
                }
            }
            
            let outputField: (KnownProperty) -> Void = { field in
                outputAnnotations(field.annotations)
                outputAttributes(field.knownAttributes, true)
                
                let line = asString(field: field,
                                    ofType: type,
                                    withTypeName: false,
                                    includeVarKeyword: true)
                
                if field.knownAttributes.isEmpty {
                    o.outputIdentation()
                }
                
                o.outputInline(line)
                o.outputLineFeed()
            }
            let outputProperty: (KnownProperty) -> Void = { property in
                outputAnnotations(property.annotations)
                outputAttributes(property.knownAttributes, true)
                
                let line: String
                
                if property.isEnumCase {
                    line = "case \(property.name)"
                } else {
                    line = asString(property: property,
                                    ofType: type,
                                    withTypeName: false,
                                    includeVarKeyword: true,
                                    includeAccessors: property.accessor != .getterAndSetter)
                }
                
                if property.knownAttributes.isEmpty {
                    o.outputIdentation()
                }
                
                o.outputInline(line)
                o.outputLineFeed()
            }
            
            let staticFields = type.knownFields.filter { $0.isStatic }
            let staticProperties = type.knownProperties.filter { $0.isStatic }
            let instanceFields = type.knownFields.filter { !$0.isStatic }
            let instanceProperties = type.knownProperties.filter { !$0.isStatic }
            
            // Statics first
            staticFields.forEach(outputField)
            staticProperties.forEach(outputProperty)
            instanceFields.forEach(outputField)
            instanceProperties.forEach(outputProperty)
            
            // Output a spacing between fields/properties and initialiezers/methods
            if (!type.knownFields.isEmpty || !type.knownProperties.isEmpty) &&
                (!type.knownConstructors.isEmpty || !type.knownMethods.isEmpty) {
                o.output(line: "")
            }
            
            for ctor in type.knownConstructors {
                outputAnnotations(ctor.annotations)
                outputAttributes(ctor.knownAttributes, false)
                
                o.output(line: "init" + asString(parameters: ctor.parameters))
            }
            for method in type.knownMethods {
                outputAnnotations(method.annotations)
                outputAttributes(method.knownAttributes, false)
                
                o.output(line:
                    asString(signature: method.signature, includeName: true,
                             includeFuncKeyword: true)
                )
            }
        }
        
        o.outputIdentation()
        o.outputInline("}")
        
        return o.buffer
    }
    
    /// Generates a string representation of a given method's signature
    public static func asString(method: KnownMethod,
                                ofType type: KnownType,
                                withTypeName typeName: Bool = true) -> String {
        
        var result = ""
        
        result += method.isStatic ? "static " : ""
        
        if typeName {
            result += type.typeName + "."
        }
        
        result += method.signature.name
        
        result += asString(parameters: method.signature.parameters)
        result += method.signature.returnType != .void ? " -> " + stringify(method.signature.returnType) : ""
        
        return result
    }
    
    /// Generates a string representation of a given property's signature, with
    /// type name, property name and property type.
    public static func asString(property: KnownProperty,
                                ofType type: KnownType,
                                withTypeName typeName: Bool = true,
                                includeVarKeyword: Bool = false,
                                includeAccessors: Bool = false) -> String {
        
        var result = ""
        
        result += property.isStatic ? "static " : ""
        
        result += property.storage.ownership == .strong ? "" : "\(property.storage.ownership.rawValue) "
        
        if includeVarKeyword {
            result += "var "
        }
        
        if typeName {
            result += type.typeName + "."
        }
        
        result += property.name + ": " + stringify(property.storage.type)
        
        if includeAccessors {
            result += " { "
            switch property.accessor {
            case .getter:
                result += "get"
            case .getterAndSetter:
                result += "get set"
            }
            result += " }"
        }
        
        return result
    }
    
    /// Generates a string representation of a given field's signature, with
    /// type name, field name and field type.
    public static func asString(field: KnownProperty,
                                ofType type: KnownType,
                                withTypeName typeName: Bool = true,
                                includeVarKeyword: Bool = false) -> String {
        
        var result = ""
        
        result += field.isStatic ? "static " : ""
        result += field.storage.ownership == .strong ? "" : "\(field.storage.ownership.rawValue) "
        
        if includeVarKeyword {
            result += field.storage.isConstant ? "let " : "var "
        }
        
        if typeName {
            result += type.typeName + "."
        }
        
        result += field.name + ": " + stringify(field.storage.type)
        
        return result
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
        return
            "extension \(ext.typeName)"
                + (ext.categoryName.map { " (\($0))" } ?? "")
    }
    
    /// Generates a string representation of a given function signature.
    /// The signature's name can be optionally include during conversion.
    public static func asString(signature: FunctionSignature,
                                includeName: Bool = false,
                                includeFuncKeyword: Bool = false) -> String {
        
        var result = ""
        
        if signature.isStatic {
            result += "static "
        }
        
        if includeFuncKeyword {
            result += "func "
        }
        
        if includeName {
            result += signature.name
        }
        
        result += asString(parameters: signature.parameters)
        
        if signature.returnType != .void {
            result += " -> \(stringify(signature.returnType))"
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
                result += "\(param.label ?? "_") "
            }
            
            result += param.name
            result += ": "
            result += stringify(param.type)
        }
        
        return result + ")"
    }
    
    /// Generates a string representation of a given initializer.
    public static func asString(initializer: KnownConstructor) -> String {
        var result: String = ""
        
        if initializer.isConvenience {
            result = "convenience "
        }
        
        result += "init"
        
        if initializer.isFailable {
            result += "?"
        }
        
        result += asString(parameters: initializer.parameters)
        
        return result
    }
    
    private static func stringify(_ trait: TraitType) -> String {
        switch trait {
        case .swiftType(let type):
            return stringify(type)
            
        case .semantics(let semantics):
            return stringify(semantics)
        }
    }
    
    private static func stringify(_ attribute: KnownAttribute) -> String {
        if let parameters = attribute.parameters {
            return "@\(attribute.name)(\(parameters))"
        }
        
        return "@\(attribute.name)"
    }
    
    private static func stringify(_ semantics: [Semantic]) -> String {
        return semantics.map { $0.name }.joined(separator: ", ")
    }

    private static func stringify(_ type: SwiftType) -> String {
        return type.description
    }
}
