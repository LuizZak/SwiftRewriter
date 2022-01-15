import SwiftAST
import TypeSystem

/// Class that represents control flow graphs (CFGs) of Swift functions.
public final class ControlFlowGraph: DirectedGraph {
    /// The entry point of this control flow graph
    internal(set) public var entry: ControlFlowGraphEntryNode
    /// The exit point of this control flow graph
    internal(set) public var exit: ControlFlowGraphExitNode
    
    /// A list of all nodes contained in this graph
    internal(set) public var nodes: [ControlFlowGraphNode] = []
    /// A list of all edges contained in this graph
    internal(set) public var edges: [ControlFlowGraphEdge] = []

    /// Returns `true` if the only nodes in this graph are the entry and exit
    /// nodes, and marker nodes.
    var isEmpty: Bool {
        return nodes.allSatisfy { node in
            node === entry || node === exit
        }
    }
    
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
            if let result = graphNode(for: node) {
                return result
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

// MARK: - Internals

extension ControlFlowGraph {
    /// Removes all nodes and edges from this control flow graph.
    ///
    /// The graph is reset to an empty graph with just the entry and exit nodes.
    func clear() {
        nodes.removeAll()
        edges.removeAll()

        nodes = [entry, exit]
    }

    /// Returns a copy of this control flow graph, containing the same node
    /// references as the current graph.
    func copy() -> ControlFlowGraph {
        let copy = ControlFlowGraph(entry: entry, exit: exit)
        copy.nodes = nodes
        
        for edge in edges {
            let edgeCopy = copy.addEdge(from: edge.start, to: edge.end)
            edgeCopy.isBackEdge = edge.isBackEdge
            edgeCopy.debugLabel = edge.debugLabel
        }

        return copy
    }

    /// Performs a deep-copy of this control flow graph, returning a CFG that
    /// points to the same syntax node references, but has independent edge/node
    /// reference identities.
    func deepCopy() -> ControlFlowGraph {
        let copy = ControlFlowGraph(entry: entry, exit: exit)
        copy.nodes = nodes
        
        for edge in edges {
            let edgeCopy = copy.addEdge(from: edge.start, to: edge.end)
            edgeCopy.isBackEdge = edge.isBackEdge
            edgeCopy.debugLabel = edge.debugLabel
        }

        return copy
    }

    /// Merges another graph's nodes and edges into this graph.
    ///
    /// If `ignoreEntryExit` is `true` (default), the entry and exit nodes from
    /// the other graph are not merged, and any connection from and to the entry
    /// and exit are not copied.
    ///
    /// If `ignoreRepeated` is `true`, nodes and edges that already exist in this
    /// graph are not added.
    func merge(
        with other: ControlFlowGraph,
        ignoreEntryExit: Bool = true,
        ignoreRepeated: Bool = false
    ) {
        
        assert(other !== self, "attempting to merge a graph with itself!")

        func shouldMerge(_ node: ControlFlowGraphNode) -> Bool {
            if !ignoreEntryExit {
                return true
            }

            return node !== other.entry && node !== other.exit
        }

        let nodes = other.nodes.filter(shouldMerge)
        
        let edges = other.edges.filter {
            shouldMerge($0.start) && shouldMerge($0.end)
        }
        
        for node in nodes {
            if ignoreRepeated && containsNode(node) {
                continue
            }

            addNode(node)
        }
        for edge in edges {
            if ignoreRepeated {
                guard containsNode(edge.start) && containsNode(edge.end) else {
                    continue
                }
                guard !areConnected(start: edge.start, end: edge.end) else {
                    continue
                }
            }

            let e = addEdge(from: edge.start, to: edge.end)
            e.isBackEdge = edge.isBackEdge
            e.debugLabel = edge.debugLabel
        }
    }
    
    /// Adds a given node to this graph.
    func addNode(_ node: Node) {
        if let subgraph = node as? ControlFlowSubgraphNode {
            assert(
                subgraph.graph !== self,
                "Adding a graph as a subnode of itself!"
            )
        }
        assert(
            !self.containsNode(node),
            "Node \(node) already exists in this graph"
        )
        
        nodes.append(node)
    }

    /// Adds a sequence of nodes to this graph.
    func addNodes<S: Sequence>(_ nodes: S) where S.Element == Node {
        nodes.forEach(addNode)
    }
    
    /// Adds a given edge to this graph.
    func addEdge(_ edge: Edge) {
        assert(
            self.edge(from: edge.start, to: edge.end) == nil,
            "An edge between nodes \(edge.start.node) and \(edge.end.node) already exists within this graph"
        )
        
        edges.append(edge)
    }
    
    /// Adds an edge `start -> end` to this graph.
    @discardableResult
    func addEdge(from start: Node, to end: Node) -> Edge {
        assert(
            containsNode(start),
            "Attempted to add edge between nodes that are not contained within this graph: \(start)."
        )
        assert(
            containsNode(end),
            "Attempted to add edge between nodes that are not contained within this graph: \(end)."
        )
        
        let edge = Edge(start: start, end: end)
        addEdge(edge)
        
        return edge
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

        edges.removeAll(where: predicate)
    }
    
    /// Removes a given node from this graph.
    func removeNode(_ node: Node) {
        assert(
            containsNode(node),
            "Attempted to remove a node that is not present in this graph: \(node)."
        )

        removeEdges(allEdges(for: node))
        nodes.removeAll(where: { $0 === node })
    }
    
    /// Removes a given sequence of edges from this graph.
    func removeEdges<S: Sequence>(_ edgesToRemove: S) where S.Element == Edge {
        edges.removeAll(where: edgesToRemove.contains)
    }
    
    /// Removes a given sequence of nodes from this graph.
    func removeNodes<S: Sequence>(_ nodesToRemove: S) where S.Element == Node {
        nodes.removeAll(where: nodesToRemove.contains)
    }

    /// Removes the entry edges from a given node.
    @discardableResult
    func removeEntryEdges(towards node: Node) -> [Edge] {
        let connections = edges(towards: node)
        removeEdges(connections)
        return connections
    }

    /// Removes the exit edges from a given node.
    @discardableResult
    func removeExitEdges(from node: Node) -> [Edge] {
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
    func redirectEntries(for node: Node, to other: Node) -> [ControlFlowGraphEdge] {
        var result: [ControlFlowGraphEdge] = []

        for connection in removeEntryEdges(towards: node) {
            guard !areConnected(start: connection.start, end: other) else {
                continue
            }

            let edge = addEdge(from: connection.start, to: other)
            edge.debugLabel = connection.debugLabel

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
    func redirectExits(for node: Node, to other: Node) -> [ControlFlowGraphEdge] {
        var result: [ControlFlowGraphEdge] = []

        for connection in removeExitEdges(from: node) {
            guard !areConnected(start: other, end: connection.end) else {
                continue
            }

            let edge = addEdge(from: other, to: connection.end)
            edge.debugLabel = connection.debugLabel

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

// MARK: - Debug internals

internal extension ControlFlowGraph {
    func dumpState() -> String {
        var buffer: String = ""

        for node in nodes {
            print(node, to: &buffer)
        }

        print(to: &buffer)

        for edge in edges {
            print("\(edge.start) -> \(edge.end)", terminator: "", to: &buffer)
            if let debugLabel = edge.debugLabel {
                print(" (\(debugLabel))", terminator: "", to: &buffer)
            }

            print(to: &buffer)
        }

        return buffer
    }
}

// MARK: - Utilities

internal extension ControlFlowGraph {
    /// Prunes this control flow graph, removing any nodes that are unreachable
    /// from its initial node.
    func prune() {
        var toRemove: Set<Node> = Set(nodes)

        breadthFirstVisit(start: entry) { visit in
            toRemove.remove(visit.node)
            
            return true
        }

        toRemove.forEach(removeNode)
    }

    /// Marks back edges for a graph.
    ///
    /// A back edge is an edge that connects one node to another node that comes
    /// earlier in the graph when visiting the graph in depth-first fashion
    /// starting from its entry point.
    func markBackEdges() {
        // TODO: Can use breadthFirstVisit now that the new visit element has the
        // TODO: visited nodes/path information built in it?

        var queue: [(start: ControlFlowGraphNode, visited: [ControlFlowGraphNode])] = []
        
        queue.append((entry, [entry]))
        
        while let next = queue.popLast() {
            for nextEdge in edges(from: next.start) {
                let node = nextEdge.end
                if next.visited.contains(node) {
                    nextEdge.isBackEdge = true
                    continue
                }
                
                queue.append((node, next.visited + [node]))
            }
        }
    }
    
    /// Expands subgraph nodes in this graph, performing a many-to-many expansion
    /// of the edges going in and out of the subgraph node.
    func expandSubgraphs() {
        for case let node as ControlFlowSubgraphNode in nodes {
            let edgesTo = edges(towards: node)
            let edgesFrom = edges(from: node)
            
            let entryEdges = node.graph.edges(from: node.graph.entry)
            let exitEdges = node.graph.edges(towards: node.graph.exit)
            
            removeNode(node)
            
            merge(with: node.graph)
            
            for edgeTo in edgesTo {
                let source = edgeTo.start
                
                for entryEdge in entryEdges {
                    let target = entryEdge.end
                    
                    let edge = addEdge(from: source, to: target)
                    edge.isBackEdge = edgeTo.isBackEdge
                }
            }
            for edgeFrom in edgesFrom {
                let target = edgeFrom.end
                
                for exitEdge in exitEdges {
                    let source = exitEdge.start
                    
                    let edge = addEdge(from: source, to: target)
                    edge.isBackEdge = edgeFrom.isBackEdge
                }
            }
        }
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

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(node))
    }

    /// Returns a copy of this graph node, pointing to the same underlying
    /// syntax node reference.
    public func copy() -> ControlFlowGraphNode {
        ControlFlowGraphNode(node: node)
    }

    public static func == (lhs: ControlFlowGraphNode, rhs: ControlFlowGraphNode) -> Bool {
        //type(of: lhs) == type(of: rhs) && lhs.node === rhs.node
        lhs === rhs
    }
}

/// Represents an entry node for a control flow graph
public final class ControlFlowGraphEntryNode: ControlFlowGraphNode {
    public override var description: String {
        "{entry: \(type(of: node)): \(node)}"
    }

    public override func copy() -> ControlFlowGraphEntryNode {
        ControlFlowGraphEntryNode(node: node)
    }
}

/// Represents an exit node for a control flow graph
public final class ControlFlowGraphExitNode: ControlFlowGraphNode {
    public override var description: String {
        "{exit: \(type(of: node)): \(node)}"
    }

    public override func copy() -> ControlFlowGraphExitNode {
        ControlFlowGraphExitNode(node: node)
    }
}

/// A graph node which contains a complete subgraph
public final class ControlFlowSubgraphNode: ControlFlowGraphNode {
    /// An associated node for this control flow graph node.
    public let graph: ControlFlowGraph
    
    init(node: SyntaxNode, graph: ControlFlowGraph) {
        self.graph = graph
        
        super.init(node: node)
    }

    public override func copy() -> ControlFlowGraphNode {
        ControlFlowSubgraphNode(node: node, graph: graph.deepCopy())
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

    public override func copy() -> ControlFlowGraphNode {
        ControlFlowGraphEndScopeNode(node: node, scope: scope)
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

    /// Returns a copy of this control flow graph edge.
    ///
    /// The new edge object references the same underlying node references.
    public func copy() -> ControlFlowGraphEdge {
        ControlFlowGraphEdge(start: start, end: end)
    }
}

extension Sequence where Element: ControlFlowGraphEdge {
    @discardableResult
    func setDebugLabel(_ debugLabel: String?) -> [Element] {
        map {
            $0.debugLabel = debugLabel
            return $0
        }
    }
}
