import Analysis
import SwiftAST
import WriterTargetOutput
import XCTest

fileprivate enum AttributeValue: CustomStringConvertible, ExpressibleByStringLiteral, ExpressibleByFloatLiteral, ExpressibleByStringInterpolation {
    case double(Double)
    case string(String)
    case raw(String)

    var description: String {
        switch self {
        case .double(let value):
            return value.description
        case .raw(let value):
            return value
        case .string(let value):
            return #""\#(value.replacingOccurrences(of: "\"", with: #"\""#))""#
        }
    }

    init(stringLiteral value: String) {
        self = .string(value)
    }

    init(floatLiteral value: Double) {
        self = .double(value)
    }
}

fileprivate func labelForSyntaxNode(_ node: SyntaxNode) -> String {
    var label: String
    switch node {
    case let exp as Expression:
        label = exp.description

    case is ExpressionsStatement:
        label = "{exp}"

    case is IfStatement:
        label = "{if}"

    case is ForStatement:
        label = "{for}"

    case is WhileStatement:
        label = "{while}"

    case is DoWhileStatement:
        label = "{do-while}"

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
        }.joined(separator: "\n")
    
    case let catchBlock as CatchBlock:
        if let pattern = catchBlock.pattern {
            label = "{catch \(pattern)}"
        } else {
            label = "{catch}"
        }
    
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

func labelForNode(_ node: ControlFlowGraphNode, graph: ControlFlowGraph) -> String {
    if node === graph.entry {
        return "entry"
    }
    if node === graph.exit {
        return "exit"
    }
    if let endScope = node as? ControlFlowGraphEndScopeNode {
        var reportNode: SyntaxNode = endScope.scope

        // Try to find a more descriptive scope node instead of using the
        // compound statement always
        if endScope.scope is CompoundStatement {
            reportNode = reportNode.parent ?? reportNode
        }

        return "{end scope of \(labelForSyntaxNode(reportNode))}"
    }

    return labelForSyntaxNode(node.node)
}

fileprivate func attributeList(_ list: [(key: String, value: AttributeValue)]) -> String {
    if list.isEmpty {
        return ""
    }

    return "[" + list.map {
        "\($0.key)=\($0.value)"
    }.joined(separator: ", ") + "]"
}

fileprivate func attributes(_ list: (key: String, value: AttributeValue)...) -> String {
    return attributeList(list)
}

internal func sanitize(
    _ graph: ControlFlowGraph,
    expectsUnreachable: Bool = false,
    file: StaticString = #filePath,
    line: UInt = #line
) {

    if !graph.nodes.contains(where: { $0 === graph.entry }) {
        XCTFail(
            """
            Graph's entry node is not currently present in nodes array
            """,
            file: file,
            line: line
        )
    }
    if !graph.nodes.contains(where: { $0 === graph.exit }) {
        XCTFail(
            """
            Graph's exit node is not currently present in nodes array
            """,
            file: file,
            line: line
        )
    }

    if graph.entry.node !== graph.exit.node {
        XCTFail(
            """
            Graph's entry and exit nodes must point to the same AST node
            """,
            file: file,
            line: line
        )
    }

    for edge in graph.edges {
        if !graph.containsNode(edge.start) {
            XCTFail(
                """
                Edge contains reference for node that is not present in graph: \(edge.start.node)
                """,
                file: file,
                line: line
            )
        }
        if !graph.containsNode(edge.end) {
            XCTFail(
                """
                Edge contains reference for node that is not present in graph: \(edge.end.node)
                """,
                file: file,
                line: line
            )
        }
    }

    for node in graph.nodes {
        if node is ControlFlowSubgraphNode {
            XCTFail(
                """
                Found non-expanded subgraph node: \(node.node)
                """,
                file: file,
                line: line
            )
        }

        if graph.allEdges(for: node).isEmpty {
            XCTFail(
                """
                Found a free node with no edges or connections: \(node.node)
                """,
                file: file,
                line: line
            )

            continue
        }

        if !expectsUnreachable && node !== graph.entry && graph.edges(towards: node).isEmpty {
            XCTFail(
                """
                Found non-entry node that has no connections towards it: \(node.node)
                """,
                file: file,
                line: line
            )
        }

        if node !== graph.exit && graph.edges(from: node).isEmpty {
            XCTFail(
                """
                Found non-exit node that has no connections from it: \(node.node)
                """,
                file: file,
                line: line
            )
        }
    }
}

internal func assertGraphviz(
    graph: ControlFlowGraph,
    matches expected: String,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let text = graphviz(graph: graph)

    if text == expected {
        return
    }

    XCTFail(
        """
        Expected produced graph to be

        \(expected)

        But found:

        \(text)

        Diff:

        \(text.makeDifferenceMarkString(against: expected))
        """,
        file: file,
        line: line
    )
}

internal func printGraphviz(graph: ControlFlowGraph) {
    let string = graphviz(graph: graph)
    print(string)
}

internal func graphviz(graph: ControlFlowGraph) -> String {

    let buffer = StringRewriterOutput(settings: .defaults)
    buffer.output(line: "digraph flow {")
    buffer.indented {
        var nodeIds: [ObjectIdentifier: String] = [:]

        var nodeDefinitions: [NodeDefinition] = []
        
        // Prepare nodes
        for node in graph.nodes {
            let label = labelForNode(node, graph: graph)
            
            let rankStart = graph.shortestDistance(from: graph.entry, to: node)
            let rankEnd = graph.shortestDistance(from: node, to: graph.exit)

            nodeDefinitions.append(
                .init(
                    node: node,
                    rankFromStart: rankStart,
                    rankFromEnd: rankEnd,
                    label: label
                )
            )
        }

        // Sort nodes so the result is more stable
        nodeDefinitions.sort { (n1, n2) -> Bool in
            if n1.node === graph.entry {
                return true
            }
            if n1.node === graph.exit {
                return false
            }
            if n2.node === graph.entry {
                return false
            }
            if n2.node === graph.exit {
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
                return n1.label < n2.label
            }
        }

        // Prepare nodes
        for (i, definition) in nodeDefinitions.enumerated() {
            let id = "n\(i + 1)"
            nodeIds[ObjectIdentifier(definition.node)] = id

            buffer.output(line: "\(id) \(attributes(("label", .string(definition.label))))")
        }

        // Output connections
        for definition in nodeDefinitions {
            let node = definition.node

            guard let nodeId = nodeIds[ObjectIdentifier(node)] else {
                continue
            }

            let edges = graph.edges(from: node)

            for edge in edges {
                let target = edge.end
                guard let targetId = nodeIds[ObjectIdentifier(target)] else {
                    continue
                }

                var attributes: [(key: String, value: AttributeValue)] = []
                if let label = edge.debugLabel {
                    attributes.append((key: "label", value: .string(label)))
                }
                if edge.isBackEdge {
                    attributes.append((key: "color", value: "#aa3333"))
                    attributes.append((key: "penwidth", value: 0.5))
                }

                var line = "\(nodeId) -> \(targetId)"
                line += " \(attributeList(attributes))"

                buffer.output(line: line.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
    buffer.output(line: "}")

    return buffer.buffer.trimmingCharacters(in: .whitespacesAndNewlines)
}

internal struct NodeDefinition {
    var node: ControlFlowGraphNode
    
    /// Rank of the node, or the minimal number of edges that connect the node
    /// to the entry of the graph.
    ///
    /// Is `0` for the entry node, and the maximal value for the exit node.
    ///
    /// If the node is not connected to the entry node, this value is `nil`.
    var rankFromStart: Int?

    /// Rank of the node, or the minimal number of edges that connect the node
    /// to the exit of the graph.
    ///
    /// Is `0` for the exit node, and the maximal value for the entry node.
    ///
    /// If the node is not connected to the exit node, this value is `nil`.
    var rankFromEnd: Int?

    var label: String
}
