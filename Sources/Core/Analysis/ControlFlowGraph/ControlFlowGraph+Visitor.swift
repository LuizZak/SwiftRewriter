import SwiftAST
import TypeSystem

/// Visitor that produces control flow graphs for syntax trees.
class CFGVisitor: ExpressionVisitor, StatementVisitor {
    typealias ExprResult = CFGVisitResult
    typealias StmtResult = CFGVisitResult

    let options: ControlFlowGraph.GenerationOptions

    init(options: ControlFlowGraph.GenerationOptions) {
        self.options = options
    }

    // MARK: - Statement

    func visitStatement(_ statement: Statement) -> CFGVisitResult {
        let result = statement.accept(self)

        if statement.isLabelableStatementType, let label = statement.label {
            return result.resolvingJumpsToExit(kind: .break(label: label))
        }

        return result.finalized()
    }

    func visitCompound(_ stmt: CompoundStatement) -> CFGVisitResult {
        enum CompoundEndEntry {
            case `defer`(DeferStatement)
            case endOfScope(CodeScopeNode)

            func toGraph(visitor: CFGVisitor) -> CFGVisitResult {
                switch self {
                case .defer(let stmt):
                    return visitor.visitDefer(stmt)
                case .endOfScope(let node):
                    return CFGVisitResult(
                        forNode: ControlFlowGraphEndScopeNode(node: node, scope: node)
                    )
                }
            }
        }

        var result = CFGVisitResult()

        var endEntries: [CompoundEndEntry] = []

        for stmt in stmt.statements {
            let stmtResult = visitStatement(stmt)

            if let stmt = stmt as? DeferStatement {
                endEntries.append(.defer(stmt))
            } else {
                result = result.then(stmtResult)
            }
        }

        if options.generateEndScopes {
            endEntries.insert(.endOfScope(stmt), at: 0)
        }
        
        return
            result
            .then(
                endEntries
                .reversed()
                .reduce(CFGVisitResult()) {
                    $0.then($1.toGraph(visitor: self))
                }
            )
            .appendingLazyDefersToJumps {
                endEntries.map {
                    $0.toGraph(visitor: self)
                }
            }
            .finalized()
    }

    func visitIf(_ stmt: IfStatement) -> CFGVisitResult {
        let exp = stmt.exp.accept(self)
        let node = CFGVisitResult(forSyntaxNode: stmt)

        let body = stmt.body.accept(self)
        let elseBody = stmt.elseBody.map(visitStatement)

        if let elseBody = elseBody {
            return exp
                .then(node)
                .then(
                    inParallel(body, elseBody)
                )
                .finalized()
        } else {
            return exp
                .then(node)
                .then(body)
                .branching(from: node.exit, to: body.exit)
                .finalized()
        }
    }

    func visitWhile(_ stmt: WhileStatement) -> CFGVisitResult {
        let exp = stmt.exp.accept(self)
        let head = CFGVisitResult(forSyntaxNode: stmt)

        let body = stmt.body.accept(self)

        let breakMarker = CFGVisitResult()

        return exp
            .then(head)
            .then(body)
            .thenLoop(backTo: exp.entry, conditionally: false)
            .then(breakMarker)
            .branching(from: head.exit, to: breakMarker.entry)
            .resolvingJumps(kind: .continue(label: nil), to: exp.entry)
            .resolvingJumps(kind: .continue(label: stmt.label), to: exp.entry)
            .resolvingJumps(kind: .break(label: nil), to: breakMarker.entry)
            .resolvingJumps(kind: .break(label: stmt.label), to: breakMarker.entry)
            .finalized()
    }

