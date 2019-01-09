import XCTest
import SwiftAST

class SyntaxNodeIteratorTests: XCTestCase {
    func testAssignmentExpression() {
        assertExpression(.assignment(lhs: .identifier("a"), op: .assign, rhs: .identifier("b")),
                         iteratesAs: [
                            Expression.assignment(lhs: .identifier("a"), op: .assign, rhs: .identifier("b")),
                            Expression.identifier("a"),
                            Expression.identifier("b")
            ]
        )
    }
    
    func testBinaryExpression() {
        assertExpression(.binary(lhs: .identifier("a"), op: .add, rhs: .identifier("b")),
                         iteratesAs: [
                            Expression.binary(lhs: .identifier("a"), op: .add, rhs: .identifier("b")),
                            Expression.identifier("a"),
                            Expression.identifier("b")
            ]
        )
    }
    
    func testUnary() {
        assertExpression(.unary(op: .negate, .identifier("a")),
                         iteratesAs: [
                            Expression.unary(op: .negate, .identifier("a")),
                            Expression.identifier("a")
            ]
        )
    }
    
    func testSizeOf() {
        assertExpression(.sizeof(.identifier("a")),
                         iteratesAs: [
                            Expression.sizeof(.identifier("a")),
                            Expression.identifier("a")
            ]
        )
    }
    
    func testPrefix() {
        assertExpression(.prefix(op: .negate, .identifier("a")),
                         iteratesAs: [
                            Expression.prefix(op: .negate, .identifier("a")),
                            Expression.identifier("a")
            ]
        )
    }
    
    func testPostfix() {
        assertExpression(Expression.identifier("a").dot("a"),
                         iteratesAs: [
                            Expression.identifier("a").dot("a"),
                            Expression.identifier("a")
            ]
        )
        
        // Test iterating into subscript expressions
        assertExpression(Expression.identifier("a").sub(.identifier("b")),
                         iteratesAs: [
                            Expression.identifier("a").sub(.identifier("b")),
                            Expression.identifier("a"),
                            Expression.identifier("b")
            ]
        )
        
        // Test iterating into function call arguments
        assertExpression(Expression.identifier("a").call([
                                    .labeled("label", .identifier("b")),
                                    .unlabeled(.identifier("c"))
                                ]),
                         iteratesAs: [
                            Expression.identifier("a").call([
                                .labeled("label", .identifier("b")),
                                .unlabeled(.identifier("c"))
                            ]),
                            Expression.identifier("a"),
                            Expression.identifier("b"),
                            Expression.identifier("c")
            ]
        )
        
        assertExpression(Expression.identifier("a").optional().call([.identifier("b")]),
                         iteratesAs: [
                            Expression.identifier("a").optional().call([.identifier("b")]),
                            Expression.identifier("a"),
                            Expression.identifier("b")
            ])
    }
    
    func testParens() {
        assertExpression(.parens(.identifier("a")),
                         iteratesAs: [
                            Expression.parens(.identifier("a")),
                            Expression.identifier("a")
            ]
        )
    }
    
    func testCast() {
        assertExpression(Expression.identifier("a").casted(to: .typeName("B")),
                         iteratesAs: [
                            Expression.identifier("a").casted(to: .typeName("B")),
                            Expression.identifier("a")
            ]
        )
    }
    
    func testArrayLiteral() {
        assertExpression(.arrayLiteral([.identifier("a"), .identifier("b")]),
                         iteratesAs: [
                            Expression.arrayLiteral([.identifier("a"), .identifier("b")]),
                            Expression.identifier("a"),
                            Expression.identifier("b")
            ]
        )
    }
    
    func testDictionaryLiteral() {
        assertExpression(.dictionaryLiteral([.init(key: .identifier("a"), value: .identifier("b")),
                                             .init(key: .identifier("c"), value: .identifier("d"))]),
                         iteratesAs: [
                            Expression.dictionaryLiteral([.init(key: .identifier("a"), value: .identifier("b")),
                                                          .init(key: .identifier("c"), value: .identifier("d"))]),
                            Expression.identifier("a"),
                            Expression.identifier("b"),
                            Expression.identifier("c"),
                            Expression.identifier("d")
            ]
        )
    }
    
    func testTernary() {
        assertExpression(.ternary(.identifier("a"), true: .identifier("b"), false: .identifier("c")),
                         iteratesAs: [
                            Expression.ternary(.identifier("a"), true: .identifier("b"), false: .identifier("c")),
                            Expression.identifier("a"),
                            Expression.identifier("b"),
                            Expression.identifier("c")
            ]
        )
    }
    
