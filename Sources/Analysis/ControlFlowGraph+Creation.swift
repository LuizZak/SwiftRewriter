/// This file contains the implementation of the bottom-to-top control flow graph
/// creation algorithm. Most of the work is done by creating smaller subgraph
/// segments with loose connections representing branching paths, which are
/// eventually resolved to proper edges when subgraph segments are merged.
///
/// Special handling is performed for defer statements to ensure the proper
/// semantics of 'unwinding' are preserved across all different types of branching
/// events in a CFG, like early returns and loop continuation and breaking.

import SwiftAST

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
        assert(node !== self,
               "Adding a node as a subnode of itself!")
        assert(!self.containsNode(node),
               "Node \(node) already exists in this graph")
        
        nodes.append(node)
    }
    
    func addEdge(_ edge: ControlFlowGraphEdge) {
        assert(self.edge(from: edge.start, to: edge.end) == nil,
               "An edge between nodes \(edge.start.node) and \(edge.end.node) already exists within this graph")
        
        edges.append(edge)
    }
    
    @discardableResult
    func addEdge(from node1: ControlFlowGraphNode, to node2: ControlFlowGraphNode) -> ControlFlowGraphEdge {
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

public extension ControlFlowGraph {
    /// Creates a control flow graph for a given compound statement.
    /// The entry and exit points for the resulting graph will be the compound
    /// statement itself, with its inner nodes being the statements contained
    /// within.
    static func forCompoundStatement(_ compoundStatement: CompoundStatement) -> ControlFlowGraph {
        let graph = innerForCompoundStatement(compoundStatement)
        
        markBackEdges(in: graph)
        
        return graph
    }
}

private extension ControlFlowGraph {
    static func markBackEdges(in graph: ControlFlowGraph) {
        var visited: Set<ControlFlowGraphNode> = []
        var queue: [(start: ControlFlowGraphNode, visited: [ControlFlowGraphNode])] = []
        
        queue.append((graph.entry, [graph.entry]))
        
        while let next = queue.popLast() {
            visited.insert(next.start)
        
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
    
    static func innerForCompoundStatement(_ compoundStatement: CompoundStatement) -> ControlFlowGraph {
        let graph = forStatementList(compoundStatement.statements, baseNode: compoundStatement)
        
        expandSubgraphs(in: graph)
        
        return graph
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
    
    private static func forStatementList(_ statements: [Statement], baseNode: SyntaxNode) -> ControlFlowGraph {
        let entry = ControlFlowGraphEntryNode(node: baseNode)
        let exit = ControlFlowGraphExitNode(node: baseNode)
        
        let graph = ControlFlowGraph(entry: entry, exit: exit)
        
        var previous = _NodeCreationResult(startNode: entry)
            .addingExitNode(entry)
        
        previous =
            _connections(for: statements, start: previous)
                .returnToExits()
        
        previous.apply(to: graph, endNode: exit)
        
        return graph
    }
    
    private static func _connections(for statements: [Statement],
                                     start: _NodeCreationResult) -> _NodeCreationResult {
        
        var activeDefers: [ControlFlowSubgraphNode] = []
        
        var previous = start
        
        for statement in statements {
            if let stmt = statement as? DeferStatement {
                let subgraph = forStatementList(stmt.body.statements, baseNode: stmt)
                let defNode = ControlFlowSubgraphNode(node: stmt, graph: subgraph)
                
                activeDefers.append(defNode)
                continue
            }
            
            let connections = _connections(for: statement)
            
            previous =
                previous
                    .chainingExits(to: connections.appendingDefers(activeDefers))
        }
        
        return previous.appendingExitDefers(activeDefers)
    }
    
    private static func _connections(for statements: [Statement]) -> _NodeCreationResult {
        _connections(for: statements, start: .invalid)
    }
    
    private static func _connections(for statement: Statement) -> _NodeCreationResult {
        
        var result: _NodeCreationResult
        
        switch statement {
        case is ExpressionsStatement,
             is VariableDeclarationsStatement:
            let node = ControlFlowGraphNode(node: statement)
            
            result = _NodeCreationResult(startNode: node)
                .addingExitNode(node)
            
        case let statement as BreakStatement:
            let node = ControlFlowGraphNode(node: statement)
            
            result = _NodeCreationResult(startNode: node)
                .addingBreakNode(node, targetLabel: statement.targetLabel)
            
        case let statement as ContinueStatement:
            let node = ControlFlowGraphNode(node: statement)
            
            result = _NodeCreationResult(startNode: node)
                .addingContinueNode(node, targetLabel: statement.targetLabel)
            
        case is ReturnStatement:
            let node = ControlFlowGraphNode(node: statement)
            
            result = _NodeCreationResult(startNode: node)
                .addingReturnNode(node)
            
        // Handled separately in _connections(for:start:) above
        case is DeferStatement:
            result = .invalid
            
        case let stmt as FallthroughStatement:
            result = _connections(forFallthrough: stmt)
            
        case let stmt as CompoundStatement:
            result = _connections(for: stmt.statements)
            
        case let stmt as DoStatement:
            result = _connections(for: stmt.body)
            
        case let stmt as IfStatement:
            result = _connections(forIf: stmt)
            
        case let stmt as SwitchStatement:
            result = _connections(forSwitch: stmt)
            
        case let stmt as WhileStatement:
            result = _connections(forWhile: stmt)
            
        case let stmt as DoWhileStatement:
            result = _connections(forDoWhile: stmt)
            
        case let stmt as ForStatement:
            result = _connections(forForLoop: stmt)
            
        default:
            let node = ControlFlowGraphNode(node: statement)
            
            result = _NodeCreationResult(startNode: node)
                .addingExitNode(node)
        }
        
        if let label = statement.label {
            result = result
                .breakToExits(targetLabel: label)
                .satisfyingBreaks(labeled: label)
        }
        
        return result
    }
    
    static func _connections(forFallthrough stmt: FallthroughStatement) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        
        return _NodeCreationResult(startNode: node)
            .addingFallthroughNode(node)
    }
    
    static func _connections(forIf stmt: IfStatement) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body)
        result = result.addingBranch(towards: bodyConnections)
        
        if let elseBody = stmt.elseBody {
            let elseConnections = _connections(for: elseBody)
            result = result.addingBranch(towards: elseConnections)
        } else {
            result = result.addingExitNode(node)
        }
        
        return result
    }
    
    static func _connections(forSwitch stmt: SwitchStatement) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        var lastFallthrough: ControlFlowGraphJumpTarget?
        
        for cs in stmt.cases {
            var branch =
                _connections(for: cs.statements)
            
            if branch.isValid {
                if let lastFallthrough = lastFallthrough {
                    branch = branch.addingJumpInto(from: lastFallthrough)
                }
                
                result =
                    result
                        .addingBranch(towards: branch.satisfyingFallthroughs().breakToExits())
                
                lastFallthrough = branch.fallthroughNodes
            } else {
                result = result.addingExitNode(node)
                
                if let lastFallthrough = lastFallthrough {
                    result.exitNodes.merge(with: lastFallthrough)
                }
                
                lastFallthrough = nil
            }
        }
        
        if let def = stmt.defaultCase {
            let defResult = _connections(for: def)
            result = result.addingBranch(towards: defResult)
        }
        
        return result
    }
    
    static func _connections(forWhile stmt: WhileStatement) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body)
        
        if bodyConnections.isValid {
            result =
                result.addingBranch(towards: bodyConnections)
                    .connectingExits(to: result.startNode)
                    .breakToExits(targetLabel: stmt.label)
                    .connectingContinues(label: stmt.label, to: result.startNode)
                    .satisfyingContinues(label: stmt.label)
        } else {
            result = result
                .addingExitNode(node)
                .connectingExits(to: result.startNode)
        }
        
        result = result.addingExitNode(node)
        
        return result
    }
    
    static func _connections(forDoWhile stmt: DoWhileStatement) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body)
        
        if bodyConnections.isValid {
            result =
                bodyConnections
                    .connectingExits(to: result.startNode)
                    .connectingContinues(label: stmt.label, to: bodyConnections.startNode)
                    .satisfyingContinues(label: stmt.label)
            
            result =
                result
                    .addingExitNode(node)
                    .connectingExits(to: bodyConnections.startNode)
                    .addingExitNode(node)
                    .breakToExits(targetLabel: stmt.label)
        } else {
            result = result
                .addingExitNode(node)
                .connectingExits(to: result.startNode)
                .addingExitNode(node)
        }
        
        return result
    }
    
    static func _connections(forForLoop stmt: ForStatement) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body)
        
        if bodyConnections.isValid {
            result =
                result.addingBranch(towards: bodyConnections)
                    .connectingExits(to: result.startNode)
                    .breakToExits(targetLabel: stmt.label)
                    .connectingContinues(label: stmt.label, to: result.startNode)
                    .satisfyingContinues(label: stmt.label)
        } else {
            result = result
                .addingExitNode(node)
                .connectingExits(to: result.startNode)
        }
        
        result = result.addingExitNode(node)
        
        return result
    }
    
    struct _NodeCreationResult {
        static let invalid = _NodeCreationResult(startNode: ControlFlowGraphNode(node: _InvalidSyntaxNode()))
        
        var isValid: Bool {
            !(startNode.node is _InvalidSyntaxNode)
        }
        
        var startNode: ControlFlowGraphNode
        var exitNodes: ControlFlowGraphJumpTarget = ControlFlowGraphJumpTarget()
        var breakNodes: ControlFlowGraphJumpTarget = ControlFlowGraphJumpTarget()
        var continueNodes: ControlFlowGraphJumpTarget = ControlFlowGraphJumpTarget()
        var fallthroughNodes: ControlFlowGraphJumpTarget = ControlFlowGraphJumpTarget()
        var returnNodes: ControlFlowGraphJumpTarget = ControlFlowGraphJumpTarget()
        
        private var operations: [GraphOperation] = []
        
        init(startNode: ControlFlowGraphNode) {
            self.startNode = startNode
            
            operations = [.addNode(startNode)]
        }
        
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
                    
                case let .addEdge(start, end):
                    if graph.edge(from: start, to: end) == nil {
                        graph.addEdge(from: start, to: end)
                    }
                }
            }
        }
        
        func addingExitNode(_ node: ControlFlowGraphNode) -> _NodeCreationResult {
            var result = self
            result.exitNodes.addNode(node)
            return result
        }
        func addingBreakNode(_ node: ControlFlowGraphNode, targetLabel: String? = nil) -> _NodeCreationResult {
            var result = self
            result.breakNodes.addNode(node, targetLabel: targetLabel)
            return result
        }
        func addingContinueNode(_ node: ControlFlowGraphNode, targetLabel: String? = nil) -> _NodeCreationResult {
            var result = self
            result.continueNodes.addNode(node, targetLabel: targetLabel)
            return result
        }
        func addingFallthroughNode(_ node: ControlFlowGraphNode) -> _NodeCreationResult {
            var result = self
            result.fallthroughNodes.addNode(node)
            return result
        }
        func addingReturnNode(_ node: ControlFlowGraphNode) -> _NodeCreationResult {
            var result = self
            result.returnNodes.addNode(node)
            return result
        }
        
        func satisfyingExits() -> _NodeCreationResult {
            var result = self
            result.exitNodes.clear()
            return result
        }
        func satisfyingBreaks(labeled targetLabel: String? = nil) -> _NodeCreationResult {
            var result = self
            result.breakNodes.clear(labeled: nil)
            result.breakNodes.clear(labeled: targetLabel)
            return result
        }
        func satisfyingContinues(label targetLabel: String? = nil) -> _NodeCreationResult {
            var result = self
            result.continueNodes.clear(labeled: nil)
            result.continueNodes.clear(labeled: targetLabel)
            return result
        }
        func satisfyingFallthroughs() -> _NodeCreationResult {
            var result = self
            result.fallthroughNodes.clear()
            return result
        }
        func satisfyingReturns() -> _NodeCreationResult {
            var result = self
            result.returnNodes.clear()
            return result
        }
        
        func breakToExits(targetLabel: String? = nil) -> _NodeCreationResult {
            var result = self
            result.exitNodes.merge(with: result.breakNodes.matchingTargetLabel(targetLabel))
            result.exitNodes.merge(with: result.breakNodes.matchingTargetLabel(nil))
            return result.satisfyingBreaks(labeled: targetLabel)
        }
        
        func returnToExits() -> _NodeCreationResult {
            var result = self
            result.exitNodes.merge(with: result.returnNodes)
            return result.satisfyingReturns()
        }
        
        func appendingDefers(_ defers: [ControlFlowSubgraphNode]) -> _NodeCreationResult {
            defers.reduce(self, { $0.appendingDefer($1) })
        }
        
        func appendingExitDefers(_ defers: [ControlFlowSubgraphNode]) -> _NodeCreationResult {
            defers.reduce(self, { $0.appendingExitDefer($1) })
        }
        
        func appendingExitDefer(_ node: ControlFlowSubgraphNode) -> _NodeCreationResult {
            var result = self
            result.exitNodes.appendDefer(node)
            return result
        }
        
        func appendingDefer(_ node: ControlFlowSubgraphNode) -> _NodeCreationResult {
            var result = self
            result.breakNodes.appendDefer(node)
            result.continueNodes.appendDefer(node)
            result.fallthroughNodes.appendDefer(node)
            result.returnNodes.appendDefer(node)
            return result
        }
        
        func addingJumpInto(from target: ControlFlowGraphJumpTarget) -> _NodeCreationResult {
            if !isValid {
                return self
            }
            
            var result = self
            result.operations.append(contentsOf: target.chainOperations(endingIn: startNode))
            return result
        }
        
        /**
         Connects this subgraph result into another subgraph result by means
         of connecting the start node of each subgraph.
         
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
         */
        func addingBranch(towards result: _NodeCreationResult) -> _NodeCreationResult {
            if !result.isValid {
                return self
            }
            if !isValid {
                return result
            }
            
            var newResult = self
            
            newResult.operations.append(.addNode(startNode))
            newResult.operations.append(.addNode(result.startNode))
            newResult.operations.append(.addEdge(start: startNode, end: result.startNode))
            newResult.operations.append(contentsOf: result.operations)
            
            newResult.exitNodes.merge(with: result.exitNodes)
            newResult.breakNodes.merge(with: result.breakNodes)
            newResult.continueNodes.merge(with: result.continueNodes)
            newResult.fallthroughNodes.merge(with: result.fallthroughNodes)
            newResult.returnNodes.merge(with: result.returnNodes)
            
            return newResult
        }
        
        func connectingExits(to node: ControlFlowGraphNode) -> _NodeCreationResult {
            var result = self
            
            result.operations.append(contentsOf: exitNodes.chainOperations(endingIn: node))
            
            return result.satisfyingExits()
        }
        
        func connectingContinues(label targetLabel: String? = nil, to node: ControlFlowGraphNode) -> _NodeCreationResult {
            var newResult = self
            
            let operations = continueNodes
                .matchingTargetLabel(targetLabel)
                .chainOperations(endingIn: node)
            
            newResult.operations.append(contentsOf: operations)
            
            return newResult.satisfyingContinues(label: targetLabel)
        }
        
        func chainingExits(to next: _NodeCreationResult) -> _NodeCreationResult {
            if !next.isValid {
                return self
            }
            if !isValid {
                return next
            }
            
            var newResult = self.connectingExits(to: next.startNode)
            
            newResult.operations.append(contentsOf: next.operations)
            
            newResult.exitNodes = next.exitNodes
            newResult.breakNodes.merge(with: next.breakNodes)
            newResult.continueNodes.merge(with: next.continueNodes)
            newResult.fallthroughNodes.merge(with: next.fallthroughNodes)
            newResult.returnNodes.merge(with: next.returnNodes)
            
            return newResult
        }
        
        private class _InvalidSyntaxNode: SyntaxNode {
            
        }
        
        enum GraphOperation {
            case addNode(ControlFlowGraphNode)
            case addEdge(start: ControlFlowGraphNode, end: ControlFlowGraphNode)
        }
    }
    
    struct ControlFlowGraphJumpTarget {
        private(set) var nodes: [JumpNodeEntry] = []
        
        mutating func clear(labeled targetLabel: String? = nil) {
            nodes.removeAll(where: { $0.jumpLabel == targetLabel })
        }
        
        mutating func addNode(_ node: ControlFlowGraphNode, targetLabel: String? = nil) {
            nodes.append(JumpNodeEntry(node: node, defers: [], jumpLabel: targetLabel))
        }
        
        func matchingTargetLabel(_ targetLabel: String?) -> ControlFlowGraphJumpTarget {
            ControlFlowGraphJumpTarget(nodes: entriesForTargetLabel(targetLabel))
        }
        
        func entriesForTargetLabel(_ label: String?) -> [JumpNodeEntry] {
            nodes.filter({ $0.jumpLabel == label })
        }
        
        mutating func appendDefer(_ node: ControlFlowSubgraphNode) {
            for i in 0..<nodes.count {
                nodes[i].defers.append(node)
            }
        }
        
        mutating func merge(with second: ControlFlowGraphJumpTarget) {
            self = ControlFlowGraphJumpTarget.merge(self, second)
        }
        
        func chainOperations(endingIn ending: ControlFlowGraphNode) -> [_NodeCreationResult.GraphOperation] {
            var operations: [_NodeCreationResult.GraphOperation] = []
            for target in nodes {
                let targetNodes =
                    [target.node]
                        + Array(target.defers.reversed())
                        + [ending]
                
                for (first, second) in zip(targetNodes, targetNodes.dropFirst()) {
                    operations.append(.addNode(first))
                    operations.append(.addEdge(start: first, end: second))
                }
            }
            
            return operations
        }
        
        static func merge(_ first: ControlFlowGraphJumpTarget,
                          _ second: ControlFlowGraphJumpTarget) -> ControlFlowGraphJumpTarget {
            
            ControlFlowGraphJumpTarget(nodes: first.nodes + second.nodes)
        }
        
        struct JumpNodeEntry {
            var node: ControlFlowGraphNode
            var defers: [ControlFlowSubgraphNode]
            var jumpLabel: String?
        }
    }
}
