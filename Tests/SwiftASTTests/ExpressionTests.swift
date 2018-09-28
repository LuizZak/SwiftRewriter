import XCTest
import GrammarModels
import SwiftRewriterLib
import SwiftAST

class ExpressionTests: XCTestCase {
    
    func testAssignParentFunctionCall() {
        let expB = Expression.identifier("b")
        let exp = Expression.identifier("a").call([expB])
        
        XCTAssert(expB.parent === exp)
    }
    
    func testAssignParentSubscription() {
        let expB = Expression.identifier("b")
        let exp = Expression.identifier("a").sub(expB)
        
        XCTAssert(expB.parent === exp)
    }
    
    func testAssignBlock() {
        let stmt = Statement.break
        let exp = Expression.block(parameters: [], return: .void, body: [stmt])
        
        XCTAssert(stmt.parent === exp.body)
        XCTAssert(exp.body.parent === exp)
    }
    
    func testAssignPostfixOperator() {
        let expB = Expression.identifier("b")
        let exp = Expression.identifier("a").call([expB])
        
        exp.op = .functionCall(arguments: [.unlabeled(expB)])
        
        XCTAssert(expB.parent === exp)
    }
    
    func testDescriptionExpressions() {
        
        XCTAssertEqual(
            Expression.identifier("abc").sub(.constant(1)).description,
            "abc[1]")
        XCTAssertEqual(
            Expression.identifier("abc").call([.labeled("label", .constant(1)), .unlabeled(.constant(true))]).description,
            "abc(label: 1, true)")
        XCTAssertEqual(
            Expression.constant(1).binary(op: .add, rhs: .constant(4)).description,
            "1 + 4")
    }
    
    func testDescriptionCasts() {
        XCTAssertEqual(
            Expression.identifier("abc").casted(to: .string).description,
            "abc as? String")
        XCTAssertEqual(
            Expression.identifier("abc").casted(to: .string).dot("count").description,
            "(abc as? String).count")
    }
    
    func testDescriptionOptionalAccess() {
        XCTAssertEqual(
            Expression.identifier("abc").casted(to: .string).optional().dot("count").description,
            "(abc as? String)?.count"
        )
        XCTAssertEqual(
            Expression.identifier("abc").casted(to: .string).forceUnwrap().dot("count").description,
            "(abc as? String)!.count"
        )
    }
    
    func testDescriptionBinaryOps() {
        XCTAssertEqual(
            (Expression.constant(10) + Expression.constant(11)).description,
            "10 + 11")
        XCTAssertEqual(
            (Expression.constant(10) - Expression.constant(11)).description,
            "10 - 11")
        XCTAssertEqual(
            (Expression.constant(10) / Expression.constant(11)).description,
            "10 / 11")
        XCTAssertEqual(
            (Expression.constant(10) * Expression.constant(11)).description,
            "10 * 11")
    }
    
    func testDescriptionNullCoalesce() {
        XCTAssertEqual(
            Expression.binary(lhs: .identifier("abc"), op: .nullCoalesce, rhs: .identifier("def")).description,
            "abc ?? def")
    }
    
    func testRangeExpressions() {
        XCTAssertEqual(
            Expression.binary(lhs: .constant(10), op: .closedRange, rhs: .constant(11)).description,
            "10...11")
        
        XCTAssertEqual(
            Expression.binary(lhs: .constant(10), op: .openRange, rhs: .constant(11)).description,
            "10..<11")
    }
    
    func testDescriptionConstants() {
        XCTAssertEqual(Expression.constant(.int(1, .decimal)).description, "1")
        XCTAssertEqual(Expression.constant(.float(132.4)).description, "132.4")
        XCTAssertEqual(Expression.constant(.hexadecimal(0xfefe)).description, "0xfefe")
        XCTAssertEqual(Expression.constant(.octal(0o7767)).description, "0o7767")
        XCTAssertEqual(Expression.constant(.string("I'm a string!")).description, "\"I'm a string!\"")
        XCTAssertEqual(Expression.constant(.boolean(true)).description, "true")
        XCTAssertEqual(Expression.constant(.boolean(false)).description, "false")
    }
    
    func testConstantEquality() {
        XCTAssertEqual(Expression.constant(1), Expression.constant(1))
        XCTAssertNotEqual(Expression.constant(1), Expression.constant(2))
    }
    
    func testIdentifierEquality() {
        XCTAssertEqual(Expression.identifier("a"), Expression.identifier("a"))
        XCTAssertNotEqual(Expression.identifier("a"), Expression.identifier("<DIFFER>"))
    }
    
