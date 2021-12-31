import Intentions
import SwiftAST
import SwiftSyntax
import TestCommons
import Utils
import XCTest

@testable import SwiftSyntaxSupport

class SwiftSyntaxProducer_StmtTests: BaseSwiftSyntaxProducerTests {

    func testExpressions() throws {
        let stmt = Statement.expressions([.identifier("foo"), .identifier("bar")])
        let sut = SwiftSyntaxProducer()
        let syntax = sut.generateExpressions(stmt)

        assert(
            try XCTUnwrap(syntax[0](sut)),
            matches: """
                foo
                """
        )

        assert(
            try XCTUnwrap(syntax[1](sut)),
            matches: """
                bar
                """
        )
    }

    func testExpressionsInCompound() {
        let stmt: CompoundStatement = [
            Statement.expressions([.identifier("foo"), .identifier("bar")])
        ]
        let syntax = SwiftSyntaxProducer().generateCompound(stmt)

        assert(
            syntax,
            matches: """
                 {
                    foo
                    bar
                }
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
        let sut = SwiftSyntaxProducer()
        let syntax = sut.generateVariableDeclarations(stmt)

        assert(
            try XCTUnwrap(syntax[0](sut)),
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
        let syntax = SwiftSyntaxProducer().generateCompound(stmt)

        assert(
            syntax,
            matches: """
                 {
                    var foo: Int, bar: Float = 0.0
                }
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
        let syntax = SwiftSyntaxProducer().generateCompound(stmt)

        assert(
            syntax,
            matches: """
                 {
                    var foo: Int, bar: Float = 0.0
                    let baz: Int, zaz: String
                }
                """
        )
    }

    func testContinueStatement() {
        assert(
            Statement.continue(),
            producer: SwiftSyntaxProducer.generateContinue,
            matches: """
                continue
                """
        )
    }

    func testContinueStatementWithLabel() {
        assert(
            Statement.continue(targetLabel: "label"),
            producer: SwiftSyntaxProducer.generateContinue,
            matches: """
                continue label
                """
        )
    }

    func testBreakStatement() {
        assert(
            Statement.break(),
            producer: SwiftSyntaxProducer.generateBreak,
            matches: """
                break
                """
        )
    }

    func testBreakStatementWithLabel() {
        assert(
            Statement.break(targetLabel: "label"),
            producer: SwiftSyntaxProducer.generateBreak,
            matches: """
                break label
                """
        )
    }

    func testFallthroughStatement() {
        assert(
            Statement.fallthrough,
            producer: SwiftSyntaxProducer.generateFallthrough,
            matches: """
                fallthrough
                """
        )
    }

    func testReturnStatement() {
        assert(
            Statement.return(nil),
            producer: SwiftSyntaxProducer.generateReturn,
            matches: """
                return
                """
        )
    }

    func testReturnStatementWithExpression() {
        assert(
            Statement.return(.constant(123)),
            producer: SwiftSyntaxProducer.generateReturn,
            matches: """
                return 123
                """
        )
    }

    func testIfStatement() {
        assert(
            Statement.if(.constant(true), body: []),
            producer: SwiftSyntaxProducer.generateIfStmt,
            matches: """
                if true {
                }
                """
        )
    }

    func testIfElseStatement() {
        assert(
            Statement.if(.constant(true), body: [], else: []),
            producer: SwiftSyntaxProducer.generateIfStmt,
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
                else: [
                    .if(
                        .constant(true),
                        body: [],
                        else: []
                    )
                ]
            ),
            producer: SwiftSyntaxProducer.generateIfStmt,
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
            producer: SwiftSyntaxProducer.generateIfStmt,
            matches: """
                if let value = exp {
                }
                """
        )
    }

    func testIfLetElseStatement() {
        assert(
            Statement.ifLet(.identifier("value"), .identifier("exp"), body: [], else: []),
            producer: SwiftSyntaxProducer.generateIfStmt,
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
            producer: SwiftSyntaxProducer.generateSwitchStmt,
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
            producer: SwiftSyntaxProducer.generateSwitchStmt,
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
            producer: SwiftSyntaxProducer.generateSwitchStmt,
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
            producer: SwiftSyntaxProducer.generateSwitchStmt,
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
            producer: SwiftSyntaxProducer.generateSwitchStmt,
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
                default: [
                    .break()
                ]
            )

        assert(
            stmt,
            producer: SwiftSyntaxProducer.generateSwitchStmt,
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
                default: [
                    .break()
                ]
            )

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
                default: [
                    .break()
                ]
            )

