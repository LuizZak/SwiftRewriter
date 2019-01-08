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
            !edgesToRemove.contains { $0 === e }
        }
    }
    
    @discardableResult
    private func connectChain<S: Sequence>(start: ControlFlowGraphNode, rest: S) -> EdgeConstructor where S.Element == ControlFlowGraphNode {
        var last = EdgeConstructor(for: start, in: self)
        
        for node in rest {
            last.connect(to: node)
            last = EdgeConstructor(for: node, in: self)
        }
        
        return last
    }
}

public extension ControlFlowGraph {
    /// Creates a control flow graph for a given compound statement.
    /// The entry and exit points for the resulting graph will be the compound
    /// statement itself, with its inner nodes being the statements contained
    /// within.
    public static func forCompoundStatement(_ compoundStatement: CompoundStatement) -> ControlFlowGraph {
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
            .addingExitNode(entry, defers: [])
        
        previous =
            _connections(for: statements, start: previous, in: graph)
                .returnToExits()
        
        previous.exitNodes
            .edgeConstructors(in: graph)
            .connect(to: exit)
        
        return graph
    }
    
    private static func _connections(for statements: [Statement],
                                     start: _NodeCreationResult,
                                     in graph: ControlFlowGraph) -> _NodeCreationResult {
        
        var activeDefers: [ControlFlowSubgraphNode] = []
        
        var previous = start
        
        for statement in statements {
            if let stmt = statement as? DeferStatement {
                let subgraph = forStatementList(stmt.body.statements, baseNode: stmt)
                let defNode = ControlFlowSubgraphNode(node: stmt, graph: subgraph)
                
                graph.addNode(defNode)
                
                activeDefers.append(defNode)
                continue
            }
            
            let connections = _connections(for: statement, in: graph)
            
            previous =
                previous
                    .chainingResult(with: connections.appendingDefers(activeDefers),
                                    in: graph)
        }
        
        return previous.appendingExitDefers(activeDefers)
    }
    
    private static func _connections(for statements: [Statement],
                                     in graph: ControlFlowGraph) -> _NodeCreationResult {
        
        return _connections(for: statements,
                            start: _NodeCreationResult.invalid,
                            in: graph)
    }
    
    private static func _connections(for statement: Statement,
                                     in graph: ControlFlowGraph) -> _NodeCreationResult {
        
        switch statement {
        case is ExpressionsStatement,
             is VariableDeclarationsStatement:
            let node = ControlFlowGraphNode(node: statement)
            
            return _NodeCreationResult(startNode: node)
                .addingExitNode(node, defers: [])
            
        case is BreakStatement:
            let node = ControlFlowGraphNode(node: statement)
            
            return _NodeCreationResult(startNode: node)
                .addingBreakNode(node, defers: [])
            
        case is ContinueStatement:
            let node = ControlFlowGraphNode(node: statement)
            
            return _NodeCreationResult(startNode: node)
                .addingContinueNode(node, defers: [])
            
        case is ReturnStatement:
            let node = ControlFlowGraphNode(node: statement)
            
            return _NodeCreationResult(startNode: node)
                .addingReturnNode(node, defers: [])
            
        // Handled separately in _connections(for:start:in) above
        case is DeferStatement:
            return .invalid
            
        case let stmt as FallthroughStatement:
            return _connections(forFallthrough: stmt)
            
        case let stmt as CompoundStatement:
            return _connections(for: stmt.statements, in: graph)
            
        case let stmt as IfStatement:
            return _connections(forIf: stmt, in: graph)
            
        case let stmt as SwitchStatement:
            return _connections(forSwitch: stmt, in: graph)
            
        case let stmt as WhileStatement:
            return _connections(forWhile: stmt, in: graph)
            
        case let stmt as DoWhileStatement:
            return _connections(forDoWhile: stmt, in: graph)
            
        case let stmt as ForStatement:
            return _connections(forForLoop: stmt, in: graph)
            
        default:
            let node = ControlFlowGraphNode(node: statement)
            
            return _NodeCreationResult(startNode: node)
                .addingExitNode(node, defers: [])
        }
    }
    
