import Foundation
import SwiftAST

/// Helper known-type builder used to come up with default types and during testing
/// as well
public struct KnownTypeBuilder {
    public typealias ParameterTuple = (label: String, type: SwiftType)
    
    private var type: BuildingKnownType
    public var useSwiftSignatureMatching: Bool = false
    
    public var typeName: String {
        return type.typeName
    }
    
    public init(from existingType: KnownType, file: String = #file, line: Int = #line) {
        var type =
            BuildingKnownType(typeName: existingType.typeName,
                              supertype: (existingType.supertype?.asTypeName).map(KnownTypeReference.typeName))
        
        type.semantics = existingType.semantics
        type.kind = existingType.kind
        type.origin = "Cloned from existing type with \(KnownTypeBuilder.self) at \(file) line \(line)"
        
        self.type = type
        
        for ctor in existingType.knownConstructors {
            self = self.constructor(withParameters: ctor.parameters,
                                    attributes: ctor.knownAttributes,
                                    semantics: ctor.semantics,
                                    isFailable: ctor.isFailable,
                                    isConvenience: ctor.isConvenience)
        }
        
        for field in existingType.knownFields {
            self = self.field(named: field.name,
                              storage: field.storage,
                              isStatic: field.isStatic,
                              attributes: field.knownAttributes,
                              semantics: field.semantics)
        }
        for method in existingType.knownMethods {
            self = self.method(withSignature: method.signature,
                               optional: method.optional,
                               attributes: method.knownAttributes,
                               semantics: method.semantics)
        }
        for prop in existingType.knownProperties {
            self =
                self.property(named: prop.name,
                              storage: prop.storage,
                              isStatic: prop.isStatic,
                              optional: prop.optional,
                              accessor: prop.accessor,
                              attributes: prop.knownAttributes,
                              isEnumCase: prop.isEnumCase,
                              semantics: prop.semantics)
        }
        for prot in existingType.knownProtocolConformances {
            self = self.protocolConformance(protocolName: prot.protocolName)
        }
        self.type.traits = existingType.knownTraits
    }
    
    public init(typeName: String,
                supertype: KnownTypeReferenceConvertible? = nil,
                kind: KnownTypeKind = .class,
                file: String = #file,
                line: Int = #line) {
        
        var type =
            BuildingKnownType(typeName: typeName,
                              supertype: supertype?.asKnownTypeReference)
        
        type.kind = kind
        type.origin = "Synthesized with \(KnownTypeBuilder.self) at \(file) line \(line)"
        
        self.type = type
    }
    
    private init(type: BuildingKnownType, useSwiftSignatureMatching: Bool) {
        self.type = type
        self.useSwiftSignatureMatching = useSwiftSignatureMatching
    }
    
    /// Changes the type name defined in this known type builder.
    public func named(_ name: String) -> KnownTypeBuilder {
        var new = clone()
        new.type.typeName = name
        return new
    }
    
    /// Sets the value of `useSwiftSignatureMatching` to be used for the remaining
    /// type builder invocations.
    public func settingUseSwiftSignatureMatching(_ value: Bool) -> KnownTypeBuilder {
        var new = clone()
        new.useSwiftSignatureMatching = value
        return new
    }
    
    /// Adds a new semantical annotation
    public func addingSemanticAnnotation(_ semantic: Semantic) -> KnownTypeBuilder {
        var new = clone()
        new.type.semantics.insert(semantic)
        return new
    }
    
    /// Sets the supertype of the type being constructed on this known type builder
    public func settingSupertype(_ supertype: KnownTypeReferenceConvertible?) -> KnownTypeBuilder {
        var new = clone()
        new.type.supertype = supertype?.asKnownTypeReference
        return new
    }
    
    /// Sets the kind of the type being built
    public func settingKind(_ kind: KnownTypeKind) -> KnownTypeBuilder {
        var new = clone()
        new.type.kind = kind
        return new
    }
    
    /// Sets the flag that indicates whether this known type is an extension of
    /// another concrete known type
    public func settingIsExtension(_ isExtension: Bool) -> KnownTypeBuilder {
        var new = clone()
        new.type.isExtension = isExtension
        return new
    }
    