        assert(
            stmt,
            producer: SwiftSyntaxProducer.generateSwitchStmt,
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
            producer: SwiftSyntaxProducer.generateWhileStmt,
            matches: """
                while true {
                }
                """
        )
    }

    func testRepeatWhileStatement() {
        assert(
            Statement.doWhile(.constant(true), body: []),
            producer: SwiftSyntaxProducer.generateDoWhileStmt,
            matches: """
                repeat {
                } while true
                """
        )
    }

    func testForStatement() {
        assert(
            Statement.for(.identifier("test"), .identifier("array"), body: []),
            producer: SwiftSyntaxProducer.generateForIn,
            matches: """
                for test in array {
                }
                """
        )
    }

    func testDoStatement() {
        assert(
            Statement.do([]),
            producer: SwiftSyntaxProducer.generateDo,
            matches: """
                do {
                }
                """
        )
    }

    func testDeferStatement() {
        assert(
            Statement.defer([]),
            producer: SwiftSyntaxProducer.generateDefer,
            matches: """
                defer {
                }
                """
        )
    }

    func testUnknownStatement() {
        let stmt = Statement.unknown(UnknownASTContext(context: "abc"))
        let sut = SwiftSyntaxProducer()

        _=sut.generateUnknown(stmt)(sut)

        XCTAssertEqual(
            sut.extraLeading,
            .blockComment("""
                /*
                abc
                */
                """
            )
        )
    }

    func testUnknownStatementNested() {
        assert(
            Statement.do([
                .unknown(.init(context: "abc"))
            ]),
            producer: SwiftSyntaxProducer.generateDo,
            matches: """
                do {
                    /*
                    abc
                    */
                }
                """
        )
    }

    func testLabeledExpressionStatement() {
        let stmt = Statement.expression(.identifier("value")).labeled("label")
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
            matches: """
                // label:
                    value
                """
        )
    }

    func testLabeledIfStatement() {
        let stmt = Statement.if(.constant(true), body: []).labeled("label")
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
            matches: """
                label:
                    if true {
                    }
                """
        )
    }

    func testLabeledWhileStatement() {
        let stmt = Statement.while(.constant(true), body: []).labeled("label")
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
            matches: """
                label:
                    while true {
                    }
                """
        )
    }

    func testLabeledRepeatWhileStatement() {
        let stmt = Statement.doWhile(.constant(true), body: []).labeled("label")
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
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
                default: nil
            ).labeled("label")
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
            matches: """
                label:
                    switch value {
                    }
                """
        )
    }

    func testLabeledForInStatement() {
        let stmt = Statement.for(.identifier("v"), .identifier("value"), body: []).labeled("label")
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
            matches: """
                label:
                    for v in value {
                    }
                """
        )
    }

    func testLabeledDoStatement() {
        let stmt = Statement.do([]).labeled("label")
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
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
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
            matches: """
                 {
                    // A Comment
                    // Another Comment
                    value
                }
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
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
            matches: """
                 {
                    // A Comment
                    // Another Comment
                    // label:
                    value
                }
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
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
            matches: """
                 {
                    // A Comment
                    // Another Comment
                    label:
                    if value {
                    }
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
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
            matches: """
                 {
                    var value: Int // A trailing comment
                }
                """
        )
    }

    func testTrailingCommentInStatement() {
        let stmt: CompoundStatement = [
            Statement
                .if(.identifier("value"), body: [])
                .withTrailingComment("// A trailing comment")
        ]
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
            matches: """
                 {
                    if value {
                    } // A trailing comment
                }
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
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
            matches: """
                 {
                    stmt1()
                    stmt2() // A trailing comment
                }
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
        let syntaxes = SwiftSyntaxProducer().generateLocalFunction(stmt)

        assert(
            syntaxes,
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
        let syntaxes = SwiftSyntaxProducer().generateStatement(stmt)

        assert(
            syntaxes,
            matches: """
                 {
                    var b: Float = 1

                    func localFunction(a: Float) -> Float {
                        return a + b
                    }
                }
                """
        )
    }
}
