import Foundation
import SwiftAST

/// Helper known-type builder used to come up with default types and during testing
/// as well
public struct KnownTypeBuilder {
    public typealias ParameterTuple = (label: String, type: SwiftType)
    
    var type: BuildingKnownType
    public var useSwiftSignatureMatching: Bool = false
    
    /// If set, indicates that the type being built is nested within a given
    /// base type.
    public var nestedType: SwiftType?
    
    public var typeName: String {
        type.typeName
    }
    
    public var kind: KnownTypeKind {
        type.kind
    }
    
    public var fields: [KnownProperty] {
        type.fields
    }
    
    public var properties: [KnownProperty] {
        type.properties
    }
    
    public var methods: [KnownMethod] {
        type.methods
    }
    
    public var constructors: [KnownConstructor] {
        type.constructors
    }
    
    public var attributes: [KnownAttribute] {
        type.attributes
    }
    
    public var subscripts: [KnownSubscript] {
        type.subscripts
    }
    
    public var traits: [String: TraitType] {
        type.traits
    }
    
    public var conformances: [KnownProtocolConformance] {
        type.knownProtocolConformances
    }
    
    public var nestedTypes: [KnownType] {
        type.nestedTypes
    }
    
    public init(from existingType: KnownType, file: String = #file, line: Int = #line) {
        var type =
            BuildingKnownType(typeName: existingType.typeName,
                              supertype: (existingType.supertype?.asTypeName).map(KnownTypeReference.typeName))
        
        type.semantics = existingType.semantics
        type.kind = existingType.kind
        type.origin = "Cloned from existing type with \(KnownTypeBuilder.self) at \(file) line \(line)"
        type.parentType = existingType.parentType
        
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
        for sub in existingType.knownSubscripts {
            self = self.subscription(parameters: sub.parameters,
                                     returnType: sub.returnType,
                                     isStatic: sub.isStatic,
                                     isConstant: sub.isConstant,
                                     attributes: sub.knownAttributes,
                                     semantics: sub.semantics,
                                     annotations: sub.annotations)
        }
        for nested in existingType.nestedTypes {
            let subType = KnownTypeBuilder(from: nested)
                .setParentType(self.type.asKnownTypeReference)
                .build()
            self.type.nestedTypes.append(subType)
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
    
    public func swiftRewriterAttribute(_ content: SwiftRewriterAttribute.Content) -> KnownTypeBuilder {
        var new = clone()
        new.type.attributes.append(SwiftRewriterAttribute(content: content).asKnownAttribute)
        return new
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
    
    /// Adds a trait to the type
    public func addingTrait(_ traitName: String, value: TraitType) -> KnownTypeBuilder {
        var new = clone()
        new.type.traits[traitName] = value
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
    
    /// Sets the attributes for this type
    public func settingAttributes(_ attributes: [KnownAttribute]) -> KnownTypeBuilder {
        var new = clone()
        new.type.attributes = attributes
        return new
    }
    
    /// Adds a parameter-less constructor to this type
    public func constructor(isFailable: Bool = false,
                            annotations: [String] = []) -> KnownTypeBuilder {
        
        assert(!type.knownConstructors.contains(where: \.parameters.isEmpty),
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
                         propertyAttributes: [ObjcPropertyAttribute] = [],
                         attributes: [KnownAttribute] = [],
                         isEnumCase: Bool = false,
                         semantics: Set<Semantic> = [],
                         annotations: [String] = [],
                         expression: Expression? = nil) -> KnownTypeBuilder {
        
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
                                  annotations: annotations,
                                  expression: expression)
        
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
                                  annotations: annotations,
                                  expression: nil)
        
        new.type.fields.append(property)
        
        return new
    }
    
    public func subscription(indexType: SwiftType,
                             type: SwiftType,
                             isStatic: Bool = false,
                             isConstant: Bool = false,
                             attributes: [KnownAttribute] = [],
                             semantics: Set<Semantic> = [],
                             annotations: [String] = []) -> KnownTypeBuilder {
        
        let parameters = [
            ParameterSignature(name: "index", type: indexType)
        ]
        
        return subscription(parameters: parameters,
                            returnType: type,
                            isStatic: isStatic,
                            isConstant: isConstant,
                            attributes: attributes,
                            semantics: semantics,
                            annotations: annotations)
    }
    
    public func subscription(parameters: [ParameterSignature],
                             returnType: SwiftType,
                             isStatic: Bool = false,
                             isConstant: Bool = false,
                             attributes: [KnownAttribute] = [],
                             semantics: Set<Semantic> = [],
                             annotations: [String] = []) -> KnownTypeBuilder {
        
        var new = clone()
        
        let sub = BuildingKnownSubscript(isStatic: isStatic,
                                         ownerType: self.type.asKnownTypeReference,
                                         parameters: parameters,
                                         returnType: returnType,
                                         isConstant: isConstant,
                                         knownAttributes: attributes,
                                         semantics: semantics,
                                         annotations: annotations)
        
        new.type.subscripts.append(sub)
        
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
    
    public func settingEnumRawValue(type rawValueType: SwiftType) -> KnownTypeBuilder {
        precondition(type.kind == .enum,
                     "cannot add enum raw value to non-enum type kind \(type.kind)")
        
        var new = clone()
        
        new.type.setKnownTrait(KnownTypeTraits.enumRawValue,
                               value: .swiftType(rawValueType))
        
        return new
    }
    
    public func enumCase(named name: String,
                         rawValue: Expression? = nil,
                         semantics: Set<Semantic> = []) -> KnownTypeBuilder {
        
        precondition(type.kind == .enum,
                     "cannot add enum case to non-enum type kind \(type.kind)")
        
        var new = clone()
        
        let storage =
            ValueStorage(type: type.asSwiftType,
                         ownership: .strong,
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
                                  annotations: [],
                                  expression: rawValue)
        
        new.type.properties.append(cs)
        
        return new
    }
    
    public func nestedType(named name: String,
                           _ initializer: (KnownTypeBuilder) -> KnownTypeBuilder = { $0 }) -> KnownTypeBuilder {
        
        var new = clone()
        
        var nested = KnownTypeBuilder(typeName: name)
        if let parent = type.parentType {
            nested = nested.setParentType(.nested(base: parent, typeName: typeName))
        } else {
            nested = nested.setParentType(.typeName(typeName))
        }
        nested = initializer(nested)
        
        new.type.nestedTypes.append(nested.build())
        
        return new
    }
    
    public func setParentType(_ typeReference: KnownTypeReference?) -> KnownTypeBuilder {
        var new = clone()
        new.type.parentType = typeReference
        return new
    }
    
    func clone() -> KnownTypeBuilder {
        KnownTypeBuilder(type: type, useSwiftSignatureMatching: useSwiftSignatureMatching)
    }
    
    /// Returns the constructed KnownType instance from this builder.
    public func build() -> KnownType {
        DummyType(type: type)
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
    /// Gets the supertype currently registered on this known type builder.
    public var supertype: KnownTypeReferenceConvertible? {
        type.supertype
    }
    
    /// Returns the currently recorded protocol conformances for the final type
    public var protocolConformances: [String] {
        type.protocols.map(\.protocolName)
    }
}

private final class DummyType: KnownType {
    var origin: String
    var typeName: String
    var knownFile: KnownFile?
    var kind: KnownTypeKind = .class
    var knownTraits: [String: TraitType] = [:]
    var knownConstructors: [KnownConstructor] = []
    var knownMethods: [KnownMethod] = []
    var knownProperties: [KnownProperty] = []
    var knownFields: [KnownProperty] = []
    var knownSubscripts: [KnownSubscript] = []
    var knownProtocolConformances: [KnownProtocolConformance] = []
    var knownAttributes: [KnownAttribute] = []
    var supertype: KnownTypeReference?
    var semantics: Set<Semantic> = []
    var nestedTypes: [KnownType] = []
    var parentType: KnownTypeReference?
    
    init(type: BuildingKnownType) {
        origin = type.origin
        typeName = type.typeName
        kind = type.kind
        knownTraits = type.knownTraits
        knownConstructors = type.knownConstructors
        knownMethods = type.knownMethods
        knownProperties = type.knownProperties
        knownFields = type.knownFields
        knownSubscripts = type.knownSubscripts
        knownProtocolConformances = type.knownProtocolConformances
        knownAttributes = type.knownAttributes
        supertype = type.supertype
        semantics = type.semantics
        nestedTypes = type.nestedTypes
        parentType = type.parentType
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

struct BuildingKnownType: Codable {
    var origin: String
    var typeName: String
    var knownFile: KnownFile?
    var kind: KnownTypeKind = .class
    var traits: [String: TraitType] = [:]
    var constructors: [BuildingKnownConstructor] = []
    var methods: [BuildingKnownMethod] = []
    var properties: [BuildingKnownProperty] = []
    var fields: [BuildingKnownProperty] = []
    var subscripts: [BuildingKnownSubscript] = []
    var protocols: [BuildingKnownProtocolConformance] = []
    var attributes: [KnownAttribute] = []
    var supertype: KnownTypeReference?
    var semantics: Set<Semantic> = []
    var nestedTypes: [KnownType] = []
    var nestedType: SwiftType?
    var parentType: KnownTypeReference?
    
    init(typeName: String, supertype: KnownTypeReference? = nil) {
        self.origin = "Synthesized type"
        self.typeName = typeName
        self.supertype = supertype
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        origin = try container.decode(String.self, forKey: .origin)
        typeName = try container.decode(String.self, forKey: .typeName)
        kind = try container.decode(KnownTypeKind.self, forKey: .kind)
        traits = try container.decode([String: TraitType].self, forKey: .traits)
        constructors = try container.decode([BuildingKnownConstructor].self, forKey: .constructors)
        methods = try container.decode([BuildingKnownMethod].self, forKey: .methods)
        properties = try container.decode([BuildingKnownProperty].self, forKey: .properties)
        fields = try container.decode([BuildingKnownProperty].self, forKey: .fields)
        subscripts = try container.decode([BuildingKnownSubscript].self, forKey: .subscripts)
        protocols = try container.decode([BuildingKnownProtocolConformance].self, forKey: .protocols)
        attributes = try container.decode([KnownAttribute].self, forKey: .attributes)
        supertype = try container.decode(KnownTypeReference?.self, forKey: .supertype)
        semantics = try container.decode(Set<Semantic>.self, forKey: .semantics)
        nestedTypes = try container.decodeKnownTypes(forKey: .nestedTypes)
        parentType = try container.decodeIfPresent(KnownTypeReference.self, forKey: .parentType)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(origin, forKey: .origin)
        try container.encode(typeName, forKey: .typeName)
        try container.encode(kind, forKey: .kind)
        try container.encode(traits, forKey: .traits)
        try container.encode(constructors, forKey: .constructors)
        try container.encode(methods, forKey: .methods)
        try container.encode(properties, forKey: .properties)
        try container.encode(fields, forKey: .fields)
        try container.encode(subscripts, forKey: .subscripts)
        try container.encode(protocols, forKey: .protocols)
        try container.encode(attributes, forKey: .attributes)
        try container.encode(supertype, forKey: .supertype)
        try container.encode(semantics, forKey: .semantics)
        try container.encodeKnownTypes(nestedTypes, forKey: .nestedTypes)
        try container.encode(parentType, forKey: .parentType)
    }
    
    enum CodingKeys: String, CodingKey {
        case origin
        case typeName
        case kind
        case traits
        case constructors
        case methods
        case properties
        case fields
        case subscripts
        case protocols
        case attributes
        case supertype
        case semantics
        case nestedTypes
        case parentType
    }
}

extension BuildingKnownType: KnownType {
    var knownTraits: [String: TraitType] {
        get {
            traits
        }
        set {
            traits = newValue
        }
    }
    var knownConstructors: [KnownConstructor] {
        constructors
    }
    var knownMethods: [KnownMethod] {
        methods
    }
    var knownProperties: [KnownProperty] {
        properties
    }
    var knownFields: [KnownProperty] {
        fields
    }
    var knownSubscripts: [KnownSubscript] {
        subscripts
    }
    var knownProtocolConformances: [KnownProtocolConformance] {
        protocols
    }
    var knownAttributes: [KnownAttribute] {
        attributes
    }
    
    mutating func setKnownTrait(_ traitName: String, value: TraitType) {
        knownTraits[traitName] = value
    }
}

final class BuildingKnownConstructor: KnownConstructor, Codable {
    var parameters: [ParameterSignature]
    var knownAttributes: [KnownAttribute]
    var semantics: Set<Semantic>
    var isFailable: Bool
    var isConvenience: Bool
    var annotations: [String]
    
    init(parameters: [ParameterSignature], knownAttributes: [KnownAttribute],
         semantics: Set<Semantic>, isFailable: Bool, isConvenience: Bool,
         annotations: [String]) {
        
        self.parameters = parameters
        self.knownAttributes = knownAttributes
        self.semantics = semantics
        self.isFailable = isFailable
        self.isConvenience = isConvenience
        self.annotations = annotations
    }
}

final class BuildingKnownMethod: KnownMethod, Codable {
    var ownerType: KnownTypeReference?
    var body: KnownMethodBody?
    var signature: FunctionSignature
    var optional: Bool
    var knownAttributes: [KnownAttribute]
    var semantics: Set<Semantic>
    var annotations: [String]
    
    init(ownerType: KnownTypeReference?, body: KnownMethodBody?,
         signature: FunctionSignature, optional: Bool, knownAttributes: [KnownAttribute],
         semantics: Set<Semantic>, annotations: [String]) {
        
        self.ownerType = ownerType
        self.body = body
        self.signature = signature
        self.optional = optional
        self.knownAttributes = knownAttributes
        self.semantics = semantics
        self.annotations = annotations
    }
    
    enum CodingKeys: String, CodingKey {
        case ownerType
        case signature
        case optional
        case semantics
        case annotations
        case knownAttributes = "attributes"
    }
}

final class BuildingKnownProperty: KnownProperty, Codable {
    var ownerType: KnownTypeReference?
    var name: String
    var storage: ValueStorage
    var objcAttributes: [ObjcPropertyAttribute]
    var isStatic: Bool
    var optional: Bool
    var accessor: KnownPropertyAccessor
    var knownAttributes: [KnownAttribute]
    var isEnumCase: Bool
    var semantics: Set<Semantic>
    var annotations: [String]
    var expression: Expression?
    
    init(ownerType: KnownTypeReference?, name: String, storage: ValueStorage,
         attributes: [ObjcPropertyAttribute], isStatic: Bool, optional: Bool,
         accessor: KnownPropertyAccessor, knownAttributes: [KnownAttribute],
         isEnumCase: Bool, semantics: Set<Semantic>, annotations: [String],
         expression: Expression?) {
        
        self.ownerType = ownerType
        self.name = name
        self.storage = storage
        self.objcAttributes = attributes
        self.isStatic = isStatic
        self.optional = optional
        self.accessor = accessor
        self.knownAttributes = knownAttributes
        self.isEnumCase = isEnumCase
        self.semantics = semantics
        self.annotations = annotations
        self.expression = expression
    }
}

final class BuildingKnownSubscript: KnownSubscript, Codable {
    var isStatic: Bool
    var ownerType: KnownTypeReference?
    var parameters: [ParameterSignature]
    var returnType: SwiftType
    var isConstant: Bool
    var knownAttributes: [KnownAttribute]
    var semantics: Set<Semantic>
    var annotations: [String]
    
    init(isStatic: Bool, ownerType: KnownTypeReference?, parameters: [ParameterSignature],
         returnType: SwiftType, isConstant: Bool, knownAttributes: [KnownAttribute],
         semantics: Set<Semantic>, annotations: [String]) {
        
        self.isStatic = isStatic
        self.ownerType = ownerType
        self.parameters = parameters
        self.returnType = returnType
        self.isConstant = isConstant
        self.knownAttributes = knownAttributes
        self.semantics = semantics
        self.annotations = annotations
    }
}

struct BuildingKnownProtocolConformance: KnownProtocolConformance, Codable {
    var protocolName: String
}
