/// A syntax node for an Objective-C protocol (`@protocol`) declaration.
public class ProtocolDeclaration: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        return firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(_isInNonnullContext: isInNonnullContext)
    }
}

public extension ProtocolDeclaration {
    var properties: [PropertyDefinition] {
        return childrenMatching()
    }
    
    var protocolList: ProtocolReferenceList? {
        return firstChild()
    }
    
    var methods: [MethodDefinition] {
        return childrenMatching()
    }
}
