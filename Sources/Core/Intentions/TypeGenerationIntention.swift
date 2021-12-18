import GrammarModels
import SwiftAST
import KnownType

/// An intention to generate a class, struct or enumeration in swift.
public class TypeGenerationIntention: FromSourceIntention {
    public var origin: String
    
    public var typeName: String
    
    public var supertype: KnownTypeReference? {
        nil
    }
    
    private(set) public var protocols: [ProtocolInheritanceIntention] = []
    private(set) public var properties: [PropertyGenerationIntention] = []
    private(set) public var methods: [MethodGenerationIntention] = []
    private(set) public var constructors: [InitGenerationIntention] = []
    private(set) public var subscripts: [SubscriptGenerationIntention] = []
    
    public var isExtension: Bool {
        false
    }
    
    /// Returns `true` if this type has no inner members, or any protocol conformance.
    public var isEmptyType: Bool {
        protocols.isEmpty && properties.isEmpty && methods.isEmpty && constructors.isEmpty
    }
    
    // Cannot be in extension with others because Swift doesn't allow overriding
    // members defined in extensions
    public var knownFields: [KnownProperty] {
        []
    }
    
    public var knownTraits: [String: TraitType] = [:]
    public var knownAttributes: [KnownAttribute] = []
    
    public var kind: KnownTypeKind {
        .class
    }
    
    public var semantics: Set<Semantic> = []
    
