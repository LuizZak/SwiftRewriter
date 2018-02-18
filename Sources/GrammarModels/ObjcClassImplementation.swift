/// A syntax node for an Objective-C class implementation (`@implementation`)
/// declaration.
public class ObjcClassImplementation: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        return firstChild()
    }
    
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
    
    public var list: ASTNodeRef<PropertySynthesizeList> = .placeholder
    
    public required init() {
        super.init()
    }
    
    public override func addChild(_ node: ASTNode) {
        super.addChild(node)
        
        if let list = node as? PropertySynthesizeList {
            self.list = .valid(list)
        }
    }
}

/// List of synthesizes in a @synthesize/@dynamic property implementation.
public class PropertySynthesizeList: ASTNode, InitializableNode {
    public var items: [PropertySynthesizeItem] {
        return childrenMatching(type: PropertySynthesizeItem.self)
    }
    
    public required init() {
        super.init()
    }
}

/// Single item of a @synthesize/@dynamic property implementation list.
public class PropertySynthesizeItem: ASTNode {
    public var propertyName: Identifier
    public var ivarName: Identifier?
    
    public init(propertyName: Identifier, location: SourceLocation = .invalid, existsInSource: Bool = true) {
        self.propertyName = propertyName
        
        super.init(location: location, existsInSource: existsInSource)
    }
}

public enum PropertyImplementationKind {
    case synthesize
    case dynamic
}

public extension ASTNodeRef where Node == PropertySynthesizeList {
    public var items: [PropertySynthesizeItem]? {
        switch self {
        case .valid(let n):
            return n.items
        case .invalid:
            return nil
        }
    }
}
