import GrammarModelBase

/// A type definition node
public class ObjcTypedefNode: ObjcASTNode, ObjcInitializableNode, CommentedASTNodeType {
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    public var type: ObjcTypeNameNode? {
        firstChild()
    }

    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class ObjcTypeDeclaratorNode: ObjcASTNode {
    public var pointerNode: ObjcPointerNode? {
        firstChild()
    }

    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
}

public class ObjcPointerNode: ObjcASTNode {
    public var pointerNode: ObjcPointerNode? {
        firstChild()
    }

    public var asPointerList: [ObjcPointerNode] {
        if let child = pointerNode {
            return [self] + child.asPointerList
        }
        return [self]
    }

    public var asString: String {
        if let node = pointerNode {
            return "*\(node.asString)"
        }

        return "*"
    }
}
