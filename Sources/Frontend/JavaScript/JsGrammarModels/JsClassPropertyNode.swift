/// A class-scoped property declaration.
public class JsClassPropertyNode: JsASTNode, JsInitializableNode {
    /// The identifier for this property.
    public var identifier: JsIdentifierNode? {
        firstChild()
    }

    /// The initial expression for this property declaration.
    public var expression: JsExpressionNode? {
        firstChild()
    }

    public required init() {
        super.init()
    }
}
