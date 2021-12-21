/// A node for JavaScript method definitions.
public class JsMethodDefinitionNode: JsASTNode, JsInitializableNode {
    /// The name of the method.
    public var identifier: JsIdentifierNode? {
        firstChild()
    }

    public required init() {
        super.init()
    }
}
