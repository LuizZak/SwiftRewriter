public class PropertyDefinition: ASTNode, InitializableNode {
    /// Type identifier
    public var type: ASTNodeRef<TypeNameNode>
    
    public var modifierList: PropertyModifierList? {
        return firstChild()
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
    
    public var keywordModifiers: [String] {
        return modifiers.compactMap { mod in
            switch mod.modifier {
            case .keyword(let kw):
                return kw
            default:
                return nil
            }
        }
    }
    
    public var getterModifiers: [String] {
        return modifiers.compactMap { mod in
            switch mod.modifier {
            case .getter(let gt):
                return gt
            default:
                return nil
            }
        }
    }
    
    public var setterModifiers: [String] {
        return modifiers.compactMap { mod in
            switch mod.modifier {
            case .setter(let st):
                return st
            default:
                return nil
            }
        }
    }
    
    required public init() {
        
    }
}

public class PropertyModifier: ASTNode {
    public var modifier: Modifier
    
    public init(name: String, location: SourceLocation = .invalid) {
        self.modifier = .keyword(name)
        super.init(location: location)
    }
    
    public init(getter: String, location: SourceLocation = .invalid) {
        self.modifier = .getter(getter)
        super.init(location: location)
    }
    
    public init(setter: String, location: SourceLocation = .invalid) {
        self.modifier = .setter(setter)
        super.init(location: location)
    }
    
    public init(modifier: Modifier, location: SourceLocation = .invalid) {
        self.modifier = modifier
        super.init(location: location)
    }
    
    public enum Modifier {
        case keyword(String)
        case getter(String)
        case setter(String)
    }
}
