import SwiftAST

extension ControlFlowGraphNode {
    static func makeNode(_ node: SyntaxNode) -> Self {
        return self.init(node: node)
    }
}

extension ControlFlowGraph {
    func addNode(_ node: ControlFlowGraphNode) {
        nodes.append(node)
    }
    
    func addEdge(_ edge: ControlFlowGraphEdge) {
        edges.append(edge)
    }
    
    @discardableResult
    func addEdge(from node1: ControlFlowGraphNode, to node2: ControlFlowGraphNode) -> ControlFlowGraphEdge {
        assert(node1 !== node2, "Attempting to connect a node to itself!")
        
        let edge = ControlFlowGraphEdge(start: node1, end: node2)
        edges.append(edge)
        
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
    func insert(node: SyntaxNode, after existingNode: SyntaxNode, mode: AfterInsertionMode = .add) -> ControlFlowGraphNode {
        guard let existingGraphNode = graphNode(for: existingNode) else {
            assertionFailure("Expected 'existingNode' to be part of this graph")
            return ControlFlowGraphNode.makeNode(node)
        }
        
        return insert(node: node, after: existingGraphNode, mode: mode)
    }
    
    /// Inserts a given syntax node after a given control flow graph in this
    /// graph.
    @discardableResult
    func insert(node: SyntaxNode, after existingNode: ControlFlowGraphNode, mode: AfterInsertionMode = .add) -> ControlFlowGraphNode {
        let node = ControlFlowGraphNode.makeNode(node)
        return insert(node: node, after: existingNode, mode: mode)
    }
    
    /// Inserts a given syntax node after a given control flow graph in this
    /// graph.
    @discardableResult
    func insert(node: ControlFlowGraphNode, after existingNode: ControlFlowGraphNode, mode: AfterInsertionMode = .add) -> ControlFlowGraphNode {
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
    func insert(node: SyntaxNode, before existingNode: ControlFlowGraphNode, mode: BeforeInsertionMode = .add) -> ControlFlowGraphNode {
        let node = ControlFlowGraphNode.makeNode(node)
        
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
        let entry = ControlFlowGraphEntryNode.makeNode(compoundStatement)
        let exit = ControlFlowGraphExitNode.makeNode(compoundStatement)
        
        let context = Context()
        
        let graph = ControlFlowGraph(entry: entry, exit: exit)
        
        var prev: NodeCreationResult = (entry, [EdgeConstructor(for: entry, in: graph)])
        
        for subStmt in compoundStatement.statements {
            guard let cur = _connections(for: subStmt, in: graph, context: context) else {
                continue
            }
            
            prev.endings.connect(to: cur.start)
            prev = cur
        }
        
        prev.endings.connect(to: exit)
        
        return graph
    }
    
    private static func _connections(for stmt: Statement,
                                     in graph: ControlFlowGraph,
                                     context: Context) -> NodeCreationResult? {
        
        let node = ControlFlowGraphNode.makeNode(stmt)
        
        switch stmt {
        case is ExpressionsStatement,
             is VariableDeclarationsStatement:
            
            graph.addNode(node)
            
            return (node, [EdgeConstructor(for: node, in: graph)])
            
        case is ReturnStatement:
            graph.addNode(node)
            graph.addEdge(from: node, to: graph.exit)
            
            return (node, [])
            
        case is BreakStatement:
            graph.addNode(node)
            context.breakTarget?.addBreak(node)
            
            return (node, [])
            
        case is ContinueStatement:
            graph.addNode(node)
            if let target = context.continueTarget {
                graph.addBackEdge(from: node, to: target)
            }
            
            return (node, [])
            
        case let stmt as CompoundStatement:
            if stmt.isEmpty {
                return nil
            }
            
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
                return (start, prev.endings)
            }
            
            return nil
            
        case let stmt as DoStatement:
            return _connections(for: stmt.body, in: graph, context: context)
            
        // TODO: Properly handle flows through defer statements
        // Defer statements are sensitive to code scopes, and are executed after
        // a code scope finishes execution, in backwards order than they where
        // defined.
        case let stmt as DeferStatement:
            return _connections(for: stmt.body, in: graph, context: context)
            
        case let stmt as IfStatement:
            graph.addNode(node)
            
            var connections: [EdgeConstructor] = []
            
            if let bodyNode = _connections(for: stmt.body, in: graph, context: context) {
                graph.addEdge(from: node, to: bodyNode.start)
                connections.append(contentsOf: bodyNode.endings)
            }
            if let elseBody = stmt.elseBody,
                let elseBodyNode = _connections(for: elseBody, in: graph, context: context) {
                
                graph.addEdge(from: node, to: elseBodyNode.start)
                connections.append(contentsOf: elseBodyNode.endings)
            } else {
                connections.append(EdgeConstructor(for: node, in: graph))
            }
            
            return (node, connections)
            
        case let stmt as SwitchStatement:
            graph.addNode(node)
            
            let breaks = context.pushJumpTarget(node)
            defer {
                context.popJumpTarget(node)
            }
            
            var connections: [EdgeConstructor] = [
            ]
            
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
            
            return (node, connections + breaks.edgeConstructors(in: graph))
            
        case let stmt as ForStatement:
            graph.addNode(node)
            
            let breaks = context.pushJumpTarget(node)
            defer {
                context.popJumpTarget(node)
            }
            
            if let bodyNode = _connections(for: stmt.body, in: graph, context: context) {
                graph.addEdge(from: node, to: bodyNode.start)
                
                // Add a back edge pointing back to the beginning of the loop
                let backEdges = bodyNode.endings.connect(to: node)
                for backEdge in backEdges {
                    backEdge.isBackEdge = true
                }
            }
            
            let connections = [EdgeConstructor(for: node, in: graph)]
            
            return (node, connections + breaks.edgeConstructors(in: graph))
            
        case let stmt as WhileStatement:
            graph.addNode(node)
            
            let breaks = context.pushJumpTarget(node)
            defer {
                context.popJumpTarget(node)
            }
            
            if let bodyNode = _connections(for: stmt.body, in: graph, context: context) {
                graph.addEdge(from: node, to: bodyNode.start)
                
                // Add a back edge pointing back to the beginning of the loop
                let backEdges = bodyNode.endings.connect(to: node)
                for backEdge in backEdges {
                    backEdge.isBackEdge = true
                }
            }
            
            let connections = [EdgeConstructor(for: node, in: graph)]
            
            return (node, connections + breaks.edgeConstructors(in: graph))
            
        default:
            return nil
        }
    }
    
    private class Context {
        var breakTargetStack: [ControlFlowGraphJumpTarget] = []
        var continueTargetStack: [ControlFlowGraphNode] = []
        
        var breakTarget: ControlFlowGraphJumpTarget? {
            return breakTargetStack.last
        }
        var continueTarget: ControlFlowGraphNode? {
            return continueTargetStack.last
        }
        
        // TODO: Support for pushing/popping and breaking/continuing labeled
        // statements
        func pushJumpTarget(_ node: ControlFlowGraphNode) -> ControlFlowGraphJumpTarget {
            let target = ControlFlowGraphJumpTarget()
            
            switch node.node {
            case is ForStatement, is WhileStatement:
                breakTargetStack.append(target)
                continueTargetStack.append(node)
                
            case is SwitchStatement:
                breakTargetStack.append(target)
                
            default:
                assertionFailure("tried to push invalid jump target node type \(type(of: node.node))")
            }
            
            return target
        }
        
        func popJumpTarget(_ node: ControlFlowGraphNode) {
            switch node.node {
            case is ForStatement, is WhileStatement:
                breakTargetStack.removeLast()
                continueTargetStack.removeLast()
                
            case is SwitchStatement:
                breakTargetStack.removeLast()
                
            default:
                assertionFailure("tried to pop invalid jump target node type \(type(of: node.node))")
            }
        }
    }
    
    private class ControlFlowGraphJumpTarget {
        private(set) var breakNodes: [ControlFlowGraphNode] = []
        
        func addBreak(_ node: ControlFlowGraphNode) {
            breakNodes.append(node)
        }
        
        func edgeConstructors(in graph: ControlFlowGraph) -> [EdgeConstructor] {
            return breakNodes.map { EdgeConstructor(for: $0, in: graph) }
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
    func create(_ node: ControlFlowGraphNode) -> ControlFlowGraphEdge {
        return _constructor(node)
    }
}

private extension Sequence where Element == EdgeConstructor {
    @discardableResult
    func connect(to node: ControlFlowGraphNode) -> [ControlFlowGraphEdge] {
        return self.map { $0.create(node) }
    }
}
