import SwiftAST
import SwiftRewriterLib

public enum UIColorCompoundType {
    private static var singleton: CompoundedMappingType = {
        let typeAndMappings = createType()
        
        return CompoundedMappingType(knownType: typeAndMappings.0,
                                     transformations: typeAndMappings.1)
    }()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> (KnownType, [PostfixTransformation]) {
        let transformations = TransformationsSink()
        var type = KnownTypeBuilder(typeName: "UIColor", supertype: "NSObject")
        
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
        
        return (type.build(), transformations.transformations)
    }
}

extension KnownTypeBuilder {
    func _createPropertyRename(from old: String, in transformations: TransformationsSink) -> KnownTypeBuilder {
        guard let property = lastProperty else {
            assertionFailure("Must be called after a call to `.property`")
            return self
        }
        
        transformations.addPropertyRenaming(old: old, new: property.name)
        
        let annotation = "Convert from '\(old)'"
        
        return self.annotationgLastProperty(annotation: annotation)
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
        
        return self.annotationgLastProperty(annotation: annotation)
    }
}
