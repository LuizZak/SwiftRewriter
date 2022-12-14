import SwiftAST
import XCTest

import struct SwiftAST.ValueTransformer

class ValueTransformerTests: XCTestCase {

    func testTransformExpression() {
        let transformer =
            ValueTransformer()
            .decompose()
            .transformIndex(
                index: 0,
                transformer: ValueTransformer()
                    .removingMemberAccess()
                    .validate { $0.resolvedType == .metatype(for: "UIFont") }
            )
            .asFunctionCall(labels: ["name", "size"])
        let exp =
            Expression
            .identifier("UIFont")
            .typed(.metatype(for: "UIFont"))
            .dot("fontWithSize")
            .call([
                .unlabeled(Expression.constant("Helvetica Neue")),
                .labeled("size", .constant(11)),
            ])

        let result = transformer(transform: exp)

        XCTAssertEqual(
            result,
            Expression
                .identifier("UIFont")
                .call([
                    .labeled("name", .constant("Helvetica Neue")),
                    .labeled("size", .constant(11)),
                ])
        )
    }

    func testFailTransformExpression() {
        let transformer =
            ValueTransformer<Expression, Expression>()
            .decompose()
            .transformIndex(
                index: 0,
                transformer: ValueTransformer()
                    .removingMemberAccess()
                    .validate { $0.resolvedType == .metatype(for: "UIFont") }
            )
            .asFunctionCall(labels: ["name", "size"])

        // Incorrect type (validate closure)
        XCTAssertNil(
            transformer(
                transform:
                    Expression
                    .identifier("UIFont")
                    .typed("SomeOtherType")
                    .dot("fontWithSize")
                    .call([
                        .unlabeled(Expression.constant("Helvetica Neue")),
                        .labeled("size", .constant(11)),
                        .labeled("weight", .constant("UIFontWeightBold")),
                    ])
            )
        )

        // Missing method member access
        XCTAssertNil(
            transformer.transform(
                value:
                    Expression
                    .identifier("UIFont")
                    .typed(.metatype(for: "UIFont"))
                    .call([
                        .unlabeled(Expression.constant("Helvetica Neue")),
                        .labeled("size", .constant(11)),
                    ])
            )
        )

        // Too many parameters
        XCTAssertNil(
            transformer.transform(
                value:
                    Expression
                    .identifier("UIFont")
                    .typed(.metatype(for: "UIFont"))
                    .dot("fontWithSize")
                    .call([
                        .unlabeled(Expression.constant("Helvetica Neue")),
                        .labeled("size", .constant(11)),
                        .labeled("weight", .constant("UIFontWeightBold")),
                    ])
            )
        )

        // Too few parameters
        XCTAssertNil(
            transformer.transform(
                value:
                    Expression
                    .identifier("UIFont")
                    .typed("TypeName")
                    .dot("fontWithSize")
                    .call()
            )
        )
    }

    func testValidate() {
        let transformer =
            ValueTransformer<Int, String>(keyPath: \.description)
            .validate { $0 != "2" }

        XCTAssertEqual(transformer(transform: 0), "0")
        XCTAssertEqual(transformer(transform: 1), "1")
        XCTAssertNil(transformer(transform: 2))
    }

    func testDebugTransform() {
        #sourceLocation(file:"test.swift",line:1)
        let transformer =
            ValueTransformer<Int, String>(keyPath: \.description)
        #sourceLocation()

        let printer = TestDebugPrinter()

        _ = transformer.debugTransform(value: 1, printer.print)

        XCTAssertEqual(
            printer.string(),
            """
            Invoking transformer from test.swift:2 with 1...
            Transformation succeeded with 1
            """
        )
    }

    func testDebugTransformNested() {
        #sourceLocation(file:"test.swift",line:1)
        let transformer =
            ValueTransformer<Int, String>(keyPath: \.description)
            .transforming { (value: String) -> Int in
                value.count
            }
        #sourceLocation()

        let printer = TestDebugPrinter()

        _ = transformer.debugTransform(value: 2, printer.print)

        XCTAssertEqual(
            printer.string(),
            """
            Invoking transformer from test.swift:3 with 2...
            Invoking transformer from test.swift:2 with 2...
            Transformation succeeded with 2
            Transformation succeeded with 1
            """
        )
    }

    func testDebugTransformFailedTransformation() {
        #sourceLocation(file:"test.swift",line:1)
        let transformer =
            ValueTransformer<Int, String>(keyPath: \.description)
            .validate { (value: String) -> Bool in
                return value.count > 3
            }
            .transforming { (value: String) -> Int in
                value.count
            }
        #sourceLocation()

        let printer = TestDebugPrinter()

        _ = transformer.debugTransform(value: 1, printer.print)

        XCTAssertEqual(
            printer.string(),
            """
            Invoking transformer from test.swift:6 with 1...
            Invoking transformer from test.swift:3 with 1...
            Transformation from test.swift:3 failed: Transformer returned nil
            """
        )
    }

