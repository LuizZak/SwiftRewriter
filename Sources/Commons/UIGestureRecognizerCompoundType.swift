import SwiftAST
import SwiftRewriterLib

public enum UIGestureRecognizerCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
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
            .method(withSignature:
                FunctionSignature(signatureString:
                    "require(toFail otherGestureRecognizer: UIGestureRecognizer)"
                ).makeSignatureMapping(fromSignature:
                    "requireGestureRecognizerToFail(_ otherGestureRecognizer: UIGestureRecognizer)",
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
        
        return
            CompoundedMappingType(knownType: type.build(),
                                  transformations: transformations.transformations)
    }
}
