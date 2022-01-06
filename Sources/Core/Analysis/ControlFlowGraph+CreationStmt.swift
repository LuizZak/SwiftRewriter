import SwiftAST

internal extension ControlFlowGraph {
    static func innerForCompoundStatement(_ compoundStatement: CompoundStatement) -> ControlFlowGraph {
        let graph = forStatementList(compoundStatement.statements, baseNode: compoundStatement)
        
        expandSubgraphs(in: graph)
        
        return graph
    }
    
    private static func forStatementList(_ statements: [Statement], baseNode: SyntaxNode) -> ControlFlowGraph {
        let entry = ControlFlowGraphEntryNode(node: baseNode)
        let exit = ControlFlowGraphExitNode(node: baseNode)
        
        let graph = ControlFlowGraph(entry: entry, exit: exit)
        
        var previous = _LazySubgraphGenerator(startNode: entry)
            .addingExitNode(entry)
        
        previous = _connections(for: statements, start: previous)
            .returnToExits()
            .throwToExits()
        
        previous.apply(to: graph, endNode: exit)
        
        return graph
    }

    private static func _connections(for statements: [Statement]) -> _LazySubgraphGenerator {
        _connections(for: statements, start: .invalid)
    }
    
    private static func _connections(
        for statements: [Statement],
        start: _LazySubgraphGenerator
    ) -> _LazySubgraphGenerator {
        
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
            
            previous = previous
                .chainingExits(to: connections.appendingDefers(activeDefers))
        }
        
        return previous.appendingExitDefers(activeDefers)
    }
    
    private static func _connections(for statement: Statement) -> _LazySubgraphGenerator {
        var result: _LazySubgraphGenerator
        
        if let statementKind = (statement as? StatementKindType)?.statementKind {
            switch statementKind {
            case .expressions(let stmt):
                result = _connections(forExpressions: stmt)
                
            case .variableDeclarations(let stmt):
                result = _connections(forDeclarations: stmt)
                
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
                result = _connections(forFallthrough: stmt)
                
            case .compound(let stmt):
                result = _connections(for: stmt.statements)
                
            case .do(let stmt):
                result = _connections(forDo: stmt)
                
            case .if(let stmt):
                result = _connections(forIf: stmt)
                
            case .switch(let stmt):
                result = _connections(forSwitch: stmt)
                
            case .while(let stmt):
                result = _connections(forWhile: stmt)
                
            case .doWhile(let stmt):
                result = _connections(forDoWhile: stmt)
                
            case .for(let stmt):
                result = _connections(forForLoop: stmt)
            
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
    
    private static func _connections(forExpressions statement: ExpressionsStatement) -> _LazySubgraphGenerator {
        let result = _connections(for: statement.expressions)
        return result
    }
    
    private static func _connections(forDeclarations statement: VariableDeclarationsStatement) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: statement)
        
        return _LazySubgraphGenerator(startNode: node)
            .addingExitNode(node)
    }
    
    private static func _connections(forFallthrough stmt: FallthroughStatement) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: stmt)
        
        return _LazySubgraphGenerator(startNode: node)
            .addingFallthroughNode(node)
    }

    private static func _connections(forDo stmt: DoStatement) -> _LazySubgraphGenerator {
        var result = _connections(for: stmt.body)
        
        for catchBlock in stmt.catchBlocks {
            let catchNode = _connections(forCatchBlock: catchBlock)
            
            result = result.appendingWithNoConnection(
                catchNode.addingJumpInto(from: result.throwNodes)
            )
        }

        return result.satisfyingThrows()
    }

    private static func _connections(forCatchBlock catchBlock: CatchBlock) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: catchBlock)
        var result = _LazySubgraphGenerator(startNode: node)

        let bodyConnections = _connections(for: catchBlock.body)
        result = result.addingBranch(towards: bodyConnections)

        return result
    }
    
    private static func _connections(forIf stmt: IfStatement) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _LazySubgraphGenerator(startNode: node)
        
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
    
    private static func _connections(forSwitch stmt: SwitchStatement) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _LazySubgraphGenerator(startNode: node)
        
        var lastFallthrough: FallthroughNodes?
        
        for cs in stmt.cases {
            var branch =
                _connections(for: cs.statements)
            
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
        
        if let def = stmt.defaultCase {
            let defResult = _connections(for: def)
            result = result.addingBranch(towards: defResult)
        }
        
        return result
    }
    
    private static func _connections(forWhile stmt: WhileStatement) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _LazySubgraphGenerator(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body)
        
        if bodyConnections.isValid {
            result = result
                .addingBranch(towards: bodyConnections)
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
    
    private static func _connections(forDoWhile stmt: DoWhileStatement) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _LazySubgraphGenerator(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body)
        
        if bodyConnections.isValid {
            result = bodyConnections
                .connectingExits(to: result.startNode)
                .connectingContinues(label: stmt.label, to: bodyConnections.startNode)
                .satisfyingContinues(label: stmt.label)
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
    
    private static func _connections(forForLoop stmt: ForStatement) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: stmt)
        var result = _LazySubgraphGenerator(startNode: node)
        
        let bodyConnections = _connections(for: stmt.body)
        
        if bodyConnections.isValid {
            result = result
                .addingBranch(towards: bodyConnections)
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
}
