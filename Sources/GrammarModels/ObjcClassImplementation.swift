/// A syntax node for an Objective-C class implementation (`@implementation`)
/// declaration.
public class ObjcClassImplementation: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        return firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
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
    
    public var propertyImplementations: [PropertyImplementation] {
        return childrenMatching()
    }
}