    /// Sets the attributes for this type
    public func settingAttributes(_ attributes: [KnownAttribute]) -> KnownTypeBuilder {
        var new = clone()
        new.type.attributes = attributes
        return new
    }
    
    /// Adds a parameter-less constructor to this type
    public func constructor(isFailable: Bool = false,
                            annotations: [String] = []) -> KnownTypeBuilder {
        assert(!type.knownConstructors.contains { $0.parameters.isEmpty },
               "An empty constructor is already provided")
        
        return constructor(withParameters: [],
                           isFailable: isFailable,
                           annotations: annotations)
    }
    
    /// Adds a new constructor to this type
    public func constructor(shortParameters shortParams: [ParameterTuple],
                            semantics: Set<Semantic> = [],
                            isFailable: Bool = false,
                            isConvenience: Bool = false,
                            annotations: [String] = []) -> KnownTypeBuilder {
        
        let parameters =
            shortParams.map { tuple in
                ParameterSignature(name: tuple.label, type: tuple.type)
            }
        
        return constructor(withParameters: parameters,
                           semantics: semantics,
                           isFailable: isFailable,
                           isConvenience: isConvenience,
                           annotations: annotations)
    }
    
    /// Adds a new constructor to this type
    public func constructor(withParameters parameters: [ParameterSignature],
                            attributes: [KnownAttribute] = [],
                            semantics: Set<Semantic> = [],
                            isFailable: Bool = false,
                            isConvenience: Bool = false,
                            annotations: [String] = []) -> KnownTypeBuilder {
        
        var new = clone()
        let ctor = BuildingKnownConstructor(parameters: parameters,
                                            knownAttributes: attributes,
                                            semantics: semantics,
                                            isFailable: isFailable,
                                            isConvenience: isConvenience,
                                            annotations: annotations)
        
        new.type.constructors.append(ctor)
        
        return new
    }
    
    /// Adds an instance method with a given return type, and a flag
    /// specifying whether the method is an optional protocol conformance method
    public func method(named name: String,
                       shortParams: [ParameterTuple] = [],
                       returning returnType: SwiftType = .void,
                       isStatic: Bool = false,
                       isMutating: Bool = false,
                       optional: Bool = false,
                       attributes: [KnownAttribute] = [],
                       semantics: Set<Semantic> = [],
                       annotations: [String] = []) -> KnownTypeBuilder {
        
        let parameters =
            shortParams.map { tuple in
                ParameterSignature(name: tuple.label, type: tuple.type)
        }
        
        let signature = FunctionSignature(name: name,
                                          parameters: parameters,
                                          returnType: returnType,
                                          isStatic: isStatic,
                                          isMutating: isMutating)
        
        return method(withSignature: signature,
                      optional: optional,
                      attributes: attributes,
                      semantics: semantics,
                      annotations: annotations)
    }
    
    /// Adds a method with a given signature, and a flag specifying whether the
    /// method is an optional protocol conformance method
    public func method(withSignature signature: FunctionSignature,
                       optional: Bool = false,
                       attributes: [KnownAttribute] = [],
                       semantics: Set<Semantic> = [],
                       annotations: [String] = []) -> KnownTypeBuilder {
        
        var new = clone()
        
        // Check duplicates
        if useSwiftSignatureMatching {
            if type.knownMethods.contains(where: { $0.signature.matchesAsSwiftFunction(signature) }) {
                return self
            }
        } else if type.knownMethods.contains(where: { $0.signature.matchesAsSelector(signature) }) {
            assertionFailure("""
                Found duplicated Objective-C function signature while adding method \
                with signature \(TypeFormatter.asString(signature: signature)) to \
                the current type.
                
                Did you mean to turn on 'KnownTypeBuilder.useSwiftSignatureMatching'?
                """)
            return self
        }
        
        let method = BuildingKnownMethod(ownerType: type.asKnownTypeReference,
                                         body: nil,
                                         signature: signature,
                                         optional: optional,
                                         knownAttributes: attributes,
                                         semantics: semantics,
                                         annotations: annotations)
        
        new.type.methods.append(method)
        
        return new
    }
    
