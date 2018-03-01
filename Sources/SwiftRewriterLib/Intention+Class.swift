import GrammarModels

/// Base intention for Class and Class Category intentions
public class BaseClassIntention: TypeGenerationIntention {
    /// Returns `true` if this class intention originated from an `@interface`
    /// declaration.
    public var isInterfaceSource: Bool {
        return source is ObjcClassInterface || source is ObjcClassCategoryInterface
    }
    
    private(set) public var instanceVariables: [InstanceVariableGenerationIntention] = []
    
    public override var knownFields: [KnownProperty] {
        return instanceVariables
    }
    
    public func addInstanceVariable(_ intention: InstanceVariableGenerationIntention) {
        if let parent = intention.parent as? BaseClassIntention {
            parent.removeInstanceVariable(named: intention.name)
        }
        
        self.instanceVariables.append(intention)
        intention.parent = self
    }
    
    public func hasInstanceVariable(named name: String) -> Bool {
        return instanceVariables.contains(where: { $0.name == name })
    }
    
    public func removeInstanceVariable(named name: String) {
        if let index = instanceVariables.index(where: { $0.name == name }) {
            instanceVariables[index].parent = nil
            instanceVariables.remove(at: index)
        }
    }
}

/// An intention to generate a Swift class type
public class ClassGenerationIntention: BaseClassIntention {
    public var superclassName: String?
    
    public override var supertype: KnownSupertype? {
        if let superclassName = superclassName {
            return KnownSupertype.typeName(superclassName)
        }
        
        return nil
    }
    
    public func setSuperclassIntention(_ superclassName: String) {
        self.superclassName = superclassName
    }
}

/// An intention to generate a class extension from an existing class
public class ClassExtensionGenerationIntention: BaseClassIntention {
    /// Original Objective-C category name that originated this category.
    public var categoryName: String?
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

extension InstanceVariableGenerationIntention: KnownProperty {
    public var attributes: [PropertyAttribute] {
        return []
    }
}
