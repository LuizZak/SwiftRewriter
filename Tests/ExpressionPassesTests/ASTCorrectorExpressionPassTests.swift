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
    
    /// Tests the corrector uses information exposed on `Expression.expectedType`
    /// to fix expressions expected to resolve as booleans
    func testCorrectsExpectedBooleanBinaryExpressions() {
        let expMaker = { Expression.identifier("a").dot("b") }
        
        let exp = expMaker()
        exp.resolvedType = .optional(.bool)
        exp.expectedType = .bool
        
        assertTransform(
            // a.b
            expression: exp,
            // a.b == true
            into: expMaker().binary(op: .equals, rhs: .constant(true))
        )
    }
    
    /// On general arbitrary boolean expressions (mostly binary expressions over
    /// logical operators, i.e. ||, &&, and unary !)
    func testCorrectsArbitraryBooleanExpressions() {
        let lhsMaker = { Expression.identifier("a") }
        let rhsMaker = { Expression.identifier("b") }
        
        let lhs = lhsMaker()
        let rhs = rhsMaker()
        lhs.resolvedType = .optional(.bool)
        lhs.expectedType = .bool
        rhs.resolvedType = .bool
        lhs.expectedType = .bool
        
        let exp = lhs.binary(op: .and, rhs: rhs)
        
        assertTransform(
            // a && b
            expression: exp,
            // (a == true) && b
            into: Expression
                .binary(lhs: .parens(lhsMaker().binary(op: .equals, rhs: .constant(true))),
                        op: .and,
                        rhs: rhsMaker())
        )
    }
    
    /// Also correct nil-style boolean expressions
    func testCorrectsArbitraryBooleanExpressionsWithNilChecks() {
        let lhsMaker = { Expression.identifier("a") }
        let rhsMaker = { Expression.identifier("b") }
        
        let lhs = lhsMaker()
        let rhs = rhsMaker()
        lhs.resolvedType = .optional(.typeName("a"))
        rhs.resolvedType = .optional(.typeName("b"))
        lhs.expectedType = .bool
        rhs.expectedType = .bool
        
        let exp = lhs.binary(op: .and, rhs: rhs)
        
        assertTransform(
            // a && b
            expression: exp,
            // (a != nil) && (b != nil)
            into: Expression
                .binary(lhs: .parens(lhsMaker().binary(op: .unequals, rhs: .constant(.nil))),
                        op: .and,
                        rhs: .parens(rhsMaker().binary(op: .unequals, rhs: .constant(.nil))))
        )
    }
    
    /// Also correct unary boolean checks
    func testCorrectsUnaryExpressions() {
        let expMaker = { Expression.identifier("a") }
        
        let innerExp = expMaker()
        innerExp.resolvedType = .optional(.typeName("a"))
        innerExp.expectedType = .bool
        
        let exp = Expression.unary(op: .negate, innerExp)
        
        assertTransform(
            // !a
            expression: exp,
            // (a == nil)
            into: .parens(expMaker().binary(op: .equals, rhs: .constant(.nil)))
        )
    }
    
    // MARK: - If statement
    
    /// On if statements, AST Corrector must try to correct the expression so that
    /// it results in a proper boolean statement.
    func testCorrectsIfStatementBooleanExpressions() {
        let expMaker = { Expression.identifier("a").dot("b") }
        
        let exp = expMaker()
        exp.resolvedType = .optional(.bool)
        exp.expectedType = .bool
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (a.b) { }
            statement: stmt,
            // if (a.b == true) { }
            into: Statement.if(expMaker().binary(op: .equals, rhs: .constant(true)),
                               body: [],
                               else: nil)
        ); assertNotifiedChange()
    }
    
    /// On boolean expressions that are unary-reversed ("!<exp>"), we simply drop
    /// the unary operator and plug in an inequality to true
    func testCorrectsIfStatementNegatedBooleanExpressions() {
        let expMaker = { Expression.identifier("a").dot("b") }
        
        let exp = Expression.unary(op: .negate, expMaker())
        exp.exp.resolvedType = .optional(.bool)
        exp.expectedType = .bool
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (!a.b) { }
            statement: stmt,
            // if (a.b != true) { }
            into: Statement.if(expMaker().binary(op: .unequals, rhs: .constant(true)),
                               body: [],
                               else: nil)
        ); assertNotifiedChange()
    }
    
    /// In Objective-C, numbers can be used in place of an if expression statement,
    /// and the expression evaluates to true if the number is different from 0
    func testCorrectsIfStatementWithNumericExpression() {
        let expMaker = { Expression.identifier("num") }
        
        let exp = expMaker()
        exp.resolvedType = .int
        exp.expectedType = .bool
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (num) { }
            statement: stmt,
            // if (num != 0) { }
            into: Statement.if(expMaker().binary(op: .unequals, rhs: .constant(0)),
                               body: [],
                               else: nil)
        ); assertNotifiedChange()
    }
    
    /// Negated numeric expressions simply compare as equals to zero.
    func testCorrectsIfStatementWithNegatedNumericExpression() {
        let expMaker = { Expression.unary(op: .negate, .identifier("num")) }
        
        let exp = expMaker()
        exp.exp.resolvedType = .int
        exp.expectedType = .bool
        
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
        let expMaker = { Expression.identifier("num") }
        
        let exp = expMaker()
        exp.resolvedType = .optional(.implicitUnwrappedOptional(.int))
        exp.expectedType = .bool
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (num) { }
            statement: stmt,
            // if (num != 0) { }
            into: Statement.if(expMaker().binary(op: .unequals, rhs: .constant(0)),
                               body: [],
                               else: nil)
        ); assertNotifiedChange()
    }
    
    /// For otherwise unknown optional expressions, replace check
    /// with an 'if-not-nil'-style check
    func testCorrectsIfStatementWithNullableValue() {
        let expMaker = { Expression.identifier("obj") }
        
        let exp = expMaker()
        exp.resolvedType = .optional(.typeName("NSObject"))
        exp.expectedType = .bool
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (obj) { }
            statement: stmt,
            // if (obj != nil) { }
            into: Statement.if(expMaker().binary(op: .unequals, rhs: .constant(.nil)),
                               body: [],
                               else: nil)
        ); assertNotifiedChange()
    }
    
    /// For otherwise unknown optional expressions, replace check
    /// with an 'if-nil'-style check
    func testCorrectsIfStatementWithNegatedNullableValue() {
        let expMaker = { Expression.identifier("obj") }
        
        let exp = Expression.unary(op: .negate, expMaker())
        exp.exp.resolvedType = .optional(.typeName("NSObject"))
        exp.expectedType = .bool
        exp.exp.expectedType = .bool
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (!obj) { }
            statement: stmt,
            // if (obj == nil) { }
            into: Statement.if(expMaker().binary(op: .equals, rhs: .constant(.nil)),
                               body: [],
                               else: nil)
        ); assertNotifiedChange()
    }
    
    /// For unknown typed expressions, perform no attempts to correct.
    func testDontCorrectUnknownExpressions() {
        let expMaker = { Expression.identifier("a").dot("b") }
        
        let exp = expMaker()
        exp.expectedType = .bool
        
        let stmt = Statement.if(exp, body: [], else: nil)
        
        assertTransform(
            // if (a.b) { }
            statement: stmt,
            // if (a.b == true) { }
            into: Statement.if(expMaker(),
                               body: [],
                               else: nil)
        ); assertDidNotNotifyChange()
    }
    
    // MARK: - While statements
    
    /// Just like if statements, on while statements the AST Corrector must try
    /// to correct the expression so that it results in a proper boolean statement.
    func testCorrectsWhileStatementBooleanExpressions() {
        let expMaker = { Expression.identifier("a").dot("b") }
        
        let exp = expMaker()
        exp.resolvedType = .optional(.bool)
        exp.expectedType = .bool
        
        let stmt = Statement.while(exp, body: [])
        
        assertTransform(
            // while (a.b) { }
            statement: stmt,
            // while (a.b == true) { }
            into: Statement.while(expMaker().binary(op: .equals, rhs: .constant(true)),
                                  body: [])
        ); assertNotifiedChange()
    }
    
    /// In Objective-C, numbers can be used in place of a while expression statement,
    /// and the expression evaluates to true if the number is different from 0
    func testCorrectsWhileStatementWithNumericExpression() {
        let expMaker = { Expression.identifier("num") }
        
        let exp = expMaker()
        exp.resolvedType = .int
        exp.expectedType = .bool
        
        let stmt = Statement.while(exp, body: [])
        
        assertTransform(
            // while (num) { }
            statement: stmt,
            // while (num != 0) { }
            into: Statement.while(expMaker().binary(op: .unequals, rhs: .constant(0)),
                                  body: [])
        ); assertNotifiedChange()
    }
    
    /// Same as above, but testing an optional value instead.
    func testCorrectswhileStatementWithNullableNumericExpressions() {
        let expMaker = { Expression.identifier("num") }
        
        let exp = expMaker()
        exp.resolvedType = .optional(.implicitUnwrappedOptional(.int))
        exp.expectedType = .bool
        
        let stmt = Statement.while(exp, body: [])
        
        assertTransform(
            // while (num) { }
            statement: stmt,
            // while (num != 0) { }
            into: Statement.while(expMaker().binary(op: .unequals, rhs: .constant(0)),
                                  body: [])
        ); assertNotifiedChange()
    }
    
    /// For otherwise unknown optional expressions, replace check
    /// with an 'while-not-nil'-style check
    func testCorrectswhileStatementWithNullableValue() {
        let expMaker = { Expression.identifier("obj") }
        
        let exp = expMaker()
        exp.resolvedType = .optional(.typeName("NSObject"))
        exp.expectedType = .bool
        
        let stmt = Statement.while(exp, body: [])
        
        assertTransform(
            // while (obj) { }
            statement: stmt,
            // while (obj != nil) { }
            into: Statement.while(expMaker().binary(op: .unequals, rhs: .constant(.nil)),
                                  body: [])
        ); assertNotifiedChange()
    }
    
    /// For unknown typed expressions, perform no attempts to correct.
    func testDontCorrectUnknownExpressionsOnWhile() {
        let expMaker = { Expression.identifier("a").dot("b") }
        
        let exp = expMaker()
        exp.expectedType = .bool
        
        let stmt = Statement.while(exp, body: [])
        
        assertTransform(
            // while (a.b) { }
            statement: stmt,
            // while (a.b == true) { }
            into: Statement.while(expMaker(),
                                  body: [])
        ); assertDidNotNotifyChange()
    }
}
