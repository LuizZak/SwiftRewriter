/// An Objective-C `struct` typedef declaration.
public final class ObjcStructDeclaration: ASTNode, InitializableNode {
    public var fields: [ObjcStructField] {
        return childrenMatching()
    }
    
    public var identifier: Identifier? {
        return firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public final class ObjcStructField: IVarDeclaration {
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
