/// This file contains the implementation of the bottom-to-top control flow graph
/// creation algorithm. Most of the work is done by creating smaller subgraph
/// segments with loose connections representing branching paths, which are
/// eventually resolved to proper edges when subgraph segments are merged.
///
/// Special handling is performed for defer statements to ensure the proper
/// semantics of 'unwinding' are preserved across all different types of branching
/// events in a CFG, like early returns and loop continuation and breaking.

import SwiftAST
import TypeSystem

public extension ControlFlowGraph {
    /// Options that can be specified during generation of control flow graphs.
    struct GenerationOptions {
        public static var `default`: Self = Self()
        
        /// If `true`, generates marker nodes between code scope changes.
        public var generateEndScopes: Bool

        /// If `true`, prunes the resulting CFG so that nodes that are unreachable
        /// from the entry node are removed from the graph.
        public var pruneUnreachable: Bool

        public init(
            generateEndScopes: Bool = false,
            pruneUnreachable: Bool = false
        ) {
            self.generateEndScopes = generateEndScopes
            self.pruneUnreachable = pruneUnreachable
        }
    }

    /// Creates a control flow graph for a given compound statement.
    /// The entry and exit points for the resulting graph will be the compound
    /// statement itself, with its inner nodes being the statements contained
    /// within.
    static func forCompoundStatement(
        _ compoundStatement: CompoundStatement,
        options: GenerationOptions = .default
    ) -> ControlFlowGraph {
        let graph = innerForCompoundStatement(
            compoundStatement,
            options: options
        )
        
        markBackEdges(in: graph)

        if options.pruneUnreachable {
            prune(graph)
        }
        
        return graph
    }
}

// MARK: - Internals

extension ControlFlowGraph {
    func merge(with other: ControlFlowGraph) {
        assert(other !== self, "attempting to merge a graph with itself!")
        
        let nodes = other.nodes.filter {
            $0 !== other.entry && $0 !== other.exit
        }
        
        let edges = other.edges.filter {
            $0.start !== other.entry && $0.start !== other.exit
                && $0.end !== other.entry && $0.end !== other.exit
        }
        
        for node in nodes {
            addNode(node)
        }
        for edge in edges {
            let e = addEdge(from: edge.start, to: edge.end)
            e.isBackEdge = edge.isBackEdge
        }
    }
    
    func addNode(_ node: ControlFlowGraphNode) {
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
    
    func addEdge(_ edge: ControlFlowGraphEdge) {
        assert(
            self.edge(from: edge.start, to: edge.end) == nil,
            "An edge between nodes \(edge.start.node) and \(edge.end.node) already exists within this graph"
        )
        
        edges.append(edge)
    }
    
    @discardableResult
    func addEdge(from node1: ControlFlowGraphNode, to node2: ControlFlowGraphNode) -> ControlFlowGraphEdge {
        assert(
            containsNode(node1) && containsNode(node2),
            "Attempted to add edge between nodes that are no contained within this graph."
        )
        
        let edge = ControlFlowGraphEdge(start: node1, end: node2)
        addEdge(edge)
        
        return edge
    }
    
    func removeNode(_ node: ControlFlowGraphNode) {
        removeEdges(allEdges(for: node))
        nodes.removeAll(where: { $0 === node })
    }
    
    func removeEdges<S: Sequence>(_ edgesToRemove: S) where S.Element == ControlFlowGraphEdge {
        edges = edges.filter { e in
            !edgesToRemove.contains(e)
        }
    }
}

internal extension ControlFlowGraph {
    /// Prunes a control flow graph, removing any nodes that are unreachable
    /// from its initial node.
    static func prune(_ graph: ControlFlowGraph) {
        var toRemove: Set<Node> = Set(graph.nodes)

        graph.breadthFirstVisit(start: graph.entry) { visit in
            toRemove.remove(visit.node)
            
            return true
        }

        toRemove.forEach(graph.removeNode)
    }

    /// Marks back edges for a graph.
    ///
    /// A back edge is an edge that connects one node to another node that comes
    /// earlier in the graph when visiting the graph in depth-first fashion
    /// starting from its entry point.
    static func markBackEdges(in graph: ControlFlowGraph) {
        var queue: [(start: ControlFlowGraphNode, visited: [ControlFlowGraphNode])] = []
        
        queue.append((graph.entry, [graph.entry]))
        
        while let next = queue.popLast() {
            for nextEdge in graph.edges(from: next.start) {
                let node = nextEdge.end
                if next.visited.contains(node) {
                    nextEdge.isBackEdge = true
                    continue
                }
                
                queue.append((node, next.visited + [node]))
            }
        }
    }
    
