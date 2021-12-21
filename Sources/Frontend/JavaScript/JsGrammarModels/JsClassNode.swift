/// A node describing a JavaScript class.
public class JsClassNode: JsASTNode, JsInitializableNode {
    /// The name identifier for this class.
    public var identifier: JsIdentifierNode? {
        firstChild()
    }

    /// A list of methods.
    public var methods: [JsMethodDefinitionNode] {
        childrenMatching()
    }

    public required init() {
        super.init()
    }
}
