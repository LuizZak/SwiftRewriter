import ObjcParserAntlr

/// A syntax node for an Objective-C class interface (`@interface`) declaration.
public class ObjcClassInterfaceNode: ObjcASTNode, ObjcInitializableNode {
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public extension ObjcClassInterfaceNode {
    var properties: [ObjcPropertyDefinitionNode] {
        childrenMatching()
    }
    
    var superclass: ObjcSuperclassNameNode? {
        firstChild()
    }
    
    var protocolList: ObjcProtocolReferenceListNode? {
        firstChild()
    }
    
    var ivarsList: ObjcIVarsListNode? {
        firstChild()
    }
    
    var methods: [ObjcMethodDefinitionNode] {
        childrenMatching()
    }
}

// MARK: - Subnodes

public class ObjcSuperclassNameNode: ObjcIdentifierNode {
    
}

public class ObjcIVarsListNode: ObjcASTNode, ObjcInitializableNode {
    public var ivarDeclarations: [ObjcIVarDeclarationNode] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class ObjcIVarDeclarationNode: ObjcASTNode, ObjcInitializableNode {
    public var type: ObjcTypeNameNode? {
        firstChild()
    }
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class ObjcProtocolReferenceListNode: ObjcASTNode, ObjcInitializableNode {
    public var protocols: [ObjcProtocolNameNode] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class ObjcProtocolNameNode: ObjcIdentifierNode {
    
}
