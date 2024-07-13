import GrammarModelBase

/// A syntax node for an Objective-C class implementation (`@implementation`)
/// declaration.
public class ObjcClassImplementationNode: ObjcASTNode, ObjcInitializableNode, CommentedASTNodeType {
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public extension ObjcClassImplementationNode {
    var superclass: ObjcSuperclassNameNode? {
        firstChild()
    }
    
    var ivarsList: ObjcIVarsListNode? {
        firstChild()
    }
    
    var methods: [ObjcMethodDefinitionNode] {
        childrenMatching()
    }
    
    var propertyImplementations: [ObjcPropertyImplementationNode] {
        childrenMatching()
    }
}
