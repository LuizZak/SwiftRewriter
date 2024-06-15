import MiniGraphviz

struct NodeDefinition<Node: Hashable> {
    var node: Node

    /// Rank of the node, or the minimal number of edges that connect the node
    /// to the entry of the graph.
    ///
    /// Is `0` for the entry node, and the maximal value for the exit node.
    ///
    /// If the node is not connected to the entry node, this value is `nil`.
    var rankFromStart: Int?

    /// Rank of the node, or the minimal number of edges that connect the node
    /// to the exit of the graph.
    ///
    /// Is `0` for the exit node, and the maximal value for the entry node.
    ///
    /// If the node is not connected to the exit node, this value is `nil`.
    var rankFromEnd: Int?

    /// Display label for the graphviz node.
    var label: String

    /// An integer used to differentiate nodes for ordering purposes.
    var id: Int = 0

    /// Extra set of attributes for a graphviz node.
    var attributes: GraphViz.Attributes = [:]
}