    func testBlockEquality() {
        XCTAssertEqual(Expression.block(parameters: [],
                                        return: .void,
                                        body: [.expressions([anExpression()])]),
                       Expression.block(parameters: [],
                                        return: .void,
                                        body: [.expressions([anExpression()])]))
        
        XCTAssertNotEqual(Expression.block(parameters: [],
                                           return: .void,
                                           body: [.expressions([anExpression()])]),
                          Expression.block(parameters: [],
                                           return: .void,
                                           body: [.expressions([anExpression(ident: "<DIFFER>")])]))
    }
    
    func testParensEquality() {
        XCTAssertEqual(Expression.parens(anExpression()),
                       Expression.parens(anExpression()))
        
        XCTAssertNotEqual(Expression.parens(anExpression()),
                          Expression.parens(anExpression(ident: "<DIFFER>")))
    }
    
    func testCastEquality() {
        XCTAssertEqual(Expression.cast(anExpression(), type: .void),
                       Expression.cast(anExpression(), type: .void))
        
        XCTAssertNotEqual(Expression.cast(anExpression(), type: .void),
                          Expression.cast(anExpression(ident: "<DIFFER>"), type: .void))
    }
    
    func testArrayLiteralEquality() {
        XCTAssertEqual(Expression.arrayLiteral([]),
                       Expression.arrayLiteral([]))
        
        XCTAssertNotEqual(Expression.arrayLiteral([]),
                          Expression.arrayLiteral([anExpression()]))
        
        XCTAssertEqual(Expression.arrayLiteral([anExpression()]),
                       Expression.arrayLiteral([anExpression()]))
        
        XCTAssertNotEqual(Expression.arrayLiteral([anExpression()]),
                          Expression.arrayLiteral([anExpression(ident: "<DIFFER>")]))
    }
    
    func testDictionaryLiteralEquality() {
        XCTAssertEqual(Expression.dictionaryLiteral([]),
                       Expression.dictionaryLiteral([]))
        
        XCTAssertEqual(
            Expression.dictionaryLiteral([
                ExpressionDictionaryPair(key: anExpression(),
                                         value: anExpression(ident: "b"))
                ]),
            Expression.dictionaryLiteral([
                ExpressionDictionaryPair(key: anExpression(),
                                         value: anExpression(ident: "b"))
                ]))
        
        XCTAssertNotEqual(
            Expression.dictionaryLiteral([
                ExpressionDictionaryPair(key: anExpression(),
                                         value: anExpression(ident: "b"))
                ]),
            Expression.dictionaryLiteral([
                ExpressionDictionaryPair(key: anExpression(),
                                         value: anExpression(ident: "<DIFFER>"))
                ]))
        
        XCTAssertNotEqual(
            Expression.dictionaryLiteral([
                ExpressionDictionaryPair(key: anExpression(),
                                         value: anExpression(ident: "b"))
                ]),
            Expression.dictionaryLiteral([
                ExpressionDictionaryPair(key: anExpression(ident: "<DIFFER>"),
                                         value: anExpression(ident: "b"))
                ]))
        
        XCTAssertNotEqual(
            Expression.dictionaryLiteral([
                ExpressionDictionaryPair(key: anExpression(),
                                         value: anExpression(ident: "b"))
                ]),
            Expression.dictionaryLiteral([
                ExpressionDictionaryPair(key: anExpression(ident: "<DIFFER>"),
                                         value: anExpression(ident: "<DIFFER>"))
                ]))
        
        XCTAssertNotEqual(Expression.dictionaryLiteral([]),
                          Expression.dictionaryLiteral([
                            ExpressionDictionaryPair(key: anExpression(),
                                                     value: anExpression(ident: "b"))
                            ]))
    }
    
    func testBinaryEquality() {
        XCTAssertEqual(Expression.binary(lhs: anExpression(),
                                         op: .equals,
                                         rhs: anExpression(ident: "b")),
                       Expression.binary(lhs: anExpression(),
                                         op: .equals,
                                         rhs: anExpression(ident: "b")))
        
        // `lhs` not equal
        XCTAssertNotEqual(Expression.binary(lhs: anExpression(ident: "<DIFFER>"),
                                            op: .equals,
                                            rhs: anExpression(ident: "b")),
                          Expression.binary(lhs: anExpression(),
                                            op: .equals,
                                            rhs: anExpression(ident: "b")))
        
        // `op` not equal
        XCTAssertNotEqual(Expression.binary(lhs: anExpression(),
                                            op: .add,
                                            rhs: anExpression(ident: "b")),
                          Expression.binary(lhs: anExpression(),
                                            op: .subtract,
                                            rhs: anExpression(ident: "b")))
        
        // `rhs` not equal
        XCTAssertNotEqual(Expression.binary(lhs: anExpression(),
                                            op: .equals,
                                            rhs: anExpression(ident: "b")),
                          Expression.binary(lhs: anExpression(ident: "<DIFFER>"),
                                            op: .equals,
                                            rhs: anExpression(ident: "b")))
    }
    
