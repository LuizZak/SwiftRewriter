/// An Objective-C `struct` typedef declaration.
public final class ObjcStructDeclaration: ASTNode, InitializableNode {
    public var body: ObjcStructDeclarationBody? {
        firstChild()
    }
    
    public var identifier: Identifier? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// The body of a C struct declaration
public final class ObjcStructDeclarationBody: ASTNode, InitializableNode {
    public var fields: [ObjcStructField] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public final class ObjcStructField: IVarDeclaration {
    public var expression: ConstantExpressionNode? {
        firstChild()
    }

    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}
