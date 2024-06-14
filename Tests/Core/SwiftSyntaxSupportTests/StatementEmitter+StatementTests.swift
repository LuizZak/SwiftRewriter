import Intentions
import SwiftAST
import SwiftSyntax
import TestCommons
import Utils
import XCTest

@testable import SwiftSyntaxSupport

class StatementEmitter_StatementTests: XCTestCase {

    func testCompoundInCompound() {
        assert(
            Statement.compound([
                .expression(.identifier("a")),
                .compound([
                    .expression(.identifier("b")),
                ]),
                .expression(.identifier("c")),
            ]),
            matches: """
                a
                b
                c
                """
        )
        assert(
            Statement.compound([
                .compound([
                    .expression(.identifier("a")),
                ]),
                .compound([
                    .expression(.identifier("b")),
                ]),
                .expression(.identifier("c")),
            ]),
            matches: """
                a
                b
                c
                """
        )
        assert(
            Statement.compound([
                .compound([
                    .compound([
                        .expression(.identifier("a")),
                    ]),
                ]),
                .compound([
                    .expression(.identifier("b")),
                ]),
                .expression(.identifier("c")),
            ]),
            matches: """
                a
                b
                c
                """
        )
    }

    func testExpressions() throws {
        let stmt = Statement.expressions([.identifier("foo"), .identifier("bar")])

        assert(
            stmt,
            matches: """
                foo
                bar
                """
        )
    }

    func testExpressionsInCompound() {
        let stmt: CompoundStatement = [
            Statement.expressions([.identifier("foo"), .identifier("bar")])
        ]

        assert(
            stmt,
            matches: """
                foo
                bar
                """
        )
    }

    func testExpressions_blockInlines() throws {
        let stmt = Statement.compound([
            .expression(
                .block(body: [
                    .expression(.identifier("a")),
                ]).call()
            ),
            .expression(.identifier("b")),
        ])

        assert(
            stmt,
            matches: """
                ({ () -> Void in
                    a
                })()
                b
                """
        )
    }

    func testVariableDeclarationsStatement() throws {
        let stmt =
            Statement
            .variableDeclarations([
                StatementVariableDeclaration(
                    identifier: "foo",
                    type: .int,
                    initialization: .constant(0)
                )
            ])

        assert(
            stmt,
            matches: """
                var foo: Int = 0
                """
        )
    }

    func testVariableDeclarationsInCompound() {
        let stmt: CompoundStatement = [
            Statement
                .variableDeclarations([
                    StatementVariableDeclaration(identifier: "foo", type: .int),
                    StatementVariableDeclaration(
                        identifier: "bar",
                        type: .float,
                        initialization: .constant(0.0)
                    ),
                ])
        ]

        assert(
            stmt,
            matches: """
                var foo: Int, bar: Float = 0.0
                """
        )
    }

    // If we have a single variable declaration statement with variables that
    // alternate between 'let' and 'var', make sure we split these declarations
    // across multiple statements, since var-decl statements cannot have both 'let'
    // and 'var' declarations in the same line
    func testSplitMixedConstantVariableDeclarationsInCompound() {
        let stmt: CompoundStatement = [
            Statement
                .variableDeclarations([
                    StatementVariableDeclaration(identifier: "foo", type: .int),
                    StatementVariableDeclaration(
                        identifier: "bar",
                        type: .float,
                        initialization: .constant(0.0)
                    ),
                    StatementVariableDeclaration(
                        identifier: "baz",
                        type: .int,
                        isConstant: true
                    ),
                    StatementVariableDeclaration(
                        identifier: "zaz",
                        type: .string,
                        isConstant: true
                    ),
                ])
        ]

        assert(
            stmt,
            matches: """
                var foo: Int, bar: Float = 0.0
                let baz: Int, zaz: String
                """
        )
    }

    func testContinueStatement() {
        assert(
            Statement.continue(),
            matches: """
                continue
                """
        )
    }

