public class ObjcClassInterface: ASTNode, InitializableNode {
    public var identifier: ASTNodeRef<Identifier> = .invalid(InvalidNode())
    
    public required init() {
        
    }
}

// MARK: - Accessor properties
public extension ObjcClassInterface {
    public var properties: [PropertyDefinition] {
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
    
    public class SuperclassName: Identifier {
        
    }
    
    public class ProtocolReferenceList: ASTNode {
        public var protocols: [ProtocolName] {
            return childrenMatching()
        }
        
        public init(location: SourceLocation = .invalid) {
            super.init(location: location)
        }
    }
    
    public class ProtocolName: Identifier {
        
    }
}
