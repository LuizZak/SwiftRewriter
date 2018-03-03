/// An Objective-C `struct` typedef declaration.
public class ObjcStructDeclaration: ASTNode, InitializableNode {
    public var fields: [ObjcStructField] {
        return childrenMatching()
    }
    
    public required init() {
        super.init(location: .invalid, existsInSource: true)
    }
}

public class ObjcStructField: ASTNode {
    public var name: Identifier
    public var type: TypeNameNode
    
    public init(name: Identifier, type: TypeNameNode) {
        self.name = name
        self.type = type
        super.init(location: .invalid, existsInSource: true)
    }
}
