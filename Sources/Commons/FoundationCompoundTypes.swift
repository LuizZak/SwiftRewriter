import SwiftAST
import SwiftRewriterLib

public enum FoundationCompoundTypes {
    public static let nsCalendar = CalendarCompoundType.self
    public static let nsArray = NSArrayCompoundType.self
    public static let nsMutableArray = NSMutableArrayCompoundType.self
    public static let nsDateFormatter = NSDateFormatterCompoundType.self
    public static let nsDate = NSDateCompoundType.self
}

public enum CalendarCompoundType {
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
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
            .method(withSignature:
                FunctionSignature(
                    name: "date",
                    parameters: [
                        ParameterSignature(label: "byAdding", name: "component",
                                           type: .nested(["Calendar", "Component"])),
                        ParameterSignature(name: "value", type: "Int"),
                        ParameterSignature(label: "to", name: "date", type: "Date")
                    ],
                    returnType: .optional("Date")
                ).makeSignatureMapping(
                    from:
                    FunctionSignature(
                        name: "dateByAddingUnit",
                        parameters: [
                            ParameterSignature(label: nil, name: "component",
                                               type: .nested(["Calendar", "Component"])),
                            ParameterSignature(name: "value", type: "Int"),
                            ParameterSignature(label: "toDate", name: "date", type: "Date"),
                            ParameterSignature(name: "options", type: "NSCalendarOptions")
                        ], returnType: .optional("Date")
                    ),
                    arguments: [
                        .asIs,
                        .labeled("value", .asIs),
                        .labeled("to", .asIs)
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
        
        return (type.build(), transformations.transformations)
    }
}

public enum NSArrayCompoundType {
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
                    in: transformations,
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
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
        
        return (type.build(), transformations.transformations)
    }
}

public enum NSMutableArrayCompoundType {
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
                    in: transformations,
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
                    in: transformations,
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
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
        
        return (type.build(), transformations.transformations)
    }
}

public enum NSDateFormatterCompoundType {
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
        var type = KnownTypeBuilder(typeName: "DateFormatter", supertype: "Formatter")
        
        type.useSwiftSignatureMatching = true
        
        type = type
            .property(named: "dateFormat", type: .implicitUnwrappedOptional(.string))
            .createPropertyFromMethods(getterName: "dateFormat",
                                       setterName: "setDateFormat",
                                       in: transformations)
        
        type = type
            .method(withSignature:
                FunctionSignature(
                    name: "string",
                    parameters: [
                        ParameterSignature(label: "from", name: "date", type: "Date")
                    ],
                    returnType: .string
                ).makeSignatureMapping(
                    fromMethodNamed: "stringFromDate",
                    parameters: [
                        ParameterSignature(label: nil, name: "date", type: "Date")
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            ).method(withSignature:
                FunctionSignature(
                    name: "date",
                    parameters: [
                        ParameterSignature(label: "from", name: "string", type: "Date")
                    ],
                    returnType: .optional("Date")
                ).makeSignatureMapping(
                    fromMethodNamed: "dateFromString",
                    parameters: [
                        ParameterSignature(label: nil, name: "date", type: "Date")
                    ],
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
        
        return (type.build(), transformations.transformations)
    }
}

public enum NSDateCompoundType {
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
        var type = KnownTypeBuilder(typeName: "Date", supertype: "NSObject")
        
        type.useSwiftSignatureMatching = true
        
        type = type
            .property(named: "timeIntervalSince1970", type: "TimeInterval")
        
        type = type
            .method(withSignature:
                FunctionSignature(
                    name: "addingTimeInterval",
                    parameters: [
                        ParameterSignature(label: nil, name: "timeInterval", type: "TimeInterval")
                    ],
                    returnType: "Date"
                ).makeSignatureMapping(
                    fromMethodNamed: "dateByAddingTimeInterval",
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
        
        return (type.build(), transformations.transformations)
    }
}
