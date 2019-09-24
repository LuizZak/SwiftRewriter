import XCTest
import SwiftSyntax
import SwiftAST
@testable import SwiftSyntaxSupport
import TestCommons

class BaseSwiftSyntaxProducerTests: XCTestCase {
    func assert<T: SwiftAST.SyntaxNode>(_ node: T,
                                        producer: (SwiftSyntaxProducer) -> (T) -> Syntax,
                                        matches expected: String,
                                        file: String = #file,
                                        line: Int = #line) {
        
        let syntax = producer(SwiftSyntaxProducer())(node)
        
        diffTest(expected: expected, file: file, line: line)
            .diff(syntax.description, file: file, line: line + 2)
    }
    
    func assert(_ node: Syntax,
                matches expected: String,
                file: String = #file,
                line: Int = #line) {
        
        diffTest(expected: expected, file: file, line: line)
            .diff(node.description, file: file, line: line)
    }
}
