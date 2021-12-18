import XCTest
import SwiftSyntax
import SwiftAST
@testable import SwiftSyntaxSupport
import TestCommons

class BaseSwiftSyntaxProducerTests: XCTestCase {
    func assert<T: SwiftAST.SyntaxNode, U: SyntaxProtocol>(
        _ node: T,
        producer: (SwiftSyntaxProducer) -> (T) -> U,
        matches expected: String,
        file: StaticString = #filePath,
        line: UInt = #line) {
        
        let syntax = producer(SwiftSyntaxProducer())(node)
        
        diffTest(expected: expected, file: file, line: line)
            .diff(syntax.description, file: file, line: line + 2)
    }
    
    func assert<T: SyntaxProtocol>(_ node: T,
                                   matches expected: String,
                                   file: StaticString = #filePath,
                                   line: UInt = #line) {
        
        diffTest(expected: expected, file: file, line: line)
            .diff(node.description, file: file, line: line)
    }
}
