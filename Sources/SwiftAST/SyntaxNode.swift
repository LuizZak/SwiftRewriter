/// Base class for syntax nodes
open class SyntaxNode {
    internal(set) public weak var parent: SyntaxNode?
}
