/// A C / Objective-C enumeration
public class ObjcEnumDeclaration: ObjcASTNode, ObjcInitializableNode {
    public var isOptionSet: Bool = false
    
    public var identifier: Identifier? {
        firstChild()
    }
    
    public var type: ObjcTypeNameNode? {
        firstChild()
    }
    
    public var cases: [ObjcEnumCase] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class ObjcEnumCase: ObjcASTNode {
    public var identifier: Identifier? {
        firstChild()
    }
    public var expression: ExpressionNode? {
        firstChild()
    }
}
