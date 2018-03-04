import XCTest
import SwiftRewriterLib
import SwiftAST
import TestCommons
import ExpressionPasses

class ASTCorrectorExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sut = ASTCorrectorExpressionPass()
    }
    
    /// On general arbitrary boolean expressions (mostly binary expressions over
    /// logical operators, i.e. ||, &&, and unary !)
    func testCorrectsArbitraryBooleanExpressions() {
        let lhs = Expression.identifier("a")
        let rhs = Expression.identifier("b")
        lhs.resolvedType = .optional(.bool)
        rhs.resolvedType = .bool
        
        let exp = lhs.binary(op: .and, rhs: rhs)
        
        assertTransform(
            // a && b
            expression: exp,
            // (a == true) && b
            into: Expression
                .binary(lhs: .parens(lhs.binary(op: .equals, rhs: .constant(true))),
                        op: .and,
                        rhs: rhs)
        )
    }
    
    /// Also correct nil-style boolean expressions
    func testCorrectsArbitraryBooleanExpressionsWithNilChecks() {
        let lhs = Expression.identifier("a")
        let rhs = Expression.identifier("b")
        lhs.resolvedType = .optional(.typeName("a"))
        rhs.resolvedType = .optional(.typeName("b"))
        
        let exp = lhs.binary(op: .and, rhs: rhs)
        
        assertTransform(
            // a && b
            expression: exp,
            // (a != nil) && (b != nil)
            into: Expression
                .binary(lhs: .parens(lhs.binary(op: .unequals, rhs: .constant(.nil))),
                        op: .and,
                        rhs: .parens(rhs.binary(op: .unequals, rhs: .constant(.nil))))
        )
    }
    
    /// Also correct unary boolean checks
    func testCorrectsUnaryExpressions() {
        let lhs = Expression.identifier("a")
        lhs.resolvedType = .optional(.typeName("a"))
        
        let exp = Expression.unary(op: .negate, lhs)
        
        assertTransform(
            // !a
            expression: exp,
            // (a == nil)
            into: .parens(lhs.binary(op: .equals, rhs: .constant(.nil)))
        )
    }
    
    // MARK: - If statement
    
    /// On if statements, AST Corrector must try to correct the expression so that
    /// it results in a proper boolean statement.
    func testCorrectsIfStatementBooleanExpressions() {
        let exp = Expression.identifier("a").dot("b")
        exp.resolvedType = .optional(.bool)
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (a.b) { }
            statement: stmt,
            // if (a.b == true) { }
            into: Statement.if(exp.binary(op: .equals, rhs: .constant(true)),
                               body: [],
                               else: nil)
        ); assertNotifiedChange()
    }
    
    /// On boolean expressions that are unary-reversed ("!<exp>"), we simply drop
    /// the unary operator and plug in an inequality to true
    func testCorrectsIfStatementNegatedBooleanExpressions() {
        let exp = Expression.unary(op: .negate, Expression.identifier("a").dot("b"))
        exp.exp.resolvedType = .optional(.bool)
        exp.resolvedType = .bool
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (!a.b) { }
            statement: stmt,
            // if (a.b != true) { }
            into: Statement.if(Expression.identifier("a").dot("b").binary(op: .unequals, rhs: .constant(true)),
                               body: [],
                               else: nil)
        ); assertNotifiedChange()
    }
    
    /// In Objective-C, numbers can be used in place of an if expression statement,
    /// and the expression evaluates to true if the number is different from 0
    func testCorrectsIfStatementWithNumericExpression() {
        let exp = Expression.identifier("num")
        exp.resolvedType = .int
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (num) { }
            statement: stmt,
            // if (num != 0) { }
            into: Statement.if(exp.binary(op: .unequals, rhs: .constant(0)),
                               body: [],
                               else: nil)
        ); assertNotifiedChange()
    }
    
    /// Negated numeric expressions simply compare as equals to zero.
    func testCorrectsIfStatementWithNegatedNumericExpression() {
        let exp = Expression.unary(op: .negate, .identifier("num"))
        exp.exp.resolvedType = .int
        exp.resolvedType = .bool
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (!num) { }
            statement: stmt,
            // if (num == 0) { }
            into: Statement.if(Expression.identifier("num").binary(op: .equals, rhs: .constant(0)),
                               body: [],
                               else: nil)
        ); assertNotifiedChange()
    }
    
    /// Same as above, but testing an optional value instead.
    func testCorrectsIfStatementWithNullableNumericExpressions() {
        let exp = Expression.identifier("num")
        exp.resolvedType = .optional(.implicitUnwrappedOptional(.int))
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (num) { }
            statement: stmt,
            // if (num != 0) { }
            into: Statement.if(exp.binary(op: .unequals, rhs: .constant(0)),
                               body: [],
                               else: nil)
        ); assertNotifiedChange()
    }
    
    /// For otherwise unknown optional expressions, replace check
    /// with an 'if-not-nil'-style check
    func testCorrectsIfStatementWithNullableValue() {
        let exp = Expression.identifier("obj")
        exp.resolvedType = .optional(.typeName("NSObject"))
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (obj) { }
            statement: stmt,
            // if (obj != nil) { }
            into: Statement.if(exp.binary(op: .unequals, rhs: .constant(.nil)),
                               body: [],
                               else: nil)
        ); assertNotifiedChange()
    }
    
    /// For otherwise unknown optional expressions, replace check
    /// with an 'if-nil'-style check
    func testCorrectsIfStatementWithNegatedNullableValue() {
        let exp = Expression.unary(op: .negate, .identifier("obj"))
        exp.resolvedType = .bool
        exp.exp.resolvedType = .optional(.typeName("NSObject"))
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (!obj) { }
            statement: stmt,
            // if (obj == nil) { }
            into: Statement.if(Expression.identifier("obj").binary(op: .equals, rhs: .constant(.nil)),
                               body: [],
                               else: nil)
        ); assertNotifiedChange()
    }
    
    /// For unknown typed expressions, perform no attempts to correct.
    func testDontCorrectUnknownExpressions() {
        let exp = Expression.identifier("a").dot("b")
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (a.b) { }
            statement: stmt,
            // if (a.b == true) { }
            into: Statement.if(Expression.identifier("a").dot("b"),
                               body: [],
                               else: nil)
        ); assertDidNotNotifyChange()
    }
    
    // MARK: - While statements
    
    /// Just like if statements, on while statements the AST Corrector must try
    /// to correct the expression so that it results in a proper boolean statement.
    func testCorrectsWhileStatementBooleanExpressions() {
        let exp = Expression.identifier("a").dot("b")
        exp.resolvedType = .optional(.bool)
        
        let stmt = Statement.while(exp, body: [])
        
        assertTransform(
            // while (a.b) { }
            statement: stmt,
            // while (a.b == true) { }
            into: Statement.while(exp.binary(op: .equals, rhs: .constant(true)),
                                  body: [])
        ); assertNotifiedChange()
    }
    
    /// In Objective-C, numbers can be used in place of a while expression statement,
    /// and the expression evaluates to true if the number is different from 0
    func testCorrectsWhileStatementWithNumericExpression() {
        let exp = Expression.identifier("num")
        exp.resolvedType = .int
        
        let stmt = Statement.while(exp, body: [])
        
        assertTransform(
            // while (num) { }
            statement: stmt,
            // while (num != 0) { }
            into: Statement.while(exp.binary(op: .unequals, rhs: .constant(0)),
                                  body: [])
        ); assertNotifiedChange()
    }
    
    /// Same as above, but testing an optional value instead.
    func testCorrectswhileStatementWithNullableNumericExpressions() {
        let exp = Expression.identifier("num")
        exp.resolvedType = .optional(.implicitUnwrappedOptional(.int))
        
        let stmt = Statement.while(exp, body: [])
        
        assertTransform(
            // while (num) { }
            statement: stmt,
            // while (num != 0) { }
            into: Statement.while(exp.binary(op: .unequals, rhs: .constant(0)),
                                  body: [])
        ); assertNotifiedChange()
    }
    
    /// For otherwise unknown optional expressions, replace check
    /// with an 'while-not-nil'-style check
    func testCorrectswhileStatementWithNullableValue() {
        let exp = Expression.identifier("obj")
        exp.resolvedType = .optional(.typeName("NSObject"))
        
        let stmt = Statement.while(exp, body: [])
        
        assertTransform(
            // while (obj) { }
            statement: stmt,
            // while (obj != nil) { }
            into: Statement.while(exp.binary(op: .unequals, rhs: .constant(.nil)),
                                  body: [])
        ); assertNotifiedChange()
    }
    
    /// For unknown typed expressions, perform no attempts to correct.
    func testDontCorrectUnknownExpressionsOnWhile() {
        let exp = Expression.identifier("a").dot("b")
        
        let stmt = Statement.while(exp, body: [])
        
        assertTransform(
            // while (a.b) { }
            statement: stmt,
            // while (a.b == true) { }
            into: Statement.while(Expression.identifier("a").dot("b"),
                                  body: [])
        ); assertDidNotNotifyChange()
    }
}
