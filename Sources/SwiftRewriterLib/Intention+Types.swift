import SwiftAST
import GrammarModels

/// An intention that comes from the reading of a source code file, instead of
/// being synthesized
public class FromSourceIntention: NonNullScopedIntention {
    public var source: ASTNode?
    public var accessLevel: AccessLevel
    
    weak internal(set) public var parent: Intention?
    
    // NOTE: This is a hack- shouldn't be recorded on the intention but passed to
    // it in a more abstract way.
    // For now we leave it as it is since it works!
    /// Whether this intention was collected between NS_ASSUME_NONNULL_BEGIN/END
    /// macros.
    public var inNonnullContext: Bool = false
    
    public init(accessLevel: AccessLevel, source: ASTNode?) {
        self.accessLevel = accessLevel
        self.source = source
    }
}

/// An intention to generate a class, struct or enumeration in swift.
public class TypeGenerationIntention: FromSourceIntention {
    public var typeName: String
    
    public var supertype: KnownSupertype? {
        return nil
    }
    
    private(set) public var protocols: [ProtocolInheritanceIntention] = []
    private(set) public var properties: [PropertyGenerationIntention] = []
    private(set) public var methods: [MethodGenerationIntention] = []
    private(set) public var constructors: [InitGenerationIntention] = []
    
    public init(typeName: String, accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.typeName = typeName
        
        super.init(accessLevel: accessLevel, source: source)
    }
    
    /// Generates a new protocol conformance intention from a given known protocol
    /// conformance.
    ///
    /// - Parameter knownProtocol: A known protocol conformance.
    @discardableResult
    public func generateProtocolConformance(from knownProtocol: KnownProtocolConformance) -> ProtocolInheritanceIntention {
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
        if let index = protocols.index(where: { $0 === intention }) {
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
                                        attributes: knownProperty.attributes)
        
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
        if let index = properties.index(where: { $0 === intention }) {
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
        if let index = methods.index(where: { $0 === intention }) {
            intention.parent = nil
            intention.type = nil
            methods.remove(at: index)
        }
    }
    
    // TODO: Create a separate intention class for constructors
    public func addConstructor(_ intention: InitGenerationIntention) {
        self.constructors.append(intention)
        
        intention.type = self
        intention.parent = self
    }
    
    public func hasProtocol(named name: String) -> Bool {
        return protocols.contains(where: { $0.protocolName == name })
    }
    
    public func hasProperty(named name: String) -> Bool {
        return properties.contains(where: { $0.name == name })
    }
    
    public func hasMethod(named name: String) -> Bool {
        return methods.contains(where: { $0.name == name })
    }
    
    public func hasMethod(withSignature signature: FunctionSignature) -> Bool {
        return method(withSignature: signature) != nil
    }
    
    public func hasMethod(withSelector signature: FunctionSignature) -> Bool {
        return method(matchingSelector: signature) != nil
    }
    
    public func method(withSignature signature: FunctionSignature) -> MethodGenerationIntention? {
        return methods.first {
            return signature.droppingNullability == $0.signature.droppingNullability
        }
    }
    
    /// Finds a method on this class that matches a given Objective-C selector
    /// signature.
    ///
    /// Ignores method variable names and types of return/parameters.
    public func method(matchingSelector signature: FunctionSignature) -> MethodGenerationIntention? {
        return methods.first {
            return $0.signature.matchesAsSelector(signature)
        }
    }
}

extension TypeGenerationIntention: KnownType {
    public var knownMethods: [KnownMethod] {
        return methods
    }
    public var knownConstructors: [KnownConstructor] {
        return constructors
    }
    public var knownProperties: [KnownProperty] {
        return properties
    }
    public var knownProtocolConformances: [KnownProtocolConformance] {
        return protocols
    }
}

/// An intention to generate a property or method on a type
public class MemberGenerationIntention: FromSourceIntention {
    /// Type this member generation intention belongs to
    public internal(set) var type: TypeGenerationIntention?
    
    /// Returns whether this member is static (i.e. class member).
    /// Defaults to `false`, unless overriden by a subclass.
    public var isStatic: Bool { return false }
}

extension MemberGenerationIntention: KnownMember {
    public var ownerType: KnownType? {
        return type
    }
}

/// An intention to generate a property, either static/instance, computed/stored
/// for a type definition.
public class PropertyGenerationIntention: MemberGenerationIntention, ValueStorageIntention {
    public var propertySource: PropertyDefinition? {
        return source as? PropertyDefinition
    }
    public var synthesizeSource: PropertySynthesizeItem? {
        return source as? PropertySynthesizeItem
    }
    
    public var isSourceReadOnly: Bool {
        return attributes.contains { $0.rawString == "readonly" }
    }
    
    public var isReadOnly: Bool = false
    public var name: String
    public var storage: ValueStorage
    public var mode: Mode = .asField
    public var attributes: [PropertyAttribute]
    
    public init(name: String, storage: ValueStorage, attributes: [PropertyAttribute],
                accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.name = name
        self.storage = storage
        self.attributes = attributes
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public enum Mode {
        case asField
        case computed(FunctionBodyIntention)
        case property(get: FunctionBodyIntention, set: Setter)
    }
    
    public struct Setter {
        /// Identifier for the setter's received value
        public var valueIdentifier: String
        /// The body for the setter
        public var body: FunctionBodyIntention
        
        public init(valueIdentifier: String, body: FunctionBodyIntention) {
            self.valueIdentifier = valueIdentifier
            self.body = body
        }
    }
}

extension PropertyGenerationIntention: KnownProperty {
    
}

/// Specifies an attribute for a property
public enum PropertyAttribute {
    case attribute(String)
    case setterName(String)
    case getterName(String)
    
    public var rawString: String {
        switch self {
        case .attribute(let str), .setterName(let str), .getterName(let str):
            return str
        }
    }
}

/// An intention to generate a body of Swift code from an equivalent Objective-C
/// source.
public class FunctionBodyIntention: FromSourceIntention, KnownMethodBody {
    /// Original source code body to generate
    public var body: CompoundStatement
    
    public init(body: CompoundStatement, source: ASTNode? = nil) {
        self.body = body
        
        super.init(accessLevel: .public, source: source)
    }
    
    /// Returns an iterator for all expressions within this method body.
    public func expressionsIterator(inspectBlocks: Bool) -> ExpressionSequence {
        return ExpressionSequence(statement: body, inspectBlocks: inspectBlocks)
    }
}

/// Access level visibility for a member or type
public enum AccessLevel: String {
    case `private`
    case `fileprivate`
    case `internal`
    case `public`
}
