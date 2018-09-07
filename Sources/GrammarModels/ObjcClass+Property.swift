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
    
    public override var location: SourceLocation {
        didSet {
            print("a")
        }
    }
    
    // For use in protocol methods only
    public var isOptionalProperty: Bool = false
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
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
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public class PropertyAttributeNode: ASTNode {
    public var attribute: Attribute
    
    public convenience init(name: String,
                            isInNonnullContext: Bool,
                            location: SourceLocation = .invalid) {
        
        self.init(modifier: .keyword(name),
                  isInNonnullContext: isInNonnullContext,
                  location: location)
    }
    
    public convenience init(getter: String,
                            isInNonnullContext: Bool,
                            location: SourceLocation = .invalid) {
        
        self.init(modifier: .getter(getter),
                  isInNonnullContext: isInNonnullContext,
                  location: location)
    }
    
    public convenience init(setter: String,
                            isInNonnullContext: Bool,
                            location: SourceLocation = .invalid) {
        
        self.init(modifier: .setter(setter),
                  isInNonnullContext: isInNonnullContext,
                  location: location)
    }
    
    public init(modifier: Attribute, isInNonnullContext: Bool, location: SourceLocation = .invalid) {
        self.attribute = modifier
        super.init(isInNonnullContext: isInNonnullContext, location: location)
    }
    
    public enum Attribute {
        case keyword(String)
        case getter(String)
        case setter(String)
    }
}
