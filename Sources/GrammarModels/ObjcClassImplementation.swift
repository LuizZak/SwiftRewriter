/// A syntax node for an Objective-C class implementation (`@implementation`)
/// declaration.
public class ObjcClassImplementation: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public extension ObjcClassImplementation {
    var superclass: SuperclassName? {
        firstChild()
    }
    
    var ivarsList: IVarsList? {
        firstChild()
    }
    
    var methods: [MethodDefinition] {
        childrenMatching()
    }
    
    var propertyImplementations: [PropertyImplementation] {
        childrenMatching()
    }
}