    static func expandSubgraphs(in graph: ControlFlowGraph) {
        for case let node as ControlFlowSubgraphNode in graph.nodes {
            let edgesTo = graph.edges(towards: node)
            let edgesFrom = graph.edges(from: node)
            
            let entryEdges = node.graph.edges(from: node.graph.entry)
            let exitEdges = node.graph.edges(towards: node.graph.exit)
            
            graph.removeNode(node)
            
            graph.merge(with: node.graph)
            
            for edgeTo in edgesTo {
                let source = edgeTo.start
                
                for entryEdge in entryEdges {
                    let target = entryEdge.end
                    
                    let edge = graph.addEdge(from: source, to: target)
                    edge.isBackEdge = edgeTo.isBackEdge
                }
            }
            for edgeFrom in edgesFrom {
                let target = edgeFrom.end
                
                for exitEdge in exitEdges {
                    let source = exitEdge.start
                    
                    let edge = graph.addEdge(from: source, to: target)
                    edge.isBackEdge = edgeFrom.isBackEdge
                }
            }
        }
    }
}

internal extension ControlFlowGraph {
    /// A lazily-computed subgraph that is composed of enqueued graph operations
    /// alongside key jump target nodes for flow control operations.
    struct _LazySubgraphGenerator {
        static let invalid = _LazySubgraphGenerator(startNode: ControlFlowGraphNode(node: _InvalidSyntaxNode()))
        
        private var operations: [GraphOperation] = []

        var isValid: Bool {
            !(startNode.node is _InvalidSyntaxNode)
        }
        
        var startNode: ControlFlowGraphNode
        var exitNodes: ExitNodes = ExitNodes()

        // Statement-specific nodes
        var breakNodes: BreakNodes = BreakNodes()
        var continueNodes: ContinueNodes = ContinueNodes()
        var fallthroughNodes: FallthroughNodes = FallthroughNodes()
        var returnNodes: ReturnNodes = ReturnNodes()
        var throwNodes: ThrowNodes = ThrowNodes()

        // Expression-specific nodes
        var nullCoalesceNodes: NullCoalesceNodes = NullCoalesceNodes()
        
        init(startNode: ControlFlowGraphNode) {
            self.startNode = startNode
            
            operations = [.addNode(startNode)]
        }
        
        init(startAndExitNode startNode: ControlFlowGraphNode) {
            self.startNode = startNode
            
            operations = [.addNode(startNode)]
            exitNodes.addNode(startNode)
        }

        /// Returns `true` if the list of operations contains a reference to a
        /// given node.
        private func _containsNode(_ node: ControlFlowGraphNode) -> Bool {
            for operation in operations {
                switch operation {
                case .addNode(let n) where n == node:
                    return true
                default:
                    break
                }
            }

            return false
        }
        
        /// Applies the operations enqueued on this lazy subgraph to the given
        /// CFG, using a given node as the exit node.
        func apply(to graph: ControlFlowGraph, endNode: ControlFlowGraphNode) {
            let operations =
                self.operations
                    + exitNodes.chainOperations(endingIn: endNode)
            
            for operation in operations {
                switch operation {
                case .addNode(let node):
                    if !graph.containsNode(node) {
                        graph.addNode(node)
                    }
                    
                case let .addEdge(start, end, label):
                    let edge =
                        graph.edge(from: start, to: end)
                            ?? graph.addEdge(from: start, to: end)

                    edge.debugLabel = edge.debugLabel ?? label
                }
            }
        }

        /// Returns a copy of this subgraph, with another subgraph embedded, with
        /// the resulting list of non-exit jumps being a union between the two.
        func mergingNonExitJumps(_ other: Self) -> Self {
            var copy = self
            copy.breakNodes.merge(with: other.breakNodes)
            copy.continueNodes.merge(with: other.continueNodes)
            copy.fallthroughNodes.merge(with: other.fallthroughNodes)
            copy.returnNodes.merge(with: other.returnNodes)
            copy.throwNodes.merge(with: other.throwNodes)
            copy.nullCoalesceNodes.merge(with: other.nullCoalesceNodes)
            return copy
        }
        
        /// Returns a copy of this lazy subgraph with an extra exit node
        /// appended to the exit jump sources list.
        func addingExitNode(_ node: ControlFlowGraphNode) -> Self {
            var result = self
            result.exitNodes.addNode(node)
            return result
        }
        
