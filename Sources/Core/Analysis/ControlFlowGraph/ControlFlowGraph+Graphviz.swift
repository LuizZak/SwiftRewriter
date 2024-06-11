import Foundation
import Intentions
import SwiftAST
import TypeSystem
import KnownType
import MiniGraphviz

extension ControlFlowGraph {
    /// Generates a GraphViz representation of this call graph.
    public func asGraphviz() -> GraphViz {
        let viz = GraphViz(rootGraphName: "flow")
        viz.rankDir = .topToBottom

        var nodeIds: [Node: GraphViz.NodeId] = [:]
        var nodeDefinitions: [NodeDefinition<ControlFlowGraphNode>] = []

        let nodes = Array(self.nodes)

        // Prepare nodes
        for node in nodes {
            let label = labelForNode(node, graph: self)

            let rankStart = self.shortestDistance(from: self.entry, to: node)
            let rankEnd = self.shortestDistance(from: node, to: self.exit)

            nodeDefinitions.append(
                .init(
                    node: node,
                    rankFromStart: rankStart,
                    rankFromEnd: rankEnd,
                    label: label,
                    id: node.id
                )
            )
        }

        // Sort nodes so the result is more stable
        nodeDefinitions.sort { (n1, n2) -> Bool in
            if n1.node === self.entry {
                return true
            }
            if n1.node === self.exit {
                return false
            }
            if n2.node === self.entry {
                return false
            }
            if n2.node === self.exit {
                return true
            }

            // If rank data is available, use it to create a more linear list of
            // nodes on the output. Nodes with no rank should be added to the end
            // of the graph, after all ranked nodes.
            switch (n1.rankFromStart, n2.rankFromStart) {
            case (nil, _?):
                return false

            case (_?, nil):
                return true

            case (let r1?, let r2?) where r1 < r2:
                return true

            case (let r1?, let r2?) where r1 > r2:
                return false

            default:
                break
            }

            switch (n1.rankFromEnd, n2.rankFromEnd) {
            case (nil, _?):
                return true

            case (_?, nil):
                return false

            case (let r1?, let r2?) where r1 < r2:
                return false

            case (let r1?, let r2?) where r1 > r2:
                return true

            default:
                break
            }

            if n1.label < n2.label {
                return true
            }
            if n1.label > n2.label {
                return false
            }

            return n1.id < n2.id
        }

        // Prepare nodes
        for definition in nodeDefinitions {
            nodeIds[definition.node] = viz.createNode(label: definition.label)
        }

        var intermediaries: [IntermediaryEdge] = []

        for edge in edges {
            guard let startId = nodeIds[edge.start] else {
                continue
            }
            guard let endId = nodeIds[edge.end] else {
                continue
            }

            let intermediary =
                IntermediaryEdge(
                    start: edge.start,
                    end: edge.end,
                    debugLabel: edge.debugLabel,
                    isBackEdge: edge.isBackEdge,
                    vizStart: startId,
                    vizEnd: endId
                )

            intermediaries.append(intermediary)
        }

        // Sort intermediaries
        intermediaries.sort()

        for intermediary in intermediaries {
            var attributes: GraphViz.Attributes = GraphViz.Attributes()

            if let label = intermediary.debugLabel {
                attributes["label"] = .string(label)
            }
            if intermediary.isBackEdge {
                attributes["color"] = .string("#aa3333")
                attributes["penwidth"] = 0.5
            }

            viz.addConnection(
                from: intermediary.vizStart,
                to: intermediary.vizEnd,
                attributes: attributes
            )
        }

        return viz
    }

    /// Used to generate Graphviz graphs; supports stable ordering based on the
    /// start/end nodes of each edge.
    private struct IntermediaryEdge: Comparable {
        var start: Node
        var end: Node
        var debugLabel: String?
        var isBackEdge: Bool

        var vizStart: GraphViz.NodeId
        var vizEnd: GraphViz.NodeId

        static func < (lhs: Self, rhs: Self) -> Bool {
            if lhs.vizStart == rhs.vizStart {
                return lhs.vizEnd < rhs.vizEnd
            }

            return lhs.vizStart < rhs.vizStart
        }
    }
}

fileprivate func labelForSyntaxNode(_ node: SwiftAST.SyntaxNode) -> String {
    var label: String
    switch node {
    case let exp as Expression:
        label = exp.description

    case is CompoundStatement:
        label = "{compound}"

    case is ExpressionsStatement:
        label = "{exp}"

    case is IfStatement:
        label = "{if}"

    case is SwitchStatement:
        label = "{switch}"

    case let clause as SwitchCase:
        if clause.patterns.count == 1 {
            label = "{case \(clause.patterns[0])}"
        } else {
            label = "{case \(clause.patterns)}"
        }

    case is SwitchDefaultCase:
        label = "{default}"

    case is ForStatement:
        label = "{for}"

    case is WhileStatement:
        label = "{while}"

    case is RepeatWhileStatement:
        label = "{repeat-while}"

    case is DoStatement:
        label = "{do}"

    case let catchBlock as CatchBlock:
        if let pattern = catchBlock.pattern {
            label = "{catch \(pattern)}"
        } else {
            label = "{catch}"
        }

    case is DeferStatement:
        label = "{defer}"

    case let ret as ReturnStatement:
        if let exp = ret.exp {
            label = "{return \(exp)}"
        } else {
            label = "{return}"
        }

    case let stmt as ThrowStatement:
        label = "{throw \(stmt.exp)}"

    case let varDecl as VariableDeclarationsStatement:
        label = varDecl.decl.map { decl -> String in
            var declLabel = decl.isConstant ? "let " : "var "
            declLabel += decl.identifier
            declLabel += ": \(decl.type)"

            return declLabel
        }.joined(separator: ", ")

    case let stmt as BreakStatement:
        if let l = stmt.targetLabel {
            label = "{break \(l)}"
        } else {
            label = "{break}"
        }

    case let stmt as ContinueStatement:
        if let l = stmt.targetLabel {
            label = "{continue \(l)}"
        } else {
            label = "{continue}"
        }

    case is FallthroughStatement:
        label = "{fallthrough}"

    case let obj as CustomStringConvertible:
        label = obj.description

    default:
        label = "\(type(of: node))"
    }

    return label
}

fileprivate func labelForNode(_ node: ControlFlowGraphNode, graph: ControlFlowGraph) -> String {
    if node === graph.entry {
        return "entry"
    }
    if node === graph.exit {
        return "exit"
    }
    if node.node is MarkerSyntaxNode {
        return "{marker}"
    }
    if let endScope = node as? ControlFlowGraphEndScopeNode {
        var reportNode: SwiftAST.SyntaxNode = endScope.scope

        // Try to find a more descriptive scope node instead of using the
        // compound statement always
        if endScope.scope is CompoundStatement {
            reportNode = reportNode.parent ?? reportNode
        }

        return "{end scope of \(labelForSyntaxNode(reportNode))}"
    }

    return labelForSyntaxNode(node.node)
}
