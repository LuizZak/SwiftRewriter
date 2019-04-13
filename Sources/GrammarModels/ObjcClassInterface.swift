import ObjcParserAntlr

/// A syntax node for an Objective-C class interface (`@interface`) declaration.
public class ObjcClassInterface: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        return firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

public extension ObjcClassInterface {
    var properties: [PropertyDefinition] {
        return childrenMatching()
    }
    
    var superclass: SuperclassName? {
        return firstChild()
    }
    
    var protocolList: ProtocolReferenceList? {
        return firstChild()
    }
    
    var ivarsList: IVarsList? {
        return firstChild()
    }
    
    var methods: [MethodDefinition] {
        return childrenMatching()
    }
}

// MARK: - Subnodes

public class SuperclassName: Identifier {
    
}

public class IVarsList: ASTNode, InitializableNode {
    public var ivarDeclarations: [IVarDeclaration] {
        return childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

public class IVarDeclaration: ASTNode, InitializableNode {
    public var type: TypeNameNode? {
        return firstChild()
    }
    public var identifier: Identifier? {
        return firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

public class ProtocolReferenceList: ASTNode, InitializableNode {
    public var protocols: [ProtocolName] {
        return childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

public class ProtocolName: Identifier {
    
}
