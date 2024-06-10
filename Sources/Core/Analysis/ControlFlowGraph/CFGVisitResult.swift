import SwiftAST

public struct CFGVisitResult {
    public var graph: ControlFlowGraph
    public var unresolvedJumps: [UnresolvedJump]

    /// Gets the entry node for this graph result.
    public var entry: ControlFlowGraphEntryNode {
        graph.entry
    }

    /// Gets the exit node for this graph result.
    public var exit: ControlFlowGraphExitNode {
        graph.exit
    }

    /// Initializes a graph from a syntax node, `entry -> syntaxNode -> exit`.
    init(forSyntaxNode syntaxNode: SyntaxNode, id: Int) {
        self.init(forNode: ControlFlowGraphNode(node: syntaxNode, id: id))
    }

    /// Initializes a graph from a graph node, `entry -> node -> exit`.
    init(forNode node: ControlFlowGraphNode) {
        self.init()

        graph.prepend(node, before: exit)
    }

    /// Initializes a graph from a syntax node that points to an unresolved jump,
    /// which branches off from the main exit, which remains unconnected.
    ///
    /// `entry -> syntaxNode -> jump X-> exit`.
    init(
        forUnresolvedJumpSyntaxNode syntaxNode: SyntaxNode,
        kind: UnresolvedJump.Kind,
        id: Int
    ) {

        let node = ControlFlowGraphNode(node: syntaxNode, id: id)

        self.init()

        let jump = UnresolvedJump(
            node: ControlFlowGraphNode(node: MarkerSyntaxNode(), id: id),
            kind: kind
        )

        graph.prepend(node, before: exit)
        graph.removeEdge(from: node, to: exit)
        graph.addNode(jump.node)
        graph.addEdge(from: node, to: jump.node)

        unresolvedJumps = [jump]
    }

    /// Initializes a graph where the entry points to an unresolved jump, with no
    /// connection to the exit.
    ///
    /// `entry -> jump X-> exit`.
    init(forUnresolvedJump kind: UnresolvedJump.Kind, id: Int) {
        self.init()

        let jump = UnresolvedJump(
            node: ControlFlowGraphNode(node: MarkerSyntaxNode(), id: id),
            kind: kind
        )

        graph.prepend(jump.node, before: exit)
        graph.removeEdge(from: jump.node, to: exit)

        unresolvedJumps = [jump]
    }

    /// Initializes a graph from a syntax node that points to both the exit
    /// and to an unresolved jump node.
    ///
    /// ```
    /// entry -> syntaxNode --> exit
    ///                     \-> jump
    /// ```
    init(
        withBranchingSyntaxNode syntaxNode: SyntaxNode,
        toUnresolvedJump kind: UnresolvedJump.Kind,
        id: Int
    ) {

        let node = ControlFlowGraphNode(node: syntaxNode, id: id)

        self.init()

        let jump = UnresolvedJump(
            node: ControlFlowGraphNode(node: MarkerSyntaxNode(), id: id),
            kind: kind
        )

        graph.prepend(node, before: exit)
        graph.addNode(jump.node)
        graph.addEdge(from: node, to: jump.node)

        unresolvedJumps = [jump]
    }

    /// Initializes a graph where the entry node points to both the exit and to
    /// an unresolved jump node.
    ///
    /// ```
    /// entry --> exit
    ///       \-> jump
    /// ```
    init(branchingToUnresolvedJump kind: UnresolvedJump.Kind, id: Int) {
        self.init()

        let jump = UnresolvedJump(
            node: ControlFlowGraphNode(node: MarkerSyntaxNode(), id: id),
            kind: kind
        )

        graph.addNode(jump.node)
        graph.addEdge(from: graph.entry, to: jump.node)

        unresolvedJumps = [jump]
    }

    /// Initializes an empty CFG visit result.
    init() {
        graph = ControlFlowGraph(
            entry: ControlFlowGraphEntryNode(node: MarkerSyntaxNode()),
            exit: ControlFlowGraphExitNode(node: MarkerSyntaxNode())
        )
        unresolvedJumps = []

        graph.addEdge(from: entry, to: exit)
    }

    func copy() -> Self {
        var copy = self
        copy.graph = self.graph.copy()
        copy.unresolvedJumps = self.unresolvedJumps
        return copy
    }

    /// Returns a copy of this graph result which is the combination of the graph
    /// from this result, and `other`, connected entry-to-exit, like a standard
    /// "fall-through" statement flow.
    ///
    /// The entry node from this graph is the entry of the result, and the exit
    /// node of `other` is the new exit node.
    ///
    /// Unresolved jump list are concatenated in the result.
    func then(_ other: Self, debugLabel: String? = nil) -> Self {
        let copy = self.inserting(other)
        let edge = copy.graph.addEdge(from: exit, to: other.entry)
        edge.debugLabel = debugLabel
        copy.graph.exit = other.exit

        return copy
    }

