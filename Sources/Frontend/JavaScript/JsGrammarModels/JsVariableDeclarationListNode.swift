/// A variable declaration list.
public class JsVariableDeclarationListNode: JsASTNode {
    /// The modifier for this declaration, aka `var`, `let`, or `const`.
    public var varModifier: VarModifier

    /// A list of variable declarations within this node.
    public var variableDeclarations: [JsVariableDeclarationNode] {
        childrenMatching()
    }

    public init(varModifier: VarModifier) {
        self.varModifier = varModifier

        super.init()
    }

    public enum VarModifier: String {
        case `var`
        case `let`
        case const
    }
}
