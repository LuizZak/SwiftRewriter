import XCTest
import SwiftAST
import SwiftRewriterLib
import ExpressionPasses

class NumberCommonsExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sut = NumberCommonsExpressionPass(context: makeContext())
    }
    
    func testConvertNumericCast() {
        let exp = Expression.constant(1).casted(to: .float)
        
        assertTransform(
            // 1 as? Float
            expression: exp,
            // Float(1)
            into: Expression
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
            into: Expression.constant(1).casted(to: .typeName("ffloaty"))
        )
        
        assertDidNotNotifyChange()
    }
    
    func testConvertFloatMethods() {
        var res = assertTransform(
            // floorf(1)
            expression: Expression.identifier("floorf").call([.constant(1)]),
            // floor(1)
            into: Expression.identifier("floor").call([.constant(1)])
        ); assertNotifiedChange()
        
        XCTAssertEqual(res.asPostfix?.functionCall?.subExpressions[0].expectedType,
                       .float)
        
        res = assertTransform(
            // ceilf(1)
            expression: Expression.identifier("ceilf").call([.constant(1)]),
            // ceil(1)
            into: Expression.identifier("ceil").call([.constant(1)])
        ); assertNotifiedChange()
        
        XCTAssertEqual(res.asPostfix?.functionCall?.subExpressions[0].expectedType,
                       .float)
        
        res = assertTransform(
            // roundf(1)
            expression: Expression.identifier("roundf").call([.constant(1)]),
            // round(1)
            into: Expression.identifier("round").call([.constant(1)])
        ); assertNotifiedChange()
        
        XCTAssertEqual(res.asPostfix?.functionCall?.subExpressions[0].expectedType,
                       .float)
        
        res = assertTransform(
            // fabs(1)
            expression: Expression.identifier("fabs").call([.constant(1)]),
            // fabs(1)
            into: Expression.identifier("fabs").call([.constant(1)])
        ); assertNotifiedChange()
        
        XCTAssertEqual(res.asPostfix?.functionCall?.subExpressions[0].expectedType,
                       .float)
    }
    
    func testConvertMacros() {
        var res = assertTransform(
            // MIN(1, 2)
            expression: Expression.identifier("MIN").call([Expression.constant(1).typed(.float), .constant(2)]),
            // min(1, 2)
            into: Expression.identifier("min").call([.constant(1), .constant(2)])
        ); assertNotifiedChange()
        
        XCTAssertEqual(res.asPostfix?.functionCall?.subExpressions[0].expectedType, .float)
        XCTAssertEqual(res.asPostfix?.functionCall?.subExpressions[1].expectedType, .float)
        
        res = assertTransform(
            // MAX(1, 2)
            expression: Expression.identifier("MAX").call([.constant(1), Expression.constant(2).typed(.float)]),
            // max(1, 2)
            into: Expression.identifier("max").call([.constant(1), .constant(2)])
        ); assertNotifiedChange()
        
        XCTAssertEqual(res.asPostfix?.functionCall?.subExpressions[0].expectedType, .float)
        XCTAssertEqual(res.asPostfix?.functionCall?.subExpressions[1].expectedType, .float)
    }
    
    // MARK: - Numerical casts
    
    func testConvertNumericTypesWithDifferentExpectedTypesWithCasts() {
        assertTransform(
            // a
            expression: Expression.identifier("a").typed(.int).typed(expected: .float),
            // Float(a)
            into: Expression.identifier("Float").call([.identifier("a")])
        ); assertNotifiedChange()
    }
    
    func testDontConvertLiteralExpresions() {
        assertTransform(
            // 1
            expression: Expression.constant(1).typed(.int).typed(expected: .float),
            // 1
            into: Expression.constant(1)
        ); assertDidNotNotifyChange()
    }
    
    func testConvertVariableDeclarations() {
        assertTransform(
            // a = b
            statement: .variableDeclaration(identifier: "a", type: .int, initialization: Expression.identifier("b").typed(.float).typed(expected: .int)),
            // a = Int(b)
            into: .variableDeclaration(identifier: "a", type: .int, initialization: Expression.identifier("Int").call([.identifier("b")]))
        ); assertNotifiedChange()
    }
    
    func testLookIntoTypealiasesForNumericalCasts() {
        typeSystem.addTypealias(aliasName: "GLenum", originalType: "UInt32")
        typeSystem.addTypealias(aliasName: "GLint", originalType: "Int32")
        
        assertTransform(
            // a
            expression: Expression.identifier("a").typed("GLenum").typed(expected: "GLint"),
            // GLint(a)
            into: Expression.identifier("GLint").call([.identifier("a")])
        ); assertNotifiedChange()
    }
}
