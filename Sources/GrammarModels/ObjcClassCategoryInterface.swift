/// A class category that extends a class with additional properties/methods/ivars/protocols.
public class ObjcClassCategoryInterface: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        firstChild()
    }
    public var categoryName: Identifier? {
        child(ofType: Identifier.self, atIndex: 1)
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
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
public class ObjcClassCategoryImplementation: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        firstChild()
    }
    public var categoryName: Identifier? {
        child(ofType: Identifier.self, atIndex: 1)
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
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
