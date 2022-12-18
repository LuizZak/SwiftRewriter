import GrammarModelBase

/// An Objective-C `struct` typedef declaration.
public final class ObjcStructDeclarationNode: ObjcASTNode, ObjcInitializableNode, CommentedASTNodeType {
    public var body: ObjcStructDeclarationBodyNode? {
        firstChild()
    }
    
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// The body of a C struct declaration
public final class ObjcStructDeclarationBodyNode: ObjcASTNode, ObjcInitializableNode {
    public var fields: [ObjcStructFieldNode] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public final class ObjcStructFieldNode: ObjcIVarDeclarationNode {
    public var expression: ObjcConstantExpressionNode? {
        firstChild()
    }

    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
