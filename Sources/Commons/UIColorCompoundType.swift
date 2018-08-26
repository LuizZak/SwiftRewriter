import SwiftAST
import SwiftRewriterLib

public enum UIColorCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        var type = KnownTypeBuilder(typeName: "UIColor", supertype: "NSObject")
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
            .property(named: "black", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "darkGray", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "lightGray", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "white", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "gray", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "red", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "green", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "blue", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "cyan", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "yellow", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "magenta", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "orange", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "purple", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "brown", type: "UIColor", isStatic: true, accessor: .getter)
            .property(named: "clear", type: "UIColor", isStatic: true, accessor: .getter)
        
        return
            CompoundedMappingType(knownType: type.build(),
                                  transformations: transformations.transformations)
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
                    .isTyped(.metatype(for: .typeName(typeName)))
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
        
        let annotation = "Convert from '\(old)'"
        
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
                                    setter: setterName)
        
        var annotation = "Convert from func \(getterName)()"
        
        if let setterName = setterName {
            annotation += " / func \(setterName)(\(property.storage.type))"
        }
        
        return self.annotationgLatestProperty(annotation: annotation)
    }
}
