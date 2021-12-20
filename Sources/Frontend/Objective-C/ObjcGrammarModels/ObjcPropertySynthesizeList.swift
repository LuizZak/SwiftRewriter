/// List of synthesizes in a @synthesize property implementation.
public class ObjcPropertySynthesizeList: ObjcASTNode, ObjcInitializableNode {
    public var synthesizations: [ObjcPropertySynthesizeItem] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Single item of a @synthesize property implementation list.
public class ObjcPropertySynthesizeItem: ObjcASTNode, ObjcInitializableNode {
    public var propertyName: Identifier? {
        firstChild()
    }
    public var instanceVarName: Identifier? {
        child(atIndex: 1)
    }
    public var isDynamic: Bool = false
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
