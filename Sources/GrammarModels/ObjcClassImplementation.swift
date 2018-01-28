/// A syntax node for an Objective-C class implementation (`@implementation`)
/// declaration.
public class ObjcClassImplementation: ASTNode, InitializableNode {
    public var identifier: ASTNodeRef<Identifier> = .invalid(InvalidNode())
    
    public required init() {
        
    }
}

public extension ObjcClassImplementation {
    public var superclass: SuperclassName? {
        return firstChild()
    }
    
    public var ivarsList: IVarsList? {
        return firstChild()
    }
    
    public var methods: [MethodDefinition] {
        return childrenMatching()
    }
}

/// Node for a @synthesize/@dynamic declaration in a class implementation.
public class PropertyImplementation: ASTNode {
    
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
    
    public var list: ASTNodeRef<PropertySynthesizeList> = .placeholder
}

/// List of synthesizes in a @synthesize/@dynamic property implementation.
public class PropertySynthesizeList: ASTNode {
    public var items: [PropertySynthesizeItem] {
        return childrenMatching(type: PropertySynthesizeItem.self)
    }
}

/// Single item of a @synthesize/@dynamic property implementation list.
public class PropertySynthesizeItem: ASTNode {
    
}

public enum PropertyImplementationKind {
    case synthesize
    case dynamic
}
