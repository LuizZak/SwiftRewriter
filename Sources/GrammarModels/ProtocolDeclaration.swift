/// A syntax node for an Objective-C protocol (`@protocol`) declaration.
public class ProtocolDeclaration: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        firstChild()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

public extension ProtocolDeclaration {
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
