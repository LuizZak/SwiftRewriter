/// A type definition node
public class TypedefNode: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        return firstChild()
    }
    public var type: TypeNameNode? {
        return firstChild()
    }
    public var blockParameters: BlockParametersNode? {
        return firstChild()
    }
    
    public required init() {
        super.init()
    }
}

/// Block parameters for a block typedef
public class BlockParametersNode: ASTNode, InitializableNode {
    public var parameters: [TypeNameNode] {
        return childrenMatching()
    }
    
    public required init() {
        super.init()
    }
}
