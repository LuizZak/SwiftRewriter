import SwiftAST

extension ControlFlowGraph {
    internal static func _connections(for expressions: [Expression]) -> _LazySubgraphGenerator {
        _connections(for: expressions, start: .invalid)
    }
    
    private static func _connections(
        for expressions: [Expression],
        start: _LazySubgraphGenerator
    ) -> _LazySubgraphGenerator {
        
        var previous = start
        
        for expression in expressions {
            let connections = _connections(forExpression: expression)
            
            previous = previous.chainingExits(to: connections)
        }
        
        return previous
    }

    private static func _connections(forExpression expression: Expression) -> _LazySubgraphGenerator {
        var result: _LazySubgraphGenerator

        if let expressionKind = (expression as? ExpressionKindType)?.expressionKind {
            switch expressionKind {
            case .arrayLiteral(let exp):
                result = _connections(for: exp)
                
            case .assignment(let exp):
                result = _connections(for: exp)

            case .binary(let exp):
                result = _connections(for: exp)

            case .blockLiteral(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .cast(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .constant(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .dictionaryLiteral(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .identifier(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .parens(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .postfix(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .prefix(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .selector(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .sizeOf(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .ternary(let exp):
                result = _connections(for: exp)

            case .tuple(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .typeCheck(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .unary(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .unknown(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)
            }
        } else {
            let node = ControlFlowGraphNode(node: expression)
            
            result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)
        }
        
        return result
    }

    private static func _connections(for exp: ArrayLiteralExpression) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: exp)
        let arraySubgraph =
            _LazySubgraphGenerator(startNode: node)
                .addingExitNode(node)
        
        return _connections(for: exp.items)
            .chainingExits(to: arraySubgraph)
    }

    private static func _connections(for exp: AssignmentExpression) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: exp)
        
        let result =
            _LazySubgraphGenerator(startNode: node)
                .addingExitNode(node)

        return result
    }

    private static func _connections(for exp: BinaryExpression) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: exp)
        var result = _LazySubgraphGenerator(startNode: node)

        // Perform short-circuiting of certain operands
        switch exp.op {
        case .and, .or, .nullCoalesce:
            let rhs = _connections(forExpression: exp.rhs)
            result =
                _connections(forExpression: exp.lhs)
                .addingBranch(towards: rhs, debugLabel: exp.op.description)
            
        default:
            result = result.addingExitNode(node)
        }

        return result
    }

    private static func _connections(for exp: TernaryExpression) -> _LazySubgraphGenerator {
        let predicate = _connections(forExpression: exp.exp)
        let ifTrue = _connections(forExpression: exp.ifTrue)
        let ifFalse = _connections(forExpression: exp.ifFalse)

        return predicate
            .satisfyingExits()
            .addingBranch(towards: ifTrue, debugLabel: "true")
            .addingBranch(towards: ifFalse, debugLabel: "false")
    }
}
