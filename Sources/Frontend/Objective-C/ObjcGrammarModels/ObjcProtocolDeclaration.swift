/// A syntax node for an Objective-C protocol (`@protocol`) declaration.
public class ObjcProtocolDeclaration: ObjcASTNode, ObjcInitializableNode {
    public var identifier: Identifier? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public extension ObjcProtocolDeclaration {
    var properties: [PropertyDefinition] {
        childrenMatching()
    }
    
    var protocolList: ProtocolReferenceList? {
        firstChild()
    }
    
    var methods: [MethodDefinition] {
        childrenMatching()
    }
}