    func visitSwitch(_ stmt: SwitchStatement) -> CFGVisitResult {
        let exp = stmt.exp.accept(self)

        let node = CFGVisitResult(forSyntaxNode: stmt)

        let caseClauses = stmt.cases.map(visitSwitchCase)
        let defaultClause = stmt.defaultCase.map(visitSwitchDefaultCase)

        let breakMarker = CFGVisitResult()

        var result = exp
            .then(node)
            .then(breakMarker)

        var totalClauses = caseClauses
        if let defaultClause = defaultClause {
            totalClauses.append(defaultClause)
        }
        for (i, clause) in totalClauses.enumerated() {
            var clauseResult = clause.result

            if i == totalClauses.count - 1 {
                clauseResult.removeJumps(kind: .switchCasePatternFail)
            }

            result = result
                .inserting(clauseResult)
                .branching(from: clauseResult.exit, to: breakMarker.entry)
                .resolvingJumps(kind: .break(label: nil), to: breakMarker.entry)
                .resolvingJumps(kind: .break(label: stmt.label), to: breakMarker.entry)

            if i == 0 {
                result = result.redirectingEntries(
                    for: node.exit,
                    to: clauseResult.entry
                )
            } else {
                result.resolveJumps(
                    caseClauses[i - 1].result.unresolvedJumps(ofKind: .fallthrough),
                    to: clause.fallthroughTarget
                )
                result.resolveJumps(
                    caseClauses[i - 1].result.unresolvedJumps(ofKind: .switchCasePatternFail),
                    to: clauseResult.entry
                )
            }
        }

        result.resolveJumpsToExit(kind: .switchCasePatternFail)

        return result.finalized()
    }

    func visitSwitchCase(_ switchCase: SwitchCase) -> SwitchCaseVisitResult {
        var result =
            switchCase.patterns.map(visitPattern)
            .reduce(CFGVisitResult()) {
                $0.then($1)
            }
            .then(CFGVisitResult(forSyntaxNode: switchCase))
            .then(CFGVisitResult(branchingToUnresolvedJump: .switchCasePatternFail))
        
        let body = visitStatement(switchCase.body)
        
        result = result.then(body)

        return .init(
            result: result,
            fallthroughTarget: body.entry
        )
    }

    func visitSwitchDefaultCase(_ defaultCase: SwitchDefaultCase) -> SwitchCaseVisitResult {
        let body = visitStatement(defaultCase.body)
        let result =
            CFGVisitResult(forSyntaxNode: defaultCase)
            .then(body)
        
        return .init(
            result: result,
            fallthroughTarget: body.entry
        )
    }

    func visitRepeatWhile(_ stmt: RepeatWhileStatement) -> CFGVisitResult {
        let body = stmt.body.accept(self)
        let exp = stmt.exp.accept(self)
        let head = CFGVisitResult(forSyntaxNode: stmt)
        let breakMark = CFGVisitResult()

        return body
            .then(exp)
            .then(head)
            .then(breakMark)
            .branching(from: head.exit, to: body.entry)
            .resolvingJumps(kind: .continue(label: nil), to: exp.entry)
            .resolvingJumps(kind: .continue(label: stmt.label), to: exp.entry)
            .resolvingJumps(kind: .break(label: nil), to: breakMark.exit)
            .resolvingJumps(kind: .break(label: stmt.label), to: breakMark.exit)
            .finalized()
    }

    func visitFor(_ stmt: ForStatement) -> CFGVisitResult {
        let exp = stmt.exp.accept(self)
        let pattern = visitPattern(stmt.pattern)
        let head = CFGVisitResult(forSyntaxNode: stmt)

        let body = stmt.body.accept(self)

        return exp
            .then(pattern)
            .then(head)
            .then(body)
            .redirectingEntries(for: body.exit, to: pattern.entry)
            .branching(from: head.exit, to: body.exit)
            .resolvingJumps(kind: .continue(label: nil), to: pattern.entry)
            .resolvingJumps(kind: .continue(label: stmt.label), to: pattern.entry)
            .resolvingJumps(kind: .break(label: nil), to: body.exit)
            .resolvingJumps(kind: .break(label: stmt.label), to: body.exit)
            .finalized()
    }

    func visitDo(_ stmt: DoStatement) -> CFGVisitResult {
        let body = 
            CFGVisitResult(forSyntaxNode: stmt)
            .then(
                stmt.body.accept(self)
            )
        
        let endMarker = CFGVisitResult()
        var result = body.then(endMarker)

        var didHandle = false
        for catchBlock in stmt.catchBlocks {
            let blockGraph = visitCatchBlock(catchBlock)

            result = result
                .inserting(blockGraph)
                .branching(from: blockGraph.exit, to: endMarker.entry)
            
            if !didHandle {
                didHandle = true

                result.resolveJumps(
                    body.unresolvedJumps(ofKind: .throw),
                    to: blockGraph.graph.entry
                )
            }
        }
        
        return result.finalized()
    }

