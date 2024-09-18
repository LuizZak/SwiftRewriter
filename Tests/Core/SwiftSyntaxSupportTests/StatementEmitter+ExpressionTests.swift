import Intentions
import SwiftAST
import SwiftSyntax
import TestCommons
import Utils
import XCTest

@testable import SwiftSyntaxSupport

class StatementEmitter_ExpressionTests: XCTestCase {

    func testConstantInt() {
        assert(
            Expression.constant(.int(123, .decimal)),
            matches: "123"
        )

        assert(
            Expression.constant(.int(123, .hexadecimal)),
            matches: "0x7b"
        )

        assert(
            Expression.constant(.int(123, .octal)),
            matches: "0o173"
        )

        assert(
            Expression.constant(.int(123, .binary)),
            matches: "0b1111011"
        )
    }

    func testConstantFloat() {
        assert(
            Expression.constant(.float(123.456)),
            matches: "123.456"
        )
    }

    func testConstantDouble() {
        assert(
            Expression.constant(.double(123.456)),
            matches: "123.456"
        )
    }

    func testConstantBoolean() {
        assert(
            Expression.constant(.boolean(true)),
            matches: "true"
        )
        assert(
            Expression.constant(.boolean(false)),
            matches: "false"
        )
    }

    func testConstantString() {
        assert(
            Expression.constant(.string("Hello, World!")),
            matches: #""Hello, World!""#
        )
    }

