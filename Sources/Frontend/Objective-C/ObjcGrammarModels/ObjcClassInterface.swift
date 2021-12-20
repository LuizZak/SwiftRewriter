import ObjcParserAntlr

/// A syntax node for an Objective-C class interface (`@interface`) declaration.
public class ObjcClassInterface: ObjcASTNode, ObjcInitializableNode {
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public extension ObjcClassInterface {
    var properties: [PropertyDefinition] {
        childrenMatching()
    }
    
    var superclass: SuperclassName? {
        firstChild()
    }
    
    var protocolList: ProtocolReferenceList? {
        firstChild()
    }
    
    var ivarsList: IVarsList? {
        firstChild()
    }
    
    var methods: [MethodDefinition] {
        childrenMatching()
    }
}

// MARK: - Subnodes

public class SuperclassName: ObjcIdentifierNode {
    
}

public class IVarsList: ObjcASTNode, ObjcInitializableNode {
    public var ivarDeclarations: [IVarDeclaration] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class IVarDeclaration: ObjcASTNode, ObjcInitializableNode {
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

public class ProtocolReferenceList: ObjcASTNode, ObjcInitializableNode {
    public var protocols: [ProtocolName] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class ProtocolName: ObjcIdentifierNode {
    
}