    func testBlockTraversalFalse() {
        assertExpression(makeBlock(), iteratesAs: [makeBlock()])
    }
    
    func testBlockTraversalTrue() {
        assertExpression(makeBlock(),
                         inspectingBlocks: true,
                         iteratesAs: [
                            makeBlock(),
                            Statement.compound([.expression(.identifier("a"))]),
                            Statement.expression(Expression.identifier("a")),
                            Expression.identifier("a")
            ]
        )
    }
    
    func testIf() {
        assertStatement(.if(.constant(true), body: [.do([.break()])], else: [.do([.continue()])]),
                        iteratesAs: [
                            Statement.if(.constant(true), body: [.do([.break()])], else: [.do([.continue()])]),
                            Expression.constant(true),
                            Statement.compound([Statement.do([.break()])]),
                            Statement.compound([Statement.do([.continue()])]),
                            Statement.do([.break()]),
                            Statement.do([.continue()]),
                            Statement.compound([.break()]),
                            Statement.compound([.continue()]),
                            Statement.break(),
                            Statement.continue()
            ]
        )
    }
    
    func testDo() {
        assertStatement(.do([.break(), .continue()]),
                        iteratesAs: [
                            Statement.do([.break(), .continue()]),
                            Statement.compound([.break(), .continue()]),
                            Statement.break(),
                            Statement.continue()
            ]
        )
    }
    
    func testWhileStatement() {
        assertStatement(.while(.constant(true), body: [.break(), .continue()]),
                        iteratesAs: [
                            Statement.while(.constant(true), body: [.break(), .continue()]),
                            Expression.constant(true),
                            Statement.compound([
                                Statement.break(),
                                Statement.continue()
                            ]),
                            Statement.break(),
                            Statement.continue()
            ]
        )
    }
    
    /*
     For loop traversal:
     
             1          2               3
     for <pattern> in <exp> < { compound statement } >
     
     1. Loop pattern
     2. Loop expression
     3. Compound loop body
     
     And then recursively within each one, in breadth-first manner.
     */
    
    func testForStatementNotInspectingBlocks() {
        assertStatement(.for(.expression(makeBlock()), makeBlock("b"),
                             body: [.expression(.identifier("c"))]),
                        inspectingBlocks: false,
                        iteratesAs: [
                            Statement.for(.expression(makeBlock()),
                                          makeBlock("b"),
                                          body: [.expression(.identifier("c"))]),
                            // Loop pattern
                            makeBlock(),
                            
                            // Loop expression
                            makeBlock("b"),
                            
                            // Loop body
                            Statement.compound([.expression(.identifier("c"))]),
                            
                            // Loop body -> expression statement
                            Statement.expression(.identifier("c")),
                            
                            // Loop body -> expression statement -> expression
                            Expression.identifier("c")
            ]
        )
    }
    
    func testForStatementInspectingBlocks() {
        assertStatement(.for(.expression(makeBlock("a")), makeBlock("b"),
                             body: [.expression(.identifier("c"))]),
                        inspectingBlocks: true,
                        iteratesAs: [
                            Statement.for(.expression(makeBlock()),
                                          makeBlock("b"),
                                          body: [.expression(.identifier("c"))]),
                            // Loop pattern
                            makeBlock(),
                            // Loop expression
                            makeBlock("b"),
                            // Loop body
                            Statement.compound([.expression(.identifier("c"))]),
                            
                            // Loop pattern -> block
                            Statement.compound([.expression(.identifier("a"))]),
                            // Loop expression -> block
                            Statement.compound([.expression(.identifier("b"))]),
                            // Loop body -> expression statement
                            Statement.expression(.identifier("c")),
                            
                            // Loop pattern -> block -> expression statement
                            Statement.expression(.identifier("a")),
                            // Loop expression -> block -> expression statement
                            Statement.expression(.identifier("b")),
                            // Loop body -> expression statement -> expression
                            Expression.identifier("c"),
                            
                            // Loop pattern -> block -> expression statement -> expression
                            Expression.identifier("a"),
                            // Loop expression -> block -> expression statement -> expression
                            Expression.identifier("b")
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
                Statement.compound([
                    Statement.expression(.identifier("a")),
                    Statement.expression(.identifier("b"))
                    ]),
                Statement.expression(.identifier("a")),
                Statement.expression(.identifier("b")),
                Expression.identifier("a"),
                Expression.identifier("b")
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
                Statement.compound([
                    .semicolon,
                    .semicolon
                    ]),
                Statement.semicolon,
                Statement.semicolon
            ]
        )
    }
    