    func testTernaryEquality() {
        XCTAssertEqual(Expression.ternary(anExpression(),
                                          true: anExpression(ident: "b"),
                                          false: anExpression(ident: "c")),
                       Expression.ternary(anExpression(),
                                          true: anExpression(ident: "b"),
                                          false: anExpression(ident: "c")))
        
        // `expression` is not equal
        XCTAssertNotEqual(Expression.ternary(anExpression(ident: "<DIFFER>"),
                                             true: anExpression(ident: "b"),
                                             false: anExpression(ident: "c")),
                          Expression.ternary(anExpression(),
                                             true: anExpression(ident: "b"),
                                             false: anExpression(ident: "c")))
        
        // `true` is not equal
        XCTAssertNotEqual(Expression.ternary(anExpression(),
                                             true: anExpression(ident: "b"),
                                             false: anExpression(ident: "c")),
                          Expression.ternary(anExpression(),
                                             true: anExpression(ident: "<DIFFER>"),
                                             false: anExpression(ident: "c")))
        
        // `false` is not equal
        XCTAssertNotEqual(Expression.ternary(anExpression(),
                                             true: anExpression(ident: "b"),
                                             false: anExpression(ident: "c")),
                          Expression.ternary(anExpression(),
                                             true: anExpression(ident: "b"),
                                             false: anExpression(ident: "<DIFFER>")))
    }
    
    func testPostfixEquality() {
        // Member
        XCTAssertEqual(Expression.postfix(anExpression(),
                                          .member("a")),
                       Expression.postfix(anExpression(),
                                          .member("a")))
        
        // Subscript
        XCTAssertEqual(Expression.postfix(anExpression(),
                                          .subscript(anExpression())),
                       Expression.postfix(anExpression(),
                                          .subscript(anExpression())))
        
        // Function call
        XCTAssertEqual(Expression.postfix(anExpression(),
                                          .functionCall(arguments: [
                                            .unlabeled(anExpression()),
                                            .labeled("a", anExpression())
                                            ])),
                       Expression.postfix(anExpression(),
                                          .functionCall(arguments: [
                                            .unlabeled(anExpression()),
                                            .labeled("a", anExpression())
                                            ])))
        
        // `.member` is different
        XCTAssertNotEqual(Expression.postfix(anExpression(),
                                             .member("a")),
                          Expression.postfix(anExpression(),
                                             .member("<DIFFER>")))
        
        // `.subscript` is different
        XCTAssertNotEqual(Expression.postfix(anExpression(),
                                             .subscript(anExpression())),
                          Expression.postfix(anExpression(),
                                             .subscript(anExpression(ident: "<DIFFER>"))))
        
        // `.functionCall`'s `.labeled`'s expression is different
        XCTAssertNotEqual(Expression.postfix(anExpression(),
                                             .functionCall(arguments: [
                                                .unlabeled(anExpression()),
                                                .labeled("a", anExpression())
                                                ])),
                          Expression.postfix(anExpression(),
                                             .functionCall(arguments: [
                                                .unlabeled(anExpression()),
                                                .labeled("a", anExpression(ident: "<DIFFER>"))
                                                ])))
        
        // `.functionCall`'s `.labeled`'s label is different
        XCTAssertNotEqual(Expression.postfix(anExpression(),
                                             .functionCall(arguments: [
                                                .unlabeled(anExpression()),
                                                .labeled("a", anExpression())
                                                ])),
                          Expression.postfix(anExpression(),
                                             .functionCall(arguments: [
                                                .unlabeled(anExpression()),
                                                .labeled("<DIFFER>", anExpression())
                                                ])))
        
        // `.functionCall`'s `.unlabeled`'s expression is different
        XCTAssertNotEqual(Expression.postfix(anExpression(),
                                             .functionCall(arguments: [
                                                .unlabeled(anExpression(ident: "<DIFFER>")),
                                                .labeled("a", anExpression())
                                                ])),
                          Expression.postfix(anExpression(),
                                             .functionCall(arguments: [
                                                .unlabeled(anExpression()),
                                                .labeled("a", anExpression())
                                                ])))
        
        // `op` is different
        XCTAssertNotEqual(Expression.postfix(anExpression(),
                                             .member("a")),
                          Expression.postfix(anExpression(),
                                             .subscript(anExpression(ident: "<DIFFER>"))))
    }
    
