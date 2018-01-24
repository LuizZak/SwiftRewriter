import GrammarModels

/// An intention to generate a class, struct or enumeration in swift.
public class TypeGenerationIntention: Intention {
    public var typeName: String
    public var scope: Scope
    
    public var properties: [PropertyGenerationIntention] = []
    public var methods: [MethodGenerationIntention] = []
    
    public var source: ASTNode?
    
    public init(typeName: String, scope: Scope = .internal, source: ASTNode? = nil) {
        self.typeName = typeName
        self.scope = scope
        self.source = source
    }
}

/// An intention to generate a property or method on a type
public class MemberGenerationIntention: Intention {
    public var source: ASTNode?
    public var scope: Scope
    
    public init(scope: Scope, source: ASTNode?) {
        self.scope = scope
        self.source = source
    }
}

/// An intention to generate a property, either static/instance, computed/stored
/// for a type definition.
public class PropertyGenerationIntention: MemberGenerationIntention {
    public var typedSource: ObjcClassInterface.Property? {
        return source as? ObjcClassInterface.Property
    }
    
    public var name: String
    public var type: ObjcType
    
    public init(name: String, type: ObjcType, scope: Scope = .internal, source: ASTNode? = nil) {
        self.name = name
        self.type = type
        super.init(scope: scope, source: source)
    }
}

/// An intention to generate a static/instance function for a type.
public class MethodGenerationIntention: MemberGenerationIntention {
    
}

/// Scope for a member
public enum Scope {
    case `private`
    case `fileprivate`
    case `internal`
    case `public`
}
