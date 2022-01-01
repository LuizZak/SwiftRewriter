import Antlr4
import Utils
import JsParser
import JsParserAntlr
import SwiftAST
import TypeSystem
import XCTest

@testable import JavaScriptFrontend

class JavaScriptExprASTReaderTests: XCTestCase {
    var tokens: CommonTokenStream!

    func testAnonymousFunction() {
        assert(
            jsExpr: """
                function (param) {
                    return param + 10;
                }
                """,
            readsAs: .block(
                parameters: [.init(name: "param", type: .any)],
                return: SwiftType.any,
                body: [
                    .return(.identifier("param").binary(op: .add, rhs: .constant(10)))
                ]
            )
        )
    }

    func testSubscript() {
        assert(
            jsExpr: "aSubscript[1]",
            readsAs: .identifier("aSubscript").sub(.constant(1))
        )
    }

    func testMemberAccess() {
        assert(jsExpr: "aValue.member", readsAs: .identifier("aValue").dot("member"))
    }

    func testFunctionCall() {
        assert(
            jsExpr: "print()",
            readsAs: .identifier("print").call()
        )

        assert(
            jsExpr: "print(123, 456)",
            readsAs: .identifier("print").call([
                .constant(123),
                .constant(456),
            ])
        )
    }

    func testMethodCall() {
        assert(
            jsExpr: "a.method()",
            readsAs: .identifier("a").dot("method").call()
        )

        assert(
            jsExpr: "a.method(1, 2, 3)",
            readsAs:
                .identifier("a")
                .dot("method").call([
                    .unlabeled(.constant(1)),
                    .unlabeled(.constant(2)),
                    .unlabeled(.constant(3)),
                ])
        )
    }

    func testAssignmentWithMethodCall() {
        let exp =
            Expression
            .identifier("UIView")
            .dot("alloc").call()
            .dot("initWithFrame").call([
                .unlabeled(
                    Expression
                        .identifier("CGRectMake")
                        .call([
                            .constant(0),
                            .identifier("kCPDefaultTimelineRowHeight"),
                            .identifier("self").dot("ganttWidth"),
                            .identifier("self").dot("ganttHeight"),
                        ])
                )
            ])

        assert(
            jsExpr: """
                _cellContainerView =
                    UIView.alloc().initWithFrame(CGRectMake(0, kCPDefaultTimelineRowHeight, self.ganttWidth, self.ganttHeight));
                """,
            readsAs: .assignment(lhs: .identifier("_cellContainerView"), op: .assign, rhs: exp)
        )
    }

    func testBinaryOperator() {
        assert(
            jsExpr: "i + 10",
            readsAs: .binary(lhs: .identifier("i"), op: .add, rhs: .constant(10))
        )

        assert(
            jsExpr: "i - 10",
            readsAs: .binary(lhs: .identifier("i"), op: .subtract, rhs: .constant(10))
        )

        assert(
            jsExpr: "i > 10",
            readsAs: .binary(lhs: .identifier("i"), op: .greaterThan, rhs: .constant(10))
        )

        assert(
            jsExpr: "i < 10",
            readsAs: .binary(lhs: .identifier("i"), op: .lessThan, rhs: .constant(10))
        )

        assert(
            jsExpr: "i % 10",
            readsAs: .binary(lhs: .identifier("i"), op: .mod, rhs: .constant(10))
        )

        assert(
            jsExpr: "i << 10",
            readsAs: .binary(lhs: .identifier("i"), op: .bitwiseShiftLeft, rhs: .constant(10))
        )

        assert(
            jsExpr: "i >> 10",
            readsAs: .binary(lhs: .identifier("i"), op: .bitwiseShiftRight, rhs: .constant(10))
        )
    }

    func testPostfixIncrementDecrement() {
        assert(
            jsExpr: "i++",
            readsAs: .assignment(lhs: .identifier("i"), op: .addAssign, rhs: .constant(1))
        )
        assert(
            jsExpr: "i--",
            readsAs: .assignment(lhs: .identifier("i"), op: .subtractAssign, rhs: .constant(1))
        )
    }

    func testPostfixStructAccessWithAssignment() {
        let exp =
            Expression
            .identifier("self")
            .dot("_ganttEndDate")
            .assignment(
                op: .assign,
                rhs: .identifier("ganttEndDate")
            )

        assert(
            jsExpr: "self._ganttEndDate = ganttEndDate",
            readsAs: exp
        )
    }

    func testTernaryExpression() {
        assert(
            jsExpr: "value ? ifTrue : ifFalse",
            readsAs: .ternary(
                .identifier("value"),
                true: .identifier("ifTrue"),
                false: .identifier("ifFalse")
            )
        )
    }

    func testThisExpression() {
        assert(jsExpr: "this", readsAs: .identifier("self"))
        assert(jsExpr: "this.a", readsAs: .identifier("self").dot("a"))
    }

