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
    func depthFirstVisit(_ visitor: (Node) -> Void)
    
    /// Performs a breadth-first visiting of this control flow graph
    @inlinable
    func breadthFirstVisit(_ visitor: (Node) -> Void)
}

public extension DirectedGraph {
    @inlinable
    public func areEdgesEqual(_ edge1: Edge, _ edge2: Edge) -> Bool {
        return areNodesEqual(startNode(for: edge1), startNode(for: edge2))
            && areNodesEqual(endNode(for: edge1), endNode(for: edge2))
    }
    
    /// Performs a depth-first visiting of this control flow graph
    @inlinable
    public func depthFirstVisit(_ visitor: (Node) -> Void) {
        var visited: Set<Node> = []
        var queue: [Node] = []
        
        queue.append(entry)
        
        while let next = queue.popLast() {
            visited.insert(next)
            
            visitor(next)
            
            for nextNode in nodesConnected(from: next) where !visited.contains(nextNode) {
                queue.append(nextNode)
            }
        }
    }
    
    /// Performs a breadth-first visiting of this control flow graph
    @inlinable
    public func breadthFirstVisit(_ visitor: (Node) -> Void) {
        var visited: Set<Node> = []
        var queue: [Node] = []
        
        queue.append(entry)
        
        while !queue.isEmpty {
            let next = queue.removeFirst()
            
            visited.insert(next)
            
            visitor(next)
            
            for nextNode in nodesConnected(from: next) where !visited.contains(nextNode) {
                queue.append(nextNode)
            }
        }
    }
}

public protocol DirectedGraphEdge: Hashable {
    
}
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
