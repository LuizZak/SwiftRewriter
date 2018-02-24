import SwiftAST
import SwiftRewriterLib

/// Helper known-type builder used during tests that require such types
class KnownTypeBuilder {
    private let type: DummyType
    
    init(typeName: String, supertype: KnownType? = nil) {
        type = DummyType(typeName: typeName, supertype: supertype)
    }
    
    /// Adds a parameter-less constructor to this type
    func addingConstructor() -> KnownTypeBuilder {
        assert(!type.knownConstructors.contains { $0.parameters.count == 0 },
               "An empty constructor is already provided")
        
        return addingConstructor(withParameters: [])
    }
    
    /// Adds a new constructor to this type
    func addingConstructor(withParameters parameters: [ParameterSignature]) -> KnownTypeBuilder {
        let ctor = DummyConstructor(parameters: parameters)
        
        type.knownConstructors.append(ctor)
        
        return self
    }
    
    /// Adds a void-returning, parameter-less instance method
    func addingVoidMethod(named name: String) -> KnownTypeBuilder {
        let signature =
            FunctionSignature(isStatic: false, name: name, returnType: .void,
                              parameters: [])
        
        return addingMethod(withSignature: signature)
    }
    
    /// Adds a parameter-less instance method with a given return type
    func addingMethod(named name: String, returning returnType: SwiftType) -> KnownTypeBuilder {
        let signature =
            FunctionSignature(isStatic: false, name: name, returnType: returnType,
                              parameters: [])
        
        return addingMethod(withSignature: signature)
    }
    
    /// Adds a method with a given signature
    func addingMethod(withSignature signature: FunctionSignature) -> KnownTypeBuilder {
        let method = DummyMethod(body: nil, signature: signature)
        
        type.knownMethods.append(method)
        
        return self
    }
    
    /// Adds a strong property with no attributes with a given name and type
    func addingProperty(named name: String, type: SwiftType) -> KnownTypeBuilder {
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        let property = DummyProperty(name: name, storage: storage, attributes: [])
        
        self.type.knownProperties.append(property)
        
        return self
    }
    
    func addingProtocolConformance(protocolName: String) -> KnownTypeBuilder {
        let conformance = DummyProtocolConformance(protocolName: protocolName)
        
        type.knownProtocolConformances.append(conformance)
        
        return self
    }
    
    /// Returns the constructed KnownType instance from this builder, with all
    /// methods and properties associated with `with[...]()` method calls.
    func build() -> KnownType {
        return type
    }
}

private class DummyType: KnownType {
    var typeName: String
    var knownConstructors: [KnownConstructor] = []
    var knownMethods: [KnownMethod] = []
    var knownProperties: [KnownProperty] = []
    var knownProtocolConformances: [KnownProtocolConformance] = []
    var supertype: KnownType? = nil
    
    init(typeName: String, supertype: KnownType? = nil) {
        self.typeName = typeName
        self.supertype = supertype
    }
}

private struct DummyConstructor: KnownConstructor {
    var parameters: [ParameterSignature]
}

private struct DummyMethod: KnownMethod {
    var body: KnownMethodBody?
    var signature: FunctionSignature
}

private struct DummyProperty: KnownProperty {
    var name: String
    var storage: ValueStorage
    var attributes: [PropertyAttribute]
}

private struct DummyProtocolConformance: KnownProtocolConformance {
    var protocolName: String
}
