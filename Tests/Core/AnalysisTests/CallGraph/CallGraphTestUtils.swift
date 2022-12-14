import SwiftAST
import WriterTargetOutput
import SwiftSyntax
import SwiftSyntaxParser
import XCTest
import Intentions
import KnownType
import TestCommons
import GraphvizLib

@testable import Analysis

internal func sanitize(
    _ graph: CallGraph,
    expectsUnreachable: Bool = false,
    expectsNonExitEndNodes: Bool = false,
    file: StaticString = #filePath,
    line: UInt = #line
) {

}

internal func assertGraphviz(
    graph: CallGraph,
    matches expected: String,
    syntaxNode: SwiftAST.SyntaxNode? = nil,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let text =
        graph
            .asGraphviz()
            .generateFile(
                options: .init(simplifyGroups: false)
            )

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

internal func printGraphviz(graph: CallGraph) {
    let string = graph.asGraphviz().generateFile()
    print(string)
}