    func visitCatchBlock(_ block: CatchBlock) -> CFGVisitResult {
        let result = CFGVisitResult(forSyntaxNode: block)

        let pattern = block.pattern.map(visitPattern) ?? CFGVisitResult()
        let body = block.body.accept(self)

        return result.then(pattern).then(body)
    }

    func visitDefer(_ stmt: DeferStatement) -> CFGVisitResult {
        CFGVisitResult(forSyntaxNode: stmt)
            .then(stmt.body.accept(self))
            .resolvingAllJumpsToExit()
    }

    func visitReturn(_ stmt: ReturnStatement) -> CFGVisitResult {
        (stmt.exp?.accept(self) ?? CFGVisitResult()).then (
            CFGVisitResult(forUnresolvedJumpSyntaxNode: stmt, kind: .return)
        ).finalized()
    }

    func visitBreak(_ stmt: BreakStatement) -> CFGVisitResult {
        CFGVisitResult(
            forUnresolvedJumpSyntaxNode: stmt,
            kind: .break(label: stmt.targetLabel)
        )
    }

    func visitFallthrough(_ stmt: FallthroughStatement) -> CFGVisitResult {
        CFGVisitResult(
            forUnresolvedJumpSyntaxNode: stmt,
            kind: .fallthrough
        )
    }

    func visitContinue(_ stmt: ContinueStatement) -> CFGVisitResult {
        CFGVisitResult(
            forUnresolvedJumpSyntaxNode: stmt,
            kind: .continue(label: stmt.targetLabel)
        )
    }

    func visitExpressions(_ stmt: ExpressionsStatement) -> CFGVisitResult {
        var result = CFGVisitResult(forSyntaxNode: stmt)

        for exp in stmt.expressions {
            var expGraph = visitExpression(exp)
            expGraph.resolveJumpsToExit(kind: .expressionShortCircuit)

            result = result.then(expGraph)
        }

        return result.finalized()
    }

    func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> CFGVisitResult {
        let result = CFGVisitResult(forSyntaxNode: stmt)

        return stmt
            .decl
            .map(visitStatementVariableDeclaration)
            .reduce(result) {
                $0.then($1)
            }.finalized()
    }

    func visitStatementVariableDeclaration(_ decl: StatementVariableDeclaration) -> CFGVisitResult {
        let initialization = decl.initialization.map(visitExpression) ?? CFGVisitResult()

        return initialization
            .then(CFGVisitResult(forSyntaxNode: decl))
            .finalized()
    }

    func visitLocalFunction(_ stmt: LocalFunctionStatement) -> CFGVisitResult {
        CFGVisitResult(forSyntaxNode: stmt)
    }

    func visitThrow(_ stmt: ThrowStatement) -> CFGVisitResult {
        stmt.exp.accept(self).then (
            CFGVisitResult(forUnresolvedJumpSyntaxNode: stmt, kind: .throw)
        ).finalized()
    }

    func visitUnknown(_ stmt: UnknownStatement) -> CFGVisitResult {
        CFGVisitResult(forSyntaxNode: stmt)
    }

    // MARK: - Expression
    
    func visitExpression(_ expression: Expression) -> CFGVisitResult {
        expression.accept(self)
    }

    func visitAssignment(_ exp: AssignmentExpression) -> CFGVisitResult {
        let suffix = CFGVisitResult()

        var lhs = visitExpression(exp.lhs).inserting(suffix)
        let rhs = visitExpression(exp.rhs).resolvingJumpsToExit(kind: .expressionShortCircuit)

        lhs.resolveJumps(kind: .expressionShortCircuit, to: suffix.graph.exit)

        let node = CFGVisitResult(forSyntaxNode: exp)
        
        return
            lhs
            .then(rhs)
            .then(node)
            .then(suffix)
            .finalized()
    }

    func visitBinary(_ exp: BinaryExpression) -> CFGVisitResult {
        let lhs = visitExpression(exp.lhs)
        let rhs = visitExpression(exp.rhs)

        let shortCircuit: CFGVisitResult
        switch exp.op {
        case .and, .or, .nullCoalesce:
            shortCircuit = CFGVisitResult(branchingToUnresolvedJump: .expressionShortCircuit)
        default:
            shortCircuit = CFGVisitResult()
        }

        return lhs
            .then(shortCircuit)
            .then(rhs)
            .resolvingJumpsToExit(kind: .expressionShortCircuit)
            .then(CFGVisitResult(forSyntaxNode: exp))
            .finalized()
    }

