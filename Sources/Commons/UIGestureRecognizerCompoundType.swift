import SwiftAST
import SwiftRewriterLib

// swiftlint:disable line_length
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length
public enum UIGestureRecognizerCompoundType {
    private static var singleton: CompoundedMappingType = {
        let typeAndMappings = createType()
        
        return CompoundedMappingType(knownType: typeAndMappings.0,
                                     signatureMappings: typeAndMappings.1)
    }()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> (KnownType, [SignatureMapper]) {
        var mappings: [SignatureMapper] = []
        var type = KnownTypeBuilder(typeName: "UIGestureRecognizer", supertype: "NSObject")
        
        type.useSwiftSignatureMatching = true
        
        type =
            type.method(withSignature:
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
                    in: &mappings
                )
            )
        
        return (type.build(), mappings)
    }
}
