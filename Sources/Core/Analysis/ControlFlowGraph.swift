import SwiftAST
import TypeSystem

/// Class that represents control flow graphs (CFGs) of functions.
public final class ControlFlowGraph: DirectedGraph {
    /// The entry point of this control flow graph
    internal(set) public var entry: ControlFlowGraphNode
    /// The exit point of this control flow graph
    internal(set) public var exit: ControlFlowGraphNode
    
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
    
    /// Returns whether a given control flow graph node exists in this control
    /// flow graph.
    ///
    /// A reference equality test (===) is used to determine syntax node equality.
    public func containsNode(_ node: ControlFlowGraphNode) -> Bool {
        nodes.contains { $0 === node }
    }
    
    /// Returns `true` iff two node references represent the same underlying node
    /// in this graph.
    public func areNodesEqual(_ node1: ControlFlowGraphNode, _ node2: ControlFlowGraphNode) -> Bool {
        node1 === node2
    }
    
    @inlinable
    public func startNode(for edge: ControlFlowGraphEdge) -> ControlFlowGraphNode {
        edge.start
    }
    
    @inlinable
    public func endNode(for edge: ControlFlowGraphEdge) -> ControlFlowGraphNode {
        edge.end
    }
    
    /// Returns the control flow graph node that represents a given syntax node,
    /// if available.
    /// Returns `nil`, if no graph node represents the given syntax node directly.
    ///
    /// A reference equality test (===) is used to determine syntax node equality.
    public func graphNode(for node: SyntaxNode) -> ControlFlowGraphNode? {
        nodes.first { $0.node === node }
    }
    
    /// Returns the control flow graph node that represents a given syntax node,
    /// or any of its ancestors.
    /// When searching across ancestors, the nearest ancestors are searched first.
    ///
    /// A reference equality test (===) is used to determine syntax node equality.
    public func graphNode(forFirstAncestorOf node: SyntaxNode) -> ControlFlowGraphNode? {
        var current: SyntaxNode? = node

        while let c = current {
            if let graphNode = graphNode(for: c) {
                return graphNode
            }

            current = c.parent
        }

        return nil
    }
    
    /// Returns all outgoing edges for a given control flow graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func edges(from node: ControlFlowGraphNode) -> [ControlFlowGraphEdge] {
        edges.filter { $0.start === node }
    }
    
    /// Returns all ingoing edges for a given control flow graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func edges(towards node: ControlFlowGraphNode) -> [ControlFlowGraphEdge] {
        edges.filter { $0.end === node }
    }
    
    /// Returns an existing edge between two nodes, or `nil`, if no edges between
    /// them currently exist.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func edge(from start: ControlFlowGraphNode, to end: ControlFlowGraphNode) -> ControlFlowGraphEdge? {
        edges.first { $0.start === start && $0.end === end }
    }
}

extension ControlFlowGraph {
    /// Returns a list of nodes collected in depth-first order
    func depthFirstList() -> [ControlFlowGraphNode] {
        var list: [ControlFlowGraphNode] = []
        
        depthFirstVisit(start: entry) {
            list.append($0.node)
            return true
        }
        
        return list
    }
    
    /// Returns a list of nodes collected in breadth-first order
    func breadthFirstList() -> [ControlFlowGraphNode] {
        var list: [ControlFlowGraphNode] = []
        
        breadthFirstVisit(start: entry) {
            list.append($0.node)
            return true
        }
        
        return list
    }
}

/// Specifies a control flow graph node
public class ControlFlowGraphNode: DirectedGraphNode, CustomStringConvertible {
    /// An associated node for this control flow graph node.
    public let node: SyntaxNode

    public var description: String {
        "{node: \(type(of: node)): \(node)}"
    }

    init(node: SyntaxNode) {
        self.node = node
    }
}

/// Represents an entry node for a control flow graph
public final class ControlFlowGraphEntryNode: ControlFlowGraphNode {
    
}

/// Represents an exit node for a control flow graph
public final class ControlFlowGraphExitNode: ControlFlowGraphNode {
    
}

/// A graph node which contains a complete subgraph
public final class ControlFlowSubgraphNode: ControlFlowGraphNode {
    /// An associated node for this control flow graph node.
    public let graph: ControlFlowGraph
    
    init(node: SyntaxNode, graph: ControlFlowGraph) {
        self.graph = graph
        
        super.init(node: node)
    }
}

/// A graph node that signifies the end of a definition scope.
public final class ControlFlowGraphEndScopeNode: ControlFlowGraphNode {
    /// An associated code scope for this control flow graph node.
    public let scope: CodeScopeNode

    init(node: SyntaxNode, scope: CodeScopeNode) {
        self.scope = scope

        super.init(node: node)
    }
}

/// Represents a directed edge in a control flow graph.
public final class ControlFlowGraphEdge: DirectedGraphEdge {
    public let start: ControlFlowGraphNode
    public let end: ControlFlowGraphNode
    
    /// True if this is a back edge which points backwards towards the start of
    /// a flow
    public var isBackEdge: Bool = false

    /// A label that can be used during debugging to discern CFG edges.
    public var debugLabel: String?
    
    init(start: ControlFlowGraphNode, end: ControlFlowGraphNode) {
        self.start = start
        self.end = end
    }
}
