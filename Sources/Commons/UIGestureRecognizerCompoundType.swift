import SwiftAST
import SwiftRewriterLib

public enum UIGestureRecognizerCompoundType {
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
        let annotations: AnnotationsSink = AnnotationsSink()
        var type = KnownTypeBuilder(typeName: "UIGestureRecognizer", supertype: "NSObject")
        
        type.useSwiftSignatureMatching = true
        
        type = type
            .method(withSignature:
                FunctionSignature(
                    name: "location",
                    parameters: [
                        ParameterSignature(label: "in", name: "view", type: .optional("UIView"))
                    ],
                    returnType: "CGPoint"
                ).makeSignatureMapping(
                    fromMethodNamed: "locationInView",
                    parameters: [
                        ParameterSignature(label: nil, name: "view", type: .optional("UIView"))
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
        
        return (type.build(), transformations.transformations)
    }
}