        /// Returns a copy of this lazy subgraph with an extra continue node
        /// appended to the continue jump sources list, optionally specifying a
        /// label.
        func addingBreakNode(_ node: ControlFlowGraphNode, targetLabel: String? = nil) -> Self {
            var result = self
            result.breakNodes.addNode(node, targetLabel: targetLabel)
            return result
        }
        
        /// Returns a copy of this lazy subgraph with an extra continue node
        /// appended to the continue jump sources list, optionally specifying a
        /// label.
        func addingContinueNode(_ node: ControlFlowGraphNode, targetLabel: String? = nil) -> Self {
            var result = self
            result.continueNodes.addNode(node, targetLabel: targetLabel)
            return result
        }

        /// Returns a copy of this lazy subgraph with an extra fallthrough node
        /// appended to the fallthrough jump sources list.
        func addingFallthroughNode(_ node: ControlFlowGraphNode) -> Self {
            var result = self
            result.fallthroughNodes.addNode(node)
            return result
        }

        /// Returns a copy of this lazy subgraph with an extra return node appended
        /// to the return jump sources list.
        func addingReturnNode(_ node: ControlFlowGraphNode) -> Self {
            var result = self
            result.returnNodes.addNode(node)
            return result
        }

        /// Returns a copy of this lazy subgraph with an extra throw node appended
        /// to the throw jump sources list.
        func addingThrowNode(_ node: ControlFlowGraphNode) -> Self {
            var result = self
            result.throwNodes.addNode(node)
            return result
        }

        /// Returns a copy of this lazy subgraph with an extra null-coalesce node
        /// appended to the null-coalesce jump sources list.
        func addingNullCoalesceNode(_ node: ControlFlowGraphNode) -> Self {
            var result = self
            result.nullCoalesceNodes.addNode(node)
            return result
        }
        
        /// Returns a copy of this lazy subgraph with exit jump sources removed.
        func satisfyingExits() -> Self {
            var result = self
            result.exitNodes.clear()
            return result
        }

        /// Returns a copy of this lazy subgraph with break jump sources removed,
        /// optionally filtering to only remove break sources with a given
        /// label.
        ///
        /// Break jumps that have `nil` label will also be satisfied by this
        /// method.
        func satisfyingBreaks(labeled targetLabel: String? = nil) -> Self {
            var result = self
            result.breakNodes.clear(labeled: nil)
            result.breakNodes.clear(labeled: targetLabel)
            return result
        }

        /// Returns a copy of this lazy subgraph with break jump sources that
        /// match a given label removed.
        ///
        /// Break jumps that have `nil` label will not be removed by this method.
        func satisfyingBreaksExclusive(labeled targetLabel: String) -> Self {
            var result = self
            result.breakNodes.clear(labeled: targetLabel)
            return result
        }

        /// Returns a copy of this lazy subgraph with continue jump sources removed,
        /// optionally filtering to only remove continue sources with a given
        /// label.
        ///
        /// Continue jumps that have `nil` label will also be satisfied by this
        /// method.
        func satisfyingContinues(label targetLabel: String? = nil) -> Self {
            var result = self
            result.continueNodes.clear(labeled: nil)
            result.continueNodes.clear(labeled: targetLabel)
            return result
        }

        /// Returns a copy of this lazy subgraph with fallthrough jump sources removed.
        func satisfyingFallthroughs() -> Self {
            var result = self
            result.fallthroughNodes.clear()
            return result
        }

        /// Returns a copy of this lazy subgraph with return jump sources removed.
        func satisfyingReturns() -> Self {
            var result = self
            result.returnNodes.clear()
            return result
        }

        /// Returns a copy of this lazy subgraph with throw jump sources removed.
        func satisfyingThrows() -> Self {
            var result = self
            result.throwNodes.clear()
            return result
        }

        /// Returns a copy of this lazy subgraph with null-coalesce jump sources
        /// removed.
        func satisfyingNullCoalesce() -> Self {
            var result = self
            result.nullCoalesceNodes.clear()
            return result
        }
        
        /// Returns a copy of this lazy subgraph with break sources converted into
        /// exit jumps, optionally specifying a target label to satisfy.
        ///
        /// Break jumps that have `nil` label will also be satisfied by this method.
        func breakToExits(targetLabel: String? = nil) -> Self {
            var result = self
            result.exitNodes.merge(with: result.breakNodes.matchingTargetLabel(targetLabel))
            result.exitNodes.merge(with: result.breakNodes.matchingTargetLabel(nil))
            return result.satisfyingBreaks(labeled: targetLabel)
        }
        