    func testContinueStatementWithLabel() {
        assert(
            Statement.continue(targetLabel: "label"),
            matches: """
                continue label
                """
        )
    }

    func testBreakStatement() {
        assert(
            Statement.break(),
            matches: """
                break
                """
        )
    }

    func testBreakStatementWithLabel() {
        assert(
            Statement.break(targetLabel: "label"),
            matches: """
                break label
                """
        )
    }

    func testFallthroughStatement() {
        assert(
            Statement.fallthrough,
            matches: """
                fallthrough
                """
        )
    }

    func testReturnStatement() {
        assert(
            Statement.return(nil),
            matches: """
                return
                """
        )
    }

    func testReturnStatementWithExpression() {
        assert(
            Statement.return(.constant(123)),
            matches: """
                return 123
                """
        )
    }

    func testIfStatement() {
        assert(
            Statement.if(.constant(true), body: []),
            matches: """
                if true {
                }
                """
        )
    }

    func testIfStatement_blockCallExpression() {
        assert(
            Statement.if(.block(body: [.return(.identifier("a"))]).call(), body: []),
            matches: """
                if ({ () -> Void in
                    return a
                })() {
                }
                """
        )
    }

    func testIfElseStatement() {
        assert(
            Statement.if(.constant(true), body: [], else: []),
            matches: """
                if true {
                } else {
                }
                """
        )
    }

    func testIfElseIfElseStatement() {
        assert(
            Statement.if(
                .constant(true),
                body: [],
                elseIf: .if(
                    .constant(true),
                    body: [],
                    else: []
                )
            ),
            matches: """
                if true {
                } else if true {
                } else {
                }
                """
        )
    }

    func testIfLetStatement() {
        assert(
            Statement.ifLet(.identifier("value"), .identifier("exp"), body: []),
            matches: """
                if let value = exp {
                }
                """
        )
    }

    func testIfLetElseStatement() {
        assert(
            Statement.ifLet(.identifier("value"), .identifier("exp"), body: [], else: []),
            matches: """
                if let value = exp {
                } else {
                }
                """
        )
    }

    func testSwitchStatementEmpty() {
        let stmt =
            Statement
            .switch(
                .identifier("value"),
                cases: [],
                default: nil
            )

        assert(
            stmt,
            matches: """
                switch value {
                }
                """
        )
    }

    func testSwitchStatementOneCase() {
        let stmt =
            Statement
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
                default: nil
            )

