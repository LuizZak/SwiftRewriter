/// A node that represents the global namespace
public final class GlobalContextNode: ASTNode, InitializableNode {
    public var functionDefinitions: [FunctionDefinition] {
        childrenMatching()
    }
    public var variableDeclarations: [VariableDeclaration] {
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
    public var typedefNodes: [TypedefNode] {
        childrenMatching()
    }
    public var enumDeclarations: [ObjcEnumDeclaration] {
        childrenMatching()
    }
    public var structDeclarations: [ObjcStructDeclaration] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
