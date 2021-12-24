import Antlr4
import JsParser
import JsParserAntlr
import SwiftAST
import TypeSystem
import XCTest

@testable import JavaScriptFrontend

class JavaScriptExprASTReaderTests: XCTestCase {
    var tokens: CommonTokenStream!

    func testConstants() {
        assert(jsExpr: "1", readsAs: .constant(.int(1, .decimal)))
        assert(jsExpr: "1ulL", readsAs: .constant(.int(1, .decimal)))
        assert(jsExpr: "1.0e2", readsAs: .constant(.float(1e2)))
        assert(jsExpr: "1f", readsAs: .constant(.float(1)))
        assert(jsExpr: "1F", readsAs: .constant(.float(1)))
        assert(jsExpr: "1d", readsAs: .constant(.float(1)))
        assert(jsExpr: "1D", readsAs: .constant(.float(1)))
        assert(jsExpr: "true", readsAs: .constant(.boolean(true)))
        assert(jsExpr: "YES", readsAs: .constant(.boolean(true)))
        assert(jsExpr: "false", readsAs: .constant(.boolean(false)))
        assert(jsExpr: "NO", readsAs: .constant(.boolean(false)))
        assert(jsExpr: "0123", readsAs: .constant(.octal(0o123)))
        assert(jsExpr: "0x123", readsAs: .constant(.hexadecimal(0x123)))
        assert(jsExpr: "\"abc\"", readsAs: .constant(.string("abc")))
        assert(jsExpr: "123.456e+20f", readsAs: .constant(.float(123.456e+20)))
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

    func testFunctionCall() {
        assert(
            jsExpr: "print()",
            readsAs: Expression.identifier("print").call()
        )

        assert(
            jsExpr: "a.method()",
            readsAs: Expression.identifier("a").dot("method").call()
        )

        assert(
            jsExpr: "print(123, 456)",
            readsAs: Expression.identifier("print").call([
                .constant(123),
                .constant(456),
            ])
        )
    }

    func testSubscript() {
        assert(
            jsExpr: "aSubscript[1]",
            readsAs: Expression.identifier("aSubscript").sub(.constant(1))
        )
    }

    func testMemberAccess() {
        assert(jsExpr: "aValue.member", readsAs: Expression.identifier("aValue").dot("member"))
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
                            Expression.identifier("self").dot("ganttWidth"),
                            Expression.identifier("self").dot("ganttHeight"),
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

    /*
    func testBlockExpression() {
        assert(
            jsExpr: "^{ thing(); }",
            readsAs: .block(
                parameters: [],
                return: .void,
                body: [
                    .expression(Expression.identifier("thing").call())
                ]
            )
        )
        assert(
            jsExpr: "^NSString*{ return thing(); }",
            readsAs: .block(
                parameters: [],
                return: SwiftType.string.asNullabilityUnspecified,
                body: [
                    .return(Expression.identifier("thing").call())
                ]
            )
        )
        assert(
            jsExpr: "^NSString*(NSInteger inty){ return thing(); }",
            readsAs: .block(
                parameters: [BlockParameter(name: "inty", type: .int)],
                return: SwiftType.string.asNullabilityUnspecified,
                body: [
                    .return(Expression.identifier("thing").call())
                ]
            )
        )
        assert(
            jsExpr: "^(NSInteger inty){ return thing(); }",
            readsAs: .block(
                parameters: [BlockParameter(name: "inty", type: .int)],
                return: .void,
                body: [
                    .return(Expression.identifier("thing").call())
                ]
            )
        )
    }

    func testBlockMultiExpression() {
        assert(
            jsExpr: "^{ thing(); thing2(); }",
            readsAs: .block(
                parameters: [],
                return: .void,
                body: [
                    .expression(
                        Expression.identifier("thing").call()
                    ),
                    .expression(
                        Expression.identifier("thing2").call()
                    ),
                ]
            )
        )
    }
    */

    /*
    func testRangeExpression() {
        assert(
            jsExpr: "0",
            parseWith: { try $0.rangeExpression() },
            readsAs: .constant(0)
        )
        assert(
            jsExpr: "0 ... 20",
            parseWith: { try $0.rangeExpression() },
            readsAs: .binary(lhs: .constant(0), op: .closedRange, rhs: .constant(20))
        )
        assert(
            jsExpr: "ident ... 20",
            parseWith: { try $0.rangeExpression() },
            readsAs: .binary(lhs: .identifier("ident"), op: .closedRange, rhs: .constant(20))
        )
    }
    */

    func testNestedCompoundStatementInExpression() {
        assert(
            jsExpr: """
                ({ 1 + 1; })
                """,
            readsAs:
                Expression
                .block(body: [
                    .expression(Expression.constant(1).binary(op: .add, rhs: .constant(1)))
                ])
                .call()
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
}

extension JavaScriptExprASTReaderTests {

    func assert(
        jsExpr: String,
        parseWith: (JavaScriptParser) throws -> ParserRuleContext = { parser in
            try parser.singleExpression()
        },
        readsAs expected: Expression,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {

        let typeSystem = TypeSystem()

        let sut =
            JavaScriptExprASTReader(
                context: JavaScriptASTReaderContext(
                    typeSystem: typeSystem,
                    typeContext: nil,
                    comments: []
                ),
                delegate: nil
            )

        do {
            let state = try JavaScriptExprASTReaderTests._state.makeMainParser(input: jsExpr)
            tokens = state.tokens

            let expr = try parseWith(state.parser)

            let result = expr.accept(sut)

            if result != expected {
                var resStr = "nil"
                var expStr = ""

                if let result = result {
                    resStr = ""
                    dump(result, to: &resStr)
                }
                dump(expected, to: &expStr)

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

    /*
    func assert(
        objcSelector: String,
        readsAsIdentifier expected: FunctionIdentifier,
        line: UInt = #line
    ) {

        do {
            let state = try JavaScriptExprASTReaderTests._state.makeMainParser(input: objcSelector)
            tokens = state.tokens

            let expr = try state.parser.selectorName()

            let result = convertSelectorToIdentifier(expr)

            if result != expected {
                XCTFail(
                    """
                    Failed: Expected to read JavaScript selector
                    \(objcSelector)
                    as
                    \(expected)
                    but read as
                    \(result?.description ?? "<nil>")
                    """,
                    file: #file,
                    line: line
                )
            }
        }
        catch {
            XCTFail(
                "Unexpected error(s) parsing JavaScript: \(error)",
                file: #file,
                line: line
            )
        }
    }
    */

    private static var _state = JsParserState()
}
