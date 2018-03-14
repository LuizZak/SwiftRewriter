/// Base class for syntax nodes
open class SyntaxNode {
    /// Custom metadata that can be associated with this node
    public var metadata: [String: Any] = [:]
    
    internal(set) public weak var parent: SyntaxNode?
    
    open var children: [SyntaxNode] {
        return []
    }
    
    public init() {
        
    }
    
    /// Returns `true` if this node's parent chain contains a given node.
    public func isDescendent(of node: SyntaxNode) -> Bool {
        if let parent = parent {
            return parent === node || parent.isDescendent(of: node)
        }
        
        return false
    }
}
