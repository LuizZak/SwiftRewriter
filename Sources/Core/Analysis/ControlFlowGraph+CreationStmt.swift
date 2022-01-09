import SwiftAST
import TypeSystem

internal extension ControlFlowGraph {
    static func innerForCompoundStatement(
        _ compoundStatement: CompoundStatement,
        options: GenerationOptions
    ) -> ControlFlowGraph {

        let graph = forStatementList(
            compoundStatement.statements,
            baseNode: compoundStatement,
            options: options
        )
        
        expandSubgraphs(in: graph)
        
        return graph
    }
    
    private static func forStatementList(
        _ statements: [Statement],
        baseNode: SyntaxNode,
        endingScope: CodeScopeNode? = nil,
        options: GenerationOptions
    ) -> ControlFlowGraph {

        let entry = ControlFlowGraphEntryNode(node: baseNode)
        let exit = ControlFlowGraphExitNode(node: baseNode)
        
        let graph = ControlFlowGraph(entry: entry, exit: exit)
        
        var result = _LazySubgraphGenerator(startNode: entry)
            .addingExitNode(entry)
        
        result = 
            _connections(
                for: statements,
                start: result,
                endingScope: endingScope,
                options: options
            )
            .returnToExits()
            .throwToExits()
        
        result.apply(to: graph, endNode: exit)
        
        return graph
    }

