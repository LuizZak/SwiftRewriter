import SwiftAST
import SwiftRewriterLib

public enum FoundationCompoundTypes {
    public static let nsCalendar = CalendarCompoundType.self
}

public enum CalendarCompoundType {
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
        let annotations: AnnotationsSink = AnnotationsSink()
        var type = KnownTypeBuilder(typeName: "Calendar", supertype: "NSObject")
        
        type.useSwiftSignatureMatching = true
        // calendar.component(Calendar.Component.month, fromDate: date)
        
        type = type
            .method(withSignature:
                FunctionSignature(
                    name: "component",
                    parameters: [
                        ParameterSignature(label: nil, name: "component",
                                           type: .nested(["Calendar", "Component"])),
                        ParameterSignature(label: "from", name: "date", type: "Date")
                    ],
                    returnType: .int
                ).makeSignatureMapping(
                    fromMethodNamed: "component",
                    parameters: [
                        ParameterSignature(label: nil, name: "component",
                                           type: .nested(["Calendar", "Component"])),
                        ParameterSignature(label: "fromDate", name: "date", type: "Date")
                    ],
                    in: &mappings,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
        
        return (type.build(), mappings)
    }
}
