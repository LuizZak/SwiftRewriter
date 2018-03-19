import SwiftAST

/// Helper known-type builder used to come up with default types and during testing
/// as well
public struct KnownTypeBuilder {
    public typealias ParameterTuple = (label: String, type: SwiftType)
    
    private let type: DummyBuildingType
    public var useSwiftSignatureMatching: Bool = false
    
    public init(typeName: String, supertype: KnownSupertypeConvertible? = nil,
                kind: KnownTypeKind = .class, file: String = #file,
                line: Int = #line) {
        var type = DummyBuildingType(typeName: typeName, supertype: supertype)
        
        type.kind = kind
        type.origin = "Synthesized with \(KnownTypeBuilder.self) at \(file) line \(line)"
        
        self.type = type
    }
    
    private init(type: DummyBuildingType, useSwiftSignatureMatching: Bool) {
        self.type = type
        self.useSwiftSignatureMatching = useSwiftSignatureMatching
    }
    
    /// Sets the supertype of the type being constructed on this known type builder
    public func settingSupertype(_ supertype: KnownSupertypeConvertible?) -> KnownTypeBuilder {
        var type = self.type
        type.supertype = supertype?.asKnownSupertype
        return KnownTypeBuilder(type: type, useSwiftSignatureMatching: useSwiftSignatureMatching)
    }
    
    /// Sets the kind of the type being built
    public func settingKind(_ kind: KnownTypeKind) -> KnownTypeBuilder {
        var type = self.type
        type.kind = kind
        return KnownTypeBuilder(type: type, useSwiftSignatureMatching: useSwiftSignatureMatching)
    }
    
    /// Adds a parameter-less constructor to this type
    public func constructor() -> KnownTypeBuilder {
        assert(!type.knownConstructors.contains { $0.parameters.isEmpty },
               "An empty constructor is already provided")
        
        return constructor(withParameters: [])
    }
    
    /// Adds a new constructor to this type
    public func constructor(shortParameters shortParams: [ParameterTuple]) -> KnownTypeBuilder {
        let parameters =
            shortParams.map { tuple in
                ParameterSignature(name: tuple.label, type: tuple.type)
            }
        
        return constructor(withParameters: parameters)
    }
    
    /// Adds a new constructor to this type
    public func constructor(withParameters parameters: [ParameterSignature]) -> KnownTypeBuilder {
        var type = self.type
        let ctor = DummyConstructor(parameters: parameters)
        
        type.knownConstructors.append(ctor)
        
        return KnownTypeBuilder(type: type, useSwiftSignatureMatching: useSwiftSignatureMatching)
    }
    
    /// Adds an instance method with a given return type, and a flag
    /// specifying whether the method is an optional protocol conformance method
    public func method(named name: String, shortParams: [ParameterTuple] = [],
                       returning returnType: SwiftType = .void, isStatic: Bool = false,
                       optional: Bool = false) -> KnownTypeBuilder {
        let parameters =
            shortParams.map { tuple in
                ParameterSignature(name: tuple.label, type: tuple.type)
        }
        
        let signature = FunctionSignature(name: name, parameters: parameters,
                                          returnType: returnType,
                                          isStatic: isStatic)
        
        return method(withSignature: signature, optional: optional)
    }
    
    /// Adds a method with a given signature, and a flag specifying whether the
    /// method is an optional protocol conformance method
    public func method(withSignature signature: FunctionSignature,
                       optional: Bool = false) -> KnownTypeBuilder {
        var type = self.type
        
        // Check duplicates
        if useSwiftSignatureMatching {
            if type.knownMethods.contains(where: { $0.signature.matchesAsSwiftFunction(signature) }) {
                return self
            }
        } else if type.knownMethods.contains(where: { $0.signature.matchesAsSelector(signature) }) {
            return self
        }
        
        let method = DummyMethod(ownerType: type, body: nil, signature: signature,
                                 optional: optional)
        
        type.knownMethods.append(method)
        
        return KnownTypeBuilder(type: type, useSwiftSignatureMatching: useSwiftSignatureMatching)
    }
    
    /// Adds a strong property with no attributes with a given name and type, and
    /// a flag specifying whether the property is an optional protocol conformance
    /// property
    public func property(named name: String, type: SwiftType, ownership: Ownership = .strong,
                         isStatic: Bool = false, optional: Bool = false,
                         accessor: KnownPropertyAccessor = .getterAndSetter) -> KnownTypeBuilder {
        let storage = ValueStorage(type: type, ownership: ownership, isConstant: false)
        
        return property(named: name, storage: storage, isStatic: isStatic,
                              optional: optional, accessor: accessor)
    }
    
    /// Adds a property with no attributes with a given name and storage, and a
    /// flag specifying whether the property is an optional protocol conformance
    /// property
    public func property(named name: String, storage: ValueStorage, isStatic: Bool = false,
                         optional: Bool = false, accessor: KnownPropertyAccessor = .getterAndSetter) -> KnownTypeBuilder {
        var type = self.type
        
        // Check duplicates
        guard !type.knownProperties.contains(where: {
            $0.name == name && $0.storage == storage && $0.isStatic == isStatic
        }) else {
            return self
        }
        
        let property = DummyProperty(ownerType: type, name: name, storage: storage,
                                     attributes: [], isStatic: isStatic,
                                     optional: optional, accessor: accessor)
        
        type.knownProperties.append(property)
        
        return KnownTypeBuilder(type: type, useSwiftSignatureMatching: useSwiftSignatureMatching)
    }
    
