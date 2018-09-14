import SwiftAST
import SwiftRewriterLib

public enum UIColorCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        var type = KnownTypeBuilder(typeName: "UIColor", supertype: "NSObject")
        let annotations = AnnotationsSink()
        let transformations = TransformationsSink(typeName: type.typeName)
        
        type.useSwiftSignatureMatching = true
        
        type = type
            .protocolConformances(protocolNames: ["NSSecureCoding", "NSCopying"])
        
        // Properties
        type = type
            .property(named: "cgColor", type: "CGColor", accessor: .getter)
            ._createPropertyRename(from: "CGColor", in: transformations)
            .property(named: "ciColor", type: "CGColor", accessor: .getter)
            ._createPropertyRename(from: "CIColor", in: transformations)
        
        // Static constants
        type = type
            .staticColorProperty(named: "black", transformations: transformations)
            .staticColorProperty(named: "darkGray", transformations: transformations)
            .staticColorProperty(named: "lightGray", transformations: transformations)
            .staticColorProperty(named: "white", transformations: transformations)
            .staticColorProperty(named: "gray", transformations: transformations)
            .staticColorProperty(named: "red", transformations: transformations)
            .staticColorProperty(named: "green", transformations: transformations)
            .staticColorProperty(named: "blue", transformations: transformations)
            .staticColorProperty(named: "cyan", transformations: transformations)
            .staticColorProperty(named: "yellow", transformations: transformations)
            .staticColorProperty(named: "magenta", transformations: transformations)
            .staticColorProperty(named: "orange", transformations: transformations)
            .staticColorProperty(named: "purple", transformations: transformations)
            .staticColorProperty(named: "brown", transformations: transformations)
            .staticColorProperty(named: "clear", transformations: transformations)
        
        // Extension colors
        type = type
            .staticColorProperty(named: "lightText", transformations: transformations)
            .staticColorProperty(named: "darkText", transformations: transformations)
            .staticColorProperty(named: "groupTableViewBackground", transformations: transformations)
            .staticColorProperty(named: "viewFlipsideBackground", transformations: transformations)
            .staticColorProperty(named: "scrollViewTexturedBackground", transformations: transformations)
            .staticColorProperty(named: "underPageBackground", transformations: transformations)
        
        type = type
            .method(withSignature:
                FunctionSignature(
                    signatureString: "withAlphaComponent(_ alpha: CGFloat) -> UIColor"
                )
                .makeSignatureMapping(
                    fromSignature: "colorWithAlphaComponent(_ alpha: CGFloat) -> UIColor",
                    in: transformations,
                    annotations: annotations
                ),
                    attributes: annotations.attributes
            )
        
        return
            CompoundedMappingType(knownType: type.build(),
                                  transformations: transformations.transformations)
    }
}

private extension KnownTypeBuilder {
    
    func staticColorProperty(named name: String, transformations: TransformationsSink) -> KnownTypeBuilder {
        return
            property(named: name, type: "UIColor", isStatic: true, accessor: .getter)
            ._createPropertyRename(from: "\(name)Color", in: transformations)
            ._createPropertyFromMethods(getterName: "\(name)Color", setterName: nil, in: transformations)
    }
    
}

extension KnownTypeBuilder {
    func _createConstructorMapping(fromStaticMethod signature: FunctionSignature,
                                   in transformations: TransformationsSink) -> KnownTypeBuilder {
        
        guard let constructor = lastConstructor else {
            assertionFailure("Must be called after a call to `.constructor`")
            return self
        }
        
        let transformer = ValueTransformer<PostfixExpression, Expression> { $0 }
            .validate { exp in
                exp.asPostfix?
                    .functionCall?
                    .identifierWith(methodName: signature.name)
                        == signature.asIdentifier
            }
            .decompose()
            .transformIndex(index: 0, transformer: ValueTransformer()
                .removingMemberAccess()
                .validate(matcher: ValueMatcher()
                    .isTyped(.metatype(for: .typeName(typeName)),
                             ignoringNullability: true)
                )
            )
            .asFunctionCall(labels: constructor.parameters.argumentLabels())
            .typed(.typeName(typeName))
        
        transformations.addValueTransformer(transformer)
        
        let annotation = """
            Convert from '\(
                TypeFormatter.asString(signature: signature, includeName: true)
            )'
            """
        
        return self.annotationgLatestConstructor(annotation: annotation)
    }
    
    func _createConstructorMapping(fromParameters parameters: [ParameterSignature],
                                   in transformations: TransformationsSink) -> KnownTypeBuilder {
        
        guard let constructor = lastConstructor else {
            assertionFailure("Must be called after a call to `.constructor`")
            return self
        }
        
        transformations.addInitTransform(from: parameters,
                                         to: constructor.parameters)
        
        let annotation = "Convert from 'init\(TypeFormatter.asString(parameters: parameters))'"
        
        return self.annotationgLatestConstructor(annotation: annotation)
    }
    
    func _createPropertyRename(from old: String, in transformations: TransformationsSink) -> KnownTypeBuilder {
        guard let property = lastProperty else {
            assertionFailure("Must be called after a call to `.property`")
            return self
        }
        
        transformations.addPropertyRenaming(old: old, new: property.name)
        
        let annotation = "Convert from \(property.isStatic ? "static " : "")var \(old)"
        
        return self.annotationgLatestProperty(annotation: annotation)
    }
    
    func _createPropertyFromMethods(getterName: String,
                                    setterName: String?,
                                    in transformations: TransformationsSink) -> KnownTypeBuilder {
        
        guard let property = lastProperty else {
            assertionFailure("Must be called after a call to `.property`")
            return self
        }
        
        transformations
            .addPropertyFromMethods(property: property.name,
                                    getter: getterName,
                                    setter: setterName,
                                    propertyType: property.storage.type,
                                    isStatic: property.isStatic)
        
        var annotation = "Convert from "
        
        if property.isStatic {
            annotation += "static "
        }
        
        annotation += "func \(getterName)()"
        
        if let setterName = setterName {
            annotation += " / "
            if property.isStatic {
                annotation += "static "
            }
            annotation += "func \(setterName)(\(property.storage.type))"
        }
        
        return self.annotationgLatestProperty(annotation: annotation)
    }
}