    func testLiterals() {
        assert(jsExpr: "1", readsAs: .constant(.decimal(1)))
        assert(jsExpr: "1.0e2", readsAs: .constant(.double(1e2)))
        assert(jsExpr: "1.0", readsAs: .constant(.double(1)))
        assert(jsExpr: "true", readsAs: .constant(.boolean(true)))
        assert(jsExpr: "false", readsAs: .constant(.boolean(false)))
        assert(jsExpr: "0123", readsAs: .constant(.octal(0o123)))
        assert(jsExpr: "0o123", readsAs: .constant(.octal(0o123)))
        assert(jsExpr: "0x123", readsAs: .constant(.hexadecimal(0x123)))
        assert(jsExpr: "0b1001", readsAs: .constant(.binary(0b1001)))
        assert(jsExpr: "\"abc\"", readsAs: .constant(.string("abc")))
        assert(jsExpr: "123.456e+20", readsAs: .constant(.double(123.456e+20)))
    }

    func testSuperExpression() {
        assert(jsExpr: "super", readsAs: .identifier("super"))
        assert(jsExpr: "super.a", readsAs: .identifier("super").dot("a"))
    }

    func testArrayLiteral() {
        assert(jsExpr: "[]", readsAs: .arrayLiteral([]))
        assert(jsExpr: "[\"abc\"]", readsAs: .arrayLiteral([.constant("abc")]))
        assert(
            jsExpr: "[\"abc\", 1]",
            readsAs: .arrayLiteral([.constant("abc"), .constant(1)])
        )
    }

    func testDictionaryLiteral() {
        assert(jsExpr: "{}", readsAs: .dictionaryLiteral([]))
        assert(
            jsExpr: "{1: 2}",
            readsAs: .dictionaryLiteral([
                ExpressionDictionaryPair(key: .constant(1), value: .constant(2))
            ])
        )
        assert(
            jsExpr: "{1: 2, 3: 4}",
            readsAs: .dictionaryLiteral([
                ExpressionDictionaryPair(key: .constant(1), value: .constant(2)),
                ExpressionDictionaryPair(key: .constant(3), value: .constant(4)),
            ])
        )
    }

    func testDictionaryLiteralFunction() {
        assert(
            jsExpr: """
            {
                f: function (a, b) {
                    return a + b;
                }
            }
            """,
            readsAs: .dictionaryLiteral([
                .identifier("f"): .block(
                    parameters: [.init(name: "a", type: .any), .init(name: "b", type: .any)],
                    return: .any,
                    body: [
                        .return(.identifier("a").binary(op: .add, rhs: .identifier("b")))
                    ]
                )
            ])
        )
    }

    func testObjectLiteralExpression() {
        assert(
            jsExpr: "{x: 1, y: 2}",
            readsAs: .dictionaryLiteral([
                .identifier("x"): .constant(1),
                .identifier("y"): .constant(2),
            ])
        )
    }

    func testParensExpression() {
        assert(
            jsExpr: "(1 + 2)",
            readsAs: .parens(.binary(lhs: .constant(1), op: .add, rhs: .constant(2)))
        )
    }

    func testParensExpression_tuple() {
        assert(
            jsExpr: "(1, 2, 3)",
            readsAs: .tuple([
                .constant(1),
                .constant(2),
                .constant(3),
            ])
        )
    }

    // MARK: JavaScriptObject emission

    func testDictionaryLiteral_javaScriptObject() {
        assert(
            jsExpr: """
            {
                x: 1,
                y: 2
            }
            """,
            options: .init(dictionaryLiteralKind: .javaScriptObject(typeName: "JavaScriptObject")),
            readsAs:
            .identifier("JavaScriptObject")
            .call([
                .dictionaryLiteral([
                    .init(key: .constant("x"), value: .constant(1)),
                    .init(key: .constant("y"), value: .constant(2)),
                ])
            ])
        )
    }
}

extension JavaScriptExprASTReaderTests {

    func assert(
        jsExpr: String,
        options: JavaScriptASTReaderOptions = .default,
        parseWith: (JavaScriptParser) throws -> ParserRuleContext = { parser in
            try parser.singleExpression()
        },
        readsAs expected: Expression,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let source = StringCodeSource(source: jsExpr, fileName: "test.js")
        let typeSystem = TypeSystem()

        let sut =
            JavaScriptExprASTReader(
                context: JavaScriptASTReaderContext(
                    source: source,
                    typeSystem: typeSystem,
                    typeContext: nil,
                    comments: [],
                    options: options
                ),
                delegate: nil
            )

        do {
            let state = try JavaScriptExprASTReaderTests._state.makeMainParser(input: jsExpr)
            tokens = state.tokens

            let expr = try parseWith(state.parser)

            let result = expr.accept(sut)

            if result != expected {
                var resStr: String
                var expStr: String

                if result?.description == expected.description {
                    if let result = result {
                        resStr = ""
                        dump(result, to: &resStr)
                    } else {
                        resStr = "<nil>"
                    }

                    expStr = ""
                    dump(expected, to: &expStr)
                } else {
                    resStr = result?.description ?? "<nil>"
                    expStr = expected.description
                }

                XCTFail(
                    """
                    Failed: Expected to read JavaScript expression
                    \(jsExpr)
                    as
                    \(expStr)
                    but read as
                    \(resStr)
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