        /// Returns a copy of this lazy subgraph with break jump sources that match
        /// a given label converted into exit jumps.
        ///
        /// Break jumps that have `nil` label will not be removed by this method.
        func breakToExitsExclusive(targetLabel: String) -> Self {
            var result = self
            result.exitNodes.merge(with: result.breakNodes.matchingTargetLabel(targetLabel))
            return result.satisfyingBreaksExclusive(labeled: targetLabel)
        }
        
        /// Returns a copy of this lazy subgraph with return sources converted into
        /// exit jumps.
        func returnToExits() -> Self {
            var result = self
            result.exitNodes.merge(with: result.returnNodes)
            return result.satisfyingReturns()
        }

        /// Returns a copy of this lazy subgraph with throw sources converted into
        /// exit jumps.
        func throwToExits() -> Self {
            var result = self
            result.exitNodes.merge(with: result.throwNodes)
            return result.satisfyingThrows()
        }

        /// Returns a copy of this lazy subgraph with null-coalesce sources
        /// converted into exit jumps.
        func nullCoalesceToExits() -> Self {
            var result = self
            result.exitNodes.merge(with: result.nullCoalesceNodes)
            return result.satisfyingNullCoalesce()
        }

        /// Returns a copy of this lazy subgraph with a given end of scope node
        /// appended to all the jump source lists.
        ///
        /// If `node` is `nil`, no change is made.
        func appendingEndOfScopeIfAvailable(_ node: ControlFlowGraphEndScopeNode?) -> Self {
            if let node = node {
                return appendingEndOfScope(node)
            }

            return self
        }

        /// Returns a copy of this lazy subgraph with a given end of scope node
        /// appended to all the jump source lists except exit jump lists.
        func appendingEndOfScope(_ node: ControlFlowGraphEndScopeNode) -> Self {
            var result = self
            result.breakNodes.appendEndOfScope(node)
            result.continueNodes.appendEndOfScope(node)
            result.fallthroughNodes.appendEndOfScope(node)
            result.returnNodes.appendEndOfScope(node)
            result.throwNodes.appendEndOfScope(node)
            return result
        }

        /// Returns a copy of this lazy subgraph with a given end of scope node
        /// appended to exit jump source lists only.
        ///
        /// If `node` is `nil`, no change is made.
        func appendingEndOfScopeOnExitsIfAvailable(_ node: ControlFlowGraphEndScopeNode?) -> Self {
            if let node = node {
                return appendingEndOfScopeOnExits(node)
            }

            return self
        }

        /// Returns a copy of this lazy subgraph with a given end of scope node
        /// appended to the exit jump source lists only.
        func appendingEndOfScopeOnExits(_ node: ControlFlowGraphEndScopeNode) -> Self {
            var result = self
            result.exitNodes.appendEndOfScope(node)
            return result
        }
        
        /// Returns a copy of this lazy subgraph with a given list of defers
        /// appended to the exit jump source list only.
        func appendingExitDefers(_ defers: [ControlFlowSubgraphNode]) -> Self {
            defers.reduce(self, { $0.appendingExitDefer($1) })
        }
        
        /// Returns a copy of this lazy subgraph with a given defer appended to
        /// the exit jump source list only.
        func appendingExitDefer(_ node: ControlFlowSubgraphNode) -> Self {
            var result = self
            result.exitNodes.appendDefer(node)
            return result
        }
        
        /// Returns a copy of this lazy subgraph with a given list of defer nodes
        /// appended to all jump source lists, except for the exit jump source list.
        func appendingDefers(_ defers: [ControlFlowSubgraphNode]) -> Self {
            defers.reduce(self, { $0.appendingDefer($1) })
        }
        
        /// Returns a copy of this lazy subgraph with a given defer appended to
        /// all jump source lists, except for the exit jump source list.
        func appendingDefer(_ node: ControlFlowSubgraphNode) -> Self {
            var result = self
            result.breakNodes.appendDefer(node)
            result.continueNodes.appendDefer(node)
            result.fallthroughNodes.appendDefer(node)
            result.returnNodes.appendDefer(node)
            result.throwNodes.appendDefer(node)
            return result
        }

