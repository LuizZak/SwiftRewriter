import XCTest
import SwiftSyntax
import SwiftAST
@testable import SwiftSyntaxSupport
import Intentions
import TestCommons
import Utils

class SwiftSyntaxProducer_StmtTests: XCTestCase {
    
    func testExpressions() {
        let stmt = Statement.expressions([.identifier("foo"), .identifier("bar")])
        let syntax = SwiftSyntaxProducer().generateExpressions(stmt)
        
        assert(syntax[0](),
               matches: """
                foo
                """)
        
        assert(syntax[1](),
               matches: """
                bar
                """)
    }
    
    func testExpressionsInCompound() {
        let stmt: CompoundStatement = [Statement.expressions([.identifier("foo"), .identifier("bar")])]
        let syntax = SwiftSyntaxProducer().generateCompound(stmt)
        
        assert(syntax,
               matches: """
                 {
                    foo
                    bar
                }
                """)
    }
    
    func testVariableDeclarationsStatement() {
        let stmt = Statement
            .variableDeclarations([
                StatementVariableDeclaration(identifier: "foo", type: .int),
                StatementVariableDeclaration(identifier: "bar",
                                             type: .float,
                                             initialization: .constant(0.0))
            ])
        let syntax = SwiftSyntaxProducer().generateVariableDeclarations(stmt)
        
        assert(syntax[0](),
               matches: """
                var foo: Int
                """)
        
        assert(syntax[1](),
               matches: """
                var bar: Float = 0.0
                """)
    }
    
    func testVariableDeclarationsInCompound() {
        let stmt: CompoundStatement = [
            Statement
                .variableDeclarations([
                    StatementVariableDeclaration(identifier: "foo", type: .int),
                    StatementVariableDeclaration(identifier: "bar",
                                                 type: .float,
                                                 initialization: .constant(0.0))
                    ])
        ]
        let syntax = SwiftSyntaxProducer().generateCompound(stmt)
        
        assert(syntax,
               matches: """
                 {
                    var foo: Int
                    var bar: Float = 0.0
                }
                """)
    }
    
    func testContinueStatement() {
        assert(
            Statement.continue(),
            producer: SwiftSyntaxProducer.generateContinue,
            matches: """
                continue
                """)
    }
    
    func testContinueStatementWithLabel() {
        assert(
            Statement.continue(targetLabel: "label"),
            producer: SwiftSyntaxProducer.generateContinue,
            matches: """
                continue label
                """)
    }
    
    func testBreakStatement() {
        assert(
            Statement.break(),
            producer: SwiftSyntaxProducer.generateBreak,
            matches: """
                break
                """)
    }
    
    func testBreakStatementWithLabel() {
        assert(
            Statement.break(targetLabel: "label"),
            producer: SwiftSyntaxProducer.generateBreak,
            matches: """
                break label
                """)
    }
    
    func testFallthroughStatement() {
        assert(
            Statement.fallthrough,
            producer: SwiftSyntaxProducer.generateFallthrough,
            matches: """
                fallthrough
                """)
    }
    
    func testReturnStatement() {
        assert(
            Statement.return(nil),
            producer: SwiftSyntaxProducer.generateReturn,
            matches: """
                return
                """)
    }
    
    func testReturnStatementWithExpression() {
        assert(
            Statement.return(.constant(123)),
            producer: SwiftSyntaxProducer.generateReturn,
            matches: """
                return 123
                """)
    }
    
    func testIfStatement() {
        assert(
            Statement.if(.constant(true), body: [], else: nil),
            producer: SwiftSyntaxProducer.generateIfStmt,
            matches: """
                if true {
                }
                """)
    }
    
    func testIfElseStatement() {
        assert(
            Statement.if(.constant(true), body: [], else: []),
            producer: SwiftSyntaxProducer.generateIfStmt,
            matches: """
                if true {
                } else {
                }
                """)
    }
    
    func testIfLetStatement() {
        assert(
            Statement.ifLet(.identifier("value"), .identifier("exp"), body: [], else: nil),
            producer: SwiftSyntaxProducer.generateIfStmt,
            matches: """
                if let value = exp {
                }
                """)
    }
    
