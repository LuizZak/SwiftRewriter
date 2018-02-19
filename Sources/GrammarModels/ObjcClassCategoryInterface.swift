/// A class category that extends a class with additional properties/methods/ivars/protocols.
public class ObjcClassCategoryInterface: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        return firstChild()
    }
    public var categoryName: Identifier? {
        return child(ofType: Identifier.self, atIndex: 1)
    }
    
    public required init() {
        
    }
}

public extension ObjcClassCategoryInterface {
    public var properties: [PropertyDefinition] {
        return childrenMatching()
    }
    
    public var protocolList: ProtocolReferenceList? {
        return firstChild()
    }
    
    public var ivarsList: IVarsList? {
        return firstChild()
    }
    
    public var methods: [MethodDefinition] {
        return childrenMatching()
    }
}

/// A syntax node for an Objective-C class implementation (`@implementation`)
/// declaration for a category.
public class ObjcClassCategoryImplementation: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        return firstChild()
    }
    public var categoryName: Identifier? {
        return child(ofType: Identifier.self, atIndex: 1)
    }
    
    public required init() {
        
    }
}

public extension ObjcClassCategoryImplementation {
    public var ivarsList: IVarsList? {
        return firstChild()
    }
    
    public var methods: [MethodDefinition] {
        return childrenMatching()
    }
}
