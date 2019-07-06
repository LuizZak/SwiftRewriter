/// A syntax node for an Objective-C class implementation (`@implementation`)
/// declaration.
public class ObjcClassImplementation: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        return firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

public extension ObjcClassImplementation {
    var superclass: SuperclassName? {
        return firstChild()
    }
    
    var ivarsList: IVarsList? {
        return firstChild()
    }
    
    var methods: [MethodDefinition] {
        return childrenMatching()
    }
    
    var propertyImplementations: [PropertyImplementation] {
        return childrenMatching()
    }
}
