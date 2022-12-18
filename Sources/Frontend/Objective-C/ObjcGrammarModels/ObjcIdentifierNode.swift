import Utils
import GrammarModelBase

/// An identifier node
public class ObjcIdentifierNode: ObjcASTNode {
    /// String identifier
    public var name: String
    
    public override var shortDescription: String {
        name
    }
    
    public init(
        name: String,
        isInNonnullContext: Bool,
        location: SourceLocation = .invalid,
        length: SourceLength = .zero
    ) {
        
        self.name = name
        
        super.init(
            isInNonnullContext: isInNonnullContext,
            location: location,
            length: length
        )
    }
}
