import JsGrammarModels

// TODO: Create a base implementation to cover this file and with ObjcParser.ObjcParserListener.

/// A class used to nest up hierarchic node creations
public class NodeCreationContext {
    /// Current top-most node
    public var topmostNode: JsASTNode? {
        _nodeStack.last
    }
    
    public var autoUpdatesSourceRange = true
    
    private var _nodeStack: [JsASTNode] = []
    
    /// Pushes a new node context
    @discardableResult
    public func pushContext<T: JsInitializableNode>(nodeType type: T.Type = T.self) -> T {
        let node = T.init()
        
        pushContext(node: node)
        
        return node
    }
    
    /// Searches for a context node with a given node type.
    /// Returns nil, if no nodes along the context stack are of type `T`.
    ///
    /// Searches from most recently added to least recently added nodes.
    public func findContextNode<T: JsASTNode>(as node: T.Type = T.self) -> T? {
        for node in _nodeStack.reversed() {
            if let node = node as? T {
                return node
            }
        }
        
        return nil
    }
    
    /// Gets the current context node as a given node type.
    /// Returns nil, if `topmostNode` is nil or if it cannot be cast to `T`.
    public func currentContextNode<T: JsASTNode>(as node: T.Type = T.self) -> T? {
        topmostNode as? T
    }

    /// Gets the topmost context node of a specified type that sits bellow the
    /// given node.
    ///
    /// If the node is not within the context stack, `nil` is returned.
    public func findContextNodeBellow<T: JsASTNode>(node: JsASTNode, as nodeType: T.Type = T.self) -> T? {
        guard let index = _nodeStack.firstIndex(where: { $0 === node }) else {
            return nil
        }

        for node in _nodeStack[..<index].reversed() {
            if let node = node as? T {
                return node
            }
        }

        return nil
    }
    
    /// Pushes a new node context using a given node
    public func pushContext(node: JsASTNode, addToTopNode: Bool = true) {
        if addToTopNode {
            topmostNode?.addChild(node)
        }

        _nodeStack.append(node)
    }
    
    /// Adds a given child node to the top-most context.
    /// - precondition: `topmostNode != nil`
    public func addChildNode(_ node: JsASTNode) {
        guard let topmostNode = topmostNode else {
            fatalError("Expected topmostNode to not be nil")
        }
        
        topmostNode.addChild(node)
    }
    
    /// Pops the current top-most node
    /// - precondition: `topmostNode != nil`
    @discardableResult
    public func popContext() -> JsASTNode? {
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