    func testConstantString_withEscapeCode() {
        assert(
            Expression.constant(.string(#"Hello,\nWorld!"#)),
            matches: #""Hello,\\nWorld!""#
        )
    }

    func testConstantNil() {
        assert(
            Expression.constant(.nil),
            matches: "nil"
        )
    }

    func testConstantRaw() {
        assert(
            Expression.constant(.rawConstant("foo")),
            matches: "foo"
        )
    }

    func testIdentifier() {
        assert(
            Expression.identifier("foo"),
            matches: "foo"
        )
    }

    func testPostfixFunctionCall() {
        assert(
            Expression.identifier("foo").call(),
            matches: "foo()"
        )

        assert(
            Expression.identifier("foo").call([.constant(1)]),
            matches: "foo(1)"
        )

        assert(
            Expression.identifier("foo").call([
                .unlabeled(.constant(1)),
                .labeled("b", .constant(2)),
            ]),
            matches: "foo(1, b: 2)"
        )
    }

    func testPostfixFunctionCallWithTrailingClosure() {
        assert(
            Expression.identifier("foo").call([.block(body: [])]),
            matches: "foo { () -> Void in\n}"
        )

        assert(
            Expression.identifier("foo").call([.constant(1), .block(body: [])]),
            matches: "foo(1) { () -> Void in\n}"
        )

        assert(
            Expression.identifier("foo").call([.block(body: []), .block(body: [])]),
            matches: """
                foo({ () -> Void in
                }, { () -> Void in
                })
                """
        )

        assert(
            Expression.identifier("foo").call([.block(body: []), .constant(1), .block(body: [])]),
            matches: """
                foo({ () -> Void in
                }, 1) { () -> Void in
                }
                """
        )
    }

    func testPostfixOptionalFunctionCall() {
        assert(
            Expression.identifier("foo").optional().call(),
            matches: "foo?()"
        )
    }

    func testPostfixForcedFunctionCall() {
        assert(
            Expression.identifier("foo").forceUnwrap().call(),
            matches: "foo!()"
        )
    }

    func testPostfixSubscript() {
        assert(
            Expression.identifier("foo").sub(.constant(1)),
            matches: "foo[1]"
        )
    }

    func testPostfixSubscriptEmptyArguments() {
        assert(
            Expression.identifier("foo").sub([]),
            matches: "foo[]"
        )
    }

    func testPostfixSubscriptMultipleArguments() {
        assert(
            Expression.identifier("foo").sub([
                FunctionArgument(label: "label", expression: .constant(1)),
                FunctionArgument(label: nil, expression: .constant(2)),
            ]),
            matches: "foo[label: 1, 2]"
        )
    }

    func testPostfixOptionalSubscript() {
        assert(
            Expression.identifier("foo").optional().sub(.constant(1)),
            matches: "foo?[1]"
        )
    }

    func testPostfixForcedSubscript() {
        assert(
            Expression.identifier("foo").forceUnwrap().sub(.constant(1)),
            matches: "foo![1]"
        )
    }

    func testPostfixMember() {
        assert(
            Expression.identifier("foo").dot("bar"),
            matches: "foo.bar"
        )
    }

    func testPostfixOptionalMember() {
        assert(
            Expression.identifier("foo").optional().dot("bar"),
            matches: "foo?.bar"
        )
    }

    func testPostfixForcedMember() {
        assert(
            Expression.identifier("foo").forceUnwrap().dot("bar"),
            matches: "foo!.bar"
        )
    }

    func testParens() {
        assert(
            Expression.parens(Expression.identifier("exp")),
            matches: "(exp)"
        )
    }

    func testArrayLiteralEmpty() {
        assert(
            Expression.arrayLiteral([]),
            matches: "[]"
        )
    }

    func testArrayLiteralOneItem() {
        assert(
            Expression.arrayLiteral([.constant(1)]),
            matches: "[1]"
        )
    }

    func testArrayLiteralMultipleItems() {
        assert(
            Expression.arrayLiteral([.constant(1), .constant(2), .constant(3)]),
            matches: "[1, 2, 3]"
        )
    }

    func testDictionaryLiteralEmpty() {
        assert(
            Expression.dictionaryLiteral([]),
            matches: "[:]"
        )
    }

    func testDictionaryLiteralOneItem() {
        assert(
            Expression.dictionaryLiteral([.constant(1): .constant(2)]),
            matches: "[1: 2]"
        )
    }

    func testDictionaryLiteralMultipleItems() {
        assert(
            Expression.dictionaryLiteral([.constant(1): .constant(2), .constant(2): .constant(4)]),
            matches: "[1: 2, 2: 4]"
        )
    }

    func testCast() {
        assert(
            Expression.identifier("foo").casted(to: .int, optional: false),
            matches: "foo as Int"
        )
    }

    func testOptionalCast() {
        assert(
            Expression.identifier("foo").casted(to: .int, optional: true),
            matches: "foo as? Int"
        )
    }

    func testCast_parenthesizesExpression() {
        assert(
            Expression.identifier("foo").binary(op: .add, rhs: .constant(1)).casted(to: .int, optional: true),
            matches: "(foo + 1) as? Int"
        )
    }

    func testTypeCheck() {
        assert(
            Expression.identifier("foo").typeCheck(as: .int),
            matches: "foo is Int"
        )
    }

    func testAssignment() {
        assert(
            Expression.identifier("foo").assignment(op: .assign, rhs: .constant(1)),
            matches: "foo = 1"
        )
    }

    func testBinary() {
        assert(
            Expression.identifier("foo").binary(op: .add, rhs: .constant(1)),
            matches: "foo + 1"
        )
    }

    func testBinary_rangeOperators() {
        assert(
            Expression.identifier("foo").binary(op: .openRange, rhs: .constant(1)),
            matches: "foo..<1"
        )
        assert(
            Expression.identifier("foo").binary(op: .closedRange, rhs: .constant(1)),
            matches: "foo...1"
        )
        // TODO: Work with operator precedence to ensure parenthesis are added when needed
        assert(
            Expression.binary(lhs: .constant(1), op: .add, rhs: .constant(1)).binary(op: .closedRange, rhs: .constant(1)),
            matches: "1 + 1...1"
        )
    }

    func testUnary() {
        assert(
            Expression.unary(op: .subtract, .identifier("foo")),
            matches: "-foo"
        )
    }

    func testPrefix() {
        assert(
            Expression.prefix(op: .subtract, .identifier("foo")),
            matches: "-foo"
        )
    }

    func testSizeOfValue() {
        assert(
            Expression.sizeof(.identifier("foo")),
            matches: "MemoryLayout.size(ofValue: foo)"
        )
    }

    func testSizeOfType() {
        assert(
            Expression.sizeof(type: .int),
            matches: "MemoryLayout<Int>.size"
        )
    }

    func testSizeOfType_inferFromResolvedType() {
        assert(
            Expression.sizeof(.identifier("Foo").typed(.metatype(for: "Foo"))),
            matches: "MemoryLayout<Foo>.size"
        )
    }

    func testTernary() {
        assert(
            Expression.ternary(
                .constant(true),
                true: .identifier("foo"),
                false: .identifier("bar")
            ),
            matches: "true ? foo : bar"
        )
    }

    func testTuple() {
        assert(
            Expression.tuple([.constant(1), .constant(2)]),
            matches: "(1, 2)"
        )
    }

    func testTupleNestedInExpression() {
        assert(
            Expression.arrayLiteral([.tuple([.constant(1), .constant(2)])]),
            matches: "[(1, 2)]"
        )
    }

    func testSelectorExpressionRootExpression() {
        assert(
            Expression.selector(FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])),
            matches: "#selector(f(_:b:))"
        )
    }