    /*
     Switch statement traversal:
     
              1
     switch <exp> { <cases> <default> }
                       L. case -> patterns
                   2.           |    L. pattern -> expression(s)
                   3.  L. case -> statement(s)
                   4.  L. default ->  statement(s)
     
     1. Switch expression
     2. Switch cases' patterns
     3. Switch cases' statements
     4. Switch default statements
     
     And then recursively within each one, in breadth-first manner.
     */
    
    func testSwitchNotInspectingBlocks() {
        var cases: [SwitchCase] {
            return [
                SwitchCase(patterns: [.expression(makeBlock("b"))],
                           statements: [.expression(.identifier("c"))]
                )
            ]
        }
        
        assertStatement(.switch(makeBlock(),
                                cases: cases, default: nil),
                        iteratesAs: [
                            Statement.switch(makeBlock("a"),
                                             cases: cases, default: nil),
                            // switch expression
                            makeBlock(),
                            // case 0 -> [pattern] -> block
                            makeBlock("b"),
                            // default -> statement(s)
                            Statement.expression(.identifier("c")),
                            
                            // default -> statement(s) -> expression
                            Expression.identifier("c"),
            ]
        )
    }
    
    func testSwitchInspectingBlocks() {
        var cases: [SwitchCase] {
            return [
                SwitchCase(patterns: [.expression(makeBlock("b"))],
                           statements: [.expression(.identifier("c"))]
                )
            ]
        }
        
        assertStatement(.switch(makeBlock(),
                                cases: cases,
                                default: [Statement.expression(.identifier("d"))]),
                        inspectingBlocks: true,
                        iteratesAs: [
                            Statement.switch(makeBlock("a"),
                                             cases: cases,
                                             default: [Statement.expression(.identifier("d"))]),
                            // switch expression -> block
                            makeBlock(),
                            // case 0 -> [pattern] -> block
                            makeBlock("b"),
                            // case 0 -> statement(s)
                            Statement.expression(.identifier("c")),
                            // default -> statement(s)
                            Statement.expression(.identifier("d")),
                            
                            // switch expression -> block -> compound statement
                            Statement.compound([.expression(.identifier("a"))]),
                            // case 0 -> [pattern] -> block -> compound statement
                            Statement.compound([.expression(.identifier("b"))]),
                            // case 0 -> statement(s) -> expression
                            Expression.identifier("c"),
                            // default -> statement(s) -> expression
                            Expression.identifier("d"),
                            
                            // switch expression -> block -> compound statement -> expression statement
                            Statement.expression(.identifier("a")),
                            // case 0 -> [pattern] -> block -> compound statement -> expression statement
                            Statement.expression(.identifier("b")),
                            // switch expression -> block -> compound statement -> expression statement
                            Expression.identifier("a"),
                            // case 0 -> [pattern] -> block -> compound statement -> expression statement -> expression
                            Expression.identifier("b")
            ]
        )
    }
    
    func testDefer() {
        assertStatement(.defer([.expression(.identifier("a")),
                                .expression(.identifier("b"))]),
                        iteratesAs: [
                            Statement.defer([.expression(.identifier("a")),
                                             .expression(.identifier("b"))]),
                            Statement.compound([.expression(.identifier("a")),
                                                .expression(.identifier("b"))]),
                            Statement.expression(.identifier("a")),
                            Statement.expression(.identifier("b")),
                            Expression.identifier("a"),
                            Expression.identifier("b")
            ]
        )
    }
    
    func testReturn() {
        assertStatement(.return(nil), iteratesAs: [Statement.return(nil)])
    }
    
    func testReturnInspectingBlocks() {
        assertStatement(.return(makeBlock("a")),
                        inspectingBlocks: true,
                        iteratesAs: [
                            Statement.return(makeBlock("a")),
                            makeBlock(),
                            Statement.compound([Statement.expression(.identifier("a"))]),
                            Statement.expression(.identifier("a")),
                            Expression.identifier("a")
            ])
    }
    
    func testBreak() {
        assertStatement(.break(), iteratesAs: [Statement.break()])
    }
    
    func testContinue() {
        assertStatement(.continue(), iteratesAs: [Statement.continue()])
    }
    
