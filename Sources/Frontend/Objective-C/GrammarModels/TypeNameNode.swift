import Utils

public class TypeNameNode: ASTNode {
    /// Full type name
    public var type: ObjcType
    
    public override var shortDescription: String {
        type.description
    }
    
    public init(type: ObjcType,
                isInNonnullContext: Bool,
                location: SourceLocation = .invalid,
                length: SourceLength = .zero) {
    
        self.type = type
        
        super.init(isInNonnullContext: isInNonnullContext,
                   location: location,
                   length: length)
    }
}
