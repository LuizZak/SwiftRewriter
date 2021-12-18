/// Base class for syntax nodes
open class SyntaxNode {
    /// Custom metadata that can be associated with this node
    public var metadata: [String: Any] = [:]
    
    internal(set) public weak var parent: SyntaxNode? {
        willSet {
            assert(newValue == nil || parent == nil || parent === newValue,
                   "Reassigning node that already has a parent")
        }
    }
    
    open var children: [SyntaxNode] {
        []
    }
    
    public init() {
        
    }
    
    @inlinable
    open func copy() -> SyntaxNode {
        fatalError("Must be overriden by subclasses")
    }
    
    /// Returns `true` if this syntax node is either the same as a given syntax
    /// node, or a descendent of it.
    public func isDescendent(of other: SyntaxNode) -> Bool {
        if other === self {
            return true
        }
        
        var currentParent = parent
        while let p = currentParent {
            if p === other {
                return true
            }
            
            currentParent = p.parent
        }
        
        return false
    }
    
    /// Returns the first ancestor of this node which matches a given node type,
    /// excluding itself.
    ///
    /// Returns `nil`, in case no ancestor of the given type is found.
    public func firstAncestor<T: SyntaxNode>(ofType type: T.Type = T.self) -> T? {
        var currentParent = parent
        while let p = currentParent {
            if let ancestor = p as? T {
                return ancestor
            }
            
            currentParent = p.parent
        }
        
        return nil
    }
}
