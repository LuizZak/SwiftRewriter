import SwiftAST

/// Class used to generate control flow graphs (CFGs) of method bodies.
public final class ControlFlowGraph {
    /// A list of all nodes contained in this graph
    private(set) public var nodes: [ControlFlowGraphNode] = []
    /// A list of all edges contained in this graph
    private(set) public var edges: [ControlFlowGraphEdge] = []
    
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
}

/// Specifies a control flow graph node
public final class ControlFlowGraphNode {
    /// An associated node for this control flow graph node.
    /// This node is the top-most node which satisfies the rule that its parent
    /// syntax node is also referenced directly by another graph node.
    public let node: SyntaxNode
    
    init(node: SyntaxNode) {
        self.node = node
    }
}

/// Represents a directed edge in a control flow graph.
public final class ControlFlowGraphEdge {
    public let start: ControlFlowGraphNode
    public let end: ControlFlowGraphNode
    
    init(start: ControlFlowGraphNode, end: ControlFlowGraphNode) {
        assert(start !== end)
        
        self.start = start
        self.end = end
    }
}
