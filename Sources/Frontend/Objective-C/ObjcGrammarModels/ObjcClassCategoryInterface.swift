/// A class category that extends a class with additional properties/methods/ivars/protocols.
public class ObjcClassCategoryInterface: ObjcASTNode, ObjcInitializableNode {
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

public extension ObjcClassCategoryInterface {
    var properties: [PropertyDefinition] {
        childrenMatching()
    }
    
    var protocolList: ProtocolReferenceList? {
        firstChild()
    }
    
    var ivarsList: IVarsList? {
        firstChild()
    }
    
    var methods: [MethodDefinition] {
        childrenMatching()
    }
}

/// A syntax node for an Objective-C class implementation (`@implementation`)
/// declaration for a category.
public class ObjcClassCategoryImplementation: ObjcASTNode, ObjcInitializableNode {
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

public extension ObjcClassCategoryImplementation {
    var ivarsList: IVarsList? {
        firstChild()
    }
    
    var methods: [MethodDefinition] {
        childrenMatching()
    }
}
