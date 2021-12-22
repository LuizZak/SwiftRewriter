/// A node for JavaScript method definitions.
public class JsMethodDefinitionNode: JsASTNode, JsInitializableNode {
    /// The name of the method.
    public var identifier: JsIdentifierNode? {
        firstChild()
    }

    /// Gets the function body for this method definition.
    public var body: JsFunctionBodyNode? {
        firstChild()
    }

    public required init() {
        super.init()
    }
}
