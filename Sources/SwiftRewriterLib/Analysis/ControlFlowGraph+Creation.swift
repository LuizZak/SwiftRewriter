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
            return _connectionsForReturn(graph, node, context)
            
        case is BreakStatement:
            return _connectionsForBreak(graph, node, context)
            
        case is ContinueStatement:
            return _connectionsForContinue(graph, node, context)
            
        case let stmt as CompoundStatement:
            return _connectionsForCompound(stmt, context, node, graph)
            
        case let stmt as DoStatement:
            return _connectionsForDo(context, node, stmt, graph)
            
        case let stmt as DeferStatement:
            return _connectionsForDefer(stmt, graph, context)
            
        case let stmt as IfStatement:
            return _connectionsForIf(graph, node, context, stmt)
            
        case let stmt as SwitchStatement:
            return _connectionsForSwitch(graph, node, context, stmt)
            
        case let stmt as ForStatement:
            graph.addNode(node)
            
            return _makeLoop(node: node, body: stmt.body, in: graph, context: context)
            
        case let stmt as WhileStatement:
            graph.addNode(node)
            
            return _makeLoop(node: node, body: stmt.body, in: graph, context: context)
            
        case let stmt as DoWhileStatement:
            return _connectionsForDoWhile(graph, node, context, stmt)
            
        default:
            return nil
        }
    }
    
    private static func _connectionsForReturn(_ graph: ControlFlowGraph,
                                              _ node: ControlFlowGraphNode,
                                              _ context: ControlFlowGraph.Context) -> ControlFlowGraph.NodeCreationResult? {
        graph.addNode(node)
        
        let activeDeferNodes = context.activeDeferNodes
        if activeDeferNodes.count > 0 {
            graph.connectChain(start: node, rest: context.activeDeferNodes)
            
            return (node, [])
        }
        
        graph.addEdge(from: node, to: graph.exit)
        
        return (node, [])
    }
    
    private static func _connectionsForBreak(_ graph: ControlFlowGraph,
                                             _ node: ControlFlowGraphNode,
                                             _ context: ControlFlowGraph.Context) -> ControlFlowGraph.NodeCreationResult? {
        graph.addNode(node)
        if let breakTarget = context.breakTarget {
            for def in breakTarget.defers {
                context.satisfyDefer(node: def)
            }
            
            breakTarget.target.addNode(node, defers: breakTarget.defers)
        }
        
        return (node, [])
    }
    
    private static func _connectionsForContinue(_ graph: ControlFlowGraph,
                                                _ node: ControlFlowGraphNode,
                                                _ context: ControlFlowGraph.Context) -> ControlFlowGraph.NodeCreationResult? {
        
        graph.addNode(node)
        context.continueTarget?.addNode(node, defers: context.activeDeferNodes)
        
        return (node, [])
    }
    
    private static func _connectionsForCompound(_ stmt: CompoundStatement,
                                                _ context: ControlFlowGraph.Context,
                                                _ node: ControlFlowGraphNode,
                                                _ graph: ControlFlowGraph) -> ControlFlowGraph.NodeCreationResult? {
        
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
    }
    
    private static func _connectionsForDo(_ context: ControlFlowGraph.Context,
                                          _ node: ControlFlowGraphNode,
                                          _ stmt: DoStatement,
                                          _ graph: ControlFlowGraph) -> ControlFlowGraph.NodeCreationResult? {
        
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
    }
    
    private static func _connectionsForDefer(_ stmt: DeferStatement,
                                             _ graph: ControlFlowGraph,
                                             _ context: ControlFlowGraph.Context) -> ControlFlowGraph.NodeCreationResult? {
        
        let body = ControlFlowGraph.forCompoundStatement(stmt.body)
        
        let subgraph = ControlFlowSubgraphNode(node: stmt, graph: body)
        
        graph.addNode(subgraph)
        
        context.pushDefer(graph: subgraph)
        
        return nil
    }
    
    private static func _connectionsForIf(_ graph: ControlFlowGraph,
                                          _ node: ControlFlowGraphNode,
                                          _ context: ControlFlowGraph.Context,
                                          _ stmt: IfStatement) -> ControlFlowGraph.NodeCreationResult? {
        
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
    }
    
    private static func _connectionsForSwitch(_ graph: ControlFlowGraph,
                                              _ node: ControlFlowGraphNode,
                                              _ context: ControlFlowGraph.Context,
                                              _ stmt: SwitchStatement) -> ControlFlowGraph.NodeCreationResult? {
        
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
    }
    
    private static func _connectionsForDoWhile(_ graph: ControlFlowGraph,
                                               _ node: ControlFlowGraphNode,
                                               _ context: ControlFlowGraph.Context,
                                               _ stmt: DoWhileStatement) -> ControlFlowGraph.NodeCreationResult? {
        
        graph.addNode(node)
        
        let scope = context.pushScope(node)
        
        var didPushHead = false
        var loopHead: ControlFlowGraphNode = node
        
        if let bodyNode = _connections(for: stmt.body, in: graph, context: context) {
            bodyNode.endings.connect(to: node)
            loopHead = bodyNode.start
            
            if bodyNode.endings.isEmpty {
                graph.removeNode(node)
            } else {
                graph.addBackEdge(from: node, to: bodyNode.start)
                didPushHead = true
            }
        } else {
            // connect loop back on itself
            graph.addBackEdge(from: node, to: node)
            didPushHead = true
        }
        
        let breaks = scope.breakTarget!
        var result = context.popScope(node,
                                      start: loopHead,
                                      outConnections: breaks.edgeConstructors(in: graph),
                                      in: graph)
        
        if didPushHead {
            result.endings.append(EdgeConstructor(for: node, in: graph))
        }
        
        return result
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
