/// Describes a node with a default parameterized `init` which is a known
/// base node requirement initializer.
public protocol ObjcInitializableNode: ObjcASTNode {
    init(isInNonnullContext: Bool)
}