    func testFallthourh() {
        assertStatement(.fallthrough, iteratesAs: [Statement.fallthrough])
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
                    ]),
                makeBlock("a")
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
                            makeBlock("a"),
                            Statement.compound([.expression(.identifier("a"))]),
                            Statement.expression(.identifier("a")),
                            Expression.identifier("a")
            ])
    }
    
    func testCastExpression() {
        assertExpression(.cast(makeBlock(), type: .void),
                         inspectingBlocks: true,
                         iteratesAs: [
                            Expression.cast(makeBlock(), type: .void),
                            makeBlock(),
                            Statement.compound([.expression(.identifier("a"))]),
                            Statement.expression(.identifier("a")),
                            Expression.identifier("a")
            ])
    }
    
    func testUnaryExpression() {
        assertExpression(.unary(op: .negate, makeBlock("a")),
                         inspectingBlocks: true,
                         iteratesAs: [
                            Expression.unary(op: .negate, makeBlock("a")),
                            makeBlock(),
                            Statement.compound([.expression(.identifier("a"))]),
                            Statement.expression(.identifier("a")),
                            Expression.identifier("a")
            ])
    }
    
    func testPrefixExpression() {
        assertExpression(.prefix(op: .negate, makeBlock("a")),
                         inspectingBlocks: true,
                         iteratesAs: [
                            Expression.prefix(op: .negate, makeBlock("a")),
                            makeBlock(),
                            Statement.compound([.expression(.identifier("a"))]),
                            Statement.expression(.identifier("a")),
                            Expression.identifier("a")
            ])
    }
    
    func testPostfixSubscriptExpression() {
        assertExpression(makeBlock().sub(makeBlock("b")),
                         inspectingBlocks: true,
                         iteratesAs: [
                            makeBlock().sub(makeBlock("b")),
                            makeBlock(),
                            makeBlock("b"),
                            
                            Statement.compound([.expression(.identifier("a"))]),
                            Statement.compound([.expression(.identifier("b"))]),
                            
                            Statement.expression(.identifier("a")),
                            Statement.expression(.identifier("b")),
                            
                            Expression.identifier("a"),
                            Expression.identifier("b")
            ])
    }
    
    func testPostfixFunctionCallExpression() {
        assertExpression(makeBlock("a").call([.unlabeled(makeBlock("b"))]),
                         inspectingBlocks: true,
                         iteratesAs: [
                            makeBlock("a").call([.unlabeled(makeBlock("b"))]),
                            makeBlock(),
                            makeBlock("b"),
                            
                            Statement.compound([.expression(.identifier("a"))]),
                            Statement.compound([.expression(.identifier("b"))]),
                            
                            Statement.expression(.identifier("a")),
                            Statement.expression(.identifier("b")),
                            
                            Expression.identifier("a"),
                            Expression.identifier("b")
            ])
    }
    
    func testParensExpression() {
        assertExpression(.parens(makeBlock("a")),
                         inspectingBlocks: true,
                         iteratesAs: [
                            Expression.parens(makeBlock("a")),
                            makeBlock(),
                            Statement.compound([.expression(.identifier("a"))]),
                            Statement.expression(.identifier("a")),
                            Expression.identifier("a")
            ])
    }
    
    func testArrayLiteralExpression() {
        assertExpression(.arrayLiteral([makeBlock(), makeBlock("b")]),
                         inspectingBlocks: true,
                         iteratesAs: [
                            Expression.arrayLiteral([makeBlock(), makeBlock("b")]),
                            makeBlock(),
                            makeBlock("b"),
                            
                            Statement.compound([.expression(.identifier("a"))]),
                            Statement.compound([.expression(.identifier("b"))]),
                            
                            Statement.expression(.identifier("a")),
                            Statement.expression(.identifier("b")),
                            
                            Expression.identifier("a"),
                            Expression.identifier("b")
            ])
    }
    
    func testDictionaryLiteralExpression() {
        assertExpression(.dictionaryLiteral([
            ExpressionDictionaryPair(key: makeBlock("a"), value: makeBlock("b"))
            ]),
                         inspectingBlocks: false,
                         iteratesAs: [
                            Expression.dictionaryLiteral([
                                ExpressionDictionaryPair(key: makeBlock(), value: makeBlock("b"))
                                ]),
                            makeBlock(),
                            makeBlock("b")
            ])
        
        assertExpression(.dictionaryLiteral([
            ExpressionDictionaryPair(key: makeBlock(), value: makeBlock("b"))
            ]),
                         inspectingBlocks: true,
                         iteratesAs: [
                            Expression.dictionaryLiteral([
                                ExpressionDictionaryPair(key: makeBlock(), value: makeBlock("b"))
                                ]),
                            
                            makeBlock(),
                            makeBlock("b"),
                            
                            Statement.compound([.expression(.identifier("a"))]),
                            Statement.compound([.expression(.identifier("b"))]),
                            
                            Statement.expression(.identifier("a")),
                            Statement.expression(.identifier("b")),
                            
                            Expression.identifier("a"),
                            Expression.identifier("b")
            ])
    }
    
    func testTernaryExpression() {
        assertExpression(.ternary(makeBlock("a"),
                                  true: makeBlock("b"),
                                  false: makeBlock("c")),
                         inspectingBlocks: true,
                         iteratesAs: [
                            Expression.ternary(makeBlock("a"),
                                               true: makeBlock("b"),
                                               false: makeBlock("c")),
                            
                            makeBlock(),
                            makeBlock("b"),
                            makeBlock("c"),
                            
                            Statement.compound([.expression(.identifier("a"))]),
                            Statement.compound([.expression(.identifier("b"))]),
                            Statement.compound([.expression(.identifier("c"))]),
                            
                            Statement.expression(.identifier("a")),
                            Statement.expression(.identifier("b")),
                            Statement.expression(.identifier("c")),
                            
                            Expression.identifier("a"),
                            Expression.identifier("b"),
                            Expression.identifier("c")
            ])
    }
    
    /// When visiting expressions within blocks, enqueue them such that they happen
    /// only after expressions within the depth the block was found where visited.
    /// This allows the search to occur in a more controller breadth-first manner.
    func testStatementVisitOrder() {
        assertStatement(.expressions([.identifier("a"),
                                      .block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                                      .identifier("c")]),
                        inspectingBlocks: true,
                        iteratesAs: [
                            Statement.expressions([.identifier("a"),
                                                   .block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                                                   .identifier("c")]),
                            Expression.identifier("a"),
                            Expression.block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                            Expression.identifier("c"),
                            Statement.compound([.expression(.identifier("b"))]),
                            Statement.expression(.identifier("b")),
                            Expression.identifier("b")
            ])
        
        // Test with block inspection off, just in case.
        assertStatement(.expressions([.identifier("a"),
                                      .block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                                      .identifier("c")]),
                        inspectingBlocks: false,
                        iteratesAs: [
                            Statement.expressions([.identifier("a"),
                                                   .block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                                                   .identifier("c")]),
                            Expression.identifier("a"),
                            Expression.block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                            Expression.identifier("c")
            ])
    }
}

