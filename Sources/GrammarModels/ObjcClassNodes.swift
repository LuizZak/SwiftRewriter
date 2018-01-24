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
        
        public init(name: String, location: SourceLocation = .invalid) {
            self.name = name
            super.init(location: location)
        }
    }
    
    public class ProtocolReferenceList: ASTNode {
        public var protocols: [String]
        
        public init(protocols: [String], location: SourceLocation = .invalid) {
            self.protocols = protocols
            super.init(location: location)
        }
    }
}
