import XCTest
import SwiftSyntax
import SwiftAST
@testable import SwiftSyntaxSupport
import Intentions
import TestCommons
import Utils

class SwiftSyntaxProducer_ExpTests: BaseSwiftSyntaxProducerTests {
    
    func testConstantInt() {
        assert(
            Expression.constant(.int(123, .decimal)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "123")
        
        assert(
            Expression.constant(.int(123, .hexadecimal)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "0x7b")
        
        assert(
            Expression.constant(.int(123, .octal)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "0o173")
        
        assert(
            Expression.constant(.int(123, .binary)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "0b1111011")
    }
    
    func testConstantFloat() {
        assert(
            Expression.constant(.float(123.456)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "123.456")
    }
    
    func testConstantBoolean() {
        assert(
            Expression.constant(.boolean(true)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "true")
        assert(
            Expression.constant(.boolean(false)),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "false")
    }
    
    func testConstantString() {
        assert(
            Expression.constant(.string("Hello, World!")),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "\"Hello, World!\"")
    }
    
    func testConstantNil() {
        assert(
            Expression.constant(.nil),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "nil")
    }
    
    func testConstantRaw() {
        assert(
            Expression.constant(.rawConstant("foo")),
            producer: SwiftSyntaxProducer.generateConstant,
            matches: "foo")
    }
    
    func testIdentifier() {
        assert(
            Expression.identifier("foo"),
            producer: SwiftSyntaxProducer.generateIdentifier,
            matches: "foo")
    }
    
    func testPostfixFunctionCall() {
        assert(
            Expression.identifier("foo").call(),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo()")
        
        assert(
            Expression.identifier("foo").call([.constant(1)]),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo(1)")
        
        assert(
            Expression.identifier("foo").call([.unlabeled(.constant(1)),
                                               .labeled("b", .constant(2))]),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo(1, b: 2)")
    }
    
    func testPostfixOptionalFunctionCall() {
        assert(
            Expression.identifier("foo").optional().call(),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo?()")
    }
    
    func testPostfixForcedFunctionCall() {
        assert(
            Expression.identifier("foo").forceUnwrap().call(),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo!()")
    }
    
    func testPostfixSubscript() {
        assert(
            Expression.identifier("foo").sub(.constant(1)),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo[1]")
    }
    
    func testPostfixOptionalSubscript() {
        assert(
            Expression.identifier("foo").optional().sub(.constant(1)),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo?[1]")
    }
    
    func testPostfixForcedSubscript() {
        assert(
            Expression.identifier("foo").forceUnwrap().sub(.constant(1)),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo![1]")
    }
    
    func testPostfixMember() {
        assert(
            Expression.identifier("foo").dot("bar"),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo.bar")
    }
    
    func testPostfixOptionalMember() {
        assert(
            Expression.identifier("foo").optional().dot("bar"),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo?.bar")
    }
    
    func testPostfixForcedMember() {
        assert(
            Expression.identifier("foo").forceUnwrap().dot("bar"),
            producer: SwiftSyntaxProducer.generatePostfix,
            matches: "foo!.bar")
    }
    
    func testParens() {
        assert(
            Expression.parens(Expression.identifier("exp")),
            producer: SwiftSyntaxProducer.generateParens,
            matches: "(exp)")
    }
    
    func testArrayLiteralEmpty() {
        assert(
            Expression.arrayLiteral([]),
            producer: SwiftSyntaxProducer.generateArrayLiteral,
            matches: "[]")
    }
    
    func testArrayLiteralOneItem() {
        assert(
            Expression.arrayLiteral([.constant(1)]),
            producer: SwiftSyntaxProducer.generateArrayLiteral,
            matches: "[1]")
    }
    
    func testArrayLiteralMultipleItems() {
        assert(
            Expression.arrayLiteral([.constant(1), .constant(2), .constant(3)]),
            producer: SwiftSyntaxProducer.generateArrayLiteral,
            matches: "[1, 2, 3]")
    }
    
    func testDictionaryLiteralEmpty() {
        assert(
            Expression.dictionaryLiteral([]),
            producer: SwiftSyntaxProducer.generateDictionaryLiteral,
            matches: "[:]")
    }
    
    func testDictionaryLiteralOneItem() {
        assert(
            Expression.dictionaryLiteral([.constant(1): .constant(2)]),
            producer: SwiftSyntaxProducer.generateDictionaryLiteral,
            matches: "[1: 2]")
    }
    
    func testDictionaryLiteralMultipleItems() {
        assert(
            Expression.dictionaryLiteral([.constant(1): .constant(2), .constant(2): .constant(4)]),
            producer: SwiftSyntaxProducer.generateDictionaryLiteral,
            matches: "[1: 2, 2: 4]")
    }
    
    func testCast() {
        assert(
            Expression.identifier("foo").casted(to: .int, optional: false),
            producer: SwiftSyntaxProducer.generateCast,
            matches: "foo as Int")
    }
    
    func testOptionalCast() {
        assert(
            Expression.identifier("foo").casted(to: .int, optional: true),
            producer: SwiftSyntaxProducer.generateCast,
            matches: "foo as? Int")
    }
    
    func testAssignment() {
        assert(
            Expression.identifier("foo").assignment(op: .assign, rhs: .constant(1)),
            producer: SwiftSyntaxProducer.generateAssignment,
            matches: "foo = 1")
    }
    
    func testBinary() {
        assert(
            Expression.identifier("foo").binary(op: .add, rhs: .constant(1)),
            producer: SwiftSyntaxProducer.generateBinary,
            matches: "foo + 1")
    }
    
    func testUnary() {
        assert(
            Expression.unary(op: .subtract, .identifier("foo")),
            producer: SwiftSyntaxProducer.generateUnary,
            matches: "-foo")
    }
    
    func testPrefix() {
        assert(
            Expression.prefix(op: .subtract, .identifier("foo")),
            producer: SwiftSyntaxProducer.generatePrefix,
            matches: "-foo")
    }
    
    func testSizeOfValue() {
        assert(
            Expression.sizeof(.identifier("foo")),
            producer: SwiftSyntaxProducer.generateSizeOf,
            matches: "MemoryLayout.size(ofValue: foo)")
    }
    
    func testSizeOfType() {
        assert(
            Expression.sizeof(type: .int),
            producer: SwiftSyntaxProducer.generateSizeOf,
            matches: "MemoryLayout<Int>.size")
    }
    
    func testTernary() {
        assert(
            Expression.ternary(.constant(true), true: .identifier("foo"), false: .identifier("bar")),
            producer: SwiftSyntaxProducer.generateTernary,
            matches: "true ? foo : bar")
    }
    
    func testClosure() {
        assert(
            Expression.block(body: []),
            producer: SwiftSyntaxProducer.generateClosure,
            matches: "{ () -> Void in\n}")
    }
    
    func testClosureWithParameters() {
        assert(
            Expression.block(
                parameters: [BlockParameter(name: "p1", type: .int)],
                return: .void,
                body: []
            ),
            producer: SwiftSyntaxProducer.generateClosure,
            matches: "{ (p1: Int) -> Void in\n}")
    }
}
