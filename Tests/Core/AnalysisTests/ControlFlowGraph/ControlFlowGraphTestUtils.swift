import SwiftAST
import WriterTargetOutput
import SwiftSyntax
import SwiftSyntaxParser
import XCTest
import TestCommons
import Graphviz

@testable import Analysis

internal func sanitize(
    _ graph: ControlFlowGraph,
    expectsUnreachable: Bool = false,
    expectsNonExitEndNodes: Bool = false,
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

        if graph.allEdges(for: node).isEmpty && node !== graph.entry && node !== graph.exit {
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

        if !expectsNonExitEndNodes && node !== graph.exit && graph.edges(from: node).isEmpty {
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

internal var recordMode: Bool = false
internal var recordedGraphs: [GraphvizUpdateEntry] = []
internal func assertGraphviz(
    graph: ControlFlowGraph,
    matches expected: String,
    syntaxNode: SwiftAST.SyntaxNode? = nil,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let text = graphviz(graph: graph)

    if text == expected {
        return
    }

    if recordMode {
        recordedGraphs.append(
            .init(
                file: "\(file)",
                line: Int(line),
                newGraphviz: text
            )
        )
    }

    let syntaxString: String?
    switch syntaxNode {
    case let node as Expression:
        syntaxString = ExpressionPrinter.toString(expression: node)

    case let node as Statement:
        syntaxString = StatementPrinter.toString(statement: node)
    
    default:
        syntaxString = nil
    }

    XCTFail(
        """
        \(syntaxString.map{ "\($0)\n\n" } ?? "")Expected produced graph to be

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

    let viz = GraphViz(rootGraphName: "flow")
    viz.rankDir = .topToBottom

    var nodeIds: [ObjectIdentifier: GraphViz.NodeId] = [:]
    var nodeDefinitions: [NodeDefinition<ControlFlowGraphNode>] = []
    
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
    for definition in nodeDefinitions {
        nodeIds[ObjectIdentifier(definition.node)] = viz.createNode(label: definition.label)
    }

    // Output connections
    for definition in nodeDefinitions {
        let node = definition.node

        guard let nodeId = nodeIds[ObjectIdentifier(node)] else {
            continue
        }

        var edges = graph.edges(from: node)

        // Sort edges by lexical ordering
        edges.sort {
            guard let lhs = nodeIds[ObjectIdentifier($0.end)] else {
                return false
            }
            guard let rhs = nodeIds[ObjectIdentifier($1.end)] else {
                return true
            }
            
            return lhs.description.compare(rhs.description, options: .numeric) == .orderedAscending
        }

        for edge in edges {
            let target = edge.end
            guard let targetId = nodeIds[ObjectIdentifier(target)] else {
                continue
            }

            var attributes: GraphViz.Attributes = GraphViz.Attributes()

            if let label = edge.debugLabel {
                attributes["label"] = .string(label)
            }
            if edge.isBackEdge {
                attributes["color"] = .string("#aa3333")
                attributes["penwidth"] = 0.5
            }

            viz.addConnection(from: nodeId, to: targetId, attributes: attributes)
        }
    }

    return viz.generateFile()
}

func updateAllRecordedGraphviz() throws {
    guard recordMode && !recordedGraphs.isEmpty else {
        return
    }
    defer { recordedGraphs.removeAll() }

    print("Updating test cases, please wait...")

    // Need to apply from bottom to top to avoid early rewrites offsetting later
    // rewrites
    let sorted = recordedGraphs.sorted(by: { $0.line > $1.line })

    for entry in sorted {
        try updateGraphvizCode(entry: entry)
    }

    print("Success!")
}

func throwErrorIfInGraphvizRecordMode(file: StaticString = #file) throws {
    struct TestError: Error, CustomStringConvertible {
        var description: String
    }

    if recordMode {
        throw TestError(description: "Record mode is on on graphviz tests in file \(file)")
    }
}

internal struct NodeDefinition<Node: DirectedGraphNode> {
    var node: Node
    
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

internal func updateGraphvizCode(entry: GraphvizUpdateEntry) throws {
    let path = URL(fileURLWithPath: entry.file)

    let syntax = try SyntaxParser.parse(path)

    let converter = SourceLocationConverter(file: entry.file, tree: syntax)
    let rewriter = GraphvizUpdateRewriter(entry: entry, locationConverter: converter)
    
    let newSyntax = rewriter.visit(syntax)
    
    guard syntax.description != newSyntax.description else {
        return
    }

    try newSyntax.description.write(to: path, atomically: true, encoding: .utf8)
}

private class GraphvizUpdateRewriter: SyntaxRewriter {
    private var _convertNextString: Bool = false

    let entry: GraphvizUpdateEntry
    let locationConverter: SourceLocationConverter

    convenience init(
        file: String,
        line: Int,
        newGraphviz: String,
        locationConverter: SourceLocationConverter
    ) {

        self.init(
            entry: .init(file: file, line: line, newGraphviz: newGraphviz),
            locationConverter: locationConverter
        )
    }

    init(entry: GraphvizUpdateEntry, locationConverter: SourceLocationConverter) {
        self.entry = entry
        self.locationConverter = locationConverter
    }

    override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        guard matchesEntryLine(node) else {
            return super.visit(node)
        }
        guard let ident = node.calledExpression.as(IdentifierExprSyntax.self) else {
            return super.visit(node)
        }
        guard matchesAssertIdentifier(ident) else {
            return super.visit(node)
        }

        let args = node.argumentList
        guard args.count == 2 || args.count == 3 else {
            return super.visit(node)
        }

        _convertNextString = true
        defer { _convertNextString = false }

        return super.visit(node)
    }

    override func visit(_ node: StringLiteralExprSyntax) -> ExprSyntax {
        if _convertNextString {
            return ExprSyntax(updatingExpectedString(node))
        }

        return super.visit(node)
    }

    private func updatingExpectedString(_ exp: StringLiteralExprSyntax) -> StringLiteralExprSyntax {
        let result = StringLiteralExprSyntax { builder in
            builder.useOpenQuote(
                SyntaxFactory.makeMultilineStringQuoteToken()
            )
            builder.useCloseQuote(
                SyntaxFactory.makeMultilineStringQuoteToken()
            )

            let formatted = formatGraphviz(entry.newGraphviz)

            builder.addSegment(
                Syntax(
                    SyntaxFactory
                    .makeStringSegment(formatted)
                )
            )
        }

        return result
    }

    private func formatGraphviz(_ string: String, indentationInSpaces: Int = 16) -> String {
        let indentation = String(repeating: " ", count: indentationInSpaces)
        let lines = string.split(separator: "\n", omittingEmptySubsequences: false)
        let lineSeparator = "\n\(indentation)"

        return lineSeparator + lines.joined(separator: lineSeparator) + lineSeparator
    }

    private func matchesAssertIdentifier(_ syntax: IdentifierExprSyntax) -> Bool {
        return syntax.identifier.withoutTrivia().description == "assertGraphviz"
    }

    private func matchesEntryLine(_ syntax: SyntaxProtocol) -> Bool {
        let loc = location(of: syntax)

        return loc.line == entry.line
    }

    private func location(of syntax: SyntaxProtocol) -> SourceLocation {
        syntax.sourceRange(converter: locationConverter).start
    }
}

internal struct GraphvizUpdateEntry {
    var file: String
    var line: Int
    var newGraphviz: String
}
