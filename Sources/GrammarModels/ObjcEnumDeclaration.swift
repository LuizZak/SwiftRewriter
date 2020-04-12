/// A C / Objective-C enumeration
public class ObjcEnumDeclaration: ASTNode, InitializableNode {
    public var isOptionSet: Bool = false
    
    public var identifier: Identifier? {
        firstChild()
    }
    
    public var type: TypeNameNode? {
        firstChild()
    }
    
    public var cases: [ObjcEnumCase] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class ObjcEnumCase: ASTNode {
    public var identifier: Identifier? {
        firstChild()
    }
    public var expression: ExpressionNode? {
        firstChild()
    }
}
