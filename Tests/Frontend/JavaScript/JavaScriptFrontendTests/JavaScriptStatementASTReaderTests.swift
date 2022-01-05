import XCTest
import Antlr4
import Utils
import JsParser
import TypeSystem
import JsParserAntlr
import SwiftAST
import SwiftSyntaxSupport

@testable import JavaScriptFrontend

class JavaScriptStatementASTReaderTests: XCTestCase {
    var tokens: CommonTokenStream!
    
    func testBlockStatement() {
        assert(
            jsStmt: """
            { }
            """,
            readsAs: CompoundStatement()
        )
    }

    func testVariableStatement() {
        // var
        assert(
            jsStmt: """
            var a;
            """,
            readsAs: .variableDeclarations([
                .init(identifier: "a", storage: .variable(ofType: .any), initialization: nil),
            ])
        )
        // let
        assert(
            jsStmt: """
            let a;
            """,
            readsAs: .variableDeclarations([
                .init(identifier: "a", storage: .variable(ofType: .any), initialization: nil)
            ])
        )
        // const
        assert(
            jsStmt: """
            const a;
            """,
            readsAs: .variableDeclarations([
                .init(identifier: "a", storage: .constant(ofType: .any), initialization: nil)
            ])
        )
        // Multi-declaration statement
        assert(
            jsStmt: """
            var a = 0, b = 1, c;
            """,
            readsAs: .variableDeclarations([
                .init(identifier: "a", storage: .variable(ofType: .any), initialization: .constant(0)),
                .init(identifier: "b", storage: .variable(ofType: .any), initialization: .constant(1)),
                .init(identifier: "c", storage: .variable(ofType: .any), initialization: nil)
            ])
        )
    }

    func testExpressionStatement() {
        assert(
            jsStmt: """
            true;
            """,
            readsAs: .expression(
                .constant(true)
            )
        )
        assert(
            jsStmt: """
            true, 1;
            """,
            readsAs: .expression(
                .tuple([.constant(true), .constant(1)])
            )
        )
    }

    func testIfStatement() {
        assert(
            jsStmt: """
            if (a) {
                true;
            }
            """,
            readsAs: .if(
                .identifier("a"),
                body: [
                    .expression(.constant(true))
                ],
                else: nil
            )
        )
    }

    func testDoStatement() {
        assert(
            jsStmt: """
            do {
                false;
            } while (true)
            """,
            readsAs: .doWhile(
                .constant(true),
                body: [
                    .expression(.constant(false))
                ]
            )
        )
    }

    func testWhileStatement() {
        assert(
            jsStmt: """
            while (true) {
                false;
            }
            """,
            readsAs: .while(
                .constant(true),
                body: [
                    .expression(.constant(false))
                ]
            )
        )
    }

    func testForStatement() {
        assert(
            jsStmt: """
            for (var i = 0; i < 10; i++) {

            }
            """,
            readsAs: .compound([
                .variableDeclaration(identifier: "i", type: .any, initialization: .constant(0)),
                .while(
                    .identifier("i").binary(op: .lessThan, rhs: .constant(10)),
                    body: [
                        .defer([
                            .expression(.identifier("i").assignment(op: .addAssign, rhs: .constant(1)))
                        ])
                    ]
                )
            ])
        )
    }

    func testForStatement_expressionInitializer() {
        assert(
            jsStmt: """
            for (i = 0; i < 10; i++) {
                true;
            }
            """,
            readsAs: .compound([
                .expression(.identifier("i").assignment(op: .assign, rhs: .constant(0))),
                .while(
                    .identifier("i").binary(op: .lessThan, rhs: .constant(10)),
                    body: [
                        .defer([
                            .expression(.identifier("i").assignment(op: .addAssign, rhs: .constant(1)))
                        ]),
                        .expression(.constant(true))
                    ]
                )
            ])
        )
    }

    func testForOfStatement() {
        assert(
            jsStmt: """
            for (i of exp) {
                true;
            }
            """,
            readsAs: .for(
                .identifier("i"),
                .identifier("exp"),
                body: [
                    .expression(.constant(true))
                ]
            )
        )
    }

    func testForOfStatement_variableDeclarationInitializer() {
        assert(
            jsStmt: """
            for (var i of exp) {
                true;
            }
            """,
            readsAs: .for(
                .identifier("i"),
                .identifier("exp"),
                body: [
                    .expression(.constant(true))
                ]
            )
        )
    }

    func testContinueStatement() {
        assert(
            jsStmt: """
            continue;
            """,
            readsAs: .continue()
        )
    }

    func testContinueStatement_labeled() {
        assert(
            jsStmt: """
            continue label;
            """,
            readsAs: .continue(targetLabel: "label")
        )
    }

    func testBreakStatement() {
        assert(
            jsStmt: """
            break;
            """,
            readsAs: .break()
        )
    }

    func testBreakStatement_labeled() {
        assert(
            jsStmt: """
            break label;
            """,
            readsAs: .break(targetLabel: "label")
        )
    }

    func testReturnStatement() {
        assert(
            jsStmt: """
            return;
            """,
            readsAs: .return(nil)
        )
        assert(
            jsStmt: """
            return exp;
            """,
            readsAs: .return(.identifier("exp"))
        )
    }

    func testLabeledStatement() {
        assert(
            jsStmt: """
            label: true;
            """,
            readsAs: .expression(.constant(true)).labeled("label")
        )
        assert(
            jsStmt: """
            label: if (true) {
            }
            """,
            readsAs: .if(.constant(true), body: []).labeled("label")
        )
    }

    func testSwitchStatement_empty() {
        assert(
            jsStmt: """
            switch (value) {
            }
            """,
            readsAs: .switch(
                .identifier("value"),
                cases: [],
                default: [
                    .break()
                ]
            )
        )
    }