    /// Adds a strong field with no attributes with a given name and type
    public func field(named name: String, type: SwiftType, isConstant: Bool = false,
                      isStatic: Bool = false) -> KnownTypeBuilder {
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: isConstant)
        
        return field(named: name, storage: storage, isStatic: isStatic)
    }
    
    /// Adds a property with no attributes with a given name and storage
    public func field(named name: String, storage: ValueStorage, isStatic: Bool = false) -> KnownTypeBuilder {
        var type = self.type
        
        // Check duplicates
        guard !type.knownFields.contains(where: {
            $0.name == name && $0.storage == storage && $0.isStatic == isStatic
        }) else {
            return self
        }
        
        let property = DummyProperty(ownerType: type, name: name, storage: storage,
                                     attributes: [], isStatic: isStatic,
                                     optional: false, accessor: .getterAndSetter)
        
        type.knownFields.append(property)
        
        return KnownTypeBuilder(type: type, useSwiftSignatureMatching: useSwiftSignatureMatching)
    }
    
    public func protocolConformance(protocolName: String) -> KnownTypeBuilder {
        var type = self.type
        
        // Check duplicates
        guard !type.knownProtocolConformances.contains(where: { $0.protocolName == protocolName }) else {
            return self
        }
        
        let conformance = DummyProtocolConformance(protocolName: protocolName)
        
        type.knownProtocolConformances.append(conformance)
        
        return KnownTypeBuilder(type: type, useSwiftSignatureMatching: useSwiftSignatureMatching)
    }
    
    public func protocolConformances(protocolNames: [String]) -> KnownTypeBuilder {
        var result = self
        for prot in protocolNames {
            result = result.protocolConformance(protocolName: prot)
        }
        
        return result
    }
    
    public func enumRawValue(type rawValueType: SwiftType) -> KnownTypeBuilder {
        var type = self.type
        precondition(type.kind == .enum)
        
        type.setKnownTrait(KnownTypeTraits.enumRawValue, value: rawValueType)
        
        return KnownTypeBuilder(type: type, useSwiftSignatureMatching: useSwiftSignatureMatching)
    }
    
    public func enumCase(named: String, rawValue: Expression? = nil) -> KnownTypeBuilder {
        var type = self.type
        
        precondition(type.kind == .enum)
        
        let cs = EnumCaseGenerationIntention(name: named, expression: rawValue)
        cs.storage.type = .typeName(type.typeName)
        type.knownProperties.append(cs)
        
        return KnownTypeBuilder(type: type, useSwiftSignatureMatching: useSwiftSignatureMatching)
    }
    
    /// Returns the constructed KnownType instance from this builder, with all
    /// methods and properties associated with `with[...]()` method calls.
    public func build() -> KnownType {
        return DummyType(type: type)
    }
}

private class DummyType: KnownType {
    var origin: String
    var typeName: String
    var kind: KnownTypeKind = .class
    var knownTraits: [String: Any] = [:]
    var knownConstructors: [KnownConstructor] = []
    var knownMethods: [KnownMethod] = []
    var knownProperties: [KnownProperty] = []
    var knownFields: [KnownProperty] = []
    var knownProtocolConformances: [KnownProtocolConformance] = []
    var supertype: KnownSupertype?
    
    init(type: DummyBuildingType) {
        origin = type.origin
        typeName = type.typeName
        kind = type.kind
        knownTraits = type.knownTraits
        knownConstructors = type.knownConstructors
        knownMethods = type.knownMethods
        knownProperties = type.knownProperties
        knownFields = type.knownFields
        knownProtocolConformances = type.knownProtocolConformances
        supertype = type.supertype
    }
    
    init(typeName: String, supertype: KnownSupertypeConvertible? = nil) {
        self.origin = "Synthesized type"
        self.typeName = typeName
        self.supertype = supertype?.asKnownSupertype
    }
    
    func setKnownTrait<T>(_ trait: KnownTypeTrait<T>, value: T) {
        knownTraits[trait.name] = value
    }
}

private struct DummyBuildingType: KnownType {
    var origin: String
    var typeName: String
    var kind: KnownTypeKind = .class
    var knownTraits: [String: Any] = [:]
    var knownConstructors: [KnownConstructor] = []
    var knownMethods: [KnownMethod] = []
    var knownProperties: [KnownProperty] = []
    var knownFields: [KnownProperty] = []
    var knownProtocolConformances: [KnownProtocolConformance] = []
    var supertype: KnownSupertype?
    
    init(typeName: String, supertype: KnownSupertypeConvertible? = nil) {
        self.origin = "Synthesized type"
        self.typeName = typeName
        self.supertype = supertype?.asKnownSupertype
    }
    
    mutating func setKnownTrait<T>(_ trait: KnownTypeTrait<T>, value: T) {
        knownTraits[trait.name] = value
    }
}

private struct DummyConstructor: KnownConstructor {
    var parameters: [ParameterSignature]
}

private struct DummyMethod: KnownMethod {
    var ownerType: KnownType?
    var body: KnownMethodBody?
    var signature: FunctionSignature
    var optional: Bool
}

private struct DummyProperty: KnownProperty {
    var ownerType: KnownType?
    var name: String
    var storage: ValueStorage
    var attributes: [PropertyAttribute]
    var isStatic: Bool
    var optional: Bool
    var accessor: KnownPropertyAccessor
}

private struct DummyProtocolConformance: KnownProtocolConformance {
    var protocolName: String
}
