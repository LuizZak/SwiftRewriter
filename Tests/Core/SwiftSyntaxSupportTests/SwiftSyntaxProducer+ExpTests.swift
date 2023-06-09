import Intentions
import SwiftAST
import SwiftSyntax
import TestCommons
import Utils
import XCTest

@testable import SwiftSyntaxSupport

class SwiftSyntaxProducer_ExpTests: BaseSwiftSyntaxProducerTests {

    func testConstantInt() {
        assert(
            Expression.constant(.int(123, .decimal)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "123"
        )

        assert(
            Expression.constant(.int(123, .hexadecimal)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "0x7b"
        )

        assert(
            Expression.constant(.int(123, .octal)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "0o173"
        )

        assert(
            Expression.constant(.int(123, .binary)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "0b1111011"
        )
    }

    func testConstantFloat() {
        assert(
            Expression.constant(.float(123.456)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "123.456"
        )
    }

    func testConstantDouble() {
        assert(
            Expression.constant(.double(123.456)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "123.456"
        )
    }

    func testConstantBoolean() {
        assert(
            Expression.constant(.boolean(true)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "true"
        )
        assert(
            Expression.constant(.boolean(false)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "false"
        )
    }

    func testConstantString() {
        assert(
            Expression.constant(.string("Hello, World!")),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "\"Hello, World!\""
        )
    }

    func testConstantString_withEscapeCode() {
        assert(
            Expression.constant(.string("Hello,\\nWorld!")),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "\"Hello,\\nWorld!\""
        )
    }

    func testConstantNil() {
        assert(
            Expression.constant(.nil),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "nil"
        )
    }

    func testConstantRaw() {
        assert(
            Expression.constant(.rawConstant("foo")),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "foo"
        )
    }

    func testIdentifier() {
        assert(
            Expression.identifier("foo"),
            producer: SwiftSyntaxProducer.generateIdentifier,
            matches: "foo"
        )
    }

    func testPostfixFunctionCall() {
        assert(
            Expression.identifier("foo").call(),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo()"
        )

        assert(
            Expression.identifier("foo").call([.constant(1)]),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo(1)"
        )

        assert(
            Expression.identifier("foo").call([
                .unlabeled(.constant(1)),
                .labeled("b", .constant(2)),
            ]),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo(1, b: 2)"
        )
    }

    func testPostfixFunctionCallWithTrailingClosure() {
        assert(
            Expression.identifier("foo").call([.block(body: [])]),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo { () -> Void in\n}"
        )

        assert(
            Expression.identifier("foo").call([.constant(1), .block(body: [])]),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo(1) { () -> Void in\n}"
        )

        assert(
            Expression.identifier("foo").call([.block(body: []), .block(body: [])]),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: """
                foo({ () -> Void in
                }, { () -> Void in
                })
                """
        )

        assert(
            Expression.identifier("foo").call([.block(body: []), .constant(1), .block(body: [])]),
            producer: SwiftSyntaxProducer.generatePostfix,
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
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo?()"
        )
    }

    func testPostfixForcedFunctionCall() {
        assert(
            Expression.identifier("foo").forceUnwrap().call(),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo!()"
        )
    }

    func testPostfixSubscript() {
        assert(
            Expression.identifier("foo").sub(.constant(1)),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo[1]"
        )
    }

    func testPostfixSubscriptEmptyArguments() {
        assert(
            Expression.identifier("foo").sub([]),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo[]"
        )
    }

    func testPostfixSubscriptMultipleArguments() {
        assert(
            Expression.identifier("foo").sub([
                FunctionArgument(label: "label", expression: .constant(1)),
                FunctionArgument(label: nil, expression: .constant(2)),
            ]),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo[label: 1, 2]"
        )
    }

    func testPostfixOptionalSubscript() {
        assert(
            Expression.identifier("foo").optional().sub(.constant(1)),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo?[1]"
        )
    }

    func testPostfixForcedSubscript() {
        assert(
            Expression.identifier("foo").forceUnwrap().sub(.constant(1)),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo![1]"
        )
    }

    func testPostfixMember() {
        assert(
            Expression.identifier("foo").dot("bar"),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo.bar"
        )
    }

    func testPostfixOptionalMember() {
        assert(
            Expression.identifier("foo").optional().dot("bar"),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo?.bar"
        )
    }

    func testPostfixForcedMember() {
        assert(
            Expression.identifier("foo").forceUnwrap().dot("bar"),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo!.bar"
        )
    }

    func testParens() {
        assert(
            Expression.parens(Expression.identifier("exp")),
            producer: SwiftSyntaxProducer.generateParens,
            matches: "(exp)"
        )
    }

    func testArrayLiteralEmpty() {
        assert(
            Expression.arrayLiteral([]),
            producer: SwiftSyntaxProducer.generateArrayLiteral,
            matches: "[]"
        )
    }

    func testArrayLiteralOneItem() {
        assert(
            Expression.arrayLiteral([.constant(1)]),
            producer: SwiftSyntaxProducer.generateArrayLiteral,
            matches: "[1]"
        )
    }

    func testArrayLiteralMultipleItems() {
        assert(
            Expression.arrayLiteral([.constant(1), .constant(2), .constant(3)]),
            producer: SwiftSyntaxProducer.generateArrayLiteral,
            matches: "[1, 2, 3]"
        )
    }

    func testDictionaryLiteralEmpty() {
        assert(
            Expression.dictionaryLiteral([]),
            producer: SwiftSyntaxProducer.generateDictionaryLiteral,
            matches: "[:]"
        )
    }

    func testDictionaryLiteralOneItem() {
        assert(
            Expression.dictionaryLiteral([.constant(1): .constant(2)]),
            producer: SwiftSyntaxProducer.generateDictionaryLiteral,
            matches: "[1: 2]"
        )
    }

    func testDictionaryLiteralMultipleItems() {
        assert(
            Expression.dictionaryLiteral([.constant(1): .constant(2), .constant(2): .constant(4)]),
            producer: SwiftSyntaxProducer.generateDictionaryLiteral,
            matches: "[1: 2, 2: 4]"
        )
    }

    func testCast() {
        assert(
            Expression.identifier("foo").casted(to: .int, optional: false),
            producer: SwiftSyntaxProducer.generateCast,
            matches: "foo as Int"
        )
    }

    func testOptionalCast() {
        assert(
            Expression.identifier("foo").casted(to: .int, optional: true),
            producer: SwiftSyntaxProducer.generateCast,
            matches: "foo as? Int"
        )
    }

    func testCast_parenthesizesExpression() {
        assert(
            Expression.identifier("foo").binary(op: .add, rhs: .constant(1)).casted(to: .int, optional: true),
            producer: SwiftSyntaxProducer.generateCast,
            matches: "(foo + 1) as? Int"
        )
    }

    func testTypeCheck() {
        assert(
            Expression.identifier("foo").typeCheck(as: .int),
            producer: SwiftSyntaxProducer.generateTypeCheck,
            matches: "foo is Int"
        )
    }

    func testAssignment() {
        assert(
            Expression.identifier("foo").assignment(op: .assign, rhs: .constant(1)),
            producer: SwiftSyntaxProducer.generateAssignment,
            matches: "foo = 1"
        )
    }

    func testBinary() {
        assert(
            Expression.identifier("foo").binary(op: .add, rhs: .constant(1)),
            producer: SwiftSyntaxProducer.generateBinary,
            matches: "foo + 1"
        )
    }

    func testUnary() {
        assert(
            Expression.unary(op: .subtract, .identifier("foo")),
            producer: SwiftSyntaxProducer.generateUnary,
            matches: "-foo"
        )
    }

    func testPrefix() {
        assert(
            Expression.prefix(op: .subtract, .identifier("foo")),
            producer: SwiftSyntaxProducer.generatePrefix,
            matches: "-foo"
        )
    }

    func testSizeOfValue() {
        assert(
            Expression.sizeof(.identifier("foo")),
            producer: SwiftSyntaxProducer.generateSizeOf,
            matches: "MemoryLayout.size(ofValue: foo)"
        )
    }

    func testSizeOfType() {
        assert(
            Expression.sizeof(type: .int),
            producer: SwiftSyntaxProducer.generateSizeOf,
            matches: "MemoryLayout<Int>.size"
        )
    }

    func testTernary() {
        assert(
            Expression.ternary(
                .constant(true),
                true: .identifier("foo"),
                false: .identifier("bar")
            ),
            producer: SwiftSyntaxProducer.generateTernary,
            matches: "true ? foo : bar"
        )
    }

    func testTuple() {
        assert(
            Expression.tuple([.constant(1), .constant(2)]),
            producer: SwiftSyntaxProducer.generateTuple,
            matches: "(1, 2)"
        )
    }

    func testTupleNestedInExpression() {
        assert(
            Expression.arrayLiteral([.tuple([.constant(1), .constant(2)])]),
            producer: SwiftSyntaxProducer.generateArrayLiteral,
            matches: "[(1, 2)]"
        )
    }

    func testSelectorExpressionRootExpression() {
        assert(
            Expression.selector(FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])),
            producer: SwiftSyntaxProducer.generateExpression,
            matches: "#selector(f(_:b:))"
        )
    }

    func testSelectorExpression_functionIdentifier() {
        assert(
            Expression.selector(FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])),
            producer: SwiftSyntaxProducer.generateSelector,
            matches: "#selector(f(_:b:))"
        )
    }

    func testSelectorExpression_typeFunctionIdentifier() {
        assert(
            Expression.selector("T", FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])),
            producer: SwiftSyntaxProducer.generateSelector,
            matches: "#selector(T.f(_:b:))"
        )
    }

    func testSelectorExpression_getter() {
        assert(
            Expression.selector(getter: "p"),
            producer: SwiftSyntaxProducer.generateSelector,
            matches: "#selector(getter: p)"
        )
    }

    func testSelectorExpression_typeGetter() {
        assert(
            Expression.selector("T", getter: "p"),
            producer: SwiftSyntaxProducer.generateSelector,
            matches: "#selector(getter: T.p)"
        )
    }

    func testSelectorExpression_setter() {
        assert(
            Expression.selector(setter: "p"),
            producer: SwiftSyntaxProducer.generateSelector,
            matches: "#selector(setter: p)"
        )
    }

    func testSelectorExpression_typeSetter() {
        assert(
            Expression.selector("T", setter: "p"),
            producer: SwiftSyntaxProducer.generateSelector,
            matches: "#selector(setter: T.p)"
        )
    }

    func testClosure() {
        assert(
            Expression.block(body: []),
            producer: SwiftSyntaxProducer.generateClosure,
            matches: "{ () -> Void in\n}"
        )

        assert(
            Expression.block(body: [.expression(Expression.identifier("foo").call())]),
            producer: SwiftSyntaxProducer.generateClosure,
            matches: "{ () -> Void in\n    foo()\n}"
        )

        assert(
            Expression.block(body: [])
            .typed(expected: SwiftType.swiftBlock(returnType: .void, parameters: []))
            .typed(SwiftType.swiftBlock(returnType: .void, parameters: [])),
            producer: SwiftSyntaxProducer.generateClosure,
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
            producer: SwiftSyntaxProducer.generateClosure,
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
            producer: SwiftSyntaxProducer.generateClosure,
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
            producer: SwiftSyntaxProducer.generateClosure,
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
            producer: SwiftSyntaxProducer.generateClosure,
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
            producer: SwiftSyntaxProducer.generateClosure,
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
            producer: SwiftSyntaxProducer.generateClosure,
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
            producer: SwiftSyntaxProducer.generateClosure,
            matches: "{ (p1: Int) -> Void in\n    foo()\n}"
        )
    }

    func testEmptyClosureWithBodyComments() {
        assert(
            Expression.block(body: CompoundStatement().withComments(["// A comment", "// Another comment"])),
            producer: SwiftSyntaxProducer.generateClosure,
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
            producer: SwiftSyntaxProducer.generateClosure,
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
            producer: SwiftSyntaxProducer.generateClosure,
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
            producer: SwiftSyntaxProducer.generateClosure,
            matches: "{ (a: String!) -> Void in\n}"
        )
    }

    func testSequentialBinaryExpression() {
        assert(
            Expression.constant(1).binary(op: .add, rhs: .constant(2)).binary(
                op: .add,
                rhs: .constant(3)
            ),
            producer: SwiftSyntaxProducer.generateBinary,
            matches: "1 + 2 + 3"
        )
    }

    func testTryExpression() {
        assert(
            Expression.try(.identifier("a")),
            producer: SwiftSyntaxProducer.generateTry,
            matches: "try a"
        )
    }

    func testTryExpression_optional() {
        assert(
            Expression.try(.identifier("a"), mode: .optional),
            producer: SwiftSyntaxProducer.generateTry,
            matches: "try? a"
        )
    }

    func testTryExpression_forced() {
        assert(
            Expression.try(.identifier("a"), mode: .forced),
            producer: SwiftSyntaxProducer.generateTry,
            matches: "try! a"
        )
    }
}
