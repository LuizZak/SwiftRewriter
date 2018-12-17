import SwiftAST

/// Class that represents control flow graphs (CFGs) of functions.
public final class ControlFlowGraph {
    /// The entry point of this control flow graph
    private(set) public var entry: ControlFlowGraphEntryNode
    /// The exit point of this control flow graph
    private(set) public var exit: ControlFlowGraphExitNode
    
    /// A list of all nodes contained in this graph
    internal(set) public var nodes: [ControlFlowGraphNode] = []
    /// A list of all edges contained in this graph
    internal(set) public var edges: [ControlFlowGraphEdge] = []
    
    init(entry: ControlFlowGraphEntryNode, exit: ControlFlowGraphExitNode) {
        self.entry = entry
        self.exit = exit
        
        addNode(entry)
        addNode(exit)
    }
    
    /// Returns the control flow graph node that represents a given syntax node,
    /// if available.
    /// Returns `nil`, if no graph node represents the given syntax node directly.
    ///
    /// A reference equality test (===) is used to determine syntax node equality.
    public func graphNode(for node: SyntaxNode) -> ControlFlowGraphNode? {
        return nodes.first { $0.node === node }
    }
    
    /// Returns all ingoing and outgoing edges for a given control flow graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func allEdges(for node: ControlFlowGraphNode) -> [ControlFlowGraphEdge] {
        return edges.filter { $0.start === node || $0.end === node }
    }
    
    /// Returns all outgoing edges for a given control flow graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func edges(from node: ControlFlowGraphNode) -> [ControlFlowGraphEdge] {
        return edges.filter { $0.start === node }
    }
    
    /// Returns all ingoing edges for a given control flow graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func edges(towards node: ControlFlowGraphNode) -> [ControlFlowGraphEdge] {
        return edges.filter { $0.end === node }
    }
    
    /// Returns all outgoing back edges for a given control flow graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func backEdges(from node: ControlFlowGraphNode) -> [ControlFlowGraphEdge] {
        return edges.filter { $0.start === node && $0.isBackEdge }
    }
    
    /// Returns all ingoing back edges for a given control flow graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func backEdges(towards node: ControlFlowGraphNode) -> [ControlFlowGraphEdge] {
        return edges.filter { $0.end === node && $0.isBackEdge }
    }
    
    /// Returns all graph nodes that are connected from a given control flow graph
    /// node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func nodesConnected(from node: ControlFlowGraphNode) -> [ControlFlowGraphNode] {
        return edges.compactMap { $0.start === node ? $0.end : nil }
    }
    
    /// Returns all graph nodes that are connected towards a given control flow
    /// graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func nodesConnected(towards node: ControlFlowGraphNode) -> [ControlFlowGraphNode] {
        return edges.compactMap { $0.end === node ? $0.start : nil }
    }
    
    /// Returns all graph nodes that are connected towards and from the given
    /// graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func allNodesConnected(to node: ControlFlowGraphNode) -> [ControlFlowGraphNode] {
        return nodesConnected(towards: node) + nodesConnected(from: node)
    }
    
    /// Performs a depth-first visiting of this control flow graph
    public func depthFirstVisit(_ visitor: (ControlFlowGraphNode) -> Void) {
        var visited: Set<ObjectIdentifier> = []
        var queue: [ControlFlowGraphNode] = []
        
        queue.append(entry)
        
        while let next = queue.popLast() {
            let identifier = ObjectIdentifier(next)
            visited.insert(identifier)
            
            visitor(next)
            
            for nextNode in nodesConnected(from: next) {
                guard !visited.contains(ObjectIdentifier(nextNode)) else {
                    continue
                }
                
                queue.append(nextNode)
            }
        }
    }
    
    /// Performs a breadth-first visiting of this control flow graph
    public func breadthFirstVisit(_ visitor: (ControlFlowGraphNode) -> Void) {
        var visited: Set<ObjectIdentifier> = []
        var queue: [ControlFlowGraphNode] = []
        
        queue.append(entry)
        
        while !queue.isEmpty {
            let next = queue.removeFirst()
            
            let identifier = ObjectIdentifier(next)
            visited.insert(identifier)
            
            visitor(next)
            
            for nextNode in nodesConnected(from: next) {
                guard !visited.contains(ObjectIdentifier(nextNode)) else {
                    continue
                }
                
                queue.append(nextNode)
            }
        }
    }
}

extension ControlFlowGraph {
    /// Returns a list of nodes collected in depth-first order
    func depthFirstList() -> [ControlFlowGraphNode] {
        var list: [ControlFlowGraphNode] = []
        
        depthFirstVisit {
            list.append($0)
        }
        
        return list
    }
    
    /// Returns a list of nodes collected in breadth-first order
    func breadthFirstList() -> [ControlFlowGraphNode] {
        var list: [ControlFlowGraphNode] = []
        
        breadthFirstVisit {
            list.append($0)
        }
        
        return list
    }
}

/// Specifies a control flow graph node
public class ControlFlowGraphNode {
    /// An associated node for this control flow graph node.
    public let node: SyntaxNode
    
    required init(node: SyntaxNode) {
        self.node = node
    }
}

/// Represents an entry node for a control flow graph
public final class ControlFlowGraphEntryNode: ControlFlowGraphNode {
    required init(node: SyntaxNode) {
        super.init(node: node)
    }
}

/// Represents an exit node for a control flow graph
public final class ControlFlowGraphExitNode: ControlFlowGraphNode {
    required init(node: SyntaxNode) {
        super.init(node: node)
    }
}

/// Represents a directed edge in a control flow graph.
public final class ControlFlowGraphEdge {
    public let start: ControlFlowGraphNode
    public let end: ControlFlowGraphNode
    
    /// True if this is a back edge which points backwards towards the start of
    /// a flow
    public var isBackEdge: Bool = false
    
    init(start: ControlFlowGraphNode, end: ControlFlowGraphNode) {
        self.start = start
        self.end = end
    }
}
