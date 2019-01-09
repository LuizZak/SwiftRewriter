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
        
        return _connections(for: statements, start: .invalid)
    }
    
    private static func _connections(for statement: Statement) -> _NodeCreationResult {
        
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
            return _connections(for: stmt.statements)
            
        case let stmt as IfStatement:
            return _connections(forIf: stmt)
            
        case let stmt as SwitchStatement:
            return _connections(forSwitch: stmt)
            
        case let stmt as WhileStatement:
            return _connections(forWhile: stmt)
            
        case let stmt as DoWhileStatement:
            return _connections(forDoWhile: stmt)
            
        case let stmt as ForStatement:
            return _connections(forForLoop: stmt)
            
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
    
    static func _connections(forIf stmt: IfStatement) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body)
        result = result.addingBranch(bodyConnections)
        
        if let elseBody = stmt.elseBody {
            let elseConnections = _connections(for: elseBody)
            result = result.addingBranch(elseConnections)
        } else {
            result = result.addingExitNode(node, defers: [])
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
            
            if let lastFallthrough = lastFallthrough {
                branch = branch.addingJumpInto(from: lastFallthrough)
            }
            
            result =
                result
                    .addingBranch(branch.breakToExits())
            
            lastFallthrough = branch.fallthroughNodes
        }
        
        if let def = stmt.defaultCase {
            let defResult = _connections(for: def)
            result = result.addingBranch(defResult)
        } else {
            result = result.addingExitNode(node, defers: [])
        }
        
        return result
    }
    
    static func _connections(forWhile stmt: WhileStatement) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body)
        
        if bodyConnections.isValid {
            result =
                result.addingBranch(bodyConnections)
                    .chainingExits(to: result)
                    .breakToExits()
                    .chainingContinues(to: result)
        } else {
            result = result
                .addingExitNode(node, defers: [])
                .chainingExits(to: result)
        }
        
        result = result.addingExitNode(node, defers: [])
        
        return result
    }
    
    static func _connections(forDoWhile stmt: DoWhileStatement) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body)
        
        if bodyConnections.isValid {
            result =
                bodyConnections
                    .chainingExits(to: result)
                    .chainingContinues(to: bodyConnections)
            
            result =
                result
                    .addingExitNode(node, defers: [])
                    .connecting(to: bodyConnections.startNode)
                    .addingExitNode(node, defers: [])
                    .breakToExits()
        } else {
            result = result
                .addingExitNode(node, defers: [])
                .chainingExits(to: result)
                .addingExitNode(node, defers: [])
        }
        
        return result
    }
    
    static func _connections(forForLoop stmt: ForStatement) -> _NodeCreationResult {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _NodeCreationResult(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body)
        
        if bodyConnections.isValid {
            result =
                result.addingBranch(bodyConnections)
                    .chainingExits(to: result)
                    .breakToExits()
                    .chainingContinues(to: result)
        } else {
            result = result
                .addingExitNode(node, defers: [])
                .chainingExits(to: result)
        }
        
        result = result.addingExitNode(node, defers: [])
        
        return result
    }
    
    struct _NodeCreationResult {
        static let invalid = _NodeCreationResult(startNode: ControlFlowGraphNode(node: _InvalidSyntaxNode()))
        
        var isValid: Bool {
            return !(startNode.node is _InvalidSyntaxNode)
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
        
        // TODO: What do we do if self.isValid == true?
        func appendingDefers(_ defers: [ControlFlowSubgraphNode]) -> _NodeCreationResult {
            return defers.reduce(self, { $0.appendingDefer($1) })
        }
        
        // TODO: What do we do if self.isValid == true?
        func appendingExitDefers(_ defers: [ControlFlowSubgraphNode]) -> _NodeCreationResult {
            return defers.reduce(self, { $0.appendingExitDefer($1) })
        }
        
        // TODO: What do we do if self.isValid == true?
        func appendingExitDefer(_ node: ControlFlowSubgraphNode) -> _NodeCreationResult {
            var result = self
            result.exitNodes.appendDefer(node)
            return result
        }
        
        // TODO: What do we do if self.isValid == true?
        func appendingDefer(_ node: ControlFlowSubgraphNode) -> _NodeCreationResult {
            var result = self
            result.breakNodes.appendDefer(node)
            result.continueNodes.appendDefer(node)
            result.fallthroughNodes.appendDefer(node)
            result.returnNodes.appendDefer(node)
            return result
        }
        
        // TODO: What do we do if self.isValid == true?
        func addingJumpInto(from target: ControlFlowGraphJumpTarget) -> _NodeCreationResult {
            var result = self
            result.operations.append(contentsOf: target.chainOperations(endingIn: startNode))
            return result
        }
        
        func addingBranch(_ result: _NodeCreationResult) -> _NodeCreationResult {
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
        
        func connecting(to node: ControlFlowGraphNode) -> _NodeCreationResult {
            var result = self
            
            result.operations.append(contentsOf: exitNodes.chainOperations(endingIn: node))
            
            return result.satisfyingExits()
        }
        
        func chainingExits(to next: _NodeCreationResult) -> _NodeCreationResult {
            if !next.isValid {
                return self
            }
            if !isValid {
                return next
            }
            
            var newResult = self.connecting(to: next.startNode)
            
            newResult.operations.append(contentsOf: next.operations)
            
            newResult.exitNodes = next.exitNodes
            newResult.breakNodes.merge(with: next.breakNodes)
            newResult.continueNodes.merge(with: next.continueNodes)
            newResult.fallthroughNodes.merge(with: next.fallthroughNodes)
            newResult.returnNodes.merge(with: next.returnNodes)
            
            return newResult
        }
        
        func chainingContinues(to next: _NodeCreationResult) -> _NodeCreationResult {
            if !next.isValid {
                return self
            }
            if !isValid {
                return next
            }
            
            var newResult = self
            
            newResult.operations.append(contentsOf: next.operations)
            newResult.operations.append(contentsOf:
                continueNodes.chainOperations(endingIn: next.startNode))
            
            newResult.breakNodes.merge(with: next.breakNodes)
            newResult.fallthroughNodes.merge(with: next.fallthroughNodes)
            newResult.returnNodes.merge(with: next.returnNodes)
            
            return newResult.satisfyingContinues()
        }
        
        private class _InvalidSyntaxNode: SyntaxNode {
            
        }
        
        enum GraphOperation {
            case addNode(ControlFlowGraphNode)
            case addEdge(start: ControlFlowGraphNode, end: ControlFlowGraphNode)
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
        
        func chainOperations(endingIn ending: ControlFlowGraphNode) -> [_NodeCreationResult.GraphOperation] {
            var operations: [_NodeCreationResult.GraphOperation] = []
            for node in nodes {
                let defers = Array(node.defers.reversed())
                
                operations.append(.addNode(node.node))
                
                for (i, def) in defers.enumerated() {
                    operations.append(.addNode(def))
                    
                    if i == 0 {
                        operations.append(.addEdge(start: node.node, end: def))
                    } else {
                        operations.append(.addEdge(start: defers[i - 1], end: def))
                    }
                }
                
                if let last = defers.last {
                    operations.append(.addEdge(start: last, end: ending))
                } else {
                    operations.append(.addEdge(start: node.node, end: ending))
                }
            }
            
            return operations
        }
        
        static func merge(_ first: ControlFlowGraphJumpTarget,
                          _ second: ControlFlowGraphJumpTarget) -> ControlFlowGraphJumpTarget {
            
            return ControlFlowGraphJumpTarget(nodes: first.nodes + second.nodes)
        }
    }
}
