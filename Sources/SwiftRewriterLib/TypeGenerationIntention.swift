import GrammarModels

/// An intention that comes from the reading of a source code file, instead of
/// being synthesized
public class FromSourceIntention: NonNullScopedIntention {
    public var source: ASTNode?
    public var accessLevel: AccessLevel
    
    weak public var parent: Intention?
    
    // NOTE: This is a hack- shouldn't be recorded on the intention but passed to
    // it in a more abstract way.
    // For now we leave as it makes things work!
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
    
    private(set) public var protocols: [ProtocolInheritanceIntention] = []
    private(set) public var properties: [PropertyGenerationIntention] = []
    private(set) public var methods: [MethodGenerationIntention] = []
    
    public init(typeName: String, accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.typeName = typeName
        
        super.init(accessLevel: accessLevel, source: source)
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
    
    public func addProperty(_ intention: PropertyGenerationIntention, at index: Int? = nil) {
        if let index = index {
            self.properties.insert(intention, at: index)
        } else {
            self.properties.append(intention)
        }
        
        intention.parent = self
    }
    public func removeProperty(_ intention: PropertyGenerationIntention) {
        if let index = properties.index(where: { $0 === intention }) {
            intention.parent = nil
            properties.remove(at: index)
        }
    }
    
    public func addMethod(_ intention: MethodGenerationIntention, at index: Int? = nil) {
        if let index = index {
            self.methods.insert(intention, at: index)
        } else {
            self.methods.append(intention)
        }
        
        intention.parent = self
    }
    public func removeMethod(_ intention: MethodGenerationIntention) {
        if let index = methods.index(where: { $0 === intention }) {
            intention.parent = nil
            methods.remove(at: index)
        }
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
    
    public func hasMethod(withSignature signature: MethodGenerationIntention.Signature) -> Bool {
        return method(withSignature: signature) != nil
    }
    
    public func method(withSignature signature: MethodGenerationIntention.Signature) -> MethodGenerationIntention? {
        return methods.first(where: {
            return signature.droppingNullability == $0.signature.droppingNullability
        })
    }
}

/// An intention to generate a property or method on a type
public class MemberGenerationIntention: FromSourceIntention {
    
}

/// An intention to generate a property, either static/instance, computed/stored
/// for a type definition.
public class PropertyGenerationIntention: MemberGenerationIntention {
    public var propertySource: PropertyDefinition? {
        return source as? PropertyDefinition
    }
    public var synthesizeSource: PropertySynthesizeItem? {
        return source as? PropertySynthesizeItem
    }
    
    public var isSourceReadOnly: Bool {
        return propertySource?.modifierList?.keywordModifiers.contains("readonly") ?? false
    }
    
    public var name: String
    public var type: SwiftType
    public var ownership: Ownership
    public var mode: Mode = .asField
    
    public init(name: String, type: SwiftType, ownership: Ownership, accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.name = name
        self.type = type
        self.ownership = ownership
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public enum Mode {
        case asField
        case computed(MethodBodyIntention)
        case property(get: MethodBodyIntention, set: Setter)
    }
    
    public struct Setter {
        /// Identifier for the setter's received value
        var valueIdentifier: String
        /// The body for the setter
        var body: MethodBodyIntention
    }
}

/// An intention to generate a body of Swift code from an equivalent Objective-C
/// source.
public class MethodBodyIntention: FromSourceIntention {
    /// Original source code body to generate
    public var body: CompoundStatement
    
    public init(body: CompoundStatement, source: ASTNode? = nil) {
        self.body = body
        
        super.init(accessLevel: .public, source: source)
    }
}

/// An intention to generate a static/instance function for a type.
public class MethodGenerationIntention: MemberGenerationIntention {
    public var typedSource: MethodDefinition? {
        return source as? MethodDefinition
    }
    
    public var isClassMethod: Bool {
        return typedSource?.isClassMethod ?? false
    }
    
    public var signature: Signature
    
    public var body: MethodBodyIntention?
    
    public var name: String {
        return signature.name
    }
    public var returnType: SwiftType {
        return signature.returnType
    }
    public var parameters: [Parameter] {
        return signature.parameters
    }
    
    public init(name: String, returnType: SwiftType, parameters: [Parameter],
                accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.signature =
            Signature(name: name, returnType: returnType,
                      parameters: parameters)
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public init(signature: Signature, accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        self.signature = signature
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public struct Signature: Equatable {
        public var name: String
        public var returnType: SwiftType
        public var parameters: [Parameter]
        
        public var droppingNullability: Signature {
            return Signature(name: name, returnType: returnType.deepUnwrapped,
                             parameters: parameters.map {
                                Parameter(label: $0.label, name: $0.name, type: $0.type.deepUnwrapped)
                            })
        }
    }
    
    public struct Parameter: Equatable {
        public var label: String
        public var name: String
        public var type: SwiftType
    }
}

/// Access level visibility for a member or type
public enum AccessLevel: String {
    case `private`
    case `fileprivate`
    case `internal`
    case `public`
}
