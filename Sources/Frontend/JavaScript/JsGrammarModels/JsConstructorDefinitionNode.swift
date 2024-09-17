/// A node for JavaScript constructor definitions.
public class JsConstructorDefinitionNode: JsASTNode, JsFunctionNodeType, JsInitializableNode {
    /// Whether this method is defined as static.
    public var isStatic: Bool = false

    /// Gets the identifier node for this constructor.
    public var identifier: JsIdentifierNode? {
        firstChild()
    }

    /// The signature for this constructor.
    public var signature: JsFunctionSignature?

    /// Gets the function body for this constructor.
    public var body: JsFunctionBodyNode? {
        firstChild()
    }

    public required init() {
        super.init()
    }
}
