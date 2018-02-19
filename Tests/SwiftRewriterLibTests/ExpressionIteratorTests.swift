import XCTest
import SwiftRewriterLib

class ExpressionIteratorTests: XCTestCase {
    func testAssignmentExpression() {
        assertExpression(.assignment(lhs: .identifier("a"), op: .assign, rhs: .identifier("b")),
                       iteratesAs: [
                        .assignment(lhs: .identifier("a"), op: .assign, rhs: .identifier("b")),
                        .identifier("a"),
                        .identifier("b")
            ]
        )
    }
    
    func testBinaryExpression() {
        assertExpression(.binary(lhs: .identifier("a"), op: .add, rhs: .identifier("b")),
                       iteratesAs: [
                        .binary(lhs: .identifier("a"), op: .add, rhs: .identifier("b")),
                        .identifier("a"),
                        .identifier("b")
            ]
        )
    }
    
    func testUnary() {
        assertExpression(.unary(op: .negate, .identifier("a")),
                       iteratesAs: [
                        .unary(op: .negate, .identifier("a")),
                        .identifier("a")
            ]
        )
    }
    
    func testPrefix() {
        assertExpression(.prefix(op: .negate, .identifier("a")),
                       iteratesAs: [
                        .prefix(op: .negate, .identifier("a")),
                        .identifier("a")
            ]
        )
    }
    
    func testPostfix() {
        assertExpression(.postfix(.identifier("a"), .member("a")),
                       iteratesAs: [
                        .postfix(.identifier("a"), .member("a")),
                        .identifier("a")
            ]
        )
        
        // Test iterating into subscript expressions
        assertExpression(.postfix(.identifier("a"), .subscript(.identifier("b"))),
                       iteratesAs: [
                        .postfix(.identifier("a"), .subscript(.identifier("b"))),
                        .identifier("a"),
                        .identifier("b")
            ]
        )
        
        // Test iterating into function call arguments
        assertExpression(.postfix(.identifier("a"),
                                .functionCall(arguments: [
                                    .labeled("label", .identifier("b")),
                                    .unlabeled(.identifier("c"))
                                    ])),
                       iteratesAs: [
                        .postfix(.identifier("a"),
                                 .functionCall(arguments: [
                                    .labeled("label", .identifier("b")),
                                    .unlabeled(.identifier("c"))
                                    ])),
                        .identifier("a"),
                        .identifier("b"),
                        .identifier("c")
            ]
        )
    }
    
    func testParens() {
        assertExpression(.parens(.identifier("a")),
                       iteratesAs: [
                        .parens(.identifier("a")),
                        .identifier("a")
            ]
        )
    }
    
    func testCast() {
        assertExpression(.cast(.identifier("a"), type: .typeName("B")),
                       iteratesAs: [
                        .cast(.identifier("a"), type: .typeName("B")),
                        .identifier("a")
            ]
        )
    }
    
    func testArrayLiteral() {
        assertExpression(.arrayLiteral([.identifier("a"), .identifier("b")]),
                       iteratesAs: [
                        .arrayLiteral([.identifier("a"), .identifier("b")]),
                        .identifier("a"),
                        .identifier("b")
            ]
        )
    }
    
    func testDictionaryLiteral() {
        assertExpression(.dictionaryLiteral([.init(key: .identifier("a"), value: .identifier("b")),
                                           .init(key: .identifier("c"), value: .identifier("d"))]),
                       iteratesAs: [
                        .dictionaryLiteral([.init(key: .identifier("a"), value: .identifier("b")),
                                            .init(key: .identifier("c"), value: .identifier("d"))]),
                        .identifier("a"),
                        .identifier("b"),
                        .identifier("c"),
                        .identifier("d")
            ]
        )
    }
    
    func testTernary() {
        assertExpression(.ternary(.identifier("a"), true: .identifier("b"), false: .identifier("c")),
                       iteratesAs: [
                        .ternary(.identifier("a"), true: .identifier("b"), false: .identifier("c")),
                        .identifier("a"),
                        .identifier("b"),
                        .identifier("c")
            ]
        )
    }
    
    func testBlockTraversalFalse() {
        assertExpression(.block(parameters: [],
                                return: .any,
                                body: [
                                    .expression(.identifier("a"))
                                ]),
                         iteratesAs: [
                            .block(parameters: [],
                                   return: .any,
                                   body: [
                                    .expression(.identifier("a"))
                                ])
            ]
        )
    }
    
    func testBlockTraversalTrue() {
        assertExpression(.block(parameters: [],
                                return: .any,
                                body: [
                                    .expression(.identifier("a"))
                                ]),
                         inspectingBlocks: true,
                         iteratesAs: [
                            .block(parameters: [],
                                   return: .any,
                                   body: [
                                    .expression(.identifier("a"))
                                ]),
                            .identifier("a")
            ]
        )
    }
    
    // MARK: - Statement Traversal
    
    func testIfStatement() {
        assertStatement(.if(.identifier("a"),
                            body: [.expression(.identifier("b"))],
                            else: [.expression(.identifier("c"))]),
                        iteratesAs: [
                            .identifier("a"),
                            .identifier("b"),
                            .identifier("c")
            ]
        )
    }
    
    func testWhileStatement() {
        assertStatement(.while(.identifier("a"),
                               body: [.expression(.identifier("b"))]),
                        iteratesAs: [
                            .identifier("a"),
                            .identifier("b")
            ]
        )
    }
    
