/// A syntax node for an Objective-C class implementation (`@implementation`)
/// declaration.
public class ObjcClassImplementation: ASTNode, InitializableNode {
    public var identifier: ASTNodeRef<Identifier> = .invalid(InvalidNode())
    
    public required init() {
        
    }
}

public extension ObjcClassImplementation {
    public var superclass: SuperclassName? {
        return childrenMatching().first
    }
    
    public var ivarsList: IVarsList? {
        return childrenMatching().first
    }
    
    public var methods: [MethodDefinition] {
        return childrenMatching()
    }
}
