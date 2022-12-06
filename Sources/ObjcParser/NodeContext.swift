import GrammarModels

/// A class used to nest up hierarchic node creations
public class NodeCreationContext {
    /// Current top-most node
    public var topmostNode: ASTNode? {
        _nodeStack.last
    }
    
    public var autoUpdatesSourceRange = true
    
    private var _nodeStack: [ASTNode] = []
    
    public var isInNonnullContext: Bool = false
    
    /// Pushes a new node context
    @discardableResult
    public func pushContext<T: InitializableNode>(nodeType type: T.Type = T.self) -> T {
        let node = T.init(isInNonnullContext: isInNonnullContext)
        
        pushContext(node: node)
        
        return node
    }
    
    /// Searches for a context node with a given node type.
    /// Returns nil, if no nodes along the context stack are of type `T`.
    ///
    /// Searches from most recently added to least recently added nodes.
    public func findContextNode<T: ASTNode>(as node: T.Type = T.self) -> T? {
        for node in _nodeStack.reversed() {
            if let node = node as? T {
                return node
            }
        }
        
        return nil
    }
    
    /// Gets the current context node as a given node type.
    /// Returns nil, if `topmostNode` is nil or if it cannot be cast into `T`.
    public func currentContextNode<T: ASTNode>(as node: T.Type = T.self) -> T? {
        topmostNode as? T
    }
    
    /// Pushes a new node context using a given node
    public func pushContext(node: ASTNode) {
        topmostNode?.addChild(node)
        _nodeStack.append(node)
    }
    
    /// Adds a given child node to the top-most context.
    /// - precondition: `topmostNode != nil`
    public func addChildNode(_ node: ASTNode) {
        guard let topmostNode = topmostNode else {
            fatalError("Expected topmostNode to not be nil")
        }
        
        topmostNode.addChild(node)
    }
    
    /// Pops the current top-most node
    /// - precondition: `topmostNode != nil`
    @discardableResult
    public func popContext() -> ASTNode? {
        guard let top = _nodeStack.popLast() else {
            return nil
        }
        
        if autoUpdatesSourceRange {
            if top.location == .invalid {
                top.updateSourceRange()
            }
        }
        
        return top
    }
}
