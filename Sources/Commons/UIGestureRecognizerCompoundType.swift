import SwiftAST
import SwiftRewriterLib

public enum UIGestureRecognizerCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let annotations: AnnotationsSink = AnnotationsSink()
        var type = KnownTypeBuilder(typeName: "UIGestureRecognizer", supertype: "NSObject")
        let transformations = TransformationsSink(typeName: type.typeName)
        
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
                    attributes: annotations.attributes
            )
            .method(withSignature:
                FunctionSignature(signatureString:
                    "require(toFail otherGestureRecognizer: UIGestureRecognizer)"
                ).makeSignatureMapping(fromSignature:
                    "requireGestureRecognizerToFail(_ otherGestureRecognizer: UIGestureRecognizer)",
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
