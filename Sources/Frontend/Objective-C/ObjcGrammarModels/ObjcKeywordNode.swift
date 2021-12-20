import Utils
import GrammarModelBase

/// A node that represents a special keyword-type token
public class ObjcKeywordNode: ObjcASTNode {
    public var keyword: ObjcKeyword
    
    public override var shortDescription: String {
        keyword.rawValue
    }
    
    public init(keyword: ObjcKeyword,
                isInNonnullContext: Bool,
                location: SourceLocation = .invalid,
                length: SourceLength = .zero) {
        
        self.keyword = keyword
        
        super.init(isInNonnullContext: isInNonnullContext,
                   location: location,
                   length: length)
    }
}