    /// Adds a method with a given signature string parsed, and a flag specifying
    /// whether the method is an optional protocol conformance method.
    ///
    /// Method traps, if signature is invalid.
    public func method(named name: String,
                       parsingSignature signature: String,
                       isStatic: Bool = false,
                       isMutating: Bool = false,
                       returning returnType: SwiftType = .void,
                       optional: Bool = false,
                       attributes: [KnownAttribute] = [],
                       semantics: Set<Semantic> = [],
                       annotations: [String] = []) -> KnownTypeBuilder {
        
        let params = try! FunctionSignatureParser.parseParameters(from: signature)
        
        let signature =
            FunctionSignature(name: name,
                              parameters: params,
                              returnType: returnType,
                              isStatic: isStatic,
                              isMutating: isMutating)
        
        return method(withSignature: signature,
                      optional: optional,
                      attributes: attributes,
                      semantics: semantics,
                      annotations: annotations)
    }
    
    /// Adds a strong property with no attributes with a given name and type, and
    /// a flag specifying whether the property is an optional protocol conformance
    /// property
    public func property(named name: String,
                         type: SwiftType,
                         ownership: Ownership = .strong,
                         isStatic: Bool = false,
                         optional: Bool = false,
                         accessor: KnownPropertyAccessor = .getterAndSetter,
                         attributes: [KnownAttribute] = [],
                         semantics: Set<Semantic> = [],
                         annotations: [String] = []) -> KnownTypeBuilder {
        
        let storage = ValueStorage(type: type, ownership: ownership, isConstant: false)
        
        return property(named: name,
                        storage: storage,
                        isStatic: isStatic,
                        optional: optional,
                        accessor: accessor,
                        attributes: attributes,
                        semantics: semantics,
                        annotations: annotations)
    }
    
    /// Adds a property with no attributes with a given name and storage, and a
    /// flag specifying whether the property is an optional protocol conformance
    /// property
    public func property(named name: String,
                         storage: ValueStorage,
                         isStatic: Bool = false,
                         optional: Bool = false,
                         accessor: KnownPropertyAccessor = .getterAndSetter,
                         propertyAttributes: [PropertyAttribute] = [],
                         attributes: [KnownAttribute] = [],
                         isEnumCase: Bool = false,
                         semantics: Set<Semantic> = [],
                         annotations: [String] = []) -> KnownTypeBuilder {
        
        var new = clone()
        
        // Check duplicates
        guard !type.knownProperties.contains(where: {
            $0.name == name && $0.storage == storage && $0.isStatic == isStatic
        }) else {
            return self
        }
        
        let property =
            BuildingKnownProperty(ownerType: type.asKnownTypeReference,
                                  name: name,
                                  storage: storage,
                                  attributes: propertyAttributes,
                                  isStatic: isStatic,
                                  optional: optional,
                                  accessor: accessor,
                                  knownAttributes: attributes,
                                  isEnumCase: isEnumCase,
                                  semantics: semantics,
                                  annotations: annotations)
        
        new.type.properties.append(property)
        
        return new
    }
    
    /// Adds a strong field with no attributes with a given name and type
    public func field(named name: String,
                      type: SwiftType,
                      isConstant: Bool = false,
                      isStatic: Bool = false,
                      attributes: [KnownAttribute] = [],
                      semantics: Set<Semantic> = [],
                      annotations: [String] = []) -> KnownTypeBuilder {
        
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: isConstant)
        
