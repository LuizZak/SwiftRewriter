/// A class category that extends a class with additional properties/methods/ivars/protocols.
public class ObjcClassCategory: ASTNode, InitializableNode {
    public var identifier: ASTNodeRef<Identifier> = .invalid(InvalidNode())
    public var categoryName: Identifier?
    
    public required init() {
        
    }
}

public extension ObjcClassCategory {
    public var properties: [PropertyDefinition] {
        return childrenMatching()
    }
    
    public var protocolList: ProtocolReferenceList? {
        return firstChild()
    }
    
    public var ivarsList: IVarsList? {
        return firstChild()
    }
    
    public var methods: [MethodDefinition] {
        return childrenMatching()
    }
}
