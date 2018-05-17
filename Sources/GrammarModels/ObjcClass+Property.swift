public class PropertyDefinition: ASTNode, InitializableNode {
    /// Type identifier
    public var type: TypeNameNode? {
        return firstChild()
    }
    
    public var attributesList: PropertyAttributesList? {
        return firstChild()
    }
    
    /// Identifier for this property
    public var identifier: Identifier? {
        return firstChild()
    }
    
    // For use in protocol methods only
    public var isOptionalProperty: Bool = false
    
    public required init() {
        super.init()
    }
}

public class PropertyAttributesList: ASTNode, InitializableNode {
    public var attributes: [PropertyAttributeNode] {
        return childrenMatching()
    }
    
    public var keywordAttributes: [String] {
        return attributes.compactMap { mod in
            switch mod.attribute {
            case .keyword(let kw):
                return kw
            default:
                return nil
            }
        }
    }
    
    required public init() {
        
    }
}

public class PropertyAttributeNode: ASTNode {
    public var attribute: Attribute
    
    public init(name: String, location: SourceLocation = .invalid) {
        self.attribute = .keyword(name)
        super.init(location: location)
    }
    
    public init(getter: String, location: SourceLocation = .invalid) {
        self.attribute = .getter(getter)
        super.init(location: location)
    }
    
    public init(setter: String, location: SourceLocation = .invalid) {
        self.attribute = .setter(setter)
        super.init(location: location)
    }
    
    public init(modifier: Attribute, location: SourceLocation = .invalid) {
        self.attribute = modifier
        super.init(location: location)
    }
    
    public enum Attribute {
        case keyword(String)
        case getter(String)
        case setter(String)
    }
}
