import XCTest
import SwiftSyntax
import SwiftAST
@testable import SwiftSyntaxSupport
import TestCommons

class BaseSwiftSyntaxProducerTests: XCTestCase {
    func assert<T: SyntaxNode>(_ node: T,
                               producer: (SwiftSyntaxProducer) -> (T) -> Syntax,
                               matches expected: String,
                               file: String = #file,
                               line: Int = #line) {
        
        let syntax = producer(SwiftSyntaxProducer())(node)
        
        if syntax.description != expected {
            let diff = syntax.description.makeDifferenceMarkString(against: expected)
            
            recordFailure(
                withDescription: """
                Expected to produce file matching:
                
                \(expected)
                
                But found:
                
                \(syntax.description)
                
                Diff:
                
                \(diff)
                """,
                inFile: file,
                atLine: line,
                expected: true
            )
        }
    }
    
    func assert(_ node: Syntax,
                matches expected: String,
                file: String = #file,
                line: Int = #line) {
        
        if node.description != expected {
            let diff = node.description.makeDifferenceMarkString(against: expected)
            
            recordFailure(
                withDescription: """
                Expected to produce file matching:
                
                \(expected)
                
                But found:
                
                \(node.description)
                
                Diff:
                
                \(diff)
                """,
                inFile: file,
                atLine: line,
                expected: true
            )
        }
    }
}