        return field(named: name,
                     storage: storage,
                     isStatic: isStatic,
                     attributes: attributes,
                     semantics: semantics,
                     annotations: annotations)
    }
    
    /// Adds a property with no attributes with a given name and storage
    public func field(named name: String,
                      storage: ValueStorage,
                      isStatic: Bool = false,
                      attributes: [KnownAttribute] = [],
                      semantics: Set<Semantic> = [],
                      annotations: [String] = []) -> KnownTypeBuilder {
        
        var new = clone()
        
        // Check duplicates
        guard !type.knownFields.contains(where: {
            $0.name == name && $0.storage == storage && $0.isStatic == isStatic
        }) else {
            return self
        }
        
        let property =
            BuildingKnownProperty(ownerType: type.asKnownTypeReference,
                                  name: name,
                                  storage: storage,
                                  attributes: [],
                                  isStatic: isStatic,
                                  optional: false,
                                  accessor: .getterAndSetter,
                                  knownAttributes: attributes,
                                  isEnumCase: false,
                                  semantics: semantics,
                                  annotations: annotations)
        
        new.type.fields.append(property)
        
        return new
    }
    
    public func annotatingLatestConstructor(annotation: String) -> KnownTypeBuilder {
        var new = clone()
        new.type.constructors[new.type.constructors.count - 1].annotations.append(annotation)
        
        return new
    }
    
    public func annotatingLatestProperty(annotation: String) -> KnownTypeBuilder {
        var new = clone()
        new.type.properties[new.type.properties.count - 1].annotations.append(annotation)
        
        return new
    }
    
    public func attributingLatestConstructor(attribute: KnownAttribute) -> KnownTypeBuilder {
        var new = clone()
        new.type.constructors[new.type.constructors.count - 1].knownAttributes.append(attribute)
        
        return new
    }
    
    public func attributingLatestProperty(attribute: KnownAttribute) -> KnownTypeBuilder {
        var new = clone()
        new.type.properties[new.type.properties.count - 1].knownAttributes.append(attribute)
        
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
        
        new.type.setKnownTrait(KnownTypeTraits.enumRawValue,
                               value: .swiftType(rawValueType))
        
        return new
    }
    
    public func enumCase(named name: String,
                         rawValue: Expression? = nil,
                         semantics: Set<Semantic> = []) -> KnownTypeBuilder {
        
        var new = clone()
        
        precondition(type.kind == .enum)
        
        let storage =
            ValueStorage(type: .typeName(type.typeName), ownership: .strong,
                         isConstant: true)
        
        let cs =
            BuildingKnownProperty(ownerType: type.asKnownTypeReference,
                                  name: name,
                                  storage: storage,
                                  attributes: [],
                                  isStatic: true,
                                  optional: false,
                                  accessor: .getter,
                                  knownAttributes: [],
                                  isEnumCase: true,
                                  semantics: semantics,
                                  annotations: [])
        
        new.type.properties.append(cs)
        
        return new
    }
    
    func clone() -> KnownTypeBuilder {
        return KnownTypeBuilder(type: type, useSwiftSignatureMatching: useSwiftSignatureMatching)
    }
    
    /// Returns the constructed KnownType instance from this builder.
    public func build() -> KnownType {
        return DummyType(type: type)
    }
    
    /// Encodes the type represented by this known type builder
    ///
    /// - Returns: A data representation of the type being built which can be later
    /// deserialized back into a buildable type with `KnownTypeBuilder.decode(from:)`.
    /// - Throws: Any error thrown during the decoding process.
    public func encode() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(type)
    }
    
    /// Decodes the type to be built by this type builder from a given serialized
    /// data which resulted from a call to `KnownTypeBuilder.encode()`.
    ///
    /// - Parameter data: A data object produced by a call to `KnownTypeBuilder.encode()`.
    /// - Throws: Any error thrown during the decoding process.
    public mutating func decode(from data: Data) throws {
        let decoder = JSONDecoder()
        type = try decoder.decode(BuildingKnownType.self, from: data)
    }
}

// MARK: - Removal
extension KnownTypeBuilder {
    
    /// Removes direct protocol conformances to protocols that match the given
    /// name.
    public func removingConformance(to protocolName: String) -> KnownTypeBuilder {
        var new = clone()
        new.type.protocols.removeAll(where: { $0.protocolName == protocolName })
        return new
    }
    
}

// MARK: - Querying
extension KnownTypeBuilder {
    /// Returns a reference to the latest constructor added to this `KnownTypeBuilder`
    /// via a `.constructor(...)` call
    public var lastConstructor: KnownConstructor? {
        return type.constructors.last
    }
    
