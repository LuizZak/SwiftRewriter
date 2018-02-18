import GrammarModels

/// Base intention for Class and Class Category intentions
public class BaseClassIntention: TypeGenerationIntention {
    public var instanceVariables: [InstanceVariableGenerationIntention] = []
    
    public func addInstanceVariable(_ intention: InstanceVariableGenerationIntention) {
        self.instanceVariables.append(intention)
    }
    
    public func hasInstanceVariable(named name: String) -> Bool {
        return instanceVariables.contains(where: { $0.name == name })
    }
}

/// An intention to generate a Swift class type
public class ClassGenerationIntention: BaseClassIntention {
    public var superclassName: String?
    
    public func setSuperclassIntention(_ superclassName: String) {
        self.superclassName = superclassName
    }
}

/// An intention to generate a class extension from an existing class
public class ClassExtensionGenerationIntention: BaseClassIntention {
    public var extensionName: String?
}

/// An intention to conform a class to a protocol
public class ProtocolInheritanceIntention: FromSourceIntention, KnownProtocolConformance {
    public var protocolName: String
    
    public init(protocolName: String, accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.protocolName = protocolName
        
        super.init(accessLevel: accessLevel, source: source)
    }
}

/// An intention to create an instance variable (Objective-C's 'ivar').
public class InstanceVariableGenerationIntention: MemberGenerationIntention, ValueStorageIntention {
    public var typedSource: IVarDeclaration? {
        return source as? IVarDeclaration
    }
    
    public var name: String
    public var storage: ValueStorage
    
    public init(name: String, storage: ValueStorage, accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        self.name = name
        self.storage = storage
        super.init(accessLevel: accessLevel, source: source)
    }
}
