/// Visitor for recursive depth-first `ASTNode`s traversing.
public protocol ASTVisitor {
    associatedtype Result
    
    func onEnter(_ node: ASTNode)
    func visit(_ node: ASTNode) -> Result
    func onExit(_ node: ASTNode)
    
    func merge(_ r1: Result, r2: Result) -> Result
}

public extension ASTVisitor {
    // Default implementation of merge simply returns the right-hand side
    func merge(_ r1: Result, r2: Result) -> Result {
        r2
    }
}

/// Traverses an `ASTNode`, passing in visiting commands to a target visitor object.
public class ASTTraverser<Visitor> where Visitor: ASTVisitor {
    var node: ASTNode
    var visitor: Visitor
    var initialValue: Visitor.Result
    
    public init(node: ASTNode, initialValue: Visitor.Result, visitor: Visitor) {
        self.node = node
        self.initialValue = initialValue
        self.visitor = visitor
    }
    
    public func traverse() -> Visitor.Result {
        let result = _traverseRecursive(node, visitor)
        
        return visitor.merge(initialValue, r2: result)
    }
    
    private func _traverseRecursive(_ node: ASTNode, _ visitor: Visitor) -> Visitor.Result {
        visitor.onEnter(node)
        
        var partial: Visitor.Result
        
        if let first = node.children.first {
            partial = _traverseRecursive(first, visitor)
            
            for child in node.children.dropFirst() {
                partial = visitor.merge(partial, r2: _traverseRecursive(child, visitor))
            }
            
            partial = visitor.merge(partial, r2: visitor.visit(node))
        } else {
            partial = visitor.visit(node)
        }
        
        visitor.onExit(node)
        
        return partial
    }
}

public extension ASTTraverser where Visitor.Result == Void {
    convenience init(node: ASTNode, visitor: Visitor) {
        self.init(node: node, initialValue: (), visitor: visitor)
    }
}

/// A pre-implementation of `ASTVisitor` that takes in closures for visiting the
/// nodes
public class AnyASTVisitor<T>: ASTVisitor {
    public typealias Result = T
    
    public var onEnterClosure: (ASTNode) -> Void
    public var visitClosure: (ASTNode) -> (T)
    public var onExitClosure: (ASTNode) -> Void
    
    public init(onEnter: @escaping (ASTNode) -> Void = { _ in },
                visit: @escaping (ASTNode) -> (T),
                onExit: @escaping (ASTNode) -> Void = { _ in }) {
        self.onEnterClosure = onEnter
        self.visitClosure = visit
        self.onExitClosure = onExit
    }
    
    public func onEnter(_ node: ASTNode) {
        onEnterClosure(node)
    }
    
    public func visit(_ node: ASTNode) -> T {
        visitClosure(node)
    }
    
    public func onExit(_ node: ASTNode) {
        onExitClosure(node)
    }
}

public extension AnyASTVisitor where T == Void {
    convenience init() {
        self.init(onEnter: { _ in }, visit: { _ in }, onExit: { _ in })
    }
}
