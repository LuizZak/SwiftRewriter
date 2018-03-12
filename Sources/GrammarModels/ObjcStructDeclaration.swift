/// An Objective-C `struct` typedef declaration.
public class ObjcStructDeclaration: ASTNode, InitializableNode {
    public var fields: [ObjcStructField] {
        return childrenMatching()
    }
    
    public var name: Identifier? {
        return firstChild()
    }
    
    public required init() {
        super.init(location: .invalid, existsInSource: true)
    }
}

public class ObjcStructField: ASTNode, InitializableNode {
    public var name: Identifier? {
        return firstChild()
    }
    public var type: TypeNameNode? {
        return firstChild()
    }
    
    public required init() {
        super.init(location: .invalid, existsInSource: true)
    }
}
