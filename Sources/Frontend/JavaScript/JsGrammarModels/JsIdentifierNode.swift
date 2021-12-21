import Utils
import GrammarModelBase

/// An identifier node
public class JsIdentifierNode: JsASTNode {
    /// String identifier
    public var name: String
    
    public override var shortDescription: String {
        name
    }
    
    public init(name: String,
                location: SourceLocation = .invalid,
                length: SourceLength = .zero) {
        
        self.name = name
        
        super.init(location: location, length: length)
    }
}
