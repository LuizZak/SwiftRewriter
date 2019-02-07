/// A node that represents the global namespace
public final class GlobalContextNode: ASTNode, InitializableNode {
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

/// A node with no proper type.
public class UnknownNode: ASTNode {
    
}

/// An identifier node
public class Identifier: ASTNode {
    /// String identifier
    public var name: String
    
    public init(name: String,
                isInNonnullContext: Bool,
                location: SourceLocation = .invalid,
                length: SourceLength = .zero) {
        
        self.name = name
        
        super.init(_isInNonnullContext: isInNonnullContext,
                   location: location,
                   length: length)
    }
    
    override public func shortDescription() -> String {
        return name
    }
}

/// A node that represents a special keyword-type token
public class KeywordNode: ASTNode {
    public var keyword: Keyword
    
    public init(keyword: Keyword,
                isInNonnullContext: Bool,
                location: SourceLocation = .invalid,
                length: SourceLength = .zero) {
        
        self.keyword = keyword
        
        super.init(_isInNonnullContext: isInNonnullContext,
                   location: location,
                   length: length)
    }
    
    override public func shortDescription() -> String {
        return keyword.rawValue
    }
}