extension SyntaxNodeIteratorTests {
    /// Creates a test block which contains only a single statement containing an
    /// `Expression.identifier()` case with a given input value as the identifier.
    ///
    /// Used in tests to generate an expression that contains statements, to test
    /// iterating statements through expressions.
    private func makeBlock(_ identifier: String = "a") -> Expression {
        return .block(parameters: [],
                      return: .void,
                      body: [.expression(.identifier(identifier))])
    }
    
    private func assertExpression(_ source: Expression, inspectingBlocks: Bool = false,
                                  iteratesAs expected: [SyntaxNode], file: String = #file, line: Int = #line) {
        let iterator =
            SyntaxNodeIterator(expression: source,
                               inspectBlocks: inspectingBlocks)
        
        assertIterator(iterator: iterator, iterates: expected, file: file, line: line)
    }
    
    private func assertStatement(_ source: Statement, inspectingBlocks: Bool = false,
                                 iteratesAs expected: [SyntaxNode], file: String = #file, line: Int = #line) {
        let iterator =
            SyntaxNodeIterator(statement: source,
                               inspectBlocks: inspectingBlocks)
        
        assertIterator(iterator: iterator, iterates: expected, file: file, line: line)
    }
    
    private func assertIterator(iterator: SyntaxNodeIterator,
                                iterates expected: [SyntaxNode],
                                file: String = #file, line: Int = #line) {
        let result = Array(AnyIterator(iterator))
        
        for (i, (actual, expect)) in zip(result, expected).enumerated() {
            switch (expect, actual) {
            case (let lhs as Statement, let rhs as Statement):
                if lhs == rhs {
                    continue
                }
            case (let lhs as Expression, let rhs as Expression):
                if lhs == rhs {
                    continue
                }
            default:
                recordFailure(withDescription: """
                    Items at index \(i) of type \(type(of: expect)) and \(type(of: actual)) \
                    cannot be compared.
                    """, inFile: file, atLine: line, expected: true)
                break
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
                """, inFile: file, atLine: line, expected: true)
            return
        }
        
        if expected.count != result.count {
            recordFailure(withDescription: """
                Mismatched result count: Expected \(expected.count) item(s) but \
                received \(result.count)
                """, inFile: file, atLine: line, expected: true)
        }
    }
}
