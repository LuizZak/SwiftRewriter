import GrammarModelBase
import Utils

/// Base Objective-C node type
open class ObjcASTNode: ASTNode {
    
    /// Indicates whether this node was completely contained within the range of
    /// a `NS_ASSUME_NONNULL_BEGIN`/`NS_ASSUME_NONNULL_END` region.
    public var isInNonnullContext: Bool
    
    /// Array of comments that precede this declaration
    public var precedingComments: [ObjcComment] = []
    
    /// Instantiates a bare ObjcASTNode with a given range.
    /// Defaults to an invalid range
    public init(isInNonnullContext: Bool,
                location: SourceLocation = .invalid,
                length: SourceLength = .zero,
                existsInSource: Bool = true) {
        
        self.isInNonnullContext = isInNonnullContext

        super.init(location: location, length: length, existsInSource: existsInSource)
    }
}
