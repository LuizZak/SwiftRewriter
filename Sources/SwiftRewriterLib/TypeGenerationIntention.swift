import GrammarModels

/// An intention that comes from the reading of a source code file, instead of
/// being synthesized
public class FromSourceIntention: NonNullScopedIntention {
    public var source: ASTNode?
    public var accessLevel: AccessLevel
    
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
    
    public var protocols: [ProtocolInheritanceIntention] = []
    public var properties: [PropertyGenerationIntention] = []
    public var methods: [MethodGenerationIntention] = []
    
    public init(typeName: String, accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.typeName = typeName
        
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public func addProtocol(_ intention: ProtocolInheritanceIntention) {
        self.protocols.append(intention)
    }
    
    public func addProperty(_ intention: PropertyGenerationIntention) {
        self.properties.append(intention)
    }
    
    public func addMethod(_ intention: MethodGenerationIntention) {
        self.methods.append(intention)
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
            return
                MethodGenerationIntention
                    .Signature
                    .match(lhs: signature, rhs: $0.signature, ignoreNullability: true)
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
    
    public var name: String
    public var type: ObjcType
    public var mode: Mode = .asField
    
    public init(name: String, type: ObjcType, accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.name = name
        self.type = type
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public enum Mode {
        case asField
        case computed(MethodBodyIntention)
        case property(get: MethodBodyIntention, set: MethodBodyIntention)
    }
}

/// An intention to generate a body of Swift code from an equivalent Objective-C
/// source.
public class MethodBodyIntention: FromSourceIntention {
    public var typedSource: MethodBody? {
        return source as? MethodBody
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
    public var returnType: ObjcType {
        return signature.returnType
    }
    public var parameters: [Parameter] {
        return signature.parameters
    }
    
    public init(name: String, returnType: ObjcType,
                returnTypeNullabilitySpecifier: TypeNullability,
                parameters: [Parameter], accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        self.signature =
            Signature(name: name, returnType: returnType,
                      returnTypeNullability: returnTypeNullabilitySpecifier,
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
        public var returnType: ObjcType
        public var returnTypeNullability: TypeNullability?
        public var parameters: [Parameter]
        
        public static func match(lhs: Signature, rhs: Signature, ignoreNullability: Bool = false) -> Bool {
            if lhs.parameters.count != rhs.parameters.count {
                return false
            }
            
            if lhs.name != rhs.name || lhs.returnType.normalized != lhs.returnType.normalized {
                return false
            }
            if !ignoreNullability && lhs.returnTypeNullability != rhs.returnTypeNullability {
                return false
            }
            
            for (p1, p2) in zip(lhs.parameters, rhs.parameters) {
                if !Parameter.match(lhs: p1, rhs: p2, ignoreNullability: ignoreNullability) {
                    return false
                }
            }
            
            return true
        }
    }
    
    public struct Parameter: Equatable {
        public var label: String
        public var name: String
        public var nullability: TypeNullability?
        public var type: ObjcType
        
        public static func match(lhs: Parameter, rhs: Parameter, ignoreNullability: Bool = false) -> Bool {
            if lhs.label != rhs.label || lhs.type.normalized != lhs.type.normalized {
                return false
            }
            if !ignoreNullability && lhs.nullability != rhs.nullability {
                return false
            }
            
            return true
        }
    }
}

/// Access level visibility for a member or type
public enum AccessLevel: String {
    case `private`
    case `fileprivate`
    case `internal`
    case `public`
}
