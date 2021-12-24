/// A plain JavaScript function node.
public class JsFunctionDeclarationNode: JsASTNode, JsFunctionNodeType, JsInitializableNode {
    /// The identifier for the function's name.
    public var identifier: JsIdentifierNode? {
        firstChild()
    }

    /// The signature for this function's arguments.
    public var signature: JsFunctionSignature?

    /// Gets the function body for this function declaration.
    public var body: JsFunctionBodyNode? {
        firstChild()
    }

    public required init() {
        super.init()
    }
}