    func testVariableDeclarationStatement() {
        assertStatement(.variableDeclaration(identifier: "_", type: .any,
                                             initialization: .identifier("a")),
                        iteratesAs: [
                            .identifier("a")
            ]
        )
        
        assertStatement(.variableDeclarations(
            [
                StatementVariableDeclaration(identifier: "_", type: .any,
                                             ownership: .strong,
                                             isConstant: false,
                                             initialization: .identifier("a")),
                
                StatementVariableDeclaration(identifier: "_", type: .any,
                                             ownership: .strong,
                                             isConstant: false,
                                             initialization: .identifier("b"))
            ]),
                        iteratesAs: [
                            .identifier("a"),
                            .identifier("b")
            ]
        )
    }
    
    func testSwitchStatement() {
        assertStatement(.switch(.identifier("a"), cases: [], default: nil),
                        iteratesAs: [
                            .identifier("a")
            ]
        )
        
        // Test traverse into switch case statements
        assertStatement(.switch(.identifier("a"),
                                cases: [
                                    SwitchCase(patterns: [.identifier("a")],
                                               statements: [
                                                .expression(.identifier("b")),
                                                .expression(.identifier("c"))
                                                ])
                                ],
                                default: nil),
                        iteratesAs: [
                            .identifier("a"),
                            .identifier("b"),
                            .identifier("c")
            ]
        )
        
        // Test traversing into default case
        assertStatement(.switch(.identifier("a"),
                                cases: [],
                                default: [
                                    .expression(.identifier("b")),
                                    .expression(.identifier("c"))
                                ]),
                        iteratesAs: [
                            .identifier("a"),
                            .identifier("b"),
                            .identifier("c")
            ]
        )
        
        // Test pattern expressions
        assertStatement(.switch(.identifier("a"),
                                cases: [
                                    SwitchCase(patterns: [.expression(.identifier("b"))], statements: []),
                                    SwitchCase(patterns: [
                                        .tuple([
                                            .tuple([
                                                .expression(.identifier("c")), .identifier("_d")
                                                ]),
                                            .expression(.identifier("d"))
                                            ])
                                        ], statements: [])
                                ],
                                default: nil),
                        iteratesAs: [
                            .identifier("a"),
                            .identifier("b"),
                            .identifier("c"),
                            .identifier("d")
            ]
        )
    }
    
    func testForStatement() {
        assertStatement(.for(.identifier("_a"), .identifier("a"), body: []),
                        iteratesAs: [
                            .identifier("a")
            ]
        )
        
        // Test traversing into pattern
        assertStatement(.for(.expression(.identifier("a")), .identifier("b"), body: []),
                        iteratesAs: [
                            .identifier("a"),
                            .identifier("b")
            ]
        )
        
        // Test traversing into loop's body
        assertStatement(.for(.identifier("_a"),
                             .identifier("a"),
                             body: [
                                .expression(.identifier("b")),
                                .expression(.identifier("c"))
                            ]),
                        iteratesAs: [
                            .identifier("a"),
                            .identifier("b"),
                            .identifier("c")
            ]
        )
    }
    
    func testReturnStatement() {
        assertStatement(.return(nil), iteratesAs: [])
        assertStatement(.return(.identifier("a")), iteratesAs: [.identifier("a")])
    }
    
    func testCompoundStatement() {
        assertStatement(.compound([
                            .expression(.identifier("a")),
                            .expression(.identifier("b"))
                        ]),
                        iteratesAs: [
                            .identifier("a"),
                            .identifier("b")
            ]
        )
    }
    
    func testMiscStatements() {
        assertStatement(.semicolon, iteratesAs: [])
        assertStatement(.continue, iteratesAs: [])
        assertStatement(.break, iteratesAs: [])
        assertStatement(.unknown(UnknownASTContext(context: "")), iteratesAs: [])
    }
    
    /// When visiting expressions within blocks, enqueue them such that they happen
    /// only after expressions within the depth the block was found where visited.
    /// This allows the search to occur in a more controller breadth-first manner.
    func testStatementVisitOrder() {
        assertStatement(.expressions([.identifier("a"),
                                      .block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                                      .identifier("c")
            ]),
                        inspectingBlocks: true,
                        iteratesAs: [
                            .identifier("a"),
                            .block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                            .identifier("c"),
                            .identifier("b")
            ])
        
        // Test with block inspection off, just in case.
        assertStatement(.expressions([.identifier("a"),
                                      .block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                                      .identifier("c")
            ]), iteratesAs: [
                .identifier("a"),
                .block(parameters: [], return: .void, body: [.expression(.identifier("b"))]),
                .identifier("c")
            ])
    }
    
    // MARK: -
    
    private func assertExpression(_ source: Expression, inspectingBlocks: Bool = false,
                                  iteratesAs expected: [Expression], file: String = #file, line: Int = #line) {
        let iterator =
            ExpressionIterator(expression: source,
                               inspectBlocks: inspectingBlocks)
        
        assertIterator(iterator: iterator, iterates: expected, file: file, line: line)
    }
    
    private func assertStatement(_ source: Statement, inspectingBlocks: Bool = false,
                                 iteratesAs expected: [Expression], file: String = #file, line: Int = #line) {
        let iterator =
            ExpressionIterator(statement: source,
                               inspectBlocks: inspectingBlocks)
        
        assertIterator(iterator: iterator, iterates: expected, file: file, line: line)
    }
    
    private func assertIterator(iterator: ExpressionIterator,
                                iterates expected: [Expression],
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
