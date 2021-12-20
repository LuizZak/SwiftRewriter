/// An Objective-C `struct` typedef declaration.
public final class ObjcStructDeclaration: ObjcASTNode, ObjcInitializableNode {
    public var body: ObjcStructDeclarationBody? {
        firstChild()
    }
    
    public var identifier: ObjcIdentifierNode? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// The body of a C struct declaration
public final class ObjcStructDeclarationBody: ObjcASTNode, ObjcInitializableNode {
    public var fields: [ObjcStructField] {
        childrenMatching()
    }
    
    public var identifier: ObjcIdentifierNode? {
        firstChild()
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
