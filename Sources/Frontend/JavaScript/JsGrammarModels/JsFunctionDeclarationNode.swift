/// A plain JavaScript function node.
public class JsFunctionDeclarationNode: JsASTNode, JsInitializableNode {
    /// The identifier for the function's name.
    public var identifier: JsIdentifierNode? {
        firstChild()
    }

    /// Gets the function body for this function declaration.
    public var body: JsFunctionBodyNode? {
        firstChild()
    }

    public required init() {
        super.init()
    }
}