    /// Returns a copy of this graph result with a branch added between two
    /// nodes contained within this graph.
    func branching(
        from start: ControlFlowGraphNode,
        to end: ControlFlowGraphNode,
        debugLabel: String? = nil
    ) -> Self {

        let copy = self.copy()
        let edge = copy.graph.addEdge(from: start, to: end)
        edge.debugLabel = debugLabel

        return copy
    }

    /// Returns a copy of this graph with the graph's exit point pointing to a
    /// graph that points back to another node in this same graph, forming a loop.
    ///
    /// If `conditional` is `true`, a branch between this graph's current exit
    /// node and the exit node of the resulting graph is left.
    func thenLoop(
        backTo node: ControlFlowGraphNode,
        conditionally conditional: Bool,
        debugLabel: String? = nil
    ) -> Self {

        let loopStart = exit

        let dummy = Self()

        let copy = self
            .then(dummy)
            .branching(
                from: loopStart,
                to: node,
                debugLabel: debugLabel
            )

        if !conditional {
            if copy.graph.areConnected(start: loopStart, end: dummy.entry) {
                copy.graph.removeEdge(from: loopStart, to: dummy.entry)
            }
        }

        return copy
    }

    /// Returns a copy of this graph result with all edges that point to a given
    /// node redirected to point to a given target node, instead.
    func redirectingEntries(
        for source: ControlFlowGraphNode,
        to target: ControlFlowGraphNode,
        debugLabel: String? = nil
    ) -> Self {

        let copy = self.copy()
        copy.graph.redirectEntries(for: source, to: target).setDebugLabel(debugLabel)

        return copy
    }

    /// Returns a copy of this graph result with all edges that start from a given
    /// node redirected to point to a given target node, instead.
    func redirectingExits(
        for source: ControlFlowGraphNode,
        to target: ControlFlowGraphNode,
        debugLabel: String? = nil
    ) -> Self {

        let copy = self.copy()
        copy.graph.redirectExits(for: source, to: target).setDebugLabel(debugLabel)

        return copy
    }

    /// Returns a copy of this graph result which is the combination of the graph
    /// from this result, and `other`, unconnected.
    ///
    /// The entry and exit of the resulting graph will still be the entry/exit
    /// from `self`.
    ///
    /// Unresolved jump list are concatenated in the result.
    func inserting(_ other: Self) -> Self {
        var copy = self.copy()
        copy.graph.merge(
            with: other.graph,
            ignoreEntryExit: false,
            ignoreRepeated: true
        )
        copy.unresolvedJumps.append(contentsOf: other.unresolvedJumps)

        return copy
    }

    /// Returns a copy of this graph with a set of defer subgraphs appended to
    /// all jump nodes.
    ///
    /// The subgraphs are provided on-demand by a closure which gets executed
    /// for each jump node that requires an independent defer structure.
    func appendingLazyDefersToJumps(_ closure: () -> [CFGVisitResult]) -> Self {
        var copy = self.copy()

        for jump in copy.unresolvedJumps {
            let subgraphs = closure()
            let deferSubgraph = subgraphs.reduce(Self()) { $0.then($1) }

            copy = copy.inserting(deferSubgraph)

            copy.graph.redirectEntries(for: jump.node, to: deferSubgraph.entry)
            copy.graph.addEdge(from: deferSubgraph.exit, to: jump.node)
        }

        return copy
    }

    /// Returns a copy of this CFG result, with any entry/exit nodes that are
    /// in the middle of a flow expanded in many-to-many fashion.
    func finalized() -> Self {
        let copy = self.copy()

        for node in copy.graph.nodes {
            if node === copy.graph.entry || node === copy.graph.exit {
                continue
            }

            if node is ControlFlowGraphEntryNode || node is ControlFlowGraphExitNode {
                _expandAndRemove(node: node, in: copy.graph)
            }
        }

        return copy
    }

    /// Returns a list of unresolved jumps from this graph result that match a
    /// specified kind.
    public func unresolvedJumps(ofKind kind: UnresolvedJump.Kind) -> [UnresolvedJump] {
        unresolvedJumps.filter { $0.kind == kind }
    }

    func resolvingJumpsToExit(kind: UnresolvedJump.Kind) -> Self {
        var copy = self.copy()
        copy.resolveJumpsToExit(kind: kind)
        return copy
    }

    mutating func resolveJumpsToExit(kind: UnresolvedJump.Kind) {
        resolveJumps(kind: kind, to: exit)
    }

    func resolvingJumps(kind: UnresolvedJump.Kind, to node: ControlFlowGraphNode) -> Self {
        var copy = self.copy()
        copy.resolveJumps(kind: kind, to: node)
        return copy
    }

    mutating func resolveJumps(kind: UnresolvedJump.Kind, to node: ControlFlowGraphNode) {
        func predicate(_ jump: UnresolvedJump) -> Bool {
            jump.kind == kind
        }

        for jump in unresolvedJumps.filter(predicate) {
            jump.resolve(to: node, in: graph)
        }

        unresolvedJumps.removeAll(where: predicate)
    }

