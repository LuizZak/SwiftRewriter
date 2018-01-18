/// Visitor for recursive depth-first `ASTNode`s traversing.
public protocol ASTVisitor {
    func onEnter(_ node: ASTNode)
    func visit(_ node: ASTNode)
    func onExit(_ node: ASTNode)
}

/// Traverses an `ASTNode`, passing in visiting commands to a target visitor object.
public class ASTTraverser {
    var node: ASTNode
    var visitor: ASTVisitor
    
    public init(node: ASTNode, visitor: ASTVisitor) {
        self.node = node
        self.visitor = visitor
    }
    
    public func traverse() {
        _traverseRecursive(node, visitor)
    }
    
    private func _traverseRecursive(_ node: ASTNode, _ visitor: ASTVisitor) {
        visitor.onEnter(node)
        
        for child in node.children {
            _traverseRecursive(child, visitor)
        }
        
        visitor.visit(node)
        
        visitor.onExit(node)
    }
}

/// A pre-implementation of `ASTVisitor` that takes in closures for visiting the
/// nodes
public class AnonymousASTVisitor: ASTVisitor {
    public var onEnterClosure: (ASTNode) -> ()
    public var visitClosure: (ASTNode) -> ()
    public var onExitClosure: (ASTNode) -> ()
    
    public init(onEnter: @escaping (ASTNode) -> () = { _ in }, visit: @escaping (ASTNode) -> () = { _ in }, onExit: @escaping (ASTNode) -> () = { _ in }) {
        self.onEnterClosure = onEnter
        self.visitClosure = visit
        self.onExitClosure = onExit
    }
    
    public func onEnter(_ node: ASTNode) {
        onEnterClosure(node)
    }
    
    public func visit(_ node: ASTNode) {
        visitClosure(node)
    }
    
    public func onExit(_ node: ASTNode) {
        onExitClosure(node)
    }
}
