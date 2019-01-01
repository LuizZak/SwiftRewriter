/// A protocol for representing directed graphs
public protocol DirectedGraph {
    associatedtype Edge: DirectedGraphEdge
    associatedtype Node: DirectedGraphNode
    
    /// The entry node for this graph
    var entry: Node { get }
    /// The exit node for this graph
    var exit: Node { get }
    
    /// Returns `true` iff two edges are equivalent (i.e. have the same start/end
    /// nodes).
    @inlinable
    func areEdgesEqual(_ edge1: Edge, _ edge2: Edge) -> Bool
    
    /// Returns `true` iff two node references represent the same underlying node
    /// in this graph.
    @inlinable
    func areNodesEqual(_ node1: Node, _ node2: Node) -> Bool
    
    /// Returns the starting edge for a given node on this graph.
    @inlinable
    func startNode(for edge: Edge) -> Node
    
    /// Returns the ending edge for a given node on this graph.
    @inlinable
    func endNode(for edge: Edge) -> Node
    
    /// Returns all ingoing and outgoing edges for a given control flow graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    @inlinable
    func allEdges(for node: Node) -> [Edge]
    
    /// Returns all outgoing edges for a given control flow graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    @inlinable
    func edges(from node: Node) -> [Edge]
    
    /// Returns all ingoing edges for a given control flow graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    @inlinable
    func edges(towards node: Node) -> [Edge]
    
    /// Returns an existing edge between two nodes, or `nil`, if no edges between
    /// them currently exist.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    @inlinable
    func edge(from start: Node, to end: Node) -> Edge?
    
    /// Returns all graph nodes that are connected from a given control flow graph
    /// node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    @inlinable
    func nodesConnected(from node: Node) -> [Node]
    
    /// Returns all graph nodes that are connected towards a given control flow
    /// graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    @inlinable
    func nodesConnected(towards node: Node) -> [Node]
    
    /// Returns all graph nodes that are connected towards and from the given
    /// graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    @inlinable
    func allNodesConnected(to node: Node) -> [Node]
    
    /// Performs a depth-first visiting of this control flow graph
    @inlinable
    func depthFirstVisit(_ visitor: (DirectedGraphVisitElement<Edge, Node>) -> Void)
    
    /// Performs a breadth-first visiting of this control flow graph
    @inlinable
    func breadthFirstVisit(_ visitor: (DirectedGraphVisitElement<Edge, Node>) -> Void)
}

/// Element for a graph visiting operation.
///
/// - root: The item represents the root of a directed graph
/// - edge: The item represents an edge, pointing to a node of the graph
public enum DirectedGraphVisitElement<E: DirectedGraphEdge, N: DirectedGraphNode> {
    case root(N)
    case edge(E, towards: N)
    
    public var node: N {
        switch self {
        case .root(let node), .edge(_, let node):
            return node
        }
    }
}

public extension DirectedGraph {
    @inlinable
    public func areEdgesEqual(_ edge1: Edge, _ edge2: Edge) -> Bool {
        return areNodesEqual(startNode(for: edge1), startNode(for: edge2))
            && areNodesEqual(endNode(for: edge1), endNode(for: edge2))
    }
    
    @inlinable
    public func allEdges(for node: Node) -> [Edge] {
        return edges(towards: node) + edges(from: node)
    }
    
    @inlinable
    public func nodesConnected(from node: Node) -> [Node] {
        return edges(from: node).map(self.endNode(for:))
    }
    
    @inlinable
    public func nodesConnected(towards node: Node) -> [Node] {
        return edges(towards: node).map(self.startNode(for:))
    }
    
    @inlinable
    public func allNodesConnected(to node: Node) -> [Node] {
        return nodesConnected(towards: node) + nodesConnected(from: node)
    }
    
    /// Performs a depth-first visiting of this control flow graph
    @inlinable
    public func depthFirstVisit(_ visitor: (DirectedGraphVisitElement<Edge, Node>) -> Void) {
        var visited: Set<Node> = []
        var queue: [DirectedGraphVisitElement<Edge, Node>] = []
        
        queue.append(.root(entry))
        
        while let next = queue.popLast() {
            visited.insert(next.node)
            
            visitor(next)
            
            for nextEdge in edges(from: next.node) {
                let node = endNode(for: nextEdge)
                if visited.contains(node) {
                    continue
                }
                
                queue.append(.edge(nextEdge, towards: node))
            }
        }
    }
    
    /// Performs a breadth-first visiting of this control flow graph
    @inlinable
    public func breadthFirstVisit(_ visitor: (DirectedGraphVisitElement<Edge, Node>) -> Void) {
        var visited: Set<Node> = []
        var queue: [DirectedGraphVisitElement<Edge, Node>] = []
        
        queue.append(.root(entry))
        
        while !queue.isEmpty {
            let next = queue.removeFirst()
            visited.insert(next.node)
            
            visitor(next)
            
            for nextEdge in edges(from: next.node) {
                let node = endNode(for: nextEdge)
                if visited.contains(node) {
                    continue
                }
                
                queue.append(.edge(nextEdge, towards: node))
            }
        }
    }
}

/// A protocol for representing a directed graph's edge
public protocol DirectedGraphEdge: Hashable {
    
}

/// A protocol for representing a directed graph's node
public protocol DirectedGraphNode: Hashable {
    
}

public extension DirectedGraphEdge where Self: AnyObject {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

public extension DirectedGraphNode where Self: AnyObject {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs === rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
