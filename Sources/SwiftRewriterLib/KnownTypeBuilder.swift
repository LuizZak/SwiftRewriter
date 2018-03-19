import SwiftAST

/// Helper known-type builder used to come up with default types and during testing
/// as well
public struct KnownTypeBuilder {
    public typealias ParameterTuple = (label: String, type: SwiftType)
    
    private var type: BuildingKnownType
    public var useSwiftSignatureMatching: Bool = false
    
    public init(typeName: String, supertype: KnownSupertypeConvertible? = nil,
                kind: KnownTypeKind = .class, file: String = #file,
                line: Int = #line) {
        var type = BuildingKnownType(typeName: typeName, supertype: supertype)
        
        type.kind = kind
        type.origin = "Synthesized with \(KnownTypeBuilder.self) at \(file) line \(line)"
        
        self.type = type
    }
    
    private init(type: BuildingKnownType, useSwiftSignatureMatching: Bool) {
        self.type = type
        self.useSwiftSignatureMatching = useSwiftSignatureMatching
    }
    
    /// Sets the supertype of the type being constructed on this known type builder
    public func settingSupertype(_ supertype: KnownSupertypeConvertible?) -> KnownTypeBuilder {
        var new = clone()
        new.type.supertype = supertype?.asKnownSupertype
        return new
    }
    
    /// Sets the kind of the type being built
    public func settingKind(_ kind: KnownTypeKind) -> KnownTypeBuilder {
        var new = clone()
        new.type.kind = kind
        return new
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
        var new = clone()
        let ctor = BuildingKnownConstructor(parameters: parameters)
        
        new.type.constructors.append(ctor)
        
        return new
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
        
        var new = clone()
        
        // Check duplicates
        if useSwiftSignatureMatching {
            if type.knownMethods.contains(where: { $0.signature.matchesAsSwiftFunction(signature) }) {
                return self
            }
        } else if type.knownMethods.contains(where: { $0.signature.matchesAsSelector(signature) }) {
            return self
        }
        
        let method = BuildingKnownMethod(ownerType: type, body: nil, signature: signature,
                                         optional: optional)
        
        new.type.methods.append(method)
        
        return new
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
        
        var new = clone()
        
        // Check duplicates
        guard !type.knownProperties.contains(where: {
            $0.name == name && $0.storage == storage && $0.isStatic == isStatic
        }) else {
            return self
        }
        
        let property =
            BuildingKnownProperty(ownerType: type, name: name, storage: storage,
                                  attributes: [], isStatic: isStatic,
                                  optional: optional, accessor: accessor,
                                  isEnumCase: false)
        
        new.type.properties.append(property)
        
        return new
    }
    
    /// Adds a strong field with no attributes with a given name and type
    public func field(named name: String, type: SwiftType, isConstant: Bool = false,
                      isStatic: Bool = false) -> KnownTypeBuilder {
        
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: isConstant)
        
        return field(named: name, storage: storage, isStatic: isStatic)
    }
    
    /// Adds a property with no attributes with a given name and storage
    public func field(named name: String, storage: ValueStorage, isStatic: Bool = false) -> KnownTypeBuilder {
        
        var new = clone()
        
        // Check duplicates
        guard !type.knownFields.contains(where: {
            $0.name == name && $0.storage == storage && $0.isStatic == isStatic
        }) else {
            return self
        }
        
        let property =
            BuildingKnownProperty(ownerType: type, name: name, storage: storage,
                                  attributes: [], isStatic: isStatic,
                                  optional: false, accessor: .getterAndSetter,
                                  isEnumCase: false)
        
        new.type.fields.append(property)
        
        return new
    }
    
    public func protocolConformance(protocolName: String) -> KnownTypeBuilder {
        var new = clone()
        
        // Check duplicates
        guard !type.knownProtocolConformances.contains(where: { $0.protocolName == protocolName }) else {
            return self
        }
        
        let conformance = BuildingKnownProtocolConformance(protocolName: protocolName)
        
        new.type.protocols.append(conformance)
        
        return new
    }
    
    public func protocolConformances(protocolNames: [String]) -> KnownTypeBuilder {
        var result = self
        for prot in protocolNames {
            result = result.protocolConformance(protocolName: prot)
        }
        
        return result
    }
    
    public func enumRawValue(type rawValueType: SwiftType) -> KnownTypeBuilder {
        var new = clone()
        precondition(type.kind == .enum)
        
        new.type.setKnownTrait(KnownTypeTraits.enumRawValue, value: rawValueType)
        
        return new
    }
    
    public func enumCase(named name: String, rawValue: Expression? = nil) -> KnownTypeBuilder {
        var new = clone()
        
        precondition(type.kind == .enum)
        
        let storage =
            ValueStorage(type: .typeName(type.typeName), ownership: .strong,
                         isConstant: true)
        
        let cs =
            BuildingKnownProperty(ownerType: type, name: name, storage: storage,
                                  attributes: [], isStatic: true, optional: false,
                                  accessor: .getter, isEnumCase: true)
        
        new.type.properties.append(cs)
        
        return new
    }
    
    func clone() -> KnownTypeBuilder {
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
    var knownTraits: [String: Codable] = [:]
    var knownConstructors: [KnownConstructor] = []
    var knownMethods: [KnownMethod] = []
    var knownProperties: [KnownProperty] = []
    var knownFields: [KnownProperty] = []
    var knownProtocolConformances: [KnownProtocolConformance] = []
    var supertype: KnownSupertype?
    
    init(type: BuildingKnownType) {
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

private struct BuildingKnownType {
    var origin: String
    var typeName: String
    var kind: KnownTypeKind = .class
    var traits: [String: Codable] = [:]
    var constructors: [BuildingKnownConstructor] = []
    var methods: [BuildingKnownMethod] = []
    var properties: [BuildingKnownProperty] = []
    var fields: [BuildingKnownProperty] = []
    var protocols: [BuildingKnownProtocolConformance] = []
    var supertype: KnownSupertype?
    
    init(typeName: String, supertype: KnownSupertypeConvertible? = nil) {
        self.origin = "Synthesized type"
        self.typeName = typeName
        self.supertype = supertype?.asKnownSupertype
    }
}

extension BuildingKnownType: KnownType {
    var knownTraits: [String: Codable] {
        get {
            return traits
        }
        set {
            traits = newValue
        }
    }
    var knownConstructors: [KnownConstructor] {
        return constructors
    }
    var knownMethods: [KnownMethod] {
        return methods
    }
    var knownProperties: [KnownProperty] {
        return properties
    }
    var knownFields: [KnownProperty] {
        return fields
    }
    var knownProtocolConformances: [KnownProtocolConformance] {
        return protocols
    }
    
    mutating func setKnownTrait<T>(_ trait: KnownTypeTrait<T>, value: T) {
        knownTraits[trait.name] = value
    }
}

private struct BuildingKnownConstructor: KnownConstructor {
    var parameters: [ParameterSignature]
}

private struct BuildingKnownMethod: KnownMethod {
    var ownerType: KnownType?
    var body: KnownMethodBody?
    var signature: FunctionSignature
    var optional: Bool
}

private struct BuildingKnownProperty: KnownProperty {
    var ownerType: KnownType?
    var name: String
    var storage: ValueStorage
    var attributes: [PropertyAttribute]
    var isStatic: Bool
    var optional: Bool
    var accessor: KnownPropertyAccessor
    var isEnumCase: Bool
}

private struct BuildingKnownProtocolConformance: KnownProtocolConformance {
    var protocolName: String
}
