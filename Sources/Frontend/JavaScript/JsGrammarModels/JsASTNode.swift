import GrammarModelBase
import Utils

/// Base JavaScript node type
open class JsASTNode: ASTNode {
    
    /// Instantiates a bare JsASTNode with a given range.
    /// Defaults to an invalid range
    public init(location: SourceLocation = .invalid,
                length: SourceLength = .zero,
                existsInSource: Bool = true) {
        
        super.init(location: location, length: length, existsInSource: existsInSource)
    }
}
