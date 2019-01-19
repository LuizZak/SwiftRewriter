import XCTest
import SwiftSyntax
import SwiftAST
@testable import SwiftSyntaxSupport
import Intentions
import TestCommons
import Utils

class SwiftSyntaxProducer_StmtTests: XCTestCase {
    
    func testReturnStatement() {
        assert(Statement.return(nil),
               producer: SwiftSyntaxProducer.generateReturn,
               matches: """
                return
                """)
    }
    
    func testReturnStatementWithExpression() {
        assert(Statement.return(.constant(123)),
               producer: SwiftSyntaxProducer.generateReturn,
               matches: """
                return 123
                """)
    }
}

extension SwiftSyntaxProducer_StmtTests {
    func testIfStatement() {
        let stmt: IfStatement = .if(.constant(true), body: [], else: [])
        
        assert(stmt,
               producer: SwiftSyntaxProducer.generateIfStmt,
               matches: """
                if true {
                } else {
                }
                """)
    }
}

// MARK: - Assertions
private extension SwiftSyntaxProducer_StmtTests {
    func assert<T: Statement, S: Syntax>(_ stmt: T, producer: (SwiftSyntaxProducer) -> (T) -> S, matches expected: String, line: Int = #line) {
        let syntax = producer(SwiftSyntaxProducer())(stmt)
        
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
                inFile: #file,
                atLine: line,
                expected: true
            )
        }
    }
}
