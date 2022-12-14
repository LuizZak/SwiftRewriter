/// A class category that extends a class with additional properties/methods/ivars/protocols.
public class ObjcClassCategoryInterfaceNode: ObjcASTNode, ObjcInitializableNode {
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    public var categoryName: ObjcIdentifierNode? {
        child(ofType: ObjcIdentifierNode.self, atIndex: 1)
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public extension ObjcClassCategoryInterfaceNode {
    var properties: [ObjcPropertyDefinitionNode] {
        childrenMatching()
    }
    
    var protocolList: ObjcProtocolReferenceListNode? {
        firstChild()
    }
    
    var ivarsList: ObjcIVarsListNode? {
        firstChild()
    }
    
    var methods: [ObjcMethodDefinitionNode] {
        childrenMatching()
    }
}

/// A syntax node for an Objective-C class implementation (`@implementation`)
/// declaration for a category.
public class ObjcClassCategoryImplementationNode: ObjcASTNode, ObjcInitializableNode {
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    public var categoryName: ObjcIdentifierNode? {
        child(ofType: ObjcIdentifierNode.self, atIndex: 1)
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public extension ObjcClassCategoryImplementationNode {
    var ivarsList: ObjcIVarsListNode? {
        firstChild()
    }
    
    var methods: [ObjcMethodDefinitionNode] {
        childrenMatching()
    }
}
