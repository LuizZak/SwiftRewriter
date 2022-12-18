import GrammarModelBase

/// A C / Objective-C enumeration
public class ObjcEnumDeclarationNode: ObjcASTNode, ObjcInitializableNode, CommentedASTNodeType {
    public var isOptionSet: Bool = false
    
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    
    public var type: ObjcTypeNameNode? {
        firstChild()
    }
    
    public var cases: [ObjcEnumCaseNode] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class ObjcEnumCaseNode: ObjcASTNode, CommentedASTNodeType {
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    public var expression: ObjcExpressionNode? {
        firstChild()
    }
}
