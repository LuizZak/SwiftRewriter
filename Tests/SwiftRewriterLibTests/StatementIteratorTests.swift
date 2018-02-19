import XCTest
import SwiftRewriterLib

class StatementIteratorTests: XCTestCase {
    
    func testIf() {
        assertStatement(.if(.constant(true), body: [.do([.break])], else: [.do([.continue])]),
                        iteratesAs: [
                            .if(.constant(true), body: [.do([.break])], else: [.do([.continue])]),
                            .do([.break]),
                            .do([.continue]),
                            .break,
                            .continue
            ]
        )
    }
    
    func testDo() {
        assertStatement(.do([.break, .continue]),
                        iteratesAs: [
                            .do([.break, .continue]),
                            .break,
                            .continue
            ]
        )
    }
    
    func testWhileStatement() {
        assertStatement(.while(.constant(true), body: [.break, .continue]),
                        iteratesAs: [
                            .while(.constant(true), body: [.break, .continue]),
                            .break,
                            .continue
            ]
        )
    }
    
    func testForStatementNotInspectingBlocks() {
        assertStatement(.for(.expression(makeBlock("a")), makeBlock("b"),
                             body: [.expression(.identifier("c"))]),
                        inspectingBlocks: false,
                        iteratesAs: [
                            .for(.expression(makeBlock("a")),
                                 makeBlock("b"),
                                 body: [.expression(.identifier("c"))]),
                                .expression(.identifier("c"))
            ]
        )
    }
    
    func testForStatementInspectingBlocks() {
        assertStatement(.for(.expression(makeBlock("a")), makeBlock("b"),
                             body: [.expression(.identifier("c"))]),
                        inspectingBlocks: true,
                        iteratesAs: [
                            .for(.expression(makeBlock("a")),
                                 makeBlock("b"),
                                 body: [.expression(.identifier("c"))]),
                            .expression(.identifier("c")),
                            .expression(.identifier("a")),
                            .expression(.identifier("b"))
            ]
        )
    }
    
    func testCompound() {
        assertStatement(
            .compound([
                .expression(.identifier("a")),
                .expression(.identifier("b"))
                ]),
            iteratesAs: [
                .compound([
                    .expression(.identifier("a")),
                    .expression(.identifier("b"))
                    ]),
                .expression(.identifier("a")),
                .expression(.identifier("b"))
            ]
        )
    }
    
    func testSemicolon() {
        assertStatement(
            .compound([
                .semicolon,
                .semicolon
                ]),
            iteratesAs: [
                .compound([
                    .semicolon,
                    .semicolon
                    ]),
                .semicolon,
                .semicolon
            ]
        )
    }
    
    func testSwitchNotInspectingBlocks() {
        let cases: [SwitchCase] = [
            SwitchCase(patterns: [.expression(makeBlock("a"))],
                       statements: [.expression(.identifier("c"))]
            )
        ]
        
        assertStatement(.switch(makeBlock("a"),
                                cases: cases, default: nil),
                        iteratesAs: [
                            .switch(makeBlock("a"),
                                    cases: cases, default: nil),
                            .expression(.identifier("c"))
            ]
        )
    }
    
    func testSwitchInspectingBlocks() {
        let cases: [SwitchCase] = [
            SwitchCase(patterns: [.expression(makeBlock("b"))],
                       statements: [.expression(.identifier("c"))]
            ),
            SwitchCase(patterns: [.tuple([.expression(makeBlock("d")), .identifier("e")])],
                       statements: []
            )
        ]
        
        assertStatement(.switch(makeBlock("a"),
                                cases: cases, default: nil),
                        inspectingBlocks: true,
                        iteratesAs: [
                            .switch(makeBlock("a"),
                                    cases: cases, default: nil),
                            .expression(.identifier("c")),
                            .expression(.identifier("a")),
                            .expression(.identifier("b")),
                            .expression(.identifier("d"))
            ]
        )
    }
    
    func testDefer() {
        assertStatement(.defer([.expression(.identifier("a")),
                                .expression(.identifier("b"))]),
                        iteratesAs: [
                            .defer([.expression(.identifier("a")),
                                    .expression(.identifier("b"))]),
                            .expression(.identifier("a")),
                            .expression(.identifier("b"))
            ]
        )
    }
    
    func testReturn() {
        assertStatement(.return(nil), iteratesAs: [.return(nil)])
    }
    
    func testReturnInspectingBlocks() {
        assertStatement(.return(makeBlock("a")),
                        inspectingBlocks: true,
                        iteratesAs: [
                            .return(makeBlock("a")),
                            .expression(.identifier("a"))
            ])
    }
    
    func testBreak() {
        assertStatement(.break, iteratesAs: [.break])
    }
    
    func testContinue() {
        assertStatement(.continue, iteratesAs: [.continue])
    }
    
    func testVariableDeclarationsNotInspectingBlocks() {
        assertStatement(Statement.variableDeclarations([
            StatementVariableDeclaration(
                identifier: "a", type: .void,
                ownership: .strong, isConstant: false,
                initialization: makeBlock("a"))
            ]), iteratesAs: [
                Statement.variableDeclarations([
                    StatementVariableDeclaration(
                        identifier: "a", type: .void,
                        ownership: .strong, isConstant: false,
                        initialization: makeBlock("a"))
                    ])
            ])
    }
    
