import SwiftAST

extension ControlFlowGraph {
    internal static func connections(for expression: Expression) -> _LazySubgraphGenerator {
        connections(for: [expression])
    }

    internal static func connections(for expressions: [Expression]) -> _LazySubgraphGenerator {
        _connections(for: expressions, start: .invalid)
    }

    internal static func connections(for pattern: Pattern) -> _LazySubgraphGenerator {
        let expressions = pattern.subExpressions

        return connections(for: expressions)
    }
    
    private static func _connections(
        for expressions: [Expression],
        start: _LazySubgraphGenerator
    ) -> _LazySubgraphGenerator {
        
        return expressions
            .map(_connections(forExpression:))
            .chainingExits()
            .nullCoalesceToExits()
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
                result = _connections(for: exp)

            case .identifier(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .parens(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node)
                    .nullCoalesceToExits()
                    .addingExitNode(node)

            case .postfix(let exp):
                result = _connections(for: exp)

            case .prefix(let exp):
                result = _chainConnection(for: exp.exp, into: exp)

            case .selector(let exp):
                let node = ControlFlowGraphNode(node: exp)
            
                result = _LazySubgraphGenerator(startNode: node).addingExitNode(node)

            case .sizeOf(let exp):
                result = _connections(for: exp)

            case .ternary(let exp):
                result = _connections(for: exp)

            case .tuple(let exp):
                result = _connections(for: exp)

            case .typeCheck(let exp):
                result = _chainConnection(for: exp.exp, into: exp)

            case .unary(let exp):
                result = _chainConnection(for: exp.exp, into: exp)

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
        
        return connections(for: exp.items)
            .chainingExits(to: arraySubgraph)
    }

    private static func _connections(for exp: DictionaryLiteralExpression) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: exp)
        let arraySubgraph =
            _LazySubgraphGenerator(startNode: node)
                .addingExitNode(node)
        
        return connections(for: exp.subExpressions)
            .chainingExits(to: arraySubgraph)
    }

    private static func _connections(for exp: AssignmentExpression) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: exp)
        let subgraph =
            _LazySubgraphGenerator(startNode: node)
            .addingExitNode(node)

        let lhs = _connections(forExpression: exp.lhs)
        let rhs = _connections(forExpression: exp.rhs)

        let result = lhs
            .chainingExits(
                to: rhs.satisfyingNullCoalesce(),
                debugLabel: exp.op.description
            )
            .nullCoalesceToExits()
        
        return result.chainingExits(to: subgraph)
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

    private static func _connections(for exp: PostfixExpression) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: exp)
        var subgraph = _LazySubgraphGenerator(startNode: node)

        let base = _connections(forExpression: exp.exp)
        let args = connections(for: exp.op.subExpressions)

        subgraph = base
            .chainingExits(to: args)
            .chainingExits(to: subgraph, debugLabel: "\(exp.op.description)")
        
        if exp.op.optionalAccessKind == .safeUnwrap {
            subgraph = subgraph.addingNullCoalesceNode(node)
        }

        return subgraph.addingExitNode(node)
    }

    private static func _connections(for exp: SizeOfExpression) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: exp)
        let subgraph =
            _LazySubgraphGenerator(startNode: node)
                .addingExitNode(node)
        
        switch exp.value {
        case .expression(let exp):
            return _connections(forExpression: exp)
                .nullCoalesceToExits()
                .chainingExits(to: subgraph)
        case .type:
            return subgraph
        }
    }

    private static func _connections(for exp: TernaryExpression) -> _LazySubgraphGenerator {
        let predicate = _connections(forExpression: exp.exp).satisfyingNullCoalesce()
        let ifTrue = _connections(forExpression: exp.ifTrue).nullCoalesceToExits()
        let ifFalse = _connections(forExpression: exp.ifFalse).nullCoalesceToExits()

        return  predicate
            .satisfyingExits()
            .combine(
                ifTrue.addingJumpInto(from: predicate.exitNodes, debugLabel: "true")
            )
            .combine(
                ifFalse.addingJumpInto(from: predicate.exitNodes, debugLabel: "false")
            )
    }

    private static func _connections(for exp: TupleExpression) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: exp)
        let arraySubgraph =
            _LazySubgraphGenerator(startNode: node)
                .addingExitNode(node)
        
        return connections(for: exp.elements)
            .chainingExits(to: arraySubgraph)
    }

    private static func _chainConnection(for exp: Expression, into parent: Expression) -> _LazySubgraphGenerator {
        let node = ControlFlowGraphNode(node: parent)
        let subgraph =
            _LazySubgraphGenerator(startNode: node)
                .addingExitNode(node)
        
        return _connections(forExpression: exp)
            .nullCoalesceToExits()
            .chainingExits(to: subgraph)
    }
}
