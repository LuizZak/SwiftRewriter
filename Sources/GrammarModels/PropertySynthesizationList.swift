/// Node for a @synthesize/@dynamic declaration in a class implementation.
public class PropertyImplementation: ASTNode, InitializableNode {
    
    /// Returns the kind of this property implementation node.
    /// Defaults to `@synthesize`, if it's missing the required keyword nodes.
    public var kind: PropertyImplementationKind {
        let kws = childrenMatching(type: KeywordNode.self)
        
        if kws.contains(where: { $0.keyword == Keyword.atDynamic }) {
            return .dynamic
        } else {
            return .synthesize
        }
    }
    
    public var list: PropertySynthesizeList? {
        return firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
    
    public override func addChild(_ node: ASTNode) {
        super.addChild(node)
    }
}

public enum PropertyImplementationKind {
    case synthesize
    case dynamic
}

/// List of synthesizes in a @synthesize property implementation.
public class PropertySynthesizeList: ASTNode, InitializableNode {
    public var synthesizations: [PropertySynthesizeItem] {
        return childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

/// Single item of a @synthesize property implementation list.
public class PropertySynthesizeItem: ASTNode, InitializableNode {
    public var propertyName: Identifier? {
        return firstChild()
    }
    public var instanceVarName: Identifier? {
        return child(atIndex: 1)
    }
    public var isDynamic: Bool = false
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}
