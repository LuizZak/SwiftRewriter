import GrammarModels

/// An intention to generate a Swift class type
public class ClassGenerationIntention: TypeGenerationIntention {
    public func setSuperclassIntention(_ superclassName: String) {
        self.superclassName = superclassName
    }
}

/// An intention to conform a class to a protocol
public class ProtocolInheritanceIntention: FromSourceIntention {
    public var protocolName: String
    
    public init(protocolName: String, scope: AccessLevel = .internal, source: ASTNode? = nil) {
        self.protocolName = protocolName
        
        super.init(scope: scope, source: source)
    }
}

/// An intention to create an instance variable (Objective-C's 'ivar').
public class InstanceVariableGenerationIntention: MemberGenerationIntention {
    public var typedSource: IVarDeclaration? {
        return source as? IVarDeclaration
    }
    
    public var name: String
    public var type: ObjcType
    
    public init(name: String, type: ObjcType, scope: AccessLevel = .private, source: ASTNode? = nil) {
        self.name = name
        self.type = type
        super.init(scope: scope, source: source)
    }
}
