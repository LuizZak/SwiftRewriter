/// Describes a node with a default parameterized `init` which is a known
/// base node requirement initializer.
public protocol JsInitializableNode: JsASTNode {
    init()
}
