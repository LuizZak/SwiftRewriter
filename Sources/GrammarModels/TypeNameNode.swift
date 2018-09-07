public class TypeNameNode: ASTNode {
    /// Full type name
    public var type: ObjcType
    
    public init(type: ObjcType, isInNonnullContext: Bool, location: SourceLocation = .invalid) {
        self.type = type
        
        super.init(isInNonnullContext: isInNonnullContext, location: location)
    }
    
    override public func shortDescription() -> String {
        return type.description
    }
}
