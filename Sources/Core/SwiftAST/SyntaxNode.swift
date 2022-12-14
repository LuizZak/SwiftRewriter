/// Base class for syntax nodes
open class SyntaxNode {
    /// Custom runtime metadata that can be associated with this node
    public var metadata: [String: Any] = [:]
    
    internal(set) public weak var parent: SyntaxNode? {
        willSet {
            assert(
                newValue == nil || parent == nil || parent === newValue,
                "Reassigning parent for node that already has a non-nil parent"
            )
        }
    }

    /// Returns the top-most parent node in this syntax node's hierarchy.
    /// If `parent == nil`, root is `self`.
    public var root: SyntaxNode {
        parent?.root ?? self
    }
    
    /// Gets the list of children `SyntaxNode` within this syntax node.
    open var children: [SyntaxNode] {
        []
    }
    
    public init() {
        
    }
    
    @inlinable
    open func copy() -> SyntaxNode {
        fatalError("Must be overridden by subclasses")
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

    /// Returns the first common ancestor between two given syntax nodes.
    ///
    /// Returns `nil` if the nodes do not share a common ancestor.
    public static func firstCommonAncestor(between node1: SyntaxNode, _ node2: SyntaxNode) -> SyntaxNode? {
        if node1 === node2 {
            return node1
        }

        var parent: SyntaxNode? = node1
        while let p = parent {
            if node2.isDescendent(of: p) {
                return p
            }

            parent = p.parent
        }

        return nil
    }
}
