public class TypeNameNode: ASTNode {
    /// Full type name
    public var type: ObjcType
    
    public init(type: ObjcType,
                isInNonnullContext: Bool,
                location: SourceLocation = .invalid,
                length: SourceLength = .zero) {
        
        self.type = type
        
        super.init(_isInNonnullContext: isInNonnullContext,
                   location: location,
                   length: length)
    }
    
    override public func shortDescription() -> String {
        return type.description
    }
}
