import SwiftAST
import TestCommons
import WriterTargetOutput
import XCTest

@testable import Analysis

class ControlFlowGraph_CreationTests: XCTestCase {
    func testCreateEmpty() {
        let stmt: CompoundStatement = []

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="exit"]
                    n1 -> n2
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 2)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt]
        )
    }

    func testPruneUnreachable_true() {
        let stmt: CompoundStatement = [
            .expression(.identifier("a")),
            .return(nil),
            .expression(.identifier("b")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt, pruneUnreachable: true)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a"]
                    n3 [label="{return}"]
                    n4 [label="exit"]
                    n1 -> n2
                    n2 -> n3
                    n3 -> n4
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 4)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
    }

    func testPruneUnreachable_false() {
        let stmt: CompoundStatement = [
            .expression(.identifier("a")),
            .return(nil),
            .expression(.identifier("b")),
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt, pruneUnreachable: false)

        sanitize(graph, expectsUnreachable: true)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="a"]
                    n3 [label="b"]
                    n4 [label="{return}"]
                    n5 [label="exit"]
                    n1 -> n2
                    n2 -> n4
                    n3 -> n5
                    n4 -> n5
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 5)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 2)
    }

    func testCreateNestedEmptyCompoundStatementGetsFlattenedToEmptyGraph() {
        let stmt: CompoundStatement = [
            CompoundStatement(statements: [])
        ]

        let graph = ControlFlowGraph.forCompoundStatement(stmt)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph flow {
                    n1 [label="entry"]
                    n2 [label="exit"]
                    n1 -> n2
                }
                """
        )
        XCTAssertEqual(graph.nodes.count, 2)
        XCTAssert(graph.entry.node === stmt)
        XCTAssert(graph.exit.node === stmt)
        XCTAssertEqual(graph.nodesConnected(from: graph.entry).count, 1)
        XCTAssertEqual(graph.nodesConnected(towards: graph.exit).count, 1)
        XCTAssertEqual(
            graph.depthFirstList().compactMap { $0.node as? Statement },
            [stmt, stmt]
        )
    }
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
    func labelForNode(_ node: ControlFlowGraphNode) -> String {
        if node === graph.entry {
            return "entry"
        }
        if node === graph.exit {
            return "exit"
        }

        var label: String
        switch node.node {
        case let exp as ExpressionsStatement:
            label = exp.expressions[0].description
            label = label.replacingOccurrences(of: "\"", with: "\\\"")

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

        default:
            label = "\(type(of: node.node))"
        }

        return label
    }

    func attributeList(_ list: [(key: String, value: String)]) -> String {
        if list.isEmpty {
            return ""
        }

        return "[" + list.map {
            "\($0.key)=\($0.value)"
        }.joined(separator: ", ") + "]"
    }

    func attributes(_ list: (key: String, value: String)...) -> String {
        return attributeList(list)
    }

    let buffer = StringRewriterOutput(settings: .defaults)
    buffer.output(line: "digraph flow {")
    buffer.indented {
        var nodeIds: [ObjectIdentifier: String] = [:]

        var nodeDefinitions: [NodeDefinition] = []

        // Prepare nodes
        for node in graph.nodes {
            var label: String = "\(type(of: node.node))"
            if node === graph.entry {
                label = "entry"
            }
            if node === graph.exit {
                label = "exit"
            }

            switch node.node {
            case let exp as Expression:
                label = exp.description
                label = label.replacingOccurrences(of: "\"", with: "\\\"")

            case let exp as ExpressionsStatement:
                label = exp.expressions[0].description
                label = label.replacingOccurrences(of: "\"", with: "\\\"")

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

            default:
                break
            }

            nodeDefinitions.append(NodeDefinition(node: node, label: label))
        }

        // Sort nodes so the result is more stable
        nodeDefinitions.sort { (n1, n2) -> Bool in
            if n1.node === graph.entry {
                return true
            }
            if n2.node === graph.entry {
                return false
            }
            if n1.node === graph.exit {
                return false
            }
            if n2.node === graph.exit {
                return true
            }

            return n1.label < n2.label
        }

        // Prepare nodes
        for (i, definition) in nodeDefinitions.enumerated() {
            let id = "n\(i + 1)"
            nodeIds[ObjectIdentifier(definition.node)] = id

            //buffer.output(line: "\(id) [label=\"\(definition.label)\"]")
            buffer.output(line: "\(id) \(attributes(("label", #""\#(definition.label)""#)))")
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

                var attributes: [(key: String, value: String)] = []
                if let label = edge.debugLabel {
                    attributes.append((key: "label", value: #""\#(label)""#))
                }
                if edge.isBackEdge {
                    attributes.append((key: "color", value: "\"#aa3333\""))
                    attributes.append((key: "penwidth", value: "0.5"))
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
    var label: String
}