    func visitUnary(_ exp: UnaryExpression) -> CFGVisitResult {
        exp.exp
            .accept(self)
            .resolvingJumpsToExit(kind: .expressionShortCircuit)
            .then(CFGVisitResult(forSyntaxNode: exp))
            .finalized()
    }

    func visitSizeOf(_ exp: SizeOfExpression) -> CFGVisitResult {
        var result = CFGVisitResult(forSyntaxNode: exp)

        switch exp.value {
        case .expression(let subExp):
            result =
                visitExpression(subExp)
                .resolvingJumpsToExit(kind: .expressionShortCircuit)
                .then(result)
        case .type:
            break
        }

        return result.finalized()
    }

    func visitPrefix(_ exp: PrefixExpression) -> CFGVisitResult {
        exp.exp
            .accept(self)
            .resolvingJumpsToExit(kind: .expressionShortCircuit)
            .then(CFGVisitResult(forSyntaxNode: exp))
            .finalized()
    }

    func visitPostfix(_ exp: PostfixExpression) -> CFGVisitResult {
        let operand: CFGVisitResult = visitExpression(exp.exp)

        var opExp = CFGVisitResult()
        for subExp in exp.op.subExpressions {
            let param = visitExpression(subExp)

            opExp = opExp.then(
                param.resolvingJumpsToExit(kind: .expressionShortCircuit)
            )
        }

        let shortCircuit: CFGVisitResult
        switch exp.op.optionalAccessKind {
        case .none, .forceUnwrap:
            shortCircuit = CFGVisitResult()
        case .safeUnwrap:
            shortCircuit = CFGVisitResult(branchingToUnresolvedJump: .expressionShortCircuit)
        }

        return
            operand
            .then(opExp)
            .then(
                CFGVisitResult(forSyntaxNode: exp)
            )
            .then(shortCircuit)
            .finalized()
    }

    func visitConstant(_ exp: ConstantExpression) -> CFGVisitResult {
        CFGVisitResult(forSyntaxNode: exp)
    }

    func visitParens(_ exp: ParensExpression) -> CFGVisitResult {
        exp.exp
            .accept(self)
            .resolvingJumpsToExit(kind: .expressionShortCircuit)
            .then(CFGVisitResult(forSyntaxNode: exp))
            .finalized()
    }

    func visitIdentifier(_ exp: IdentifierExpression) -> CFGVisitResult {
        CFGVisitResult(forSyntaxNode: exp)
    }

    func visitCast(_ exp: CastExpression) -> CFGVisitResult {
        visitExpression(exp.exp)
            .resolvingJumpsToExit(kind: .expressionShortCircuit)
            .then(CFGVisitResult(forSyntaxNode: exp))
            .finalized()
    }

    func visitTypeCheck(_ exp: TypeCheckExpression) -> CFGVisitResult {
        visitExpression(exp.exp)
            .resolvingJumpsToExit(kind: .expressionShortCircuit)
            .then(CFGVisitResult(forSyntaxNode: exp))
            .finalized()
    }

    func visitArray(_ exp: ArrayLiteralExpression) -> CFGVisitResult {
        var result = CFGVisitResult()

        for item in exp.items {
            let item = visitExpression(item)

            result = result.then(
                item.resolvingJumpsToExit(kind: .expressionShortCircuit)
            )
        }

        return result
            .then(CFGVisitResult(forSyntaxNode: exp))
            .finalized()
    }

    func visitDictionary(_ exp: DictionaryLiteralExpression) -> CFGVisitResult {
        var result = CFGVisitResult()

        for pair in exp.pairs {
            let key =
                visitExpression(pair.key)
                .resolvingJumpsToExit(kind: .expressionShortCircuit)
            
            let value =
                visitExpression(pair.value)
                .resolvingJumpsToExit(kind: .expressionShortCircuit)

            result = result.then(
                key.then(value)
            )
        }

        return result
            .then(CFGVisitResult(forSyntaxNode: exp))
            .finalized()
    }

    func visitBlock(_ exp: BlockLiteralExpression) -> CFGVisitResult {
        CFGVisitResult(forSyntaxNode: exp)
    }

