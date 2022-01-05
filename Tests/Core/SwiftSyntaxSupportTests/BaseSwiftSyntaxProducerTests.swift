import SwiftAST
import SwiftSyntax
import TestCommons
import XCTest

@testable import SwiftSyntaxSupport

class BaseSwiftSyntaxProducerTests: XCTestCase {
    func assert<T: SwiftAST.SyntaxNode, U: SyntaxProtocol>(
        _ node: T,
        producer: (SwiftSyntaxProducer) -> (T) -> U,
        matches expected: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        let syntax = producer(SwiftSyntaxProducer())(node)

        diffTest(expected: expected, file: file, line: line + 3)
            .diff(syntax.description, file: file, line: line)
    }

    func assert<T: SyntaxProtocol>(
        _ node: T,
        matches expected: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        diffTest(expected: expected, file: file, line: line + 2)
            .diff(node.description, file: file, line: line)
    }
}
