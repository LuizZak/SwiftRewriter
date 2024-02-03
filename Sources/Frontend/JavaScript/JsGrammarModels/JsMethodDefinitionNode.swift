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

    /// The context associated to this method definition.
    public var context: Context?

    /// Gets the function body for this method definition.
    public var body: JsFunctionBodyNode? {
        firstChild()
    }

    public required init() {
        super.init()
    }

    /// Extra context that can be appended to a method definition.
    public enum Context {
        /// Method was parsed from a property getter.
        case isGetter

        /// Method was parsed from a property setter.
        case isSetter
    }
}
