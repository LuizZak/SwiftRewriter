/// Base class for syntax nodes
open class SyntaxNode {
    internal(set) public weak var parent: SyntaxNode?
    
    public var children: [SyntaxNode] {
        return []
    }
}
