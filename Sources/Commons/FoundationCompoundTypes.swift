import SwiftAST
import SwiftRewriterLib

public enum FoundationCompoundTypes {
    public static let nsCalendar = CalendarCompoundType.self
    public static let nsArray = NSArrayCompoundType.self
    public static let nsMutableArray = NSMutableArrayCompoundType.self
    public static let nsDateFormatter = NSDateFormatterCompoundType.self
    public static let nsDate = NSDateCompoundType.self
    public static let nsLocale = NSLocaleCompoundType.self
}

public enum CalendarCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let annotations: AnnotationsSink = AnnotationsSink()
        var type = KnownTypeBuilder(typeName: "Calendar", supertype: "NSObject")
        let transformations = TransformationsSink(typeName: type.typeName)
        
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
        
        return
            CompoundedMappingType(knownType: type.build(),
                                  transformations: transformations.transformations)
    }
}

public enum NSArrayCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let annotations: AnnotationsSink = AnnotationsSink()
        var type = KnownTypeBuilder(typeName: "NSArray", supertype: "NSObject")
        let transformations = TransformationsSink(typeName: type.typeName)
        
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
            .property(named: "firstObject", type: .optional(.any), accessor: .getter)
            ._createPropertyFromMethods(getterName: "firstObject", setterName: nil, in: transformations)
            .property(named: "lastObject", type: .optional(.any), accessor: .getter)
            ._createPropertyFromMethods(getterName: "lastObject", setterName: nil, in: transformations)
        
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
        
        return
            CompoundedMappingType(knownType: type.build(),
                                  transformations: transformations.transformations)
    }
}

public enum NSMutableArrayCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let annotations: AnnotationsSink = AnnotationsSink()
        var type = KnownTypeBuilder(typeName: "NSMutableArray", supertype: "NSArray")
        let transformations = TransformationsSink(typeName: type.typeName)
        
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
        
        return
            CompoundedMappingType(knownType: type.build(),
                                  transformations: transformations.transformations)
    }
}

public enum NSDateFormatterCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let annotations: AnnotationsSink = AnnotationsSink()
        var type = KnownTypeBuilder(typeName: "DateFormatter", supertype: "Formatter")
        let transformations = TransformationsSink(typeName: type.typeName)
        
        type.useSwiftSignatureMatching = true
        
        type = type
            .property(named: "dateFormat", type: .implicitUnwrappedOptional(.string))
            ._createPropertyFromMethods(getterName: "dateFormat",
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
        
        return
            CompoundedMappingType(knownType: type.build(),
                                  transformations: transformations.transformations)
    }
}

public enum NSDateCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let aliases = ["NSDate"]
        let annotations: AnnotationsSink = AnnotationsSink()
        var type = KnownTypeBuilder(typeName: "Date", kind: .struct)
        let transformations = TransformationsSink(typeName: type.typeName)
        
        type.useSwiftSignatureMatching = true
        
        type = type
            .protocolConformances(protocolNames: ["Hashable", "Equatable"])
        
        type = type
            .property(named: "timeIntervalSince1970", type: "TimeInterval")
        
        type = type
            .constructor()
            ._createConstructorMapping(
                fromStaticMethod:
                    FunctionSignature(isStatic: true,
                                      signatureString: "date() -> Date"),
                in: transformations
            )
        
        type = type
            .method(withSignature:
                FunctionSignature(
                    isStatic: true,
                    signatureString: "date() -> Date"
                )
            )
        
        type = type
            .method(withSignature:
                FunctionSignature(
                    signatureString: "addingTimeInterval(_ timeInterval: TimeInterval) -> Date"
                ).makeSignatureMapping(
                    fromMethodNamed: "dateByAddingTimeInterval",
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
            .method(withSignature:
                FunctionSignature(
                    signatureString: "timeIntervalSince(_ date: Date) -> TimeInterval"
                ).makeSignatureMapping(
                    fromMethodNamed: "timeIntervalSinceDate",
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
            .method(withSignature:
                FunctionSignature(
                    signatureString: "isEqual(_ other: AnyObject) -> Bool"
                ).toBinaryOperation(
                    op: .equals,
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
            .method(withSignature:
                FunctionSignature(
                    signatureString: "isEqualToDate(_ other: Date) -> Bool"
                ).toBinaryOperation(
                    op: .equals,
                    in: transformations,
                    annotations: annotations
                ),
                    annotations: annotations.annotations
            )
        
        return
            CompoundedMappingType(knownType: type.build(),
                                  transformations: transformations.transformations,
                                  aliases: aliases)
    }
}

public enum NSLocaleCompoundType {
    private static var singleton = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let aliases = ["NSLocale"]
        var type = KnownTypeBuilder(typeName: "Locale", kind: .struct)
        let transformations = TransformationsSink(typeName: type.typeName)
        
        type.useSwiftSignatureMatching = true
        
        type = type
            .protocolConformances(protocolNames: ["Hashable", "Equatable"])
        
        type = type
            .constructor(shortParameters: [("identifier", .string)])
            ._createConstructorMapping(fromParameters:
                Array(parsingParameters: "(localeIdentifier: String)"),
                in: transformations
            )
        
        return
            CompoundedMappingType(knownType: type.build(),
                                  transformations: transformations.transformations,
                                  aliases: aliases)
    }
}