        /// Chain the exits from this subgraph into a second subgraph's start
        /// node.
        func then(_ other: Self) -> Self {
            if !isValid {
                return other
            }

            let chain = self.exitNodes.chainOperations(endingIn: other.startNode)

            var copy = self
                .mergingNonExitJumps(other)
                .satisfyingExits()
            
            copy.operations.append(contentsOf: other.operations)
            copy.operations.append(contentsOf: chain)
            copy.exitNodes = other.exitNodes

            return copy
        }

        /// Adds a branch from the exit nodes of this subgraph to another subgraph's
        /// start node, ignoring the other subgraph's remaining nodes and jumps.
        ///
        /// Calling this method assumes that the other subgraph's contents are
        /// already present within this subgraph.
        ///
        /// This method does not erase the existing exit nodes from this graph.
        func loop(_ other: Self) -> Self {
            if !isValid {
                return other
            }
            if !other.isValid {
                return self
            }

            return connectingExits(to: other.startNode)
        }

        /// Adds a branch from the exit nodes of this subgraph to another subgraph's
        /// start node.
        ///
        /// This method does not erase the existing exit nodes from this graph.
        func branching(to other: Self) -> Self {
            if !isValid {
                return other
            }
            if !other.isValid {
                return self
            }

            return branchingExits(to: other.startNode)
                .combine(other)
        }
        
        /**
        Returns a copy of this subgraph with a connection to another subgraph by
        making the specified jump source nodes list point to the start of this
        subgraph.

        Example:

        This subgraph:

            n1 -> n2
        
        Second subgraph:

            start -> p1 --> p2
                        `-> p3 (jump target)
                        `-> p4 (jump target)
        
        Resulting subgraph:
            
            p3 --> n1 --> n2
            p4 -´
        
        A debug label can optionally be specified and will be added to the jump's
        edge representation.
        */
        func addingJumpInto<Tag>(from source: ControlFlowGraphJumpSources<Tag>, debugLabel: String? = nil) -> Self {
            if !isValid {
                return self
            }
            
            var result = self
            result.operations.append(contentsOf: source.chainOperations(endingIn: startNode, debugLabel: debugLabel))
            return result
        }
        
        /**
         Returns a copy of this subgraph by connecting another subgraph result by
         means of connecting the start node of this subgraph to the start node of
         the given subgraph.

         If `from` is specified, the jump is made from that node instead of the
         start node of this subgraph.
         
         Example:
         
         This subgraph:
         
             start --> n1 --> n2
 
         Second subgraph:
         
             p1 --> p2
                `-> p3
         
         Resulting subgraph:
         
                  ,-> n1 --> n2
             start
                  `-> p1 --> p2
                         `-> p3
        
        A debug label can optionally be specified and will be added to the branch's
        edge representation.
         */
        func addingBranch(towards result: _LazySubgraphGenerator, from: ControlFlowGraphNode? = nil, debugLabel: String? = nil) -> Self {
            if !result.isValid {
                return self
            }
            if !isValid {
                return result
            }

            if let from = from {
                assert(
                    _containsNode(from),
                    "Referenced node to branch from that is not contained in this subgraph: \(from)"
                )
            }
            
            var newResult = combine(result)
            newResult.operations.append(
                .addEdge(
                    start: from ?? startNode,
                    end: result.startNode,
                    debugLabel: debugLabel
                )
            )

            return newResult
        }
        
        /// Returns a copy of this subgraph with another subgraph appended to it,
        /// but with no connections made between the nodes of each other.
        ///
        /// Jump nodes are the result of the combination of both subgraphs.
        func combine(_ other: _LazySubgraphGenerator) -> Self {
            if !other.isValid {
                return self
            }
            if !isValid {
                return other
            }

            var newResult = self
            
            newResult.operations.append(contentsOf: other.operations)
            
            newResult.exitNodes.merge(with: other.exitNodes)
            newResult.breakNodes.merge(with: other.breakNodes)
            newResult.continueNodes.merge(with: other.continueNodes)
            newResult.fallthroughNodes.merge(with: other.fallthroughNodes)
            newResult.returnNodes.merge(with: other.returnNodes)
            newResult.throwNodes.merge(with: other.throwNodes)
            newResult.nullCoalesceNodes.merge(with: other.nullCoalesceNodes)
            
            return newResult
        }
        