    func testSelectorExpression_functionIdentifier() {
        assert(
            Expression.selector(FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])),
            matches: "#selector(f(_:b:))"
        )
    }

    func testSelectorExpression_typeFunctionIdentifier() {
        assert(
            Expression.selector("T", FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])),
            matches: "#selector(T.f(_:b:))"
        )
    }

    func testSelectorExpression_getter() {
        assert(
            Expression.selector(getter: "p"),
            matches: "#selector(getter: p)"
        )
    }

    func testSelectorExpression_typeGetter() {
        assert(
            Expression.selector("T", getter: "p"),
            matches: "#selector(getter: T.p)"
        )
    }

    func testSelectorExpression_setter() {
        assert(
            Expression.selector(setter: "p"),
            matches: "#selector(setter: p)"
        )
    }

    func testSelectorExpression_typeSetter() {
        assert(
            Expression.selector("T", setter: "p"),
            matches: "#selector(setter: T.p)"
        )
    }

    func testClosure() {
        assert(
            Expression.block(body: []),
            matches: "{ () -> Void in\n}"
        )

        assert(
            Expression.block(body: [.expression(Expression.identifier("foo").call())]),
            matches: "{ () -> Void in\n    foo()\n}"
        )

        assert(
            Expression.block(body: [])
            .typed(expected: SwiftType.swiftBlock(returnType: .void, parameters: []))
            .typed(SwiftType.swiftBlock(returnType: .void, parameters: [])),
            matches: "{\n}"
        )
    }

    func testClosureWithParameters() {
        assert(
            Expression.block(
                parameters: [BlockParameter(name: "p1", type: .int)],
                return: .void,
                body: [
                    .expression(Expression.identifier("foo").call())
                ]
            ),
            matches: "{ (p1: Int) -> Void in\n    foo()\n}"
        )

        assert(
            Expression.block(
                parameters: [
                    BlockParameter(name: "p1", type: .int),
                    BlockParameter(name: "p2", type: .string),
                ],
                return: .void,
                body: [
                    .expression(Expression.identifier("foo").call())
                ]
            ),
            matches: "{ (p1: Int, p2: String) -> Void in\n    foo()\n}"
        )
    }

    func testClosureOmitsTypeSignatureWhenExpectedTypeAndActualTypesMatch() {
        assert(
            Expression.block(
                parameters: [],
                return: .void,
                body: [
                    .expression(Expression.identifier("foo").call())
                ]
            )
            .typed(expected: SwiftType.swiftBlock(returnType: .void, parameters: []))
            .typed(SwiftType.swiftBlock(returnType: .void, parameters: [])),
            matches: "{\n    foo()\n}"
        )

        assert(
            Expression.block(
                parameters: [
                    BlockParameter(name: "p1", type: .int)
                ],
                return: .void,
                body: [
                    .expression(Expression.identifier("foo").call())
                ]
            )
            .typed(expected: SwiftType.swiftBlock(returnType: .void, parameters: [.int]))
            .typed(SwiftType.swiftBlock(returnType: .void, parameters: [.int])),
            matches: """
                { p1 in
                    foo()
                }
                """
        )

        assert(
            Expression.block(
                parameters: [
                    BlockParameter(name: "p1", type: .int),
                    BlockParameter(name: "p2", type: .string),
                ],
                return: .void,
                body: [
                    .expression(Expression.identifier("foo").call())
                ]
            )
            .typed(expected: SwiftType.swiftBlock(returnType: .void, parameters: [.int, .string]))
            .typed(SwiftType.swiftBlock(returnType: .void, parameters: [.int, .string])),
            matches: """
                { p1, p2 in
                    foo()
                }
                """
        )
    }

    func testClosureEmitsTypeSignatureWhenExpectedTypeAndActualTypesMismatch() {
        assert(
            Expression.block(
                parameters: [],
                return: .void,
                body: [
                    .expression(Expression.identifier("foo").call())
                ]
            )
            .typed(expected: SwiftType.swiftBlock(returnType: .void, parameters: []))
            .typed(SwiftType.swiftBlock(returnType: .int, parameters: [])),
            matches: "{ () -> Void in\n    foo()\n}"
        )

        assert(
            Expression.block(
                parameters: [
                    BlockParameter(name: "p1", type: .int)
                ],
                return: .void,
                body: [
                    .expression(Expression.identifier("foo").call())
                ]
            )
            .typed(expected: SwiftType.swiftBlock(returnType: .void, parameters: []))
            .typed(SwiftType.swiftBlock(returnType: .int, parameters: [])),
            matches: "{ (p1: Int) -> Void in\n    foo()\n}"
        )
    }

    func testEmptyClosureWithBodyComments() {
        assert(
            Expression.block(body: CompoundStatement().withComments(["// A comment", "// Another comment"])),
            matches: """
            { () -> Void in
                // A comment
                // Another comment
            }
            """
        )
        assert(
            Expression.block(body: CompoundStatement().withComments(["// A comment", "// Another comment"]))
            .typed(expected: SwiftType.swiftBlock(returnType: .void, parameters: []))
            .typed(SwiftType.swiftBlock(returnType: .void, parameters: [])),
            matches: """
            {
                // A comment
                // Another comment
            }
            """
        )
    }

    func testClosure_promotesNullabilityUnspecifiedReturnToOptional() {
        assert(
            Expression.block(
                return: .nullabilityUnspecified(.string),
                body: []
            ),
            matches: "{ () -> String? in\n}"
        )
    }

    func testClosure_doesNotPromoteNullabilityUnspecifiedArgumentsToOptional() {
        assert(
            Expression.block(
                parameters: [
                    .init(name: "a", type: .nullabilityUnspecified(.string))
                ],
                body: []
            ),
            matches: "{ (a: String!) -> Void in\n}"
        )
    }

    func testSequentialBinaryExpression() {
        assert(
            Expression.constant(1).binary(op: .add, rhs: .constant(2)).binary(
                op: .add,
                rhs: .constant(3)
            ),
            matches: "1 + 2 + 3"
        )
    }

    func testTryExpression() {
        assert(
            Expression.try(.identifier("a")),
            matches: "try a"
        )
    }

    func testTryExpression_optional() {
        assert(
            Expression.try(.identifier("a"), mode: .optional),
            matches: "try? a"
        )
    }

    func testTryExpression_forced() {
        assert(
            Expression.try(.identifier("a"), mode: .forced),
            matches: "try! a"
        )
    }
}

// MARK: - Test internals
extension StatementEmitter_ExpressionTests {
    func assert<T: SwiftAST.Expression>(
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