    /// Returns a new graph a given list of jumps locally on this graph result.
    /// Jump nodes that are not present in this graph are added prior to resolution,
    /// and existing unresolved jumps that match node-wise with jumps from the
    /// given list are removed.
    func resolvingJumps(_ jumps: [UnresolvedJump], to node: ControlFlowGraphNode) -> Self {
        var copy = self.copy()
        copy.resolveJumps(jumps, to: node)

        return copy
    }

    /// Resolves a given list of jumps locally on this graph result.
    /// Jump nodes that are not present in this graph are added prior to resolution,
    /// and existing unresolved jumps that match node-wise with jumps from the
    /// given list are removed.
    mutating func resolveJumps(_ jumps: [UnresolvedJump], to node: ControlFlowGraphNode) {
        for jump in jumps {
            jump.resolve(to: node, in: graph)
        }

        unresolvedJumps.removeAll { u in
            jumps.contains { j in u.node === j.node }
        }
    }

    /// Returns a copy of this graph with all jumps from this graph result to a
    /// given node.
    func resolvingAllJumps(to node: ControlFlowGraphNode) -> Self {
        var copy = self.copy()
        copy.resolveAllJumps(to: node)

        return copy
    }

    /// Resolves all jumps from this graph result to a given node.
    mutating func resolveAllJumps(to node: ControlFlowGraphNode) {
        for jump in unresolvedJumps {
            jump.resolve(to: node, in: graph)
        }

        unresolvedJumps.removeAll()
    }

    /// Returns a copy of this graph with all jumps from this graph result to the
    /// current exit node.
    func resolvingAllJumpsToExit() -> Self {
        var copy = self.copy()
        copy.resolveAllJumpsToExit()

        return copy
    }

    /// Resolves all jumps from this graph result to the current exit node.
    mutating func resolveAllJumpsToExit() {
        for jump in unresolvedJumps {
            jump.resolve(to: exit, in: graph)
        }

        unresolvedJumps.removeAll()
    }

    /// Returns a copy of this subgraph with all jumps that match a specific
    /// kind removed.
    func removingJumps(kind: UnresolvedJump.Kind) -> Self {
        var copy = self.copy()
        copy.removeJumps(kind: kind)

        return copy
    }

    /// Removes all jumps that match a specific kind in this graph.
    mutating func removeJumps(kind: UnresolvedJump.Kind) {
        func predicate(_ jump: UnresolvedJump) -> Bool {
            jump.kind == kind
        }

        for jump in unresolvedJumps {
            if predicate(jump) {
                graph.removeNode(jump.node)
            }
        }

        unresolvedJumps.removeAll(where: predicate)
    }

    /// An unresolved jump from a CFG visit.
    public struct UnresolvedJump {
        public var node: ControlFlowGraphNode
        public var kind: Kind

        func resolve(to node: ControlFlowGraphNode, in graph: ControlFlowGraph) {
            connect(to: node, in: graph)

            expandAndRemove(in: graph)
        }

        func expandAndRemove(in graph: ControlFlowGraph) {
            if graph.edges(from: node).isEmpty {
                fatalError(
                    "Attempted to remove unresolved jump \(kind) before connecting it to other nodes."
                )
            }

            _expandAndRemove(node: node, in: graph)
        }

        func connect(to target: ControlFlowGraphNode, in graph: ControlFlowGraph) {
            if !graph.containsNode(node) {
                graph.addNode(node)
            }
            if !graph.containsNode(target) {
                graph.addNode(target)
            }

            guard !graph.areConnected(start: node, end: target) else {
                return
            }

            graph.addEdge(from: node, to: target)
        }

        public enum Kind: Equatable {
            case `continue`(label: String?)
            case `break`(label: String?)
            case `return`
            case `throw`
            case `fallthrough`
            case expressionShortCircuit
            case switchCasePatternFail
        }
    }
}

/// A syntax node class used in marker nodes and entry/exit nodes of subgraphs.
class MarkerSyntaxNode: SyntaxNode {

}

private func _expandAndRemove(node: ControlFlowGraphNode, in graph: ControlFlowGraph) {
    guard graph.containsNode(node) else {
        return
    }

    let edgesToMarker = graph.edges(towards: node)
    let edgesFromMarker = graph.edges(from: node)

    graph.removeNode(node)

    for edgeTo in edgesToMarker {
        for edgeFrom in edgesFromMarker {
            if edgeTo.start === node && edgeTo.end === node {
                fatalError("Expanding self-referential nodes is not supported: \(node)")
            }

            guard !graph.areConnected(start: edgeTo.start, end: edgeFrom.end) else {
                continue
            }

            let edge = graph.addEdge(from: edgeTo.start, to: edgeFrom.end)

            switch (edgeTo.debugLabel, edgeFrom.debugLabel) {
            case (let labelTo?, let labelFrom?):
                edge.debugLabel = "\(labelTo)/\(labelFrom)"
            case (nil, let label?), (let label?, nil):
                edge.debugLabel = label
            case (nil, nil):
                break
            }
        }
    }
}