    func testIfLetElseStatement() {
        assert(
            Statement.ifLet(.identifier("value"), .identifier("exp"), body: [], else: []),
            producer: SwiftSyntaxProducer.generateIfStmt,
            matches: """
                if let value = exp {
                } else {
                }
                """)
    }
    
    func testSwitchStatementEmpty() {
        let stmt = Statement
            .switch(
                .identifier("value"),
                cases: [
                ],
                default: nil)
        
        assert(
            stmt,
            producer: SwiftSyntaxProducer.generateSwitchStmt,
            matches: """
                switch value {
                }
                """)
    }
    
    func testSwitchStatementOneCase() {
        let stmt = Statement
            .switch(
                .identifier("value"),
                cases: [
                    SwitchCase(
                        patterns: [
                            .expression(.constant(0))
                        ],
                        statements: [
                            .break()
                        ]
                    )
                ],
                default: nil)
        
        assert(
            stmt,
            producer: SwiftSyntaxProducer.generateSwitchStmt,
            matches: """
                switch value {
                case 0:
                    break
                }
                """)
    }
    
    func testSwitchStatementTwoCases() {
        let stmt = Statement
            .switch(
                .identifier("value"),
                cases: [
                    SwitchCase(
                        patterns: [
                            .expression(.constant(0))
                        ],
                        statements: [
                            .break()
                        ]
                    ),
                    SwitchCase(
                        patterns: [
                            .tuple([.expression(.constant(0)),
                                    .expression(.constant(0))])
                        ],
                        statements: [
                            .break()
                        ]
                    )
                ],
                default: nil)
        
        assert(
            stmt,
            producer: SwiftSyntaxProducer.generateSwitchStmt,
            matches: """
                switch value {
                case 0:
                    break
                case (0, 0):
                    break
                }
                """)
    }
    
    func testSwitchStatementOneCaseWithDefault() {
        let stmt = Statement
            .switch(
                .identifier("value"),
                cases: [
                    SwitchCase(
                        patterns: [
                            .expression(.constant(0))
                        ],
                        statements: [
                            .break()
                        ]
                    )
                ],
                default: [
                    .break()
                ])
        
        assert(
            stmt,
            producer: SwiftSyntaxProducer.generateSwitchStmt,
            matches: """
                switch value {
                case 0:
                    break
                default:
                    break
                }
                """)
    }
    
    func testSwitchStatementFull() {
        let stmt = Statement
            .switch(
                .identifier("value"),
                cases: [
                    SwitchCase(
                        patterns: [
                            .expression(.constant(0)),
                            .expression(.constant(1))
                        ],
                        statements: [
                            .expression(Expression.identifier("foo").call())
                        ]
                    ),
                    SwitchCase(
                        patterns: [
                            .tuple([.expression(.constant(0)),
                                    .expression(.constant(0))])
                        ],
                        statements: [
                            .expression(Expression.identifier("foo").call()),
                            .expression(Expression.identifier("bar").call())
                        ]
                    )
                ],
                default: [
                    .break()
                ])
        
        assert(
            stmt,
            producer: SwiftSyntaxProducer.generateSwitchStmt,
            matches: """
                switch value {
                case 0, 1:
                    foo()
                case (0, 0):
                    foo()
                    bar()
                default:
                    break
                }
                """)
    }
    
    func testWhileStatement() {
        assert(
            Statement.while(.constant(true), body: []),
            producer: SwiftSyntaxProducer.generateWhileStmt,
            matches: """
                while true {
                }
                """)
    }
    
    func testRepeatWhileStatement() {
        assert(
            Statement.doWhile(.constant(true), body: []),
            producer: SwiftSyntaxProducer.generateDoWhileStmt,
            matches: """
                repeat {
                } while true
                """)
    }
    
    func testForStatement() {
        assert(
            Statement.for(.identifier("test"), .identifier("array"), body: []),
            producer: SwiftSyntaxProducer.generateForIn,
            matches: """
                for test in array {
                }
                """)
    }
    
    func testDoStatement() {
        assert(
            Statement.do([]),
            producer: SwiftSyntaxProducer.generateDo,
            matches: """
                do {
                }
                """)
    }
    
    func testDeferStatement() {
        assert(
            Statement.defer([]),
            producer: SwiftSyntaxProducer.generateDefer,
            matches: """
                defer {
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
    
    func assert(_ syntax: Syntax, matches expected: String, line: Int = #line) {
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
