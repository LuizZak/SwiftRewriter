public class TypeNameNode: ASTNode {
    /// Full type name
    public var type: ObjcType
    
    public init(type: ObjcType, location: SourceLocation = .invalid) {
        self.type = type
        
        super.init(location: location)
    }
}