    func testSwitchStatement_singleCase_empty() {
        assert(
            jsStmt: """
            switch (value) {
            case 10:
            }
            """,
            readsAs: .switch(
                .identifier("value"),
                cases: [
                    .init(
                        patterns: [.expression(.constant(10))],
                        statements: [
                            .fallthrough
                        ]
                    )
                ],
                default: [
                    .break()
                ]
            )
        )
    }

    func testSwitchStatement_mergeEmptyCases() {
        assert(
            jsStmt: """
            switch (value) {
            case 10:
            case 20:
                break
            }
            """,
            readsAs: .switch(
                .identifier("value"),
                cases: [
                    .init(
                        patterns: [.expression(.constant(10)), .expression(.constant(20))],
                        statements: [
                            .break()
                        ]
                    )
                ],
                default: [
                    .break()
                ]
            )
        )
    }

    func testSwitchStatement_mergeEmptyCases_fallthroughOnFinalEmptyCase() {
        assert(
            jsStmt: """
            switch (value) {
            case 10:
            case 20:
            }
            """,
            readsAs: .switch(
                .identifier("value"),
                cases: [
                    .init(
                        patterns: [.expression(.constant(10)), .expression(.constant(20))],
                        statements: [
                            .fallthrough
                        ]
                    )
                ],
                default: [
                    .break()
                ]
            )
        )
    }

    func testSwitch() {
        assert(
            jsStmt: "switch(value) { case 0: break; }",
            readsAs: .switch(
                .identifier("value"),
                cases: [SwitchCase(patterns: [.expression(.constant(0))], statements: [.break()])],
                default: [.break()]
            )
        )

        assert(
            jsStmt: "switch(value) { case 0: break; case 1: break; }",
            readsAs: .switch(
                .identifier("value"),
                cases: [
                    SwitchCase(patterns: [.expression(.constant(0))], statements: [.break()]),
                    SwitchCase(patterns: [.expression(.constant(1))], statements: [.break()]),
                ],
                default: [.break()]
            )
        )

        assert(
            jsStmt: "switch(value) { case 0: case 1: break; }",
            readsAs: .switch(
                .identifier("value"),
                cases: [
                    SwitchCase(
                        patterns: [.expression(.constant(0)), .expression(.constant(1))],
                        statements: [.break()]
                    )
                ],
                default: [.break()]
            )
        )

        assert(
            jsStmt: "switch(value) { case 0: case 1: break; default: stmt(); }",
            readsAs: .switch(
                .identifier("value"),
                cases: [
                    SwitchCase(
                        patterns: [
                            .expression(.constant(0)),
                            .expression(.constant(1)),
                        ],
                        statements: [.break()]
                    )
                ],
                default: [
                    .expression(
                        Expression.identifier("stmt").call()
                    )
                ]
            )
        )
    }

    func testAutomaticSwitchFallthrough() {
        assert(
            jsStmt: "switch(value) { case 0: stmt(); case 1: break; }",
            readsAs: .switch(
                .identifier("value"),
                cases: [
                    SwitchCase(
                        patterns: [.expression(.constant(0))],
                        statements: [
                            .expression(Expression.identifier("stmt").call()),
                            .fallthrough,
                        ]
                    ),
                    SwitchCase(patterns: [.expression(.constant(1))], statements: [.break()]),
                ],
                default: [.break()]
            )
        )
    }

    func testLocalFunctionStatement() {
        assert(
            jsStmt: """
            function f(a, b) {
                return 0;
            }
            """,
            readsAs: .localFunction(
                identifier: "f",
                parameters: [
                    .init(label: nil, name: "a", type: .any),
                    .init(label: nil, name: "b", type: .any),
                ],
                returnType: .any,
                body: [
                    .return(.constant(0))
                ]
            )
        )
    }

    func testThrowStatement() {
        assert(
            jsStmt: """
            throw new Error();
            """,
            readsAs: .throw(.identifier("Error").call())
        )
    }
}

extension JavaScriptStatementASTReaderTests {

    func assert(
        jsStmt: String,
        options: JavaScriptASTReaderOptions = .default,
        parseWith: (JavaScriptParser) throws -> ParserRuleContext = { parser in
            try parser.statement()
        },
        readsAs expected: Statement,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let source = StringCodeSource(source: jsStmt, fileName: "test.js")
        let typeSystem = TypeSystem()

        let context = JavaScriptASTReaderContext(
            source: source,
            typeSystem: typeSystem,
            typeContext: nil,
            comments: [],
            options: options
        )

        let expReader = JavaScriptExprASTReader(
            context: context,
            delegate: nil
        )

        let sut =
            JavaScriptStatementASTReader(
                expressionReader: expReader,
                context: context,
                delegate: nil
            )

        do {
            let state = try JavaScriptStatementASTReaderTests._state.makeMainParser(input: jsStmt)
            tokens = state.tokens

            let expr = try parseWith(state.parser)

            let result = expr.accept(sut)

            if result != expected {
                var expString = ""
                var resString = ""

                let producer = SwiftSyntaxProducer()

                expString = producer.generateStatement(expected).description + "\n"
                resString = (result.map(producer.generateStatement)?.description ?? "") + "\n"

                XCTFail(
                    """
                    Failed: Expected to read JavaScript statement
                    \(jsStmt)
                    as

                    \(expString)

                    but read as

                    \(resString)

                    """,
                    file: file,
                    line: line
                )
            }
        }
        catch {
            XCTFail(
                "Unexpected error(s) parsing JavaScript: \(error)",
                file: file,
                line: line
            )
        }
    }

    private static var _state = JsParserState()
}

