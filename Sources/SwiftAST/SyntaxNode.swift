/// Base class for syntax nodes
open class SyntaxNode {
    internal(set) public weak var parent: SyntaxNode?
    
    open var children: [SyntaxNode] {
        return []
    }
    
    public init() {
        
    }
}
