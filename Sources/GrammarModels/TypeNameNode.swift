public class TypeNameNode: ASTNode {
    /// Full type name
    public var type: ObjcType
    
    public init(type: ObjcType, location: SourceLocation = .invalid) {
        self.type = type
        
        super.init(location: location)
    }
}

public extension ASTNodeRef where Node == TypeNameNode {
    public var type: ObjcType? {
        switch self {
        case .valid(let node):
            return node.type
        case .invalid:
            return nil
        }
    }
}
