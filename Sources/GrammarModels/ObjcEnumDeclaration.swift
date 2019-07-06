/// A C / Objective-C enumeration
public class ObjcEnumDeclaration: ASTNode, InitializableNode {
    public var isOptionSet: Bool = false
    
    public var identifier: Identifier? {
        return firstChild()
    }
    
    public var type: TypeNameNode? {
        return firstChild()
    }
    
    public var cases: [ObjcEnumCase] {
        return childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

public class ObjcEnumCase: ASTNode {
    public var identifier: Identifier? {
        return firstChild()
    }
    public var expression: ExpressionNode? {
        return firstChild()
    }
}