    public init(typeName: String,
                accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        
        self.typeName = typeName
        
        self.origin = {
            guard let sourceNode = source else {
                return "Code-generated type"
            }
            guard let filename = sourceNode.originalSource?.filePath else {
                return "Code-generated type"
            }
            
            return "File '\(filename)' line \(sourceNode.location.line) column \(sourceNode.location.column)"
        }()
        
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        origin = try container.decode(String.self, forKey: .origin)
        typeName = try container.decode(String.self, forKey: .typeName)
        protocols = try container.decodeIntentions(forKey: .protocols)
        properties = try container.decodeIntentions(forKey: .properties)
        methods = try container.decodeIntentions(forKey: .methods)
        constructors = try container.decodeIntentions(forKey: .constructors)
        subscripts = try container.decodeIntentions(forKey: .subscripts)
        knownTraits = try container.decode([String: TraitType].self, forKey: .knownTraits)
        semantics = try container.decode(Set<Semantic>.self, forKey: .semantics)
        
        try super.init(from: container.superDecoder())
        
        for intention in protocols {
            intention.parent = self
        }
        for intention in methods {
            intention.type = self
            intention.parent = self
        }
        for intention in properties {
            intention.type = self
            intention.parent = self
        }
        for intention in constructors {
            intention.type = self
            intention.parent = self
        }
        for intention in subscripts {
            intention.type = self
            intention.parent = self
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(origin, forKey: .origin)
        try container.encode(typeName, forKey: .typeName)
        try container.encodeIntentions(protocols, forKey: .protocols)
        try container.encodeIntentions(properties, forKey: .properties)
        try container.encodeIntentions(methods, forKey: .methods)
        try container.encodeIntentions(constructors, forKey: .constructors)
        try container.encodeIntentions(subscripts, forKey: .subscripts)
        try container.encode(knownTraits, forKey: .knownTraits)
        try container.encode(semantics, forKey: .semantics)
        
        try super.encode(to: container.superEncoder())
    }
    
    /// Generates a new protocol conformance intention from a given known protocol
    /// conformance.
    ///
    /// - Parameter knownProtocol: A known protocol conformance.
    @discardableResult
    public func generateProtocolConformance(
        from knownProtocol: KnownProtocolConformance) -> ProtocolInheritanceIntention {
        
        let intention =
            ProtocolInheritanceIntention(protocolName: knownProtocol.protocolName)
        
        addProtocol(intention)
        
        return intention
    }
    public func addProtocol(_ intention: ProtocolInheritanceIntention, at index: Int? = nil) {
        if let index = index {
            self.protocols.insert(intention, at: index)
        } else {
            self.protocols.append(intention)
        }
        
        intention.parent = self
    }
    public func removeProtocol(_ intention: ProtocolInheritanceIntention) {
        if let index = protocols.firstIndex(where: { $0 === intention }) {
            intention.parent = nil
            protocols.remove(at: index)
        }
    }
    
    /// Generates a new property intention from a given known property and its
    /// name and storage information.
    ///
    /// - Parameter knownProperty: A known property declaration.
    @discardableResult
    public func generateProperty(from knownProperty: KnownProperty) -> PropertyGenerationIntention {
        let intention =
            PropertyGenerationIntention(name: knownProperty.name,
                                        storage: knownProperty.storage,
                                        objcAttributes: knownProperty.objcAttributes)
        
        addProperty(intention)
        
        return intention
    }
    public func addProperty(_ intention: PropertyGenerationIntention, at index: Int? = nil) {
        if let index = index {
            self.properties.insert(intention, at: index)
        } else {
            self.properties.append(intention)
        }
        
        intention.type = self
        intention.parent = self
    }
    public func removeProperty(_ intention: PropertyGenerationIntention) {
        if let index = properties.firstIndex(where: { $0 === intention }) {
            intention.parent = nil
            intention.type = nil
            properties.remove(at: index)
        }
    }
    
    /// Generates a new empty method from a given known method's signature.
    ///
    /// - Parameter knownMethod: A known method with an available signature.
    @discardableResult
    public func generateMethod(from knownMethod: KnownMethod, source: ASTNode? = nil) -> MethodGenerationIntention {
        let method =
            MethodGenerationIntention(signature: knownMethod.signature,
                                      accessLevel: .internal, source: source)
        
        if let body = knownMethod.body {
            method.functionBody = FunctionBodyIntention(body: body.body)
        }
        
        addMethod(method)
        
        return method
    }
    
    public func addMethod(_ intention: MethodGenerationIntention, at index: Int? = nil) {
        if let index = index {
            self.methods.insert(intention, at: index)
        } else {
            self.methods.append(intention)
        }
        
        intention.type = self
        intention.parent = self
    }
    public func removeMethod(_ intention: MethodGenerationIntention) {
        if let index = methods.firstIndex(where: { $0 === intention }) {
            intention.parent = nil
            intention.type = nil
            methods.remove(at: index)
        }
    }
    
    public func addSubscript(_ intention: SubscriptGenerationIntention) {
        subscripts.append(intention)
        
        intention.type = self
        intention.parent = self
    }
    
    public func addConstructor(_ intention: InitGenerationIntention) {
        self.constructors.append(intention)
        
        intention.type = self
        intention.parent = self
    }
    
    public func hasProperty(named name: String) -> Bool {
        properties.contains(where: { $0.name == name })
    }
    
    public func hasProtocol(named name: String) -> Bool {
        protocols.contains(where: { $0.protocolName == name })
    }
    
    /// Finds a method on this class that matches a given Objective-C selector
    /// signature.
    ///
    /// Ignores method variable names and types of return/parameters.
    public func method(matchingSelector selector: SelectorSignature) -> MethodGenerationIntention? {
        methods.first {
            $0.signature.asSelector == selector
        }
    }
    
    /// Returns all methods that match a given function identifier.
    public func methods(matching identifier: FunctionIdentifier) -> [MethodGenerationIntention] {
        methods.filter {
            $0.signature.asIdentifier == identifier
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case origin
        case typeName
        case supertype
        case protocols
        case properties
        case methods
        case constructors
        case subscripts
        case knownTraits
        case semantics
    }
}

extension TypeGenerationIntention: KnownType {
    public var knownMethods: [KnownMethod] {
        methods
    }
    public var knownConstructors: [KnownConstructor] {
        constructors
    }
    public var knownProperties: [KnownProperty] {
        properties
    }
    public var knownProtocolConformances: [KnownProtocolConformance] {
        protocols
    }
    public var knownSubscripts: [KnownSubscript] {
        subscripts
    }
    public var nestedTypes: [KnownType] {
        []
    }
    public var parentType: KnownTypeReference? {
        return nil
    }
}