    /// Returns a reference to the latest method added to this `KnownTypeBuilder`
    /// via a `.method(...)` call
    public var latestMethod: KnownMethod? {
        return type.methods.last
    }
    
    /// Returns a reference to the latest property added to this `KnownTypeBuilder`
    /// via a `.property(...)` call
    public var lastProperty: KnownProperty? {
        return type.properties.last
    }
    
    /// Returns the currently recorded protocol conformances for the final type
    public var protocolConformances: [String] {
        return type.protocols.map { $0.protocolName }
    }
}

private class DummyType: KnownType {
    var origin: String
    var typeName: String
    var kind: KnownTypeKind = .class
    var isExtension: Bool = false
    var knownTraits: [String: TraitType] = [:]
    var knownConstructors: [KnownConstructor] = []
    var knownMethods: [KnownMethod] = []
    var knownProperties: [KnownProperty] = []
    var knownFields: [KnownProperty] = []
    var knownProtocolConformances: [KnownProtocolConformance] = []
    var knownAttributes: [KnownAttribute] = []
    var supertype: KnownTypeReference?
    var semantics: Set<Semantic> = []
    
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
        knownAttributes = type.knownAttributes
        supertype = type.supertype
        semantics = type.semantics
        isExtension = type.isExtension
    }
    
    init(typeName: String, supertype: KnownTypeReferenceConvertible? = nil) {
        self.origin = "Synthesized type"
        self.typeName = typeName
        self.supertype = supertype?.asKnownTypeReference
    }
    
    func setKnownTrait(_ traitName: String, value: TraitType) {
        knownTraits[traitName] = value
    }
}

private struct BuildingKnownType: Codable {
    var origin: String
    var typeName: String
    var kind: KnownTypeKind = .class
    var isExtension: Bool = false
    var traits: [String: TraitType] = [:]
    var constructors: [BuildingKnownConstructor] = []
    var methods: [BuildingKnownMethod] = []
    var properties: [BuildingKnownProperty] = []
    var fields: [BuildingKnownProperty] = []
    var protocols: [BuildingKnownProtocolConformance] = []
    var attributes: [KnownAttribute] = []
    var supertype: KnownTypeReference?
    var semantics: Set<Semantic> = []
    
    init(typeName: String, supertype: KnownTypeReference? = nil) {
        self.origin = "Synthesized type"
        self.typeName = typeName
        self.supertype = supertype
    }
}

extension BuildingKnownType: KnownType {
    var knownTraits: [String: TraitType] {
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
    var knownAttributes: [KnownAttribute] {
        return attributes
    }
    
    mutating func setKnownTrait(_ traitName: String, value: TraitType) {
        knownTraits[traitName] = value
    }
}

private struct BuildingKnownConstructor: KnownConstructor, Codable {
    var parameters: [ParameterSignature]
    var knownAttributes: [KnownAttribute]
    var semantics: Set<Semantic>
    var isFailable: Bool
    var isConvenience: Bool
    var annotations: [String]
}

private struct BuildingKnownMethod: KnownMethod, Codable {
    var ownerType: KnownTypeReference?
    var body: KnownMethodBody?
    var signature: FunctionSignature
    var optional: Bool
    var knownAttributes: [KnownAttribute]
    var semantics: Set<Semantic>
    var annotations: [String]
    
    public enum CodingKeys: String, CodingKey {
        case ownerType
        case signature
        case optional
        case semantics
        case annotations
        case knownAttributes = "attributes"
    }
}

private struct BuildingKnownProperty: KnownProperty, Codable {
    var ownerType: KnownTypeReference?
    var name: String
    var storage: ValueStorage
    var attributes: [PropertyAttribute]
    var isStatic: Bool
    var optional: Bool
    var accessor: KnownPropertyAccessor
    var knownAttributes: [KnownAttribute]
    var isEnumCase: Bool
    var semantics: Set<Semantic>
    var annotations: [String]
}

private struct BuildingKnownProtocolConformance: KnownProtocolConformance, Codable {
    var protocolName: String
}