    func testUnknownEquality() {
        XCTAssertEqual(Expression.unknown(UnknownASTContext(context: "")),
                       Expression.unknown(UnknownASTContext(context: "1")))
    }
    
    func testUnwrappingParens() {
        XCTAssertEqual(Expression.constant(1).unwrappingParens,
                       Expression.constant(1))
        
        XCTAssertEqual(Expression.parens(Expression.constant(1)).unwrappingParens,
                       Expression.constant(1))
        
        XCTAssertEqual(Expression.parens(Expression.parens(Expression.constant(1))).unwrappingParens,
                       Expression.constant(1))
    }
    
    func testLiteralExpressionKind() {
        XCTAssertEqual(Expression.constant(1).literalExpressionKind, .integer)
        XCTAssertEqual(Expression.constant(1.0).literalExpressionKind, .float)
        XCTAssertEqual(Expression.constant("abc").literalExpressionKind, .string)
        XCTAssertEqual(Expression.constant(true).literalExpressionKind, .boolean)
        XCTAssertEqual(Expression.constant(.nil).literalExpressionKind, .nil)
        XCTAssertEqual(Expression.constant(.rawConstant("123")).literalExpressionKind, nil)
    }
    
    func testLiteralExpressionKindIsNilForAllNonLiteralExpressions() {
        XCTAssertNil(Expression.arrayLiteral([]).literalExpressionKind)
        XCTAssertNil(Expression.dictionaryLiteral([]).literalExpressionKind)
        XCTAssertNil(Expression.assignment(lhs: .constant(0), op: .assign, rhs: .constant(0)).literalExpressionKind)
        XCTAssertNil(Expression.cast(.constant(0), type: .int).literalExpressionKind)
        XCTAssertNil(Expression.binary(lhs: .constant(0), op: .assign, rhs: .constant(0)).literalExpressionKind)
        XCTAssertNil(Expression.block(body: []).literalExpressionKind)
        XCTAssertNil(Expression.identifier("abc").literalExpressionKind)
    }
    
    func testLiteralExpressionKindOnParensExpressionTransmitsLiteralKindOfInnerExpression() {
        XCTAssertEqual(
            Expression.parens(.constant(1)).literalExpressionKind,
            .integer)
        XCTAssertEqual(
            Expression.parens(.constant(1.0)).literalExpressionKind,
            .float)
        XCTAssertEqual(
            Expression.parens(.constant("abc")).literalExpressionKind,
            .string)
        XCTAssertEqual(
            Expression.parens(.constant(true)).literalExpressionKind,
            .boolean)
        XCTAssertEqual(
            Expression.parens(.constant(.nil)).literalExpressionKind,
            .nil)
        XCTAssertEqual(
            Expression.parens(.constant(.rawConstant("123"))).literalExpressionKind,
            nil)
    }

    func testLiteralExpressionKindOnUnaryExpressionTransmitsLiteralKindOfInnerExpression() {
        XCTAssertEqual(
            Expression.unary(op: .add, .constant(1)).literalExpressionKind,
            .integer)
        XCTAssertEqual(
            Expression.unary(op: .add, .constant(1.0)).literalExpressionKind,
            .float)
        XCTAssertEqual(
            Expression.unary(op: .add, .constant("abc")).literalExpressionKind,
            .string)
        XCTAssertEqual(
            Expression.unary(op: .add, .constant(true)).literalExpressionKind,
            .boolean)
        XCTAssertEqual(
            Expression.unary(op: .add, .constant(.nil)).literalExpressionKind,
            .nil)
        XCTAssertEqual(
            Expression.unary(op: .add, .constant(.rawConstant("123"))).literalExpressionKind,
            nil)
    }
    
    func testLiteralExpressionKindOnPrefixExpressionTransmitsLiteralKindOfInnerExpression() {
        XCTAssertEqual(
            Expression.prefix(op: .add, .constant(1)).literalExpressionKind,
            .integer)
        XCTAssertEqual(
            Expression.prefix(op: .add, .constant(1.0)).literalExpressionKind,
            .float)
        XCTAssertEqual(
            Expression.prefix(op: .add, .constant("abc")).literalExpressionKind,
            .string)
        XCTAssertEqual(
            Expression.prefix(op: .add, .constant(true)).literalExpressionKind,
            .boolean)
        XCTAssertEqual(
            Expression.prefix(op: .add, .constant(.nil)).literalExpressionKind,
            .nil)
        XCTAssertEqual(
            Expression.prefix(op: .add, .constant(.rawConstant("123"))).literalExpressionKind,
            nil)
    }
    
    func anExpression(ident: String = "a") -> Expression {
        return .identifier(ident)
    }
}
