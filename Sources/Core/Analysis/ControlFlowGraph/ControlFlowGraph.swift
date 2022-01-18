import SwiftAST
import TypeSystem

/// Class that represents control flow graphs (CFGs) of Swift functions.
public final class ControlFlowGraph: DirectedGraphBase<ControlFlowGraphNode, ControlFlowGraphEdge> {
    /// The entry point of this control flow graph
    internal(set) public var entry: ControlFlowGraphEntryNode
    /// The exit point of this control flow graph
    internal(set) public var exit: ControlFlowGraphExitNode
    
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

        super.init(nodes: [], edges: [])
        
        addNode(entry)
        addNode(exit)
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
    
    // MARK: - Internals

    override func copyMetadata(from node1: ControlFlowGraphNode, to node2: ControlFlowGraphNode) {
    
    }

    override func copyMetadata(from edge1: ControlFlowGraphEdge, to edge2: ControlFlowGraphEdge) {
        edge2.debugLabel = edge1.debugLabel
        edge2.isBackEdge = edge1.isBackEdge
    }

    /// Removes all nodes and edges from this control flow graph.
    ///
    /// The graph is reset to an empty graph with just the entry and exit nodes.
    override func clear() {
        super.clear()

        nodes = [entry, exit]
    }

    /// Adds a given node to this graph.
    override func addNode(_ node: Node) {
        if let subgraph = node as? ControlFlowSubgraphNode {
            assert(
                subgraph.graph !== self,
                "Adding a graph as a subnode of itself!"
            )
        }
        
        super.addNode(node)
    }

    /// Adds an edge `start -> end` to this graph.
    @discardableResult
    override func addEdge(from start: Node, to end: Node) -> Edge {
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
}

// MARK: - Internals - extension

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

extension ControlFlowGraph {
    /// Returns a copy of this control flow graph, containing the same node
    /// references as the current graph.
    func copy() -> ControlFlowGraph {
        let copy = ControlFlowGraph(entry: entry, exit: exit)
        copy.nodes = nodes
        
        for edge in edges {
            let edgeCopy = copy.addEdge(from: edge.start, to: edge.end)
            copyMetadata(from: edge, to: edgeCopy)
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
            copyMetadata(from: edge, to: edgeCopy)
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
            copyMetadata(from: edge, to: e)
        }
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
public final class ControlFlowGraphEdge: DirectedGraphBaseEdgeType {
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