        /**
        Returns a copy of this subgraph with a connection to another subgraph by
        making the exit jump nodes list point to the start of the other subgraph.

        Example:

        This subgraph:

            start -> p1 --> p2 -> <exit>
                        `-> p3
                        `-> p4 -> <exit>
        
        Second subgraph:

            n1 -> n2 -> <exit>
        
        Resulting subgraph:
            
            start -> p1 --> p2 --> n1 -> n2 -> <exit>
                        `-> p3  /
                        `-> p4 ´
        
        A debug label can optionally be specified and will be added to the exit
        jumps' edge representation.
        */
        func chainingExits(to next: _LazySubgraphGenerator, debugLabel: String? = nil) -> Self {
            if !next.isValid {
                return self
            }
            if !isValid {
                return next
            }

            var newResult = self.connectingExits(to: next.startNode, debugLabel: debugLabel)
            
            newResult.operations.append(contentsOf: next.operations)
            
            newResult.exitNodes = next.exitNodes
            newResult.breakNodes.merge(with: next.breakNodes)
            newResult.continueNodes.merge(with: next.continueNodes)
            newResult.fallthroughNodes.merge(with: next.fallthroughNodes)
            newResult.returnNodes.merge(with: next.returnNodes)
            newResult.throwNodes.merge(with: next.throwNodes)
            newResult.nullCoalesceNodes.merge(with: next.nullCoalesceNodes)
            
            return newResult
        }
        
        /**
        Returns a copy of this subgraph with a connection to another subgraph by
        making the continue jump nodes list point to the start of the other subgraph.

        Example:

        This subgraph:

            start -> p1 --> p2 -> <throw>
                        `-> p3
                        `-> p4 -> <exit>
        
        Second subgraph:

            n1 -> n2 -> <exit>
        
        Resulting subgraph:
            
            start -> p1 --> p2 --> n1 -> n2 -> <exit>
                        `-> p3
                        `-> p4 -> <exit>
        
        The resulting subgraph has the continue jumps from this subgraph with
        the matching label satisfied, but will still contain continue jumps from
        the referenced subgraph.
        
        A debug label can optionally be specified and will be added to the jumps'
        edge representation.
        */
        func chainingContinues(
            label targetLabel: String? = nil,
            to next: _LazySubgraphGenerator,
            debugLabel: String? = nil
        ) -> Self {
            
            if !next.isValid {
                return self
            }
            if !isValid {
                return next
            }
            
            var newResult = self.connectingContinues(
                label: targetLabel,
                to: next.startNode,
                debugLabel: debugLabel
            )
            
            newResult.operations.append(contentsOf: next.operations)
            
            newResult.exitNodes.merge(with: next.exitNodes)
            newResult.breakNodes.merge(with: next.breakNodes)
            newResult.continueNodes = next.continueNodes
            newResult.fallthroughNodes.merge(with: next.fallthroughNodes)
            newResult.returnNodes.merge(with: next.returnNodes)
            newResult.throwNodes.merge(with: next.throwNodes)
            newResult.nullCoalesceNodes.merge(with: next.nullCoalesceNodes)
            
            return newResult
        }
        
        /**
        Returns a copy of this subgraph with a connection to another subgraph by
        making the throw jump nodes list point to the start of the other subgraph.

        Example:

        This subgraph:

            start -> p1 --> p2 -> <throw>
                        `-> p3
                        `-> p4 -> <exit>
        
        Second subgraph:

            n1 -> n2
        
        Resulting subgraph:
            
            start -> p1 --> p2 --> n1 -> n2
                        `-> p3
                        `-> p4 -> <exit>
        
        A debug label can optionally be specified and will be added to the throw
        jumps' edge representation.
        */
        func chainingThrows(to next: _LazySubgraphGenerator, debugLabel: String? = nil) -> Self {
            if !next.isValid {
                return self
            }
            if !isValid {
                return next
            }

            var newResult = self.connectingThrows(to: next.startNode, debugLabel: debugLabel)
            
            newResult.operations.append(contentsOf: next.operations)
            
            newResult.exitNodes.merge(with: next.exitNodes)
            newResult.breakNodes.merge(with: next.breakNodes)
            newResult.continueNodes.merge(with: next.continueNodes)
            newResult.fallthroughNodes.merge(with: next.fallthroughNodes)
            newResult.returnNodes.merge(with: next.returnNodes)
            newResult.throwNodes = next.throwNodes
            newResult.nullCoalesceNodes.merge(with: next.nullCoalesceNodes)
            
            return newResult
        }
        