    static func _connections(forFallthrough stmt: FallthroughStatement) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        
        return _NodeCreationResult(startNode: node)
            .addingFallthroughNode(node, defers: [])
    }
    
    static func _connections(forIf stmt: IfStatement, in graph: ControlFlowGraph) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body, in: graph)
        result = result.addingBranch(bodyConnections, in: graph)
        
        if let elseBody = stmt.elseBody {
            let elseConnections = _connections(for: elseBody, in: graph)
            result = result.addingBranch(elseConnections, in: graph)
        } else {
            result = result.addingExitNode(node, defers: [])
        }
        
        return result
    }
    
    static func _connections(forSwitch stmt: SwitchStatement, in graph: ControlFlowGraph) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        var lastFallthrough: ControlFlowGraphJumpTarget?
        
        for cs in stmt.cases {
            let branch =
                _connections(for: cs.statements, in: graph)
            
            if let lastFallthrough = lastFallthrough {
                lastFallthrough
                    .edgeConstructors(in: graph)
                    .connect(to: branch.startNode)
            }
            
            result =
                result
                    .addingBranch(branch.breakToExits(), in: graph)
            
            lastFallthrough = branch.fallthroughNodes
        }
        
        if let def = stmt.defaultCase {
            let defResult = _connections(for: def, in: graph)
            result = result.addingBranch(defResult, in: graph)
        } else {
            result = result.addingExitNode(node, defers: [])
        }
        
        return result
    }
    
    static func _connections(forWhile stmt: WhileStatement, in graph: ControlFlowGraph) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body, in: graph)
        
        if bodyConnections.isValid {
            result =
                result.addingBranch(bodyConnections, in: graph)
                    .chainingResult(with: result, in: graph)
                    .breakToExits()
                    .chainContinues(to: result, in: graph)
        } else {
            result = result
                .addingExitNode(node, defers: [])
                .chainingResult(with: result, in: graph)
        }
        
        result = result.addingExitNode(node, defers: [])
        
        return result
    }
    
    static func _connections(forDoWhile stmt: DoWhileStatement, in graph: ControlFlowGraph) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body, in: graph)
        
        if bodyConnections.isValid {
            result =
                bodyConnections
                    .chainingResult(with: result, in: graph)
                    .chainContinues(to: bodyConnections, in: graph)
            
            result =
                result
                    .addingExitNode(node, defers: [])
                    .connecting(to: bodyConnections.startNode, in: graph)
                    .addingExitNode(node, defers: [])
                    .breakToExits()
        } else {
            result = result
                .addingExitNode(node, defers: [])
                .chainingResult(with: result, in: graph)
                .addingExitNode(node, defers: [])
        }
        
        return result
    }
    
    static func _connections(forForLoop stmt: ForStatement, in graph: ControlFlowGraph) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body, in: graph)
        
        if bodyConnections.isValid {
            result =
                result.addingBranch(bodyConnections, in: graph)
                    .chainingResult(with: result, in: graph)
                    .breakToExits()
                    .chainContinues(to: result, in: graph)
        } else {
            result = result
                .addingExitNode(node, defers: [])
                .chainingResult(with: result, in: graph)
        }
        
        result = result.addingExitNode(node, defers: [])
        
        return result
    }
    
    struct _NodeCreationResult {
        static let invalid = _NodeCreationResult(startNode: ControlFlowGraphNode(node: _InvalidSyntaxNode()))
        
        var isValid: Bool {
            return !(startNode.node is _InvalidSyntaxNode)
        }
        
        var isDefer: Bool {
            return (startNode.node is DeferStatement)
        }
        
        var startNode: ControlFlowGraphNode
        var exitNodes: ControlFlowGraphJumpTarget = ControlFlowGraphJumpTarget()
        var breakNodes: ControlFlowGraphJumpTarget = ControlFlowGraphJumpTarget()
        var continueNodes: ControlFlowGraphJumpTarget = ControlFlowGraphJumpTarget()
        var fallthroughNodes: ControlFlowGraphJumpTarget = ControlFlowGraphJumpTarget()
        var returnNodes: ControlFlowGraphJumpTarget = ControlFlowGraphJumpTarget()
        
        init(startNode: ControlFlowGraphNode) {
            self.startNode = startNode
        }
        
        func addingExitNode(_ node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode]) -> _NodeCreationResult {
            var result = self
            result.exitNodes.addNode(node, defers: defers)
            return result
        }
        func addingBreakNode(_ node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode]) -> _NodeCreationResult {
            var result = self
            result.breakNodes.addNode(node, defers: defers)
            return result
        }
        func addingContinueNode(_ node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode]) -> _NodeCreationResult {
            var result = self
            result.continueNodes.addNode(node, defers: defers)
            return result
        }
        func addingFallthroughNode(_ node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode]) -> _NodeCreationResult {
            var result = self
            result.fallthroughNodes.addNode(node, defers: defers)
            return result
        }
        func addingReturnNode(_ node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode]) -> _NodeCreationResult {
            var result = self
            result.returnNodes.addNode(node, defers: defers)
            return result
        }
        
        func satisfyingExits() -> _NodeCreationResult {
            var result = self
            result.exitNodes.clear()
            return result
        }
        func satisfyingBreaks() -> _NodeCreationResult {
            var result = self
            result.breakNodes.clear()
            return result
        }
        func satisfyingContinues() -> _NodeCreationResult {
            var result = self
            result.continueNodes.clear()
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
        
        func breakToExits() -> _NodeCreationResult {
            var result = self
            result.exitNodes.merge(with: result.breakNodes)
            return result.satisfyingBreaks()
        }
        
        func returnToExits() -> _NodeCreationResult {
            var result = self
            result.exitNodes.merge(with: result.returnNodes)
            return result.satisfyingReturns()
        }
        
        func appendingDefers(_ defers: [ControlFlowSubgraphNode]) -> _NodeCreationResult {
            return defers.reduce(self, { $0.appendingDefer($1) })
        }
        
        func appendingExitDefers(_ defers: [ControlFlowSubgraphNode]) -> _NodeCreationResult {
            return defers.reduce(self, { $0.appendingExitDefer($1) })
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
        
        func addingBranch(_ result: _NodeCreationResult, in graph: ControlFlowGraph) -> _NodeCreationResult {
            if !result.isValid {
                return self
            }
            if !isValid {
                return result
            }
            
            if !graph.containsNode(startNode) {
                graph.addNode(startNode)
            }
            if !graph.containsNode(result.startNode) {
                graph.addNode(result.startNode)
            }
            
            var newResult = self
            
            if graph.edge(from: startNode, to: result.startNode) == nil {
                graph.addEdge(from: startNode, to: result.startNode)
            }
            
            newResult.exitNodes.merge(with: result.exitNodes)
            newResult.breakNodes.merge(with: result.breakNodes)
            newResult.continueNodes.merge(with: result.continueNodes)
            newResult.fallthroughNodes.merge(with: result.fallthroughNodes)
            newResult.returnNodes.merge(with: result.returnNodes)
            
            return newResult
        }
        
        func connecting(to node: ControlFlowGraphNode, in graph: ControlFlowGraph) -> _NodeCreationResult {
            exitNodes
                .edgeConstructors(in: graph)
                .connect(to: node)
            
            return self.satisfyingExits()
        }
        
        func chainingResult(with next: _NodeCreationResult, in graph: ControlFlowGraph) -> _NodeCreationResult {
            if !next.isValid {
                return self
            }
            if !isValid {
                return next
            }
            
            if !graph.containsNode(startNode) {
                graph.addNode(startNode)
            }
            if !graph.containsNode(next.startNode) {
                graph.addNode(next.startNode)
            }
            
            var newResult =
                self.connecting(to: next.startNode, in: graph)
            
            newResult.exitNodes = next.exitNodes
            newResult.breakNodes.merge(with: next.breakNodes)
            newResult.continueNodes.merge(with: next.continueNodes)
            newResult.fallthroughNodes.merge(with: next.fallthroughNodes)
            newResult.returnNodes.merge(with: next.returnNodes)
            
            return newResult
        }
        
        func chainContinues(to next: _NodeCreationResult, in graph: ControlFlowGraph) -> _NodeCreationResult {
            if !next.isValid {
                return self
            }
            if !isValid {
                return next
            }
            
            if !graph.containsNode(startNode) {
                graph.addNode(startNode)
            }
            if !graph.containsNode(next.startNode) {
                graph.addNode(next.startNode)
            }
            
            let newResult = self
            
            continueNodes
                .edgeConstructors(in: graph)
                .connect(to: next.startNode)
            
            return newResult.satisfyingContinues()
        }
        
        private class _InvalidSyntaxNode: SyntaxNode {
            
        }
    }
    
    struct ControlFlowGraphJumpTarget {
        private(set) var nodes: [(node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode])] = []
        
        mutating func clear() {
            nodes.removeAll()
        }
        
        mutating func addNode(_ node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode]) {
            nodes.append((node, defers))
        }
        
        mutating func appendDefer(_ node: ControlFlowSubgraphNode) {
            for i in 0..<nodes.count {
                nodes[i].defers.append(node)
            }
        }
        
        mutating func merge(with second: ControlFlowGraphJumpTarget) {
            self = ControlFlowGraphJumpTarget.merge(self, second)
        }
        
        func edgeConstructors(in graph: ControlFlowGraph) -> [EdgeConstructor] {
            return nodes.map { node in
                graph.connectChain(start: node.node, rest: node.defers.reversed())
            }
        }
        
        static func merge(_ first: ControlFlowGraphJumpTarget,
                          _ second: ControlFlowGraphJumpTarget) -> ControlFlowGraphJumpTarget {
            
            return ControlFlowGraphJumpTarget(nodes: first.nodes + second.nodes)
        }
    }
}

/// Represents a free connection that is meant to be connected to next nodes
/// when traversing AST nodes to construct control flow graphs.
private struct EdgeConstructor {
    private let line: Int
    private let node: ControlFlowGraphNode
    private let graph: ControlFlowGraph
    
    init(for node: ControlFlowGraphNode, in graph: ControlFlowGraph, line: Int = #line) {
        self.line = line
        self.node = node
        self.graph = graph
    }
    
    @discardableResult
    func connect(to node: ControlFlowGraphNode) -> ControlFlowGraphEdge {
        if let edge = graph.edge(from: self.node, to: node) {
            return edge
        }
        
        return graph.addEdge(from: self.node, to: node)
    }
}

private extension Sequence where Element == EdgeConstructor {
    @discardableResult
    func connect(to node: ControlFlowGraphNode) -> [ControlFlowGraphEdge] {
        return self.map { $0.connect(to: node) }
    }
}
