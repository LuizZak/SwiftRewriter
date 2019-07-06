/// An Objective-C `struct` typedef declaration.
public final class ObjcStructDeclaration: ASTNode, InitializableNode {
    public var fields: [ObjcStructField] {
        childrenMatching()
    }
    
    public var identifier: Identifier? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

public final class ObjcStructField: IVarDeclaration {
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