        /// Returns a copy of this subgraph with all exit jumps pointing to a
        /// given node.
        ///
        /// The resulting subgraph has no exit nodes listed.
        ///
        /// A debug label can optionally be specified and will be added to the
        /// exit jumps' edge representation.
        func connectingExits(to node: ControlFlowGraphNode, debugLabel: String? = nil) -> Self {
            if !isValid {
                return _LazySubgraphGenerator(startNode: node)
            }

            var result = self
            
            result.operations.append(contentsOf:
                exitNodes.chainOperations(
                    endingIn: node,
                    debugLabel: debugLabel
                )
            )
            
            return result.satisfyingExits()
        }
        
        /// Returns a copy of this subgraph with all exit jumps pointing to a
        /// given node.
        ///
        /// The resulting subgraph still has the current exit nodes available.
        ///
        /// A debug label can optionally be specified and will be added to the
        /// exit jumps' edge representation.
        func branchingExits(to node: ControlFlowGraphNode, debugLabel: String? = nil) -> Self {
            if !isValid {
                return _LazySubgraphGenerator(startNode: node)
            }

            var result = self
            
            result.operations.append(contentsOf:
                exitNodes.chainOperations(
                    endingIn: node,
                    debugLabel: debugLabel
                )
            )
            
            return result
        }
        
        /// Returns a copy of this subgraph with all continue jumps pointing to
        /// a given node, optionally specifying a target label to filter the
        /// continue jumps.
        ///
        /// The resulting subgraph has the continue jumps with the matching label
        /// satisfied.
        ///
        /// A debug label can optionally be specified and will be added to the
        /// jumps' edge representation.
        func connectingContinues(
            label targetLabel: String? = nil,
            to node: ControlFlowGraphNode,
            debugLabel: String? = nil
        ) -> Self {
            if !isValid {
                return .invalid
            }
            
            var newResult = self
            
            let operations = continueNodes
                .matchingTargetLabel(targetLabel)
                .chainOperations(
                    endingIn: node,
                    debugLabel: debugLabel
                )
            
            newResult.operations.append(contentsOf: operations)
            
            return newResult.satisfyingContinues(label: targetLabel)
        }
        
        /// Returns a copy of this subgraph with all throw jumps pointing to
        /// a given node.
        ///
        /// The resulting subgraph has the throw jumps satisfied.
        ///
        /// A debug label can optionally be specified and will be added to the
        /// jumps' edge representation.
        func connectingThrows(
            to node: ControlFlowGraphNode,
            debugLabel: String? = nil
        ) -> Self {
            if !isValid {
                return .invalid
            }

            var newResult = self
            
            let operations = throwNodes
                .chainOperations(
                    endingIn: node,
                    debugLabel: debugLabel
                )
            
            newResult.operations.append(contentsOf: operations)
            
            return newResult.satisfyingThrows()
        }
        
        private class _InvalidSyntaxNode: SyntaxNode {
            
        }
        
        enum GraphOperation {
            case addNode(ControlFlowGraphNode)
            case addEdge(start: ControlFlowGraphNode, end: ControlFlowGraphNode, debugLabel: String? = nil)
        }
    }
    
    typealias ExitNodes = ControlFlowGraphJumpSources<SyntaxNode>
    typealias BreakNodes = ControlFlowGraphJumpSources<BreakStatement>
    typealias ContinueNodes = ControlFlowGraphJumpSources<ContinueStatement>
    typealias FallthroughNodes = ControlFlowGraphJumpSources<FallthroughStatement>
    typealias ReturnNodes = ControlFlowGraphJumpSources<ReturnStatement>
    typealias ThrowNodes = ControlFlowGraphJumpSources<ThrowStatement>
    typealias NullCoalesceNodes = ControlFlowGraphJumpSources<Expression>
    
    /// A list of control flow graph nodes that represent control flow jumps from
    /// specific points in a subgraph.
    struct ControlFlowGraphJumpSources<Tag: SyntaxNode>: CustomStringConvertible {
        private(set) var nodes: [JumpNodeEntry<Tag>] = []

        var description: String {
            "[" + nodes.map(\.description).joined(separator: ", ") + "]"
        }

        /// Returns `true` if no nodes are present within this jump source.
        var isEmpty: Bool {
            nodes.isEmpty
        }
        
        /// Removes jump sources that match a given label.
        mutating func clear(labeled targetLabel: String?) {
            nodes.removeAll(where: { $0.jumpLabel == targetLabel })
        }
        
        /// Removes all jump source nodes.
        mutating func clear() {
            nodes.removeAll()
        }
        