        assert(
            stmt,
            matches: """
                switch value {
                case 0:
                    break
                }
                """
        )
    }

    func testSwitchStatementMultiplePatterns() {
        let stmt =
            Statement
            .switch(
                .identifier("value"),
                cases: [
                    SwitchCase(
                        patterns: [
                            .expression(.constant(0)),
                            .expression(.constant(1)),
                        ],
                        statements: [
                            .break()
                        ]
                    )
                ],
                default: nil
            )

        assert(
            stmt,
            matches: """
                switch value {
                case 0, 1:
                    break
                }
                """
        )
    }

    func testSwitchStatementTuplePattern() {
        let stmt =
            Statement
            .switch(
                .identifier("value"),
                cases: [
                    SwitchCase(
                        patterns: [
                            .tuple([
                                .expression(.constant(0)),
                                .expression(.constant(1)),
                            ])
                        ],
                        statements: [
                            .break()
                        ]
                    )
                ],
                default: nil
            )

        assert(
            stmt,
            matches: """
                switch value {
                case (0, 1):
                    break
                }
                """
        )
    }

    func testSwitchStatementTwoCases() {
        let stmt =
            Statement
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
                            .expression(.constant(1))
                        ],
                        statements: [
                            .break()
                        ]
                    ),
                ],
                default: nil
            )

        assert(
            stmt,
            matches: """
                switch value {
                case 0:
                    break
                case 1:
                    break
                }
                """
        )
    }

    func testSwitchStatementDefaultOnly() {
        let stmt =
            Statement
            .switch(
                .identifier("value"),
                cases: [],
                defaultStatements: [
                    .break()
                ]
            )

        assert(
            stmt,
            matches: """
                switch value {
                default:
                    break
                }
                """
        )
    }

    func testSwitchStatementOneCaseWithDefault() {
        let stmt =
            Statement
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
                defaultStatements: [
                    .break()
                ]
            )

        assert(
            stmt,
            matches: """
                switch value {
                case 0:
                    break
                default:
                    break
                }
                """
        )
    }

    func testSwitchStatementTwoCasesWithDefault() {
        let stmt =
            Statement
            .switch(
                .identifier("value"),
                cases: [
                    SwitchCase(
                        patterns: [
                            .expression(.constant(0))
                        ],
                        statements: [
                            .expression(Expression.identifier("foo").call())
                        ]
                    ),
                    SwitchCase(
                        patterns: [
                            .expression(.constant(1))
                        ],
                        statements: [
                            .expression(Expression.identifier("foo").call()),
                            .expression(Expression.identifier("bar").call()),
                        ]
                    ),
                ],
                defaultStatements: [
                    .break()
                ]
            )

        assert(
            stmt,
            matches: """
                switch value {
                case 0:
                    foo()
                case 1:
                    foo()
                    bar()
                default:
                    break
                }
                """
        )
    }

    func testWhileStatement() {
        assert(
            Statement.while(.constant(true), body: []),
            matches: """
                while true {
                }
                """
        )
    }

    func testRepeatWhileStatement() {
        assert(
            Statement.repeatWhile(.constant(true), body: []),
            matches: """
                repeat {
                } while true
                """
        )
    }

    func testForStatement() {
        assert(
            Statement.for(.identifier("test"), .identifier("array"), body: []),
            matches: """
                for test in array {
                }
                """
        )
    }

    func testDoStatement() {
        assert(
            Statement.do([]),
            matches: """
                do {
                }
                """
        )
    }

    func testDoStatement_catchBlocks() {
        let stmt = Statement
            .do([])
            .catch([
                .expression(.identifier("a").call())
            ])
            .catch(pattern: .identifier("error"), [
                .expression(.identifier("b").call())
            ])

        assert(
            stmt,
            matches: """
                do {
                } catch {
                    a()
                } catch let error {
                    b()
                }
                """
        )
    }

    func testDeferStatement() {
        assert(
            Statement.defer([]),
            matches: """
                defer {
                }
                """
        )
    }

    func testUnknownStatement() {
        assert(
            Statement.unknown(UnknownASTContext(context: "abc")),
            matches: """
                /*
                abc
                */
                """
        )
    }

    func testUnknownStatementNested() {
        assert(
            Statement.do([.unknown(.init(context: "abc"))]),
            matches: """
                do {
                    /*
                    abc
                    */
                }
                """
        )
    }

    func testLabeledStatements_sequence() {
        let stmt = Statement.compound([
            Statement.if(.constant(true), body: []).labeled("label1"),
            Statement.while(.constant(true), body: []).labeled("label2"),
        ])

        assert(
            stmt,
            matches: """
                label1:
                if true {
                }

                label2:
                while true {
                }
                """
        )
    }

    func testLabeledExpressionStatement() {
        let stmt = Statement.expression(.identifier("value")).labeled("label")

        assert(
            stmt,
            matches: """
                // label:
                value
                """
        )
    }

    func testLabeledIfStatement() {
        let stmt = Statement.if(.constant(true), body: []).labeled("label")

        assert(
            stmt,
            matches: """
                label:
                if true {
                }
                """
        )
    }

    func testLabeledWhileStatement() {
        let stmt = Statement.while(.constant(true), body: []).labeled("label")

        assert(
            stmt,
            matches: """
                label:
                while true {
                }
                """
        )
    }

    func testLabeledRepeatWhileStatement() {
        let stmt = Statement.repeatWhile(.constant(true), body: []).labeled("label")

        assert(
            stmt,
            matches: """
                label:
                repeat {
                } while true
                """
        )
    }

    func testLabeledSwitchStatement() {
        let stmt =
            Statement
            .switch(
                .identifier("value"),
                cases: [],
                defaultStatements: nil
            ).labeled("label")

        assert(
            stmt,
            matches: """
                label:
                switch value {
                }
                """
        )
    }

    func testLabeledForInStatement() {
        let stmt = Statement.for(.identifier("v"), .identifier("value"), body: []).labeled("label")

        assert(
            stmt,
            matches: """
                label:
                for v in value {
                }
                """
        )
    }

    func testLabeledDoStatement() {
        let stmt = Statement.do([]).labeled("label")

        assert(
            stmt,
            matches: """
                label:
                do {
                }
                """
        )
    }

    func testComment() {
        let stmt: CompoundStatement = [
            Statement
                .expression(.identifier("value"))
                .withComments(["// A Comment", "// Another Comment"])
        ]

        assert(
            stmt,
            matches: """
                // A Comment
                // Another Comment
                value
                """
        )
    }

    func testCommentInCompoundStatement() {
        let stmt: CompoundStatement = []
        stmt.comments = [
            "// A comment",
            "// Another comment",
        ]

        assert(
            stmt,
            matches: """
                // A comment
                // Another comment
                """
        )
    }

    func testCommentInCompoundStatement_nonEmpty() {
        let stmt: CompoundStatement = [
            .expression(.identifier("a"))
        ]
        stmt.comments = [
            "// A comment",
            "// Another comment",
        ]

        assert(
            stmt,
            matches: """
                // A comment
                // Another comment

                a
                """
        )
    }

    func testCommentAndLabel() {
        let stmt: CompoundStatement = [
            Statement
                .expression(.identifier("value"))
                .withComments(["// A Comment", "// Another Comment"])
                .labeled("label")
        ]

        assert(
            stmt,
            matches: """
                // A Comment
                // Another Comment
                // label:
                value
                """
        )
    }

    func testCommentAndLabelInLabelableStatement() {
        let stmt: CompoundStatement = [
            Statement
                .if(.identifier("value"), body: [])
                .withComments(["// A Comment", "// Another Comment"])
                .labeled("label")
        ]

        assert(
            stmt,
            matches: """
                // A Comment
                // Another Comment
                label:
                if value {
                }
                """
        )
    }

    func testTrailingComment() {
        let stmt: CompoundStatement = [
            Statement
                .variableDeclaration(identifier: "value", type: .int, initialization: nil)
                .withTrailingComment("// A trailing comment")
        ]

        assert(
            stmt,
            matches: """
                var value: Int // A trailing comment
                """
        )
    }

    func testTrailingCommentInStatement() {
        let stmt: CompoundStatement = [
            Statement
                .if(.identifier("value"), body: [])
                .withTrailingComment("// A trailing comment")
        ]

        assert(
            stmt,
            matches: """
                if value {
                } // A trailing comment
                """
        )
    }

    func testTrailingCommentInSplitExpressionsStatement() {
        let stmt: CompoundStatement = [
            Statement
                .expressions([
                    Expression.identifier("stmt1").call(),
                    Expression.identifier("stmt2").call(),
                ])
                .withTrailingComment("// A trailing comment")
        ]

        assert(
            stmt,
            matches: """
                stmt1()
                stmt2() // A trailing comment
                """
        )
    }

    func testCommentBetweenStatements() {
        let stmt: CompoundStatement = [
            .continue(),
            .break().withComments(["// A comment"]),
            .return(nil),
        ]

        assert(
            stmt,
            matches: """
                continue

                // A comment
                break
                
                return
                """
        )
    }

    func testLocalFunction() {
        let stmt = LocalFunctionStatement(
            function: LocalFunction(
                identifier: "localFunction",
                parameters: [
                    .init(name: "a", type: .float)
                ],
                returnType: .float,
                body: [
                    .return(.identifier("a").binary(op: .add, rhs: .constant(2)))
                ]
            )
        )

        assert(
            stmt,
            matches: """
                func localFunction(a: Float) -> Float {
                    return a + 2
                }
                """
        )
    }

    func testLocalFunctionInCompoundStatement() {
        let stmt: CompoundStatement = [
            .variableDeclaration(identifier: "b", type: .float, initialization: .constant(1)),
            LocalFunctionStatement(
                function: LocalFunction(
                    identifier: "localFunction",
                    parameters: [
                        .init(name: "a", type: .float)
                    ],
                    returnType: .float,
                    body: [
                        .return(.identifier("a").binary(op: .add, rhs: .identifier("b")))
                    ]
                )
            )
        ]

        assert(
            stmt,
            matches: """
                var b: Float = 1

                func localFunction(a: Float) -> Float {
                    return a + b
                }
                """
        )
    }

    func testThrowStatement() {
        assert(
            Statement.throw(.identifier("Error")),
            matches: """
                throw Error
                """
        )
    }

    func testThrowStatementInCompoundStatement() {
        assert(
            Statement.compound([
                .throw(.identifier("Error"))
            ]),
            matches: """
                throw Error
                """
        )
    }

    func testPattern_expression() {
        let sut = makeSut()

        sut.visitPattern(.expression(.identifier("a")))

        XCTAssertEqual(sut.producer.buffer, "a")
    }

    func testPattern_tuple() {
        let sut = makeSut()

        sut.visitPattern(
            .tuple([.identifier("a"), .identifier("b")])
        )

        XCTAssertEqual(sut.producer.buffer, "(a, b)")
    }

    func testPattern_identifier() {
        let sut = makeSut()

        sut.visitPattern(.identifier("a"))

        XCTAssertEqual(sut.producer.buffer, "a")
    }

    func testPattern_asType() {
        let sut = makeSut()

        sut.visitPattern(
            .asType(.identifier("a"), .int)
        )

        XCTAssertEqual(sut.producer.buffer, "a as Int")
    }

    func testPattern_valueBindingPattern_constantFalse() {
        let sut = makeSut()

        sut.visitPattern(
            .valueBindingPattern(constant: false, .identifier("a"))
        )

        XCTAssertEqual(sut.producer.buffer, "var a")
    }

    func testPattern_valueBindingPattern_constantTrue() {
        let sut = makeSut()

        sut.visitPattern(
            .valueBindingPattern(constant: true, .identifier("a"))
        )

        XCTAssertEqual(sut.producer.buffer, "let a")
    }

    func testPattern_wildcard() {
        let sut = makeSut()

        sut.visitPattern(.wildcard)

        XCTAssertEqual(sut.producer.buffer, "_")
    }
}

// MARK: - Test internals
extension StatementEmitter_StatementTests {
    func makeSut() -> StatementEmitter {
        return StatementEmitter(producer: SwiftProducer())
    }

    func assert<T: Statement, U: SyntaxProtocol>(
        _ node: T,
        producer: (SwiftProducer) -> (Statement) -> U,
        matches expected: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        let syntax = producer(SwiftProducer())(node)

        diffTest(expected: expected, file: file, line: line + 3)
            .diff(syntax.description, file: file, line: line)
    }

    func assert<T: Statement>(
        _ node: T,
        matches expected: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        let sut = SwiftProducer()
        sut.emit(node)
        sut.buffer = sut.buffer.trimmingWhitespaceTrail()

        diffTest(expected: expected, file: file, line: line + 3)
            .diff(sut.buffer, file: file, line: line)
    }
}
