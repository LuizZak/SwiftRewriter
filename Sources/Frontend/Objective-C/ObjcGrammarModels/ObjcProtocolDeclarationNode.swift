/// A syntax node for an Objective-C protocol (`@protocol`) declaration.
public class ObjcProtocolDeclarationNode: ObjcASTNode, ObjcInitializableNode {
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public extension ObjcProtocolDeclarationNode {
    var properties: [ObjcPropertyDefinitionNode] {
        childrenMatching()
    }
    
    var protocolList: ObjcProtocolReferenceListNode? {
        firstChild()
    }
    
    var methods: [ObjcMethodDefinitionNode] {
        childrenMatching()
    }
}
