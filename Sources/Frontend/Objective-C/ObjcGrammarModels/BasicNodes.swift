/// A node that represents the global namespace
public final class GlobalContextNode: ObjcASTNode, ObjcInitializableNode {
    public var functionDefinitions: [ObjcFunctionDefinition] {
        childrenMatching()
    }
    public var variableDeclarations: [ObjcVariableDeclaration] {
        childrenMatching()
    }
    public var classInterfaces: [ObjcClassInterface] {
        childrenMatching()
    }
    public var classImplementations: [ObjcClassImplementation] {
        childrenMatching()
    }
    public var categoryInterfaces: [ObjcClassCategoryInterface] {
        childrenMatching()
    }
    public var categoryImplementations: [ObjcClassCategoryImplementation] {
        childrenMatching()
    }
    public var protocolDeclarations: [ObjcProtocolDeclaration] {
        childrenMatching()
    }
    public var typedefNodes: [ObjcTypedefNode] {
        childrenMatching()
    }
    public var enumDeclarations: [ObjcEnumDeclaration] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