    func testVariableDeclarationsInspectingBlocks() {
        assertStatement(Statement.variableDeclarations([
            StatementVariableDeclaration(
                identifier: "a", type: .void,
                ownership: .strong, isConstant: false,
                initialization: makeBlock("a"))
            ]),
                        inspectingBlocks: true,
                        iteratesAs: [
                            Statement.variableDeclarations([
                                StatementVariableDeclaration(
                                    identifier: "a", type: .void,
                                    ownership: .strong, isConstant: false,
                                    initialization: makeBlock("a"))
                                ]),
                            .expression(.identifier("a"))
            ])
    }
    
    func testCastExpression() {
        assertExpression(.cast(makeBlock("a"), type: .void),
                         inspectingBlocks: true,
                         iteratesAs: [
                            .expression(.identifier("a"))
            ])
    }
    
    func testUnaryExpression() {
        assertExpression(.unary(op: .negate, makeBlock("a")),
                         inspectingBlocks: true,
                         iteratesAs: [
                            .expression(.identifier("a"))
            ])
    }
    
    func testPrefixExpression() {
        assertExpression(.prefix(op: .negate, makeBlock("a")),
                         inspectingBlocks: true,
                         iteratesAs: [
                            .expression(.identifier("a"))
            ])
    }
    
    func testPostfixSubscriptExpression() {
        assertExpression(.postfix(makeBlock("a"), .subscript(makeBlock("b"))),
                         inspectingBlocks: true,
                         iteratesAs: [
                            .expression(.identifier("a")),
                            .expression(.identifier("b"))
            ])
    }
    
    func testPostfixFunctionCallExpression() {
        assertExpression(.postfix(makeBlock("a"), .functionCall(arguments: [.unlabeled(makeBlock("b"))])),
                         inspectingBlocks: true,
                         iteratesAs: [
                            .expression(.identifier("a")),
                            .expression(.identifier("b"))
            ])
    }
    
    func testParensExpression() {
        assertExpression(.parens(makeBlock("a")),
                         inspectingBlocks: true,
                         iteratesAs: [
                            .expression(.identifier("a"))
            ])
    }
    
    func testArrayLiteralExpression() {
        assertExpression(.arrayLiteral([makeBlock("a"), makeBlock("b")
            ]),
                         inspectingBlocks: true,
                         iteratesAs: [
                            .expression(.identifier("a")),
                            .expression(.identifier("b"))
            ])
    }
    
    func testDictionaryLiteralExpression() {
        assertExpression(.dictionaryLiteral([
            ExpressionDictionaryPair(key: makeBlock("a"), value: makeBlock("b"))
            ]),
                         inspectingBlocks: false,
                         iteratesAs: [
                
            ])
        
        assertExpression(.dictionaryLiteral([
            ExpressionDictionaryPair(key: makeBlock("a"), value: makeBlock("b"))
            ]),
                         inspectingBlocks: true,
                         iteratesAs: [
                            .expression(.identifier("a")),
                            .expression(.identifier("b"))
            ])
    }
    
    func testTernaryExpression() {
        assertExpression(.ternary(makeBlock("a"),
                                  true: makeBlock("b"),
                                  false: makeBlock("c")),
                         inspectingBlocks: true,
                         iteratesAs: [
                            .expression(.identifier("a")),
                            .expression(.identifier("b")),
                            .expression(.identifier("c"))
            ])
    }
    
    /// Creates a test block which contains only a single statement containing an
    /// `Expression.identifier()` case with a given input value as the identifier.
    ///
    /// Used in tests to generate an expression that contains statements, to test
    /// iterating statements through expressions.
    private func makeBlock(_ input: String) -> Expression {
        return .block(parameters: [],
                      return: .void,
                      body: [.expression(.identifier(input))])
    }
    
    private func assertExpression(_ source: Expression, inspectingBlocks: Bool = false,
                                  iteratesAs expected: [Statement], file: String = #file, line: Int = #line) {
        let iterator =
            StatementIterator(expression: source,
                              inspectBlocks: inspectingBlocks)
        
        assertIterator(iterator: iterator, iterates: expected, file: file, line: line)
    }
    
    private func assertStatement(_ source: Statement, inspectingBlocks: Bool = false,
                                 iteratesAs expected: [Statement], file: String = #file, line: Int = #line) {
        let iterator =
            StatementIterator(statement: source,
                              inspectBlocks: inspectingBlocks)
        
        assertIterator(iterator: iterator, iterates: expected, file: file, line: line)
    }
    
    private func assertIterator(iterator: StatementIterator,
                                iterates expected: [Statement],
                                file: String = #file, line: Int = #line) {
        let result = Array(AnyIterator(iterator))
        
        for (i, (actual, expect)) in zip(result, expected).enumerated() {
            guard actual != expect else {
                continue
            }
            
            var expString = ""
            var actString = ""
            
            dump(expect, to: &expString)
            dump(actual, to: &actString)
            
            recordFailure(withDescription: """
                Expected index \(i) of iterator to be:
                \(expString)
                but found:
                \(actString)
                """, inFile: file, atLine: line, expected: false)
            return
        }
        
        if expected.count != result.count {
            recordFailure(withDescription: """
                Mismatched result count: Expected \(expected.count) item(s) but \
                received \(result.count)
                """, inFile: file, atLine: line, expected: false)
        }
    }
}
