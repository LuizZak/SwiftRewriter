import MiniDigraph

/// A base class for directed graph class implementations in this module.
public class DirectedGraphBase<Node, Edge: DirectedGraphBaseEdgeType>: DirectedGraphType where Edge.Node == Node {
    /// A list of all nodes contained in this graph
    internal(set) public var nodes: Set<Node> = []
    /// A list of all edges contained in this graph
    internal(set) public var edges: Set<Edge> = []

    /// Initializes an empty directed graph.
    required convenience init() {
        self.init(nodes: [], edges: [])
    }

    init(nodes: [Node], edges: [Edge]) {
        self.nodes = Set(nodes)
        self.edges = Set(edges)
    }

    init(nodes: Set<Node>, edges: Set<Edge>) {
        self.nodes = nodes
        self.edges = edges
    }

    public func subgraph<S>(of nodes: S) -> Self where S: Sequence, S.Element == Node {
        let nodeSet = Set(nodes)
        let connectedEdges = self.edges.filter {
            nodeSet.contains($0.start) && nodeSet.contains($0.end)
        }

        let graph = Self()
        graph.addNodes(nodeSet)

        for edge in connectedEdges {
            graph.addEdge(from: edge.start, to: edge.end)
        }

        return graph
    }

    /// Returns `true` iff two node references represent the same underlying node
    /// in this graph.
    public func areNodesEqual(_ node1: Node, _ node2: Node) -> Bool {
        node1 === node2
    }

    /// Returns whether a given graph node exists in this graph.
    ///
    /// A reference equality test (===) is used to determine syntax node equality.
    public func containsNode(_ node: Node) -> Bool {
        nodes.contains { $0 === node }
    }

    @inlinable
    public func startNode(for edge: Edge) -> Node {
        edge.start
    }

    @inlinable
    public func endNode(for edge: Edge) -> Node {
        edge.end
    }

    /// Returns all outgoing edges for a given graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func edges(from node: Node) -> Set<Edge> {
        edges.filter { $0.start === node }
    }

    /// Returns all ingoing edges for a given graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func edges(towards node: Node) -> Set<Edge> {
        edges.filter { $0.end === node }
    }

    /// Returns an existing edge between two nodes, or `nil`, if no edges between
    /// them currently exist.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func edge(from start: Node, to end: Node) -> Edge? {
        edges.first { $0.start === start && $0.end === end }
    }

    // MARK: - Internals

    func copyMetadata(from node1: Node, to node2: Node) {

    }

    func copyMetadata(from edge1: Edge, to edge2: Edge) {

    }

    /// Removes all nodes and edges from this graph.
    func clear() {
        nodes.removeAll()
        edges.removeAll()
    }

    /// Adds a given node to this graph.
    func addNode(_ node: Node) {
        assert(
            !self.containsNode(node),
            "Node \(node) already exists in this graph"
        )

        nodes.insert(node)
    }

    /// Adds a sequence of nodes to this graph.
    func addNodes<S: Sequence>(_ nodes: S) where S.Element == Node {
        nodes.forEach(addNode)
    }

    /// Adds an edge `start -> end` to this graph, if one doesn't already exists.
    @discardableResult
    func ensureEdge(from start: Node, to end: Node) -> Edge {
        if let existing = edge(from: start, to: end) {
            return existing
        }

        return addEdge(from: start, to: end)
    }

    /// Adds an edge `start -> end` to this graph.
    @discardableResult
    func addEdge(from start: Node, to end: Node) -> Edge {
        fatalError("Must be implemented by subclasses")
    }

    /// Adds a given edge to this graph.
    func addEdge(_ edge: Edge) {
        edges.insert(edge)
    }

    /// Removes an edge between two nodes from this graph.
    func removeEdge(from start: Node, to end: Node) {
        func predicate(_ edge: Edge) -> Bool {
            areNodesEqual(edge.start, start) && self.areNodesEqual(edge.end, end)
        }

        assert(
            edges.contains(where: predicate),
            "Attempted to remove edge from nodes \(start) -> \(end) that do not exist in this graph."
        )

        edges = edges.filter({ !predicate($0) })
    }

    /// Removes a given node from this graph.
    func removeNode(_ node: Node) {
        assert(
            containsNode(node),
            "Attempted to remove a node that is not present in this graph: \(node)."
        )

        removeEdges(allEdges(for: node))
        nodes = nodes.filter({ $0 !== node })
    }

    /// Removes a given sequence of edges from this graph.
    func removeEdges<S: Sequence>(_ edgesToRemove: S) where S.Element == Edge {
        edges = edges.filter({ !edgesToRemove.contains($0) })
    }

    /// Removes a given sequence of nodes from this graph.
    func removeNodes<S: Sequence>(_ nodesToRemove: S) where S.Element == Node {
        nodes = nodes.filter({ !nodesToRemove.contains($0) })
    }

    /// Removes the entry edges from a given node.
    @discardableResult
    func removeEntryEdges(towards node: Node) -> Set<Edge> {
        let connections = edges(towards: node)
        removeEdges(connections)
        return connections
    }

    /// Removes the exit edges from a given node.
    @discardableResult
    func removeExitEdges(from node: Node) -> Set<Edge> {
        let connections = edges(from: node)
        removeEdges(connections)
        return connections
    }

    /// Moves the entry edges from a given node to a target node.
    ///
    /// The existing entry edges for `other` are kept as is.
    ///
    /// The return list contains the new edges that where created.
    @discardableResult
    func redirectEntries(for node: Node, to other: Node) -> [Edge] {
        var result: [Edge] = []

        for connection in removeEntryEdges(towards: node) {
            guard !areConnected(start: connection.start, end: other) else {
                continue
            }

            let edge = addEdge(from: connection.start, to: other)
            copyMetadata(from: connection, to: edge)

            result.append(edge)
        }

        return result
    }

    /// Moves the exit edges from a given node to a target node.
    ///
    /// The existing exit edges for `other` are kept as is.
    ///
    /// The return list contains the new edges that where created.
    @discardableResult
    func redirectExits(for node: Node, to other: Node) -> [Edge] {
        var result: [Edge] = []

        for connection in removeExitEdges(from: node) {
            guard !areConnected(start: other, end: connection.end) else {
                continue
            }

            let edge = addEdge(from: other, to: connection.end)
            copyMetadata(from: connection, to: edge)

            result.append(edge)
        }

        return result
    }

    /// Prepends a node before a suffix node, redirecting the entries to the
    /// suffix node to the prefix node, and adding an edge from the prefix to the
    /// suffix node.
    func prepend(_ node: Node, before next: Node) {
        if !containsNode(node) {
            addNode(node)
        } else {
            let fromEdges = edges(from: node)
            removeEdges(fromEdges)
        }

        redirectEntries(for: next, to: node)
        addEdge(from: node, to: next)
    }
}

public protocol DirectedGraphBaseEdgeType: AnyObject, Hashable, DirectedGraphEdge {
    associatedtype Node: AnyObject & Hashable

    var start: Node { get }
    var end: Node { get }
}