        mutating func addNode(_ node: ControlFlowGraphNode, targetLabel: String? = nil) {
            assert(
                node.node is Tag,
                """
                Attempted to add unrelated control flow node type \(type(of: node.node)) to a tagged jump source list of type \(Tag.self)
                """
            )

            nodes.append(
                JumpNodeEntry(
                    node: node,
                    defers: [],
                    endOfScopes: [],
                    jumpLabel: targetLabel
                )
            )
        }
        
        func matchingTargetLabel(_ targetLabel: String?) -> ControlFlowGraphJumpSources {
            ControlFlowGraphJumpSources(nodes: entriesForTargetLabel(targetLabel))
        }
        
        func entriesForTargetLabel(_ label: String?) -> [JumpNodeEntry<Tag>] {
            nodes.filter({ $0.jumpLabel == label })
        }
        
        mutating func appendDefer(_ node: ControlFlowSubgraphNode) {
            for i in 0..<nodes.count {
                nodes[i].defers.append(node)
            }
        }
        
        mutating func appendEndOfScope(_ node: ControlFlowGraphEndScopeNode) {
            for i in 0..<nodes.count {
                nodes[i].endOfScopes.append(node)
            }
        }
        
        mutating func merge(with second: ControlFlowGraphJumpSources) {
            self = ControlFlowGraphJumpSources.merge(self, second)
        }
        
        mutating func merge<T>(with second: ControlFlowGraphJumpSources<T>) where Tag == SyntaxNode {
            self = ControlFlowGraphJumpSources(nodes: nodes + second.nodes.cast())
        }
        
        /// Returns a chain of lazy graph operations that execute all jumps listed
        /// within this jump source list, including defer statements, ending
        /// in a last hop to a specific ending node.
        ///
        /// A debug label can optionally be specified and will be added to the
        /// last jump's edge representation.
        func chainOperations(endingIn ending: ControlFlowGraphNode, debugLabel: String? = nil) -> [_LazySubgraphGenerator.GraphOperation] {
            var operations: [_LazySubgraphGenerator.GraphOperation] = []
            for source in nodes {
                let sourceNodes =
                    [source.node]
                        + Array(source.defers.reversed())
                        + Array(source.endOfScopes)
                        + [ending]
                
                // Add nodes before edges
                for node in sourceNodes {
                    operations.append(.addNode(node))
                }
                for (first, second) in zip(sourceNodes, sourceNodes.dropFirst()) {
                    operations.append(.addEdge(start: first, end: second, debugLabel: second === ending ? debugLabel : nil))
                }
            }
            
            return operations
        }
        
        static func merge(
            _ first: ControlFlowGraphJumpSources,
            _ second: ControlFlowGraphJumpSources
        ) -> ControlFlowGraphJumpSources {

            ControlFlowGraphJumpSources(nodes: first.nodes + second.nodes)
        }
    }
    
    struct JumpNodeEntry<Tag: SyntaxNode>: CustomStringConvertible {
        var node: ControlFlowGraphNode
        var defers: [ControlFlowSubgraphNode]
        var endOfScopes: [ControlFlowGraphEndScopeNode]
        var jumpLabel: String?

        var description: String {
            "{node: \(node), defers: \(defers), endOfScopes: \(endOfScopes), jumpLabel: \(jumpLabel ?? "<nil>")}"
        }

        func cast<U>() -> JumpNodeEntry<U> {
            .init(
                node: node,
                defers: defers,
                endOfScopes: endOfScopes,
                jumpLabel: jumpLabel
            )
        }
    }
}

internal extension Sequence where Element == ControlFlowGraph._LazySubgraphGenerator {
    /// Returns the result of chaining all of the subgraph elements' exists to
    /// one element to the next on this sequence.
    ///
    /// If this sequence is empty of elements, `.invalid` is returned, instead.
    func chainingExits() -> Element {
        var result: Element?

        for element in self {
            if let current = result {
                result = current.chainingExits(to: element)
            } else {
                result = element
            }
        }

        return result ?? .invalid
    }
}

private extension Sequence {
    /// Returns the result of chaining all of the subgraph elements' exists to
    /// one element to the next on this sequence.
    ///
    /// If this sequence is empty of elements, `.invalid` is returned, instead.
    func cast<T, U>() -> [ControlFlowGraph.JumpNodeEntry<U>] where Element == ControlFlowGraph.JumpNodeEntry<T> {
        map { $0.cast() }
    }
}
