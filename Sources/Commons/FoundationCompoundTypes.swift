import SwiftAST
import SwiftRewriterLib

public enum FoundationCompoundTypes {
    public static let nsCalendar = CalendarCompoundType.self
    public static let nsArray = NSArrayCompoundType.self
    public static let nsMutableArray = NSMutableArrayCompoundType.self
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

public enum NSArrayCompoundType {
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
        var type = KnownTypeBuilder(typeName: "NSArray", supertype: "NSObject")
        
        type.useSwiftSignatureMatching = true
        
        type = type
            .protocolConformances(protocolNames: [
                "NSCopying",
                "NSMutableCopying",
                "NSSecureCoding",
                "NSFastEnumeration"
            ])
        
        type = type
            .property(named: "count", type: .int, accessor: .getter)
        
        type = type
            .method(withSignature:
                FunctionSignature(
                    name: "object",
                    parameters: [
                        ParameterSignature(label: "at", name: "index", type: .int)
                    ],
                    returnType: .any
                ).makeSignatureMapping(
                    fromMethodNamed: "objectAtIndex",
                    parameters: [
                        ParameterSignature(label: nil, name: "index", type: .int)
                    ],
                    in: &mappings,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            ).method(withSignature:
                FunctionSignature(
                    name: "contains",
                    parameters: [
                        ParameterSignature(label: nil, name: "anObject", type: .any)
                    ],
                    returnType: .bool
                ).makeSignatureMapping(
                    fromMethodNamed: "containsObject",
                    parameters: [
                        ParameterSignature(label: nil, name: "anObject", type: .any)
                    ],
                    in: &mappings,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
        
        return (type.build(), mappings)
    }
}

public enum NSMutableArrayCompoundType {
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
        var type = KnownTypeBuilder(typeName: "NSMutableArray", supertype: "NSArray")
        
        type.useSwiftSignatureMatching = true
        
        type = type
            .method(withSignature:
                FunctionSignature(
                    name: "add",
                    parameters: [
                        ParameterSignature(label: nil, name: "anObject", type: .any)
                    ]
                ).makeSignatureMapping(
                    fromMethodNamed: "addObject",
                    parameters: [
                        ParameterSignature(label: nil, name: "anObject", type: .any)
                    ],
                    in: &mappings,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            ).method(withSignature:
                FunctionSignature(
                    name: "addObjects",
                    parameters: [
                        ParameterSignature(label: "from", name: "otherArray", type: .array(.any))
                    ]
                ).makeSignatureMapping(
                    fromMethodNamed: "addObjectsFromArray",
                    parameters: [
                        ParameterSignature(label: nil, name: "otherArray", type: .array(.any))
                    ],
                    in: &mappings,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            ).method(withSignature:
                FunctionSignature(
                    name: "remove",
                    parameters: [
                        ParameterSignature(label: nil, name: "anObject", type: .any)
                    ]
                ).makeSignatureMapping(
                    fromMethodNamed: "removeObject",
                    parameters: [
                        ParameterSignature(label: nil, name: "anObject", type: .any)
                    ],
                    in: &mappings,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
        
        return (type.build(), mappings)
    }
}
