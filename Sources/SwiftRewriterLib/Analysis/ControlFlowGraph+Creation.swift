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
    
    func insert(graph: ControlFlowGraph, between start: ControlFlowGraphNode, _ end: ControlFlowGraphNode) {
        let nodes = graph.nodes.filter {
            $0 !== graph.entry && $0 !== graph.exit
        }
        
        let edges = graph.edges.filter {
            $0.start !== graph.entry && $0.start !== graph.exit
                && $0.end !== graph.entry && $0.end !== graph.exit
        }
        
        for node in nodes {
            addNode(node)
        }
        for edge in edges {
            let e = addEdge(from: edge.start, to: edge.end)
            e.isBackEdge = edge.isBackEdge
        }
        
        // Re-connect original entry/exit edges
        for node in graph.nodesConnected(from: graph.entry) {
            addEdge(from: start, to: node)
        }
        for node in graph.nodesConnected(towards: graph.exit) {
            addEdge(from: node, to: end)
        }
    }
    
    func reset(entry: ControlFlowGraphEntryNode, exit: ControlFlowGraphExitNode) {
        nodes.removeAll()
        edges.removeAll()
        
        self.entry = entry
        self.exit = exit
        
        nodes.append(entry)
        nodes.append(exit)
    }
    
    func addNode(_ node: ControlFlowGraphNode) {
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
    
    @discardableResult
    func addEdges(from nodes: [ControlFlowGraphNode], to node2: ControlFlowGraphNode) -> [ControlFlowGraphEdge] {
        return nodes.map {
            addEdge(from: $0, to: node2)
        }
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
    
    /// Inserts a given syntax node after a given syntax node's corresponding
    /// graph node in this graph.
    ///
    /// Asserts in case `existingNode` is not part of this graph.
    @discardableResult
    func insert(node: SyntaxNode,
                after existingNode: SyntaxNode,
                mode: AfterInsertionMode = .add) -> ControlFlowGraphNode {
        
        guard let existingGraphNode = graphNode(for: existingNode) else {
            assertionFailure("Expected 'existingNode' to be part of this graph")
            return ControlFlowGraphNode(node: node)
        }
        
        return insert(node: node, after: existingGraphNode, mode: mode)
    }
    
    /// Inserts a given syntax node after a given control flow graph in this
    /// graph.
    @discardableResult
    func insert(node: SyntaxNode,
                after existingNode: ControlFlowGraphNode,
                mode: AfterInsertionMode = .add) -> ControlFlowGraphNode {
        
        let node = ControlFlowGraphNode(node: node)
        return insert(node: node, after: existingNode, mode: mode)
    }
    
    /// Inserts a given syntax node after a given control flow graph in this
    /// graph.
    @discardableResult
    func insert(node: ControlFlowGraphNode,
                after existingNode: ControlFlowGraphNode,
                mode: AfterInsertionMode = .add) -> ControlFlowGraphNode {
        
        switch mode {
        case .add:
            addNode(node)
            addEdge(from: existingNode, to: node)
            
        case .beforeOutgoingNodes:
            let edges = self.edges(from: existingNode)
            removeEdges(edges)
            
            addNode(node)
            addEdge(from: existingNode, to: node)
            
            for edge in edges {
                addEdge(from: node, to: edge.end)
            }
        }
        
        return node
    }
    
    /// Inserts a given syntax node before a given control flow graph in this
    /// graph.
    @discardableResult
    func insert(node: SyntaxNode,
                before existingNode: ControlFlowGraphNode,
                mode: BeforeInsertionMode = .add) -> ControlFlowGraphNode {
        
        let node = ControlFlowGraphNode(node: node)
        
        switch mode {
        case .add:
            addNode(node)
            addEdge(from: node, to: existingNode)
            
        case .beforeIngoingNodes:
            let edges = self.edges(towards: existingNode)
            removeEdges(edges)
            
            addNode(node)
            addEdge(from: node, to: existingNode)
            
            for edge in edges {
                addEdge(from: edge.start, to: node)
            }
        }
        
        return node
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
    
    enum AfterInsertionMode {
        /// Adds a new outgoing edge on the target node for the new node:
        ///
        /// ```
        ///     target      N - new node
        ///      node       |
        ///        |        V
        ///        |
        ///                /-> O
        ///        O --------> O    - existing nodes
        ///                \-> O
        ///
        /// result:
        ///
        ///                /-> N
        ///                |-> O
        ///        O --------> O
        ///                \-> O
        /// ```
        case add
        
        /// Adds a new edge between the inserted node and the target node, and
        /// move all previous outgoing nodes from the target to the new node:
        ///
        /// ```
        ///     target  N - new node
        ///      node   |
        ///        |    |
        ///        |    V
        ///                /-> O
        ///        O --------> O    - existing nodes
        ///                \-> O
        ///
        /// result:
        ///
        ///                /-> O
        ///        O -> N ---> O
        ///                \-> O
        /// ```
        case beforeOutgoingNodes
    }
    
    enum BeforeInsertionMode {
        /// Adds a new ingoing edge on the target node for the new node:
        ///
        /// ```
        ///       N - new     target
        ///       |   node     node
        ///       V              |
        ///                      |
        ///       O --\
        ///       O -----------> O
        ///       O --/
        ///
        /// result:
        ///
        ///       N --\
        ///       O --|
        ///       O -----------> O
        ///       O --/
        /// ```
        case add
        
        /// Adds a new edge between the inserted node and the target node, and
        /// move all previous ingoing nodes from the target to the new node:
        ///
        /// ```
        ///     new node - N   target
        ///                |    node
        ///                |      |
        ///                V      |
        ///       O --\
        ///       O ------------> O
        ///       O --/
        ///
        /// result:
        ///
        ///       O --\
        ///       O ----> N ----> O
        ///       O --/
        /// ```
        case beforeIngoingNodes
    }
}

public extension ControlFlowGraph {
    private typealias NodeCreationResult = (start: ControlFlowGraphNode, endings: [EdgeConstructor])
    
    /// Creates a control flow graph for a given compound statement.
    /// The entry and exit points for the resulting graph will be the compound
    /// statement itself, with its inner nodes being the statements contained
    /// within.
    public static func forCompoundStatement(_ compoundStatement: CompoundStatement) -> ControlFlowGraph {
        let graph = forStatementList(compoundStatement.statements, baseNode: compoundStatement)
        
        expandSubgraphs(in: graph)
        
        return graph
    }
    
    private static func expandSubgraphs(in graph: ControlFlowGraph) {
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
        
        let context = Context()
        
        _=context.pushScope(entry)
        
        let graph = ControlFlowGraph(entry: entry, exit: exit)
        
        var prev: NodeCreationResult = (entry, [EdgeConstructor(for: entry, in: graph)])
        
        for subStmt in statements {
            guard let cur = _connections(for: subStmt, in: graph, context: context) else {
                continue
            }
            
            prev.endings.connect(to: cur.start)
            prev = cur
        }
        
        prev = context.popScope(entry, start: entry, outConnections: prev.endings, in: graph)
        
        prev.endings.connect(to: exit)
        
        return graph
    }
    
    private static func _connections(for stmt: Statement,
                                     in graph: ControlFlowGraph,
                                     context: Context) -> NodeCreationResult? {
        
        let node = ControlFlowGraphNode(node: stmt)
        
        switch stmt {
        case is ExpressionsStatement,
             is VariableDeclarationsStatement:
            
            graph.addNode(node)
            
            return (node, [EdgeConstructor(for: node, in: graph)])
            
        case is ReturnStatement:
            graph.addNode(node)
            
            let activeDeferNodes = context.activeDeferNodes
            if activeDeferNodes.count > 0 {
                graph.connectChain(start: node, rest: context.activeDeferNodes)
                
                return (node, [])
            }
            
            graph.addEdge(from: node, to: graph.exit)
            
            return (node, [])
            
        case is BreakStatement:
            graph.addNode(node)
            if let breakTarget = context.breakTarget {
                for def in breakTarget.defers {
                    context.satisfyDefer(node: def)
                }
                
                breakTarget.target.addNode(node, defers: breakTarget.defers)
            }
            
            return (node, [])
            
        case is ContinueStatement:
            graph.addNode(node)
            context.continueTarget?.addNode(node, defers: context.activeDeferNodes)
            
            return (node, [])
            
        case let stmt as CompoundStatement:
            if stmt.isEmpty {
                return nil
            }
            
            _=context.pushScope(node)
            
            var start: ControlFlowGraphNode?
            var prev: NodeCreationResult?
            for subStmt in stmt.statements {
                guard let cur = _connections(for: subStmt, in: graph, context: context) else {
                    continue
                }
                
                if let prev = prev {
                    prev.endings.connect(to: cur.start)
                } else {
                    start = cur.start
                }
                
                prev = cur
            }
            
            if let prev = prev, let start = start {
                let result = context.popScope(node, start: start, outConnections: prev.endings, in: graph)
                
                return result
            }
            
            return nil
            
        case let stmt as DoStatement:
            // TODO: Support breaking out of labeled do statements
            _=context.pushScope(node)
            
            if let result = _connections(for: stmt.body, in: graph, context: context) {
                return context.popScope(node,
                                        start: result.start,
                                        outConnections: result.endings,
                                        in: graph)
            }
            
            return context.popScope(node,
                                    start: node,
                                    outConnections: [],
                                    in: graph)
            
        case let stmt as DeferStatement:
            let body = ControlFlowGraph.forCompoundStatement(stmt.body)
            
            let subgraph = ControlFlowSubgraphNode(node: stmt, graph: body)
            
            graph.addNode(subgraph)
            
            context.pushDefer(graph: subgraph)
            
            return nil
            
        case let stmt as IfStatement:
            graph.addNode(node)
            
            // TODO: Support breaking out of labeled if statements
            _=context.pushScope(node)
            
            var connections: [EdgeConstructor] = []
            
            if let bodyNode = _connections(for: stmt.body, in: graph, context: context) {
                graph.addEdge(from: node, to: bodyNode.start)
                connections.append(contentsOf: bodyNode.endings)
            }
            
            let hasElse: Bool
            
            if let elseBody = stmt.elseBody,
                let elseBodyNode = _connections(for: elseBody, in: graph, context: context) {
                
                hasElse = true
                
                graph.addEdge(from: node, to: elseBodyNode.start)
                connections.append(contentsOf: elseBodyNode.endings)
            } else {
                hasElse = false
            }
            
            var result = context.popScope(node,
                                          start: node,
                                          outConnections: connections,
                                          in: graph)
            
            if !hasElse {
                result.endings.append(EdgeConstructor(for: node, in: graph))
            }
            
            return result
            
        case let stmt as SwitchStatement:
            graph.addNode(node)
            
            let scope = context.pushScope(node)
            
            var connections: [EdgeConstructor] = []
            
            let caseStatements =
                stmt.cases.map { $0.statements }
            
            // TODO: Support detecting fallthrough in switch cases
            for stmts in caseStatements + [stmt.defaultCase ?? []] {
                let caseConnections =
                    stmts.compactMap {
                        _connections(for: $0, in: graph, context: context)
                    }
                
                if caseConnections.isEmpty {
                    continue
                }
                
                graph.addEdge(from: node, to: caseConnections[0].start)
                zip(caseConnections, caseConnections.dropFirst()).forEach {
                    $0.endings.connect(to: $1.start)
                }
                
                connections.append(contentsOf: caseConnections.last!.endings)
            }
            
            if stmt.defaultCase == nil {
                connections.append(EdgeConstructor(for: node, in: graph))
            }
            
            let breaks = scope.breakTarget!
            
            return context.popScope(node,
                                    start: node,
                                    outConnections: connections + breaks.edgeConstructors(in: graph),
                                    in: graph)
            
        case let stmt as ForStatement:
            graph.addNode(node)
            
            return _makeLoop(node: node, body: stmt.body, in: graph, context: context)
            
        case let stmt as WhileStatement:
            graph.addNode(node)
            
            return _makeLoop(node: node, body: stmt.body, in: graph, context: context)
            
        case let stmt as DoWhileStatement:
            graph.addNode(node)
            
            let scope = context.pushScope(node)
            
            var loopHead: ControlFlowGraphNode = node
            
            if let bodyNode = _connections(for: stmt.body, in: graph, context: context) {
                bodyNode.endings.connect(to: node)
                loopHead = bodyNode.start
                graph.addBackEdge(from: node, to: bodyNode.start)
            } else {
                // connect loop back on itself
                graph.addBackEdge(from: node, to: node)
            }
            
            let breaks = scope.breakTarget!
            var result = context.popScope(node,
                                          start: loopHead,
                                          outConnections: breaks.edgeConstructors(in: graph),
                                          in: graph)
            
            result.endings.append(EdgeConstructor(for: node, in: graph))
            
            return result
            
        default:
            return nil
        }
    }
    
    private static func _makeLoop(node: ControlFlowGraphNode,
                                  body: CompoundStatement,
                                  in graph: ControlFlowGraph,
                                  context: Context) -> NodeCreationResult? {
        
        let scope = context.pushScope(node)
        
        if let bodyNode = _connections(for: body, in: graph, context: context) {
            graph.addEdge(from: node, to: bodyNode.start)
            
            // Add a back edge pointing back to the beginning of the loop
            let backEdges = bodyNode.endings.connect(to: node)
            for backEdge in backEdges {
                backEdge.isBackEdge = true
            }
            
            if let continues = context.continueTarget {
                for continueNode in continues.nodes {
                    let backEdge = graph.addEdge(from: continueNode.node, to: node)
                    backEdge.isBackEdge = true
                }
            }
        } else {
            // connect loop back on itself
            graph.addBackEdge(from: node, to: node)
        }
        
        let breaks = scope.breakTarget!
        var result = context.popScope(node,
                                      start: node,
                                      outConnections: breaks.edgeConstructors(in: graph),
                                      in: graph)
        
        result.endings.append(EdgeConstructor(for: node, in: graph))
        
        return result
    }
    
    private class Context {
        private(set) var scopes: [Scope] = []
        
        var currentScope: Scope? {
            return scopes.last
        }
        
        /// Returns the stack of defer statements node, in reverse order (defers
        /// defined later appear first)
        var activeDeferNodes: [ControlFlowSubgraphNode] {
            return scopes.flatMap { $0.openDefers }.reversed()
        }
        
        var breakTarget: (target: ControlFlowGraphJumpTarget, defers: [ControlFlowSubgraphNode])? {
            var defers: [ControlFlowSubgraphNode] = []
            
            for scope in scopes.reversed() {
                defers.append(contentsOf: scope.openDefers)
                
                if let breakTarget = scope.breakTarget {
                    return (breakTarget, defers)
                }
            }
            
            return nil
        }
        
        var continueTarget: ControlFlowGraphJumpTarget? {
            for scope in scopes.reversed() {
                if let continueTarget = scope.continueTarget {
                    return continueTarget
                }
            }
            
            return nil
        }
        
        // TODO: Support for pushing/popping and breaking/continuing labeled
        // statements
        func pushScope(_ node: ControlFlowGraphNode) -> Scope {
            let scope = Scope()
            
            switch node.node {
            case is ForStatement, is WhileStatement, is DoWhileStatement:
                scope.breakTarget = ControlFlowGraphJumpTarget()
                scope.continueTarget = ControlFlowGraphJumpTarget()
                scope.isLoopScope = true
                
            case is SwitchStatement:
                scope.breakTarget = ControlFlowGraphJumpTarget()
                
            case is CompoundStatement where currentScope?.isLoopScope == true:
                scope.isLoopScope = true
                
            default:
                break
            }
            
            scopes.append(scope)
            
            return scope
        }
        
        func popScope(_ node: ControlFlowGraphNode,
                      start: ControlFlowGraphNode,
                      outConnections: [EdgeConstructor],
                      in graph: ControlFlowGraph) -> NodeCreationResult {
            
            let scope = scopes.removeLast()
            
            var lastConnections: [EdgeConstructor] = outConnections
            
            let defers = scope.openDefers

            for deferGraph in defers.reversed() {
                lastConnections.connect(to: deferGraph)
                lastConnections = [EdgeConstructor(for: deferGraph, in: graph)]
            }
            
            return (start, lastConnections)
        }
        
        func pushDefer(graph: ControlFlowSubgraphNode) {
            scopes[scopes.count - 1].openDefers.append(graph)
        }
        
        func satisfyDefer(node: ControlFlowSubgraphNode) {
            for scope in scopes.reversed() {
                if let index = scope.openDefers.firstIndex(where: { $0 === node }) {
                    scope.openDefers.remove(at: index)
                    return
                }
            }
        }
        
        class Scope {
            /// Stack of opened defer statement sub-graphs for the current scope
            var openDefers: [ControlFlowSubgraphNode] = []
            var continueTarget: ControlFlowGraphJumpTarget?
            var breakTarget: ControlFlowGraphJumpTarget?
            var isLoopScope: Bool = false
        }
    }
    
    private class ControlFlowGraphJumpTarget {
        private(set) var nodes: [(node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode])] = []
        
        func addNode(_ node: ControlFlowGraphNode, defers: [ControlFlowSubgraphNode]) {
            nodes.append((node, defers))
        }
        
        func edgeConstructors(in graph: ControlFlowGraph) -> [EdgeConstructor] {
            return nodes.map { node in
                graph.connectChain(start: node.node, rest: node.defers)
            }
        }
    }
}

private extension ControlFlowGraph {
    
    private func insert(graph: ControlFlowGraph, ingoingConnections: [EdgeConstructor], _ end: ControlFlowGraphNode) {
        let nodes = graph.nodes.filter {
            $0 !== graph.entry && $0 !== graph.exit
        }
        
        let edges = graph.edges.filter {
            $0.start !== graph.entry && $0.start !== graph.exit
                && $0.end !== graph.entry && $0.end !== graph.exit
        }
        
        for node in nodes {
            addNode(node)
        }
        for edge in edges {
            let e = addEdge(from: edge.start, to: edge.end)
            e.isBackEdge = edge.isBackEdge
        }
        
        // Re-connect original entry/exit edges
        for node in graph.nodesConnected(from: graph.entry) {
            ingoingConnections.connect(to: node)
        }
    }
    
}

/// Represents a free connection that is meant to be connected to next nodes
/// when traversing AST nodes to construct control flow graphs.
private struct EdgeConstructor {
    private let _constructor: (ControlFlowGraphNode) -> ControlFlowGraphEdge
    
    init(for node: ControlFlowGraphNode, in graph: ControlFlowGraph) {
        self.init { n in
            graph.addEdge(from: node, to: n)
        }
    }
    
    init(_ constructor: @escaping (ControlFlowGraphNode) -> ControlFlowGraphEdge) {
        self._constructor = constructor
    }
    
    @discardableResult
    func connect(to node: ControlFlowGraphNode) -> ControlFlowGraphEdge {
        return _constructor(node)
    }
}

private extension Sequence where Element == EdgeConstructor {
    @discardableResult
    func connect(to node: ControlFlowGraphNode) -> [ControlFlowGraphEdge] {
        return self.map { $0.connect(to: node) }
    }
}