    private static func _connections(
        for statements: [Statement],
        endingScope: CodeScopeNode?,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {

        _connections(
            for: statements,
            start: .invalid,
            endingScope: endingScope,
            options: options
        )
    }
    
    private static func _connections(
        for statements: [Statement],
        start: _LazySubgraphGenerator,
        endingScope: CodeScopeNode?,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {

        struct DeferEntry {
            let statement: DeferStatement

            func concretize(options: GenerationOptions) -> ControlFlowSubgraphNode {
                let subgraph = ControlFlowGraph.forStatementList(
                    statement.body.statements,
                    baseNode: statement,
                    endingScope: statement.body,
                    options: options
                )

                let defNode = ControlFlowSubgraphNode(
                    node: statement,
                    graph: subgraph
                )

                return defNode
            }
        }

        var deferEntries: [DeferEntry] = []
        var activeDefersCopy: [ControlFlowSubgraphNode] {
            deferEntries.map { $0.concretize(options: options) }
        }
        
        var endOfScopeNodeCopy: ControlFlowGraphEndScopeNode? {
            if options.generateEndScopes {
                return endingScope.map {
                    ControlFlowGraphEndScopeNode(node: $0, scope: $0)
                }
            }

            return nil
        }
        
        var previous = start
        
        for statement in statements {
            if let stmt = statement as? DeferStatement {
                let entry = DeferEntry(statement: stmt)

                deferEntries.append(entry)
                continue
            }
            
            let connections = _connections(
                for: statement,
                options: options
            )

            previous = previous
                .chainingExits(to:
                    connections
                        .appendingEndOfScopeIfAvailable(endOfScopeNodeCopy)
                        .appendingDefers(activeDefersCopy)
                )
            
            // For pruning purposes: If the current statement does not offer
            // normal exits, quit early as the statement has skipped normal flow
            // and continuing would generate dangling nodes that could alter
            // graph generation upstream.
            if options.pruneUnreachable && connections.exitNodes.isEmpty {
                break
            }            
        }

        return previous
            .appendingExitDefers(activeDefersCopy)
            .appendingEndOfScopeOnExitsIfAvailable(endOfScopeNodeCopy)
    }
    
    private static func _connections(
        for statement: Statement,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {

        var result: _LazySubgraphGenerator
        
        if let statementKind = (statement as? StatementKindType)?.statementKind {
            switch statementKind {
            case .expressions(let stmt):
                result = _connections(forExpressions: stmt, options: options)
                
            case .variableDeclarations(let stmt):
                result = _connections(forDeclarations: stmt, options: options)
                
            case .break(let stmt):
                let node = ControlFlowGraphNode(node: stmt)
                
                result = _LazySubgraphGenerator(startNode: node)
                    .addingBreakNode(node, targetLabel: stmt.targetLabel)
                
            case .continue(let stmt):
                let node = ControlFlowGraphNode(node: stmt)
                
                result = _LazySubgraphGenerator(startNode: node)
                    .addingContinueNode(node, targetLabel: stmt.targetLabel)
                
            case .return(let stmt):
                let node = ControlFlowGraphNode(node: stmt)
                
                result = _LazySubgraphGenerator(startNode: node)
                    .addingReturnNode(node)
                
            case .throw(let stmt):
                let node = ControlFlowGraphNode(node: stmt)
                
                result = _LazySubgraphGenerator(startNode: node)
                    .addingThrowNode(node)
                
            // Handled separately in _connections(for:start:) above
            case .defer:
                result = .invalid
                
            case .fallthrough(let stmt):
                result = _connections(forFallthrough: stmt, options: options)
                
            case .compound(let stmt):
                result = _connections(
                    for: stmt.statements,
                    endingScope: stmt,
                    options: options
                )
                
            case .do(let stmt):
                result = _connections(forDo: stmt, options: options)
                
            case .if(let stmt):
                result = _connections(forIf: stmt, options: options)
                
            case .switch(let stmt):
                result = _connections(forSwitch: stmt, options: options)
                
            case .while(let stmt):
                result = _connections(forWhile: stmt, options: options)
                
            case .doWhile(let stmt):
                result = _connections(forDoWhile: stmt, options: options)
                
            case .for(let stmt):
                result = _connections(forForLoop: stmt, options: options)
            
            case .localFunction(_):
                result = .invalid
            
            case .unknown(_):
                let node = ControlFlowGraphNode(node: statement)
                
                result = _LazySubgraphGenerator(startNode: node)
                    .addingExitNode(node)
            }
        } else {
            let node = ControlFlowGraphNode(node: statement)
            
            result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)
        }
        
        if let label = statement.label {
            result = result
                .breakToExits(targetLabel: label)
                .satisfyingBreaks(labeled: label)
        }
        
        return result
    }
    
    private static func _connections(
        forExpressions statement: ExpressionsStatement,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {

        let node = ControlFlowGraphNode(node: statement)

        return _LazySubgraphGenerator(startNode: node)
            .addingExitNode(node)
            .chainingExits(to: connections(for: statement.expressions))
    }
    
    private static func _connections(
        forDeclarations statement: VariableDeclarationsStatement,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {

        var declChain = _LazySubgraphGenerator.invalid

        for decl in statement.decl {
            guard let connections = _connections(forDeclaration: decl, options: options) else {
                continue
            }

            declChain = declChain.chainingExits(
                to: connections
            )
        }

        return declChain
    }

    private static func _connections(
        forDeclaration declaration: StatementVariableDeclaration,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator? {

        let node = ControlFlowGraphNode(node: declaration)
        let graph = _LazySubgraphGenerator(startNode: node)

        let initialization = declaration.initialization.map(connections(for:)) ?? .invalid

        return initialization
            .chainingExits(to: graph)
            .addingExitNode(node)
    }
    
    private static func _connections(
        forFallthrough stmt: FallthroughStatement,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {

        let node = ControlFlowGraphNode(node: stmt)
        
        return _LazySubgraphGenerator(startNode: node)
            .addingFallthroughNode(node)
    }

    private static func _connections(
        forDo stmt: DoStatement,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {

        var result = _connections(for: stmt.body, options: options)
        
        for catchBlock in stmt.catchBlocks {
            let catchNode =
                _connections(forCatchBlock: catchBlock, options: options)
            
            result = result.chainingThrows(to: catchNode)
        }

        return result
    }

    private static func _connections(
        forCatchBlock catchBlock: CatchBlock,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {

        let node = ControlFlowGraphNode(node: catchBlock)
        var result = _LazySubgraphGenerator(startNode: node)

        let bodyConnections = _connections(for: catchBlock.body, options: options)
        result = result.addingBranch(towards: bodyConnections)

        return result
    }
    
    private static func _connections(
        forIf stmt: IfStatement,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {

        let node = ControlFlowGraphNode(node: stmt)
        var result =
            _LazySubgraphGenerator(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body, options: options)
        result = result.addingBranch(towards: bodyConnections)
        
        if let elseBody = stmt.elseBody {
            let elseConnections = _connections(for: elseBody, options: options)
            result = result.addingBranch(towards: elseConnections)
        } else {
            result = result.addingExitNode(node)
        }
        
        let expConnections = connections(for: stmt.exp)
        result = expConnections.chainingExits(to: result)

        return result
    }
    
    private static func _connections(
        forSwitch stmt: SwitchStatement,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {

        let node = ControlFlowGraphNode(node: stmt)
        var result = _LazySubgraphGenerator(startNode: node)
        
        var lastFallthrough: FallthroughNodes?
        
        for cs in stmt.cases {
            var branch = _connections(
                forSwitchCase: cs,
                options: options
            )
            
            if branch.isValid {
                if let lastFallthrough = lastFallthrough {
                    branch = branch.addingJumpInto(from: lastFallthrough)
                }
                
                result = result
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
        
        if let defaultCase = stmt.defaultCase {
            let defResult = _connections(
                forSwitchDefaultCase: defaultCase,
                options: options
            )
            result = result.addingBranch(towards: defResult)
        }
        
        let expConnections = connections(for: stmt.exp)
        result = expConnections.chainingExits(to: result)
        
        return result
    }
    
    private static func _connections(
        forSwitchCase switchCase: SwitchCase,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {

        let patterns = switchCase
            .patterns
            .map(connections(for:))
            .chainingExits()

        let branch =
            _connections(
                for: switchCase.statements,
                endingScope: switchCase,
                options: options
            )
        
        return patterns.chainingExits(to: branch)
    }
    
    private static func _connections(
        forSwitchDefaultCase defaultCase: SwitchDefaultCase,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {

        let branch =
            _connections(
                for: defaultCase.statements,
                endingScope: defaultCase,
                options: options
            )
        
        return branch
    }
    
    private static func _connections(
        forWhile stmt: WhileStatement,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {

        var result = _LazySubgraphGenerator.invalid

        let loopHead = _LazySubgraphGenerator(
            startAndExitNode: ControlFlowGraphNode(node: stmt)
        )
        let loopCondition = connections(for: stmt.exp)
        let loopBody = _connections(
            for: stmt.body,
            options: options
        )

        result =
            loopCondition
            .then(
                loopHead
                .branching(
                    to: loopBody
                        .connectingContinues(label: stmt.label, to: loopCondition.startNode)
                        .connectingExits(to: loopCondition.startNode)
                )
            )
            .breakToExits(targetLabel: stmt.label)

        return result
    }
    
    private static func _connections(
        forDoWhile stmt: DoWhileStatement,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {
        
        let loopBody = _connections(
            for: stmt.body,
            options: options
        )
        let loopHead = _LazySubgraphGenerator(
            startAndExitNode: ControlFlowGraphNode(node: stmt)
        )

        let loopCondition = connections(for: stmt.exp)

        let loopStart =
            loopBody.connectingContinues(
                label: stmt.label,
                to: loopCondition.startNode
            )
            .then(loopCondition)

        let result =
            loopStart
            .then(
                loopHead.branchingExits(to: loopStart.startNode)
            )
            .breakToExits(targetLabel: stmt.label)

        return result
    }
    
    private static func _connections(
        forForLoop stmt: ForStatement,
        options: GenerationOptions
    ) -> _LazySubgraphGenerator {
        
        var result = _LazySubgraphGenerator.invalid

        let loopHead = _LazySubgraphGenerator(
            startAndExitNode: ControlFlowGraphNode(node: stmt)
        )
        let loopExpression = connections(for: stmt.exp)
        let loopBody = _connections(
            for: stmt.body,
            options: options
        )

        result =
            loopExpression
            .then(
                loopHead
                .branching(
                    to: loopBody
                        .connectingContinues(label: stmt.label, to: loopHead.startNode)
                        .connectingExits(to: loopHead.startNode)
                )
            )
            .breakToExits(targetLabel: stmt.label)

        return result
    }
}
