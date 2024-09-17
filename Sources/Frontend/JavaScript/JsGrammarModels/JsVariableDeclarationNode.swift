/// A variable definition contained within a `JsVariableDeclarationListNode`.
public class JsVariableDeclarationNode: JsASTNode, JsInitializableNode {
    /// The identifier for this variable.
    public var identifier: JsIdentifierNode? {
        firstChild()
    }

    /// The initial expression for this variable declaration.
    public var expression: JsExpressionNode? {
        firstChild()
    }

    public required init() {
        super.init()
    }
}