    func visitTernary(_ exp: TernaryExpression) -> CFGVisitResult {
        let predicate = 
            exp.exp
            .accept(self)
            .resolvingJumpsToExit(kind: .expressionShortCircuit)

        let lhs =
            exp.ifTrue
            .accept(self)
            .resolvingJumpsToExit(kind: .expressionShortCircuit)
        
        let rhs =
            exp.ifFalse
            .accept(self)
            .resolvingJumpsToExit(kind: .expressionShortCircuit)

        let node = CFGVisitResult(forSyntaxNode: exp)

        return predicate
            .then(node)
            .then(
                inParallel(lhs, rhs)
            )
            .finalized()
    }

    func visitTuple(_ exp: TupleExpression) -> CFGVisitResult {
        var result = CFGVisitResult()

        for item in exp.elements {
            let item = visitExpression(item)

            result = result.then(
                item.resolvingJumpsToExit(kind: .expressionShortCircuit)
            )
        }

        return result
            .then(CFGVisitResult(forSyntaxNode: exp))
            .finalized()
    }

    func visitSelector(_ exp: SelectorExpression) -> CFGVisitResult {
        CFGVisitResult(forSyntaxNode: exp)
    }

    func visitUnknown(_ exp: UnknownExpression) -> CFGVisitResult {
        CFGVisitResult(forSyntaxNode: exp)
    }

    func visitPattern(_ pattern: Pattern) -> CFGVisitResult {
        pattern
            .subExpressions
            .map(visitExpression)
            .reduce(CFGVisitResult()) {
                $0.then($1)
            }
            .finalized()
    }

    struct SwitchCaseVisitResult {
        var result: CFGVisitResult
        var fallthroughTarget: ControlFlowGraphNode
    }
}

struct CFGVisitResult {
    var graph: ControlFlowGraph
    var unresolvedJumps: [UnresolvedJump]

    /// Gets the entry node for this graph result.
    var entry: ControlFlowGraphEntryNode {
        graph.entry
    }

    /// Gets the exit node for this graph result.
    var exit: ControlFlowGraphExitNode {
        graph.exit
    }

    /// Initializes a graph from a syntax node, `entry -> syntaxNode -> exit`.
    init(forSyntaxNode syntaxNode: SyntaxNode) {
        self.init(forNode: ControlFlowGraphNode(node: syntaxNode))
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
    init(forUnresolvedJumpSyntaxNode syntaxNode: SyntaxNode, kind: UnresolvedJump.Kind) {
        let node = ControlFlowGraphNode(node: syntaxNode)

        self.init()

        let jump = UnresolvedJump(
            node: ControlFlowGraphNode(node: MarkerSyntaxNode()),
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
    init(forUnresolvedJump kind: UnresolvedJump.Kind) {
        self.init()

        let jump = UnresolvedJump(
            node: ControlFlowGraphNode(node: MarkerSyntaxNode()),
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
    init(withBranchingSyntaxNode syntaxNode: SyntaxNode, toUnresolvedJump kind: UnresolvedJump.Kind) {
        let node = ControlFlowGraphNode(node: syntaxNode)

        self.init()

        let jump = UnresolvedJump(
            node: ControlFlowGraphNode(node: MarkerSyntaxNode()),
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
    init(branchingToUnresolvedJump kind: UnresolvedJump.Kind) {
        self.init()

        let jump = UnresolvedJump(
            node: ControlFlowGraphNode(node: MarkerSyntaxNode()),
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
    func unresolvedJumps(ofKind kind: UnresolvedJump.Kind) -> [UnresolvedJump] {
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
    struct UnresolvedJump {
        var node: ControlFlowGraphNode
        var kind: Kind

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
        
        enum Kind: Equatable {
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
private class MarkerSyntaxNode: SyntaxNode {

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

/// Returns the given list of results, joined by a single entry and exit node,
/// running in 'parallel'.
private func inParallel(_ results: CFGVisitResult...) -> CFGVisitResult {
    let entry = ControlFlowGraphEntryNode(node: MarkerSyntaxNode())
    let exit = ControlFlowGraphExitNode(node: MarkerSyntaxNode())

    var result = CFGVisitResult()
    result.graph.addNode(entry)
    result.graph.addNode(exit)

    for item in results {
        result = result
            .inserting(item)
        
        result.graph.addEdge(
            from: entry,
            to: item.graph.entry
        )
        result.graph.addEdge(
            from: item.graph.exit,
            to: exit
        )
    }

    result.graph.entry = entry
    result.graph.exit = exit

    return result
}
