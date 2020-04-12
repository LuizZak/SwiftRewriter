import SwiftAST
import WriterTargetOutput

/// Helper functions for generating friendly textual representations of types,
/// methods and other constructs.
public extension TypeFormatter {
    /// Generates a string representation of a given known type
    static func asString(knownType type: KnownType) -> String {
        
        let o = StringRewriterOutput(settings: .defaults)
        
        var _onFirstDeclaration = true
        
        let outputAttributesAndAnnotations: ([KnownAttribute], [String], Bool) -> Bool
        outputAttributesAndAnnotations = { attr, annotations, sameLine in
            guard !attr.isEmpty || !annotations.isEmpty else {
                return false
            }
            
            let attrInLineLimit = 20
            let attrInLine = attr.map(stringify).joined(separator: " ")
            
            if !annotations.isEmpty || (!attr.isEmpty && (!sameLine || attrInLine.count >= attrInLineLimit)) {
                if !_onFirstDeclaration {
                    o.output(line: "")
                }
            }
            
            for annotation in annotations {
                o.output(line: "// \(annotation)", style: .comment)
            }
            
            printAttributes: if !attr.isEmpty {
                if sameLine {
                    if attrInLine.count < attrInLineLimit {
                        o.outputIndentation()
                        o.outputInlineWithSpace(attrInLine, style: .keyword)
                        
                        return true
                    }
                }
                
                for attr in attr {
                    o.output(line: stringify(attr), style: .attribute)
                }
            }
            
            return false
        }
        
        _=outputAttributesAndAnnotations(type.knownAttributes, [], false)
        _onFirstDeclaration = true
        
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
        o.indented {
            let outputField: (KnownProperty) -> Void = { field in
                let didPrintSameLine = outputAttributesAndAnnotations(field.knownAttributes,
                                                                      field.annotations,
                                                                      true)
                
                let line = asString(field: field,
                                    ofType: type,
                                    withTypeName: false,
                                    includeVarKeyword: true)
                
                if !didPrintSameLine {
                    o.outputIndentation()
                }
                
                o.outputInline(line)
                o.outputLineFeed()
                
                _onFirstDeclaration = false
            }
            let outputProperty: (KnownProperty) -> Void = { property in
                let didPrintSameLine = outputAttributesAndAnnotations(property.knownAttributes,
                                                                      property.annotations,
                                                                      true)
                
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
                
                if !didPrintSameLine {
                    o.outputIndentation()
                }
                
                o.outputInline(line)
                o.outputLineFeed()
                
                _onFirstDeclaration = false
            }
            let outputSubscript: (KnownSubscript) -> Void = { subscriptDecl in
                let didPrintSameLine = outputAttributesAndAnnotations(subscriptDecl.knownAttributes,
                                                                      subscriptDecl.annotations,
                                                                      true)
                
                let line = asString(subscript: subscriptDecl,
                                    ofType: type,
                                    withTypeName: false,
                                    includeAccessors: subscriptDecl.isConstant)
                
                if !didPrintSameLine {
                    o.outputIndentation()
                }
                
                o.outputInline(line)
                o.outputLineFeed()
                
                _onFirstDeclaration = false
            }
            
            let staticFields = type.knownFields.filter(\.isStatic)
            let staticProperties = type.knownProperties.filter(\.isStatic)
            let instanceFields = type.knownFields.filter { !$0.isStatic }
            let instanceProperties = type.knownProperties.filter { !$0.isStatic }
            
            // Statics first
            staticFields.forEach(outputField)
            staticProperties.forEach(outputProperty)
            instanceFields.forEach(outputField)
            instanceProperties.forEach(outputProperty)
            type.knownSubscripts.forEach(outputSubscript)
            
            // Output a spacing between fields/properties/subscripts and initialiezers/methods
            if (!type.knownFields.isEmpty || !type.knownProperties.isEmpty || !type.knownSubscripts.isEmpty) &&
                (!type.knownConstructors.isEmpty || !type.knownMethods.isEmpty) {
                o.output(line: "")
            }
            
            for ctor in type.knownConstructors {
                _=outputAttributesAndAnnotations(ctor.knownAttributes,
                                                 ctor.annotations,
                                                 false)
                
                o.output(line: "init" + asString(parameters: ctor.parameters))
                
                _onFirstDeclaration = false
            }
            for method in type.knownMethods {
                _=outputAttributesAndAnnotations(method.knownAttributes,
                                                 method.annotations,
                                                 false)
                
                o.output(line:
                    asString(signature: method.signature, includeName: true,
                             includeFuncKeyword: true)
                )
                
                _onFirstDeclaration = false
            }
        }
        
        o.outputIndentation()
        o.outputInline("}")
        
        return o.buffer
    }
    
    /// Generates a string representation of a given method's signature
    static func asString(method: KnownMethod,
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
    static func asString(property: KnownProperty,
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
    static func asString(field: KnownProperty,
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
    
    static func asString(subscript decl: KnownSubscript,
                         ofType type: KnownType,
                         withTypeName typeName: Bool = true,
                         includeAccessors: Bool = false) -> String {
        
        var result = ""
        
        result += decl.isStatic ? "static " : ""

        if typeName {
            result += type.typeName + "."
        }
        
        
        
        result += "subscript\(asString(parameters: decl.parameters)) -> " + stringify(decl.type)
        
        if includeAccessors {
            result += " { "
            if decl.isConstant {
                result += "get"
            } else {
                result += "get set"
            }
            result += " }"
        }
        
        return result
    }
    
    /// Generates a string representation of a given initializer.
    static func asString(initializer: KnownConstructor) -> String {
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
    
    static func stringify(_ trait: TraitType) -> String {
        switch trait {
        case .swiftType(let type):
            return stringify(type)
            
        case .semantics(let semantics):
            return stringify(semantics)
        }
    }
    
    static func stringify(_ attribute: KnownAttribute) -> String {
        if let parameters = attribute.parameters {
            return "@\(attribute.name)(\(parameters))"
        }
        
        return "@\(attribute.name)"
    }
    
    static func stringify(_ semantics: [Semantic]) -> String {
        semantics.map(\.name).joined(separator: ", ")
    }
}
