/// List of synthesizes in a @synthesize property implementation.
public class ObjcPropertySynthesizeListNode: ObjcASTNode, ObjcInitializableNode {
    public var synthesizations: [ObjcPropertySynthesizeItemNode] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// Single item of a @synthesize property implementation list.
public class ObjcPropertySynthesizeItemNode: ObjcASTNode, ObjcInitializableNode {
    public var propertyName: ObjcIdentifierNode? {
        firstChild()
    }
    public var instanceVarName: ObjcIdentifierNode? {
        child(atIndex: 1)
    }
    public var isDynamic: Bool = false
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
