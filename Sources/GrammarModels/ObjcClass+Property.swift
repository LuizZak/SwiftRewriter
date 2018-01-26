public class PropertyDefinition: ASTNode, InitializableNode {
    /// Type identifier
    public var type: ASTNodeRef<TypeNameNode>
    
    public var modifierList: PropertyModifierList? {
        return childrenMatching().first
    }
    
    /// Identifier for this property
    public var identifier: ASTNodeRef<Identifier>
    
    public init(type: ASTNodeRef<TypeNameNode>, identifier: ASTNodeRef<Identifier>) {
        self.type = type
        self.identifier = identifier
        super.init()
    }
    
    public required init() {
        self.type = .placeholder
        self.identifier = .placeholder
        super.init()
    }
}

public class PropertyModifierList: ASTNode, InitializableNode {
    public var modifiers: [PropertyModifier] {
        return childrenMatching()
    }
    
    required public init() {
        
    }
}

public class PropertyModifier: ASTNode {
    public var name: String
    
    public init(name: String, location: SourceLocation = .invalid) {
        self.name = name
        super.init(location: location)
    }
}
