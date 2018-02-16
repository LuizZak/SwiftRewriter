/// A syntax node for an Objective-C protocol (`@protocol`) declaration.
public class ProtocolDeclaration: ASTNode, InitializableNode {
    public var identifier: Identifier? {
        return firstChild()
    }
    
    public required init() {
        
    }
}

public extension ProtocolDeclaration {
    public var properties: [PropertyDefinition] {
        return childrenMatching()
    }
    
    public var protocolList: ProtocolReferenceList? {
        return firstChild()
    }
    
    public var methods: [MethodDefinition] {
        return childrenMatching()
    }
}
