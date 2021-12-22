import SwiftAST
import SwiftRewriterLib
import XCTest

@testable import ExpressionPasses

class NumberCommonsExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()

        sutType = NumberCommonsExpressionPass.self
    }

    func testConvertNumericCast() {
        let exp = Expression.constant(1).casted(to: .float)

        assertTransform(
            // 1 as? Float
            expression: exp,
            // Float(1)
            into:
                .identifier("Float")
                .call([.unlabeled(.constant(1))])
        )

        assertNotifiedChange()
    }

    func testDoNotConvertNonNumericCasts() {
        let exp = Expression.constant(1).casted(to: .typeName("ffloaty"))

        assertTransform(
            // 1 as? ffloaty
            expression: exp,
            // 1 as? ffloaty
            into: .constant(1).casted(to: .typeName("ffloaty"))
        )

        assertDidNotNotifyChange()
    }

    func testConvertFloatMethods() {
        var res = assertTransform(
            // floorf(1)
            expression: .identifier("floorf").call([.constant(1)]),
            // floor(1)
            into: .identifier("floor").call([.constant(1)])
        )
        assertNotifiedChange()

        XCTAssertEqual(
            res.asPostfix?.functionCall?.subExpressions[0].expectedType,
            .float
        )

        res = assertTransform(
            // ceilf(1)
            expression: .identifier("ceilf").call([.constant(1)]),
            // ceil(1)
            into: .identifier("ceil").call([.constant(1)])
        )
        assertNotifiedChange()

        XCTAssertEqual(
            res.asPostfix?.functionCall?.subExpressions[0].expectedType,
            .float
        )

        res = assertTransform(
            // roundf(1)
            expression: .identifier("roundf").call([.constant(1)]),
            // round(1)
            into: .identifier("round").call([.constant(1)])
        )
        assertNotifiedChange()

        XCTAssertEqual(
            res.asPostfix?.functionCall?.subExpressions[0].expectedType,
            .float
        )

        res = assertTransform(
            // fabs(1)
            expression: .identifier("fabs").call([.constant(1)]),
            // fabs(1)
            into: .identifier("fabs").call([.constant(1)])
        )
        assertNotifiedChange()

        XCTAssertEqual(
            res.asPostfix?.functionCall?.subExpressions[0].expectedType,
            .float
        )
    }

    func testConvertMacros() {
        var res = assertTransform(
            // MIN(1, 2)
            expression: .identifier("MIN").call([.constant(1).typed(.float), .constant(2)]),
            // min(1, 2)
            into: .identifier("min").call([.constant(1), .constant(2)])
        )
        assertNotifiedChange()

        XCTAssertEqual(res.asPostfix?.functionCall?.subExpressions[0].expectedType, .float)
        XCTAssertEqual(res.asPostfix?.functionCall?.subExpressions[1].expectedType, .float)

        res = assertTransform(
            // MAX(1, 2)
            expression: .identifier("MAX").call([.constant(1), .constant(2).typed(.float)]),
            // max(1, 2)
            into: .identifier("max").call([.constant(1), .constant(2)])
        )
        assertNotifiedChange()

        XCTAssertEqual(res.asPostfix?.functionCall?.subExpressions[0].expectedType, .float)
        XCTAssertEqual(res.asPostfix?.functionCall?.subExpressions[1].expectedType, .float)
    }

    // MARK: - Numerical casts

    func testConvertNumericTypesWithDifferentExpectedTypesWithCasts() {
        assertTransform(
            // a
            expression: .identifier("a").typed(.int).typed(expected: .float),
            // Float(a)
            into: .identifier("Float").call([.identifier("a")])
        )
        assertNotifiedChange()
    }

    func testDontConvertLiteralExpressions() {
        assertTransform(
            // 1
            expression: .constant(1).typed(.int).typed(expected: .float),
            // 1
            into: .constant(1)
        )
        assertDidNotNotifyChange()
    }

    func testConvertVariableDeclarations() {
        assertTransform(
            // a = b
            statement: .variableDeclaration(
                identifier: "a",
                type: .int,
                initialization: .identifier("b").typed(.float).typed(expected: .int)
            ),
            // a = Int(b)
            into: .variableDeclaration(
                identifier: "a",
                type: .int,
                initialization: .identifier("Int").call([.identifier("b")])
            )
        )
        assertNotifiedChange()
    }

    func testLookIntoTypealiasesForNumericalCasts() {
        typeSystem.addTypealias(aliasName: "GLenum", originalType: "UInt32")
        typeSystem.addTypealias(aliasName: "GLint", originalType: "Int32")

        assertTransform(
            // a
            expression: .identifier("a").typed("GLenum").typed(expected: "GLint"),
            // GLint(a)
            into: .identifier("GLint").call([.identifier("a")])
        )
        assertNotifiedChange()
    }
}
