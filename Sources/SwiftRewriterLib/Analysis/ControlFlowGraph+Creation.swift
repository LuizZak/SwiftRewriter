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
    
    @discardableResult
    func addBackEdge(from node1: ControlFlowGraphNode, to node2: ControlFlowGraphNode) -> ControlFlowGraphEdge {
        let edge = addEdge(from: node1, to: node2)
        edge.isBackEdge = true
        
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
        var queue: [(ControlFlowGraphNode, [ControlFlowGraphNode])] = []
        
        queue.append((graph.entry, [graph.entry]))
        
        while let next = queue.popLast() {
            visited.insert(next.0)
        
            for nextEdge in graph.edges(from: next.0) {
                let node = nextEdge.end
                if next.1.contains(node) {
                    nextEdge.isBackEdge = true
                    continue
                }
                
                queue.append((node, next.1 + [node]))
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
        
        if statements.isEmpty {
            return start
        }
        
        var activeDefers: [ControlFlowSubgraphNode] = []
        
        var previous = start
        
        for statement in statements {
            let connections = _connections(for: statement, in: graph)
            if connections.isDefer {
                activeDefers.append(connections.startNode as! ControlFlowSubgraphNode)
                continue
            }
            
            previous = previous.chainResult(next: connections, in: graph)
        }
        
        return previous.appendingDefers(activeDefers)
    }
    
    private static func _connections(for statements: [Statement],
                                     in graph: ControlFlowGraph) -> _NodeCreationResult {
        
        if statements.isEmpty {
            return _NodeCreationResult.invalid
        }
        
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
            
        case let stmt as DeferStatement:
            let subgraph = forStatementList(stmt.body.statements, baseNode: stmt)
            let defNode = ControlFlowSubgraphNode(node: stmt, graph: subgraph)
            
            graph.addNode(defNode)
            
            return _NodeCreationResult(startNode: defNode)
                .appendingDefer(defNode)
            
        case let stmt as FallthroughStatement:
            return _connections(forFallthrough: stmt)
            
        case let stmt as CompoundStatement:
            return _connections(for: stmt.statements, in: graph)
            
        case let stmt as IfStatement:
            return _connections(forIf: stmt, in: graph)
            
        case let stmt as WhileStatement:
            return _connections(forWhile: stmt, in: graph)
            
        case let stmt as SwitchStatement:
            return _connections(forSwitch: stmt, in: graph)
            
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
    
    static func _connections(forWhile stmt: WhileStatement, in graph: ControlFlowGraph) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body, in: graph)
        
        result =
            result.addingBranch(bodyConnections, in: graph)
                .chainResult(next: result, in: graph)
                .breakToExits()
                .chainContinues(to: result, in: graph)
        
        result = result.addingExitNode(node, defers: [])
        
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
    
    class Context {
        private(set) var scopes: [Scope] = []
        
        var currentScope: Scope? {
            return scopes.last
        }
        
        /// Returns the stack of defer statements node, in reverse order (defers
        /// defined later appear first)
        var activeDeferNodes: [ControlFlowSubgraphNode] {
            return scopes.flatMap { $0.openDefers }.reversed()
        }
        
        func pushScope() -> Scope {
            let scope = Scope()
            
            scopes.append(scope)
            
            return scope
        }
        
        func popScope() -> Scope {
            return scopes.removeLast()
        }
        
        func pushDefer(graph: ControlFlowSubgraphNode) {
            scopes[scopes.count - 1].openDefers.append(graph)
        }
        
        class Scope {
            /// Stack of opened defer statement sub-graphs for the current scope
            var openDefers: [ControlFlowSubgraphNode] = []
        }
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
        
        mutating func addExitNode(_ node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode]) {
            self = addingExitNode(node, defers: defers)
        }
        mutating func addBreakNode(_ node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode]) {
            self = addingBreakNode(node, defers: defers)
        }
        mutating func addContinueNode(_ node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode]) {
            self = addingContinueNode(node, defers: defers)
        }
        mutating func addFallthroughNode(_ node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode]) {
            self = addingFallthroughNode(node, defers: defers)
        }
        mutating func addReturnNode(_ node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode]) {
            self = addingReturnNode(node, defers: defers)
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
        
        func breakToExits() -> _NodeCreationResult {
            var result = self
            result.exitNodes.merge(with: result.breakNodes)
            result.breakNodes.clear()
            return result
        }
        
        func returnToExits() -> _NodeCreationResult {
            var result = self
            result.exitNodes.merge(with: result.returnNodes)
            result.returnNodes.clear()
            return result
        }
        
        func appendingDefers(_ defers: [ControlFlowSubgraphNode]) -> _NodeCreationResult {
            return defers.reduce(self, { $0.appendingDefer($1) })
        }
        
        func appendingDefer(_ node: ControlFlowSubgraphNode) -> _NodeCreationResult {
            var result = self
            result.exitNodes.appendDefer(node)
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
        
        func chainResult(next: _NodeCreationResult, in graph: ControlFlowGraph) -> _NodeCreationResult {
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
            
            var newResult = self
            
            exitNodes
                .edgeConstructors(in: graph)
                .connect(to: next.startNode)
            
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
            
            var newResult = self
            
            continueNodes
                .edgeConstructors(in: graph)
                .connect(to: next.startNode)
            
            newResult.exitNodes.merge(with: next.exitNodes)
            newResult.breakNodes.merge(with: next.breakNodes)
            newResult.continueNodes.merge(with: next.continueNodes)
            newResult.fallthroughNodes.merge(with: next.fallthroughNodes)
            newResult.returnNodes.merge(with: next.returnNodes)
            
            return newResult
        }
        
        private class _InvalidSyntaxNode: SyntaxNode {
            
        }
    }
    
    struct ControlFlowGraphJumpTarget {
        private(set) var nodes: [(node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode])] = []
        var defers: [ControlFlowSubgraphNode] {
            return nodes.flatMap { $0.defers }
        }
        
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
                graph.connectChain(start: node.node, rest: node.defers)
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
