import GrammarModelBase

/// A node that represents the global namespace
public final class ObjcGlobalContextNode: ObjcASTNode, ObjcInitializableNode {
    public var functionDefinitions: [ObjcFunctionDefinitionNode] {
        childrenMatching()
    }
    public var variableDeclarations: [ObjcVariableDeclarationNode] {
        childrenMatching()
    }
    public var classInterfaces: [ObjcClassInterfaceNode] {
        childrenMatching()
    }
    public var classImplementations: [ObjcClassImplementationNode] {
        childrenMatching()
    }
    public var categoryInterfaces: [ObjcClassCategoryInterfaceNode] {
        childrenMatching()
    }
    public var categoryImplementations: [ObjcClassCategoryImplementationNode] {
        childrenMatching()
    }
    public var protocolDeclarations: [ObjcProtocolDeclarationNode] {
        childrenMatching()
    }
    public var typedefNodes: [ObjcTypedefNode] {
        childrenMatching()
    }
    public var enumDeclarations: [ObjcEnumDeclarationNode] {
        childrenMatching()
    }
    public var structDeclarations: [ObjcStructDeclarationNode] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }

    public override func addChild(_ node: ASTNode) {
        super.addChild(node)
    }
}
