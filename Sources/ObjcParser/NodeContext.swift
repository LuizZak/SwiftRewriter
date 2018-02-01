import GrammarModels

/// A class used to nest up hierarchic node creations
public class NodeCreationContext {
    /// Current top-most node
    public var topmostNode: ASTNode? {
        return _nodeStack.last
    }
    
    public var autoUpdatesSourceRange = true
    
    private var _nodeStack: [ASTNode] = []
    
    /// Pushes a new node context
    @discardableResult
    public func pushContext<T: ASTNode & InitializableNode>(nodeType type: T.Type = T.self) -> T {
        let node = T()
        
        pushContext(node: node)
        
        return node
    }
    
    /// Gets the current context node as a given node type.
    /// Returns nil, if `topmostNode` is nil or if it is not castable to `T`.
    public func currentContextNode<T: ASTNodeValue>(as node: T.Type = T.self) -> T? {
        return topmostNode as? T
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
