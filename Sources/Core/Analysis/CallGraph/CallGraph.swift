import Intentions

/// Represents call order dependencies of functions and variable initializers in
/// a program.
public class CallGraph: DirectedGraphBase<CallGraphNode, CallGraphEdge> {
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

    public static func fromIntentions(_ intentionCollection: IntentionCollection) -> CallGraph {
        _fromIntentions(intentionCollection)
    }

    @discardableResult
    func ensureNode(_ declaration: FunctionBodyCarryingIntention) -> Node {
        if let node = nodes.first(where: { $0.declaration == declaration }) {
            return node
        }

        let node = Node(declaration: declaration)
        return node
    }
}

/// A node in a call graph.
public class CallGraphNode: DirectedGraphNode {
    public let declaration: FunctionBodyCarryingIntention

    init(declaration: FunctionBodyCarryingIntention) {
        self.declaration = declaration
    }
}

/// An edge in a call graph.
public class CallGraphEdge: DirectedGraphBaseEdgeType {
    public let start: CallGraphNode
    public let end: CallGraphNode

    internal init(start: CallGraphNode, end: CallGraphNode) {
        self.start = start
        self.end = end
    }
}