    func testDebugTransformFailedMiddleTransformation() {
        #sourceLocation(file:"test.swift",line:1)
        let transformer =
            ValueTransformer<Int, String>(keyPath: \.description)
            .validate { (value: String) -> Bool in
                return value.count > 3
            }
            .transforming { (value: String) -> String? in
                return value == "4" ? nil : value
            }
            .transforming { (value: String) -> Int in
                value.count
            }
        #sourceLocation()

        let printer = TestDebugPrinter()

        _ = transformer.debugTransform(value: 4, printer.print)

        XCTAssertEqual(
            printer.string(),
            """
            Invoking transformer from test.swift:9 with 4...
            Invoking transformer from test.swift:6 with 4...
            Invoking transformer from test.swift:3 with 4...
            Transformation from test.swift:3 failed: Transformer returned nil
            """
        )
    }

    func testDebugTransformFailValidationResult() {
        #sourceLocation(file:"test.swift",line:1)
        let transformer =
            ValueTransformer<Int, String>(keyPath: \.description)
            .validateResult { (value: String) in
                if value.count > 3 {
                    return .success(value: value)
                }

                return .failure(message: "value.count (\(value.count)) <= 3")
            }
            .transforming { (value: String) -> Int in
                value.count
            }
        #sourceLocation()

        let printer = TestDebugPrinter()

        _ = transformer.debugTransform(value: 1, printer.print)

        XCTAssertEqual(
            printer.string(),
            """
            Invoking transformer from test.swift:10 with 1...
            Invoking transformer from test.swift:3 with 1...
            Transformation from test.swift:3 failed: Validation failed: value.count (1) <= 3
            """
        )
    }

    func testDebugTransformComplex() {
        let exp =
            Expression
            .identifier("CGRect").call([
                .labeled("x", .constant(1)),
                .labeled("y", .constant(2)),
                .labeled("width", .constant(3)),
                .labeled("height", .constant(4)),
            ])
            .dot("contains").call([
                Expression
                    .identifier("CGRect")
                    .call([
                        .labeled("x", .constant(1)),
                        .labeled("y", .constant(2)),
                        .labeled("width", .constant(3)),
                        .labeled("height", .constant(4)),
                    ])
            ])

        #sourceLocation(file:"test.swift",line:1)
        let sut = ValueTransformer<PostfixExpression, Expression>(transformer: { $0 })
            // Flatten expressions (breaks postfix expressions into sub-expressions)
            .decompose()
            .validate { $0.count == 2 }
            // Verify first expression is a member access to the type we expect
            .transformIndex(
                index: 0,
                transformer: ValueTransformer()
                    .validate(
                        matcher: ValueMatcher()
                            .keyPath(\.asPostfix, .isMemberAccess(forMember: ""))
                            .keyPath(\.resolvedType, equals: "Int")
                    )
                    .removingMemberAccess()
                    .validate(
                        matcher: ValueMatcher()
                            .isTyped(.typeName("TypeName"), ignoringNullability: true)
                    )
            )
            // Re-shape it into a binary expression
            .asBinaryExpression(operator: .add)
            .anyExpression()
        #sourceLocation()

        let printer = TestDebugPrinter()

        _ = sut.debugTransform(value: exp, printer.print)

        XCTAssertEqual(
            printer.string(),
            """
            Invoking transformer from test.swift:22 with CGRect(x: 1, y: 2, width: 3, height: 4).contains(CGRect(x: 1, y: 2, width: 3, height: 4))...
            Invoking transformer from test.swift:21 with CGRect(x: 1, y: 2, width: 3, height: 4).contains(CGRect(x: 1, y: 2, width: 3, height: 4))...
            Invoking transformer from test.swift:6 with CGRect(x: 1, y: 2, width: 3, height: 4).contains(CGRect(x: 1, y: 2, width: 3, height: 4))...
            Invoking transformer from test.swift:4 with CGRect(x: 1, y: 2, width: 3, height: 4).contains(CGRect(x: 1, y: 2, width: 3, height: 4))...
            Transformation succeeded with [CGRect(x: 1, y: 2, width: 3, height: 4).contains, CGRect(x: 1, y: 2, width: 3, height: 4)]
            Transformation from test.swift:6 failed: Failed to pass matcher at test.swift:9
            """
        )
    }

    func testDebugTransformMessageIsLazilyEvaluated() {
        var wasInvoked = false
        var message: String {
            wasInvoked = true
            return "message"
        }

        let sut =
            ValueTransformer<Int, String>(keyPath: \.description)
            .transformingResult { value -> Result<String> in
                return .failure(message: message)
            }

        _ = sut(transform: 1)

        XCTAssertFalse(wasInvoked)
    }
}

private class TestDebugPrinter {
    var output: [String] = []

    func print(_ input: @autoclosure () -> String) {
        output.append(input())
    }

    func string() -> String {
        return output.joined(separator: "\n")
    }
}
