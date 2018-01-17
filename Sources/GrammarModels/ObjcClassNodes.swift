public class ObjcClassInterface: ASTNode, InitializableNode {
    public var identifier: ASTNodeRef<Identifier> = .invalid(InvalidNode())
    
    public required init() {
        
    }
}

// MARK: - Accessor properties
public extension ObjcClassInterface {
    public var properties: [Property] {
        return childrenMatching()
    }
    
    public var superclass: SuperclassName? {
        return childrenMatching().first
    }
    
    public var protocolList: ProtocolReferenceList? {
        return childrenMatching().first
    }
}

// MARK: - Subnodes
public extension ObjcClassInterface {
    
    public class SuperclassName: ASTNode {
        /// Type identifier
        public var name: String
        
        public init(name: String, location: SourceRange = .invalid) {
            self.name = name
            super.init(location: location)
        }
    }
    
    public class ProtocolReferenceList: ASTNode {
        public var protocols: [String]
        
        public init(protocols: [String], location: SourceRange = .invalid) {
            self.protocols = protocols
            super.init(location: location)
        }
    }
    
    public class Property: ASTNode {
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
        
        public init(name: String, location: SourceRange = .invalid) {
            self.name = name
            super.init(location: location)
        }
    }
}
