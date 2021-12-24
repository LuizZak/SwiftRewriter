/// A node for JavaScript method definitions.
public class JsMethodDefinitionNode: JsASTNode, JsFunctionNodeType, JsInitializableNode {
    /// The name of the method.
    public var identifier: JsIdentifierNode? {
        firstChild()
    }

    /// Whether this method is defined as static.
    public var isStatic: Bool = false

    /// The signature for this function.
    public var signature: JsFunctionSignature?

    /// Gets the function body for this method definition.
    public var body: JsFunctionBodyNode? {
        firstChild()
    }

    public required init() {
        super.init()
    }
}
