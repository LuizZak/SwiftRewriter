import SwiftAST

/// Helper known-type builder used to come up with default types and during testing
/// as well
public class KnownTypeBuilder {
    private let type: DummyType
    
    public init(typeName: String, supertype: KnownSupertypeConvertible? = nil, file: String = #file, line: Int = #line) {
        type = DummyType(typeName: typeName, supertype: supertype)
        
        type.origin = "Synthesized with \(KnownTypeBuilder.self) at \(file) line \(line)"
    }
    
    /// Sets the supertype of the type being constructed on this known type builder
    public func settingSupertype(_ supertype: KnownSupertypeConvertible?) -> KnownTypeBuilder {
        type.supertype = supertype?.asKnownSupertype
        return self
    }
    
    /// Adds a parameter-less constructor to this type
    public func addingConstructor() -> KnownTypeBuilder {
        assert(!type.knownConstructors.contains { $0.parameters.count == 0 },
               "An empty constructor is already provided")
        
        return addingConstructor(withParameters: [])
    }
    
    /// Adds a new constructor to this type
    public func addingConstructor(withParameters parameters: [ParameterSignature]) -> KnownTypeBuilder {
        let ctor = DummyConstructor(parameters: parameters)
        
        type.knownConstructors.append(ctor)
        
        return self
    }
    
    /// Adds a void-returning, parameter-less instance method
    public func addingVoidMethod(named name: String) -> KnownTypeBuilder {
        let signature =
            FunctionSignature(name: name, parameters: [])
        
        return addingMethod(withSignature: signature)
    }
    
    /// Adds a parameter-less instance method with a given return type
    public func addingMethod(named name: String, returning returnType: SwiftType) -> KnownTypeBuilder {
        let signature =
            FunctionSignature(name: name, parameters: [], returnType: returnType)
        
        return addingMethod(withSignature: signature)
    }
    
    /// Adds a method with a given signature
    public func addingMethod(withSignature signature: FunctionSignature) -> KnownTypeBuilder {
        // TODO: Verify whether we should match with Swift or Objective-C selector
        // rules here (Swift allows for overloads over parameter/return types).
        // Probably with a flag on the KnownTypeBuilder instance.
        
        // Check duplicates
        guard !type.knownMethods.contains(where: { $0.signature.matchesAsSelector(signature) }) else {
            return self
        }
        
        let method = DummyMethod(ownerType: type, body: nil, signature: signature)
        
        type.knownMethods.append(method)
        
        return self
    }
    
    /// Adds a strong property with no attributes with a given name and type
    public func addingProperty(named name: String, type: SwiftType) -> KnownTypeBuilder {
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        
        return addingProperty(named: name, storage: storage)
    }
    
    /// Adds a property with no attributes with a given name and storage
    public func addingProperty(named name: String, storage: ValueStorage, isStatic: Bool = false) -> KnownTypeBuilder {
        // Check duplicates
        guard !type.knownProperties.contains(where: { $0.name == name && $0.storage == storage && $0.isStatic == isStatic }) else {
            return self
        }
        
        let property = DummyProperty(ownerType: type,
                                     name: name,
                                     storage: storage,
                                     attributes: [],
                                     isStatic: isStatic)
        
        type.knownProperties.append(property)
        
        return self
    }
    
    /// Adds a strong field with no attributes with a given name and type
    public func addingField(named name: String, type: SwiftType) -> KnownTypeBuilder {
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        
        return addingField(named: name, storage: storage)
    }
    
    /// Adds a property with no attributes with a given name and storage
    public func addingField(named name: String, storage: ValueStorage, isStatic: Bool = false) -> KnownTypeBuilder {
        // Check duplicates
        guard !type.knownFields.contains(where: { $0.name == name && $0.storage == storage && $0.isStatic == isStatic }) else {
            return self
        }
        
        let property = DummyProperty(ownerType: type,
                                     name: name,
                                     storage: storage,
                                     attributes: [],
                                     isStatic: isStatic)
        
        type.knownFields.append(property)
        
        return self
    }
    
    public func addingProtocolConformance(protocolName: String) -> KnownTypeBuilder {
        // Check duplicates
        guard !type.knownProtocolConformances.contains(where: { $0.protocolName == protocolName }) else {
            return self
        }
        
        let conformance = DummyProtocolConformance(protocolName: protocolName)
        
        type.knownProtocolConformances.append(conformance)
        
        return self
    }
    
    /// Returns the constructed KnownType instance from this builder, with all
    /// methods and properties associated with `with[...]()` method calls.
    public func build() -> KnownType {
        return type
    }
}

private class DummyType: KnownType {
    var origin: String
    var typeName: String
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
}

private struct DummyConstructor: KnownConstructor {
    var parameters: [ParameterSignature]
}

private struct DummyMethod: KnownMethod {
    var ownerType: KnownType?
    var body: KnownMethodBody?
    var signature: FunctionSignature
}

private struct DummyProperty: KnownProperty {
    var ownerType: KnownType?
    var name: String
    var storage: ValueStorage
    var attributes: [PropertyAttribute]
    var isStatic: Bool
}

private struct DummyProtocolConformance: KnownProtocolConformance {
    var protocolName: String
}
