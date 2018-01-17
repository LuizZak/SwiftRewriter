/// A node that represents the global namespace
public final class GlobalContextNode: ASTNode, InitializableNode {
    public required init() {
        
    }
}

/// A node with no proper type.
public class UnknownNode: ASTNode {
    
}

/// A node that holds an arbitrary token that has no proper semantic naming without
/// context.
public class TokenNode: ASTNode {
    public var token: String
    
    public init(token: String, location: SourceRange = .invalid) {
        self.token = token
        
        super.init(location: location)
    }
}

/// An identifier node
public class Identifier: ASTNode {
    /// String identifier
    public var name: String
    
    public init(name: String, location: SourceRange = .invalid) {
        self.name = name
        
        super.init(location: location)
    }
}

public extension ASTNodeRef where Node == Identifier {
    public var name: String? {
        switch self {
        case .valid(let node):
            return node.name
        case .invalid:
            return nil
        }
    }
}

/// A node that represents a special keyword-type token
public class Keyword: ASTNode {
    public var name: String
    
    public init(name: String, location: SourceRange = .invalid) {
        self.name = name
        
        super.init(location: location)
    }
}

public extension ASTNodeRef where Node == Keyword {
    public var name: String? {
        switch self {
        case .valid(let node):
            return node.name
        case .invalid:
            return nil
        }
    }
}
