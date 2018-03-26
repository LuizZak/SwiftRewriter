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
    
    /// Tests inserting null-coalesces on optional numeric types on the left
    /// and right side of arithmetic operators
    func testNullCoalesceOnArithmeticOperators() {
        let expMaker = { Expression.identifier("a") }
        
        let exp = expMaker().binary(op: .add, rhs: Expression.identifier("b"))
        exp.lhs.resolvedType = .optional(.int)
        
        assertTransform(
            // a + b
            expression: exp,
            // (a ?? 0) + b
            into:
            Expression
                .parens(expMaker().binary(op: .nullCoalesce, rhs: .constant(0)))
                .binary(op: .add, rhs: Expression.identifier("b"))
        ); assertNotifiedChange()
    }
    
    /// Tests null-coalescing on deep nested binary expressions
    func testNullCoalesceOnNestedArithmeticOperators() {
        let lhsLhsMaker = { Expression.identifier("a") }
        let lhsMaker = { Expression.identifier("b") }
        
        let exp = (lhsLhsMaker().binary(op: .add, rhs: lhsMaker())).binary(op: .add, rhs: Expression.identifier("c"))
        exp.lhs.asBinary?.lhs.resolvedType = .optional(.int)
        exp.lhs.asBinary?.rhs.resolvedType = .optional(.int)
        
        assertTransform(
            // a + b + c
            expression: exp,
            // (a ?? 0) + (b ?? 0) + c
            into:
            Expression
                .parens(
                    lhsLhsMaker()
                        .binary(op: .nullCoalesce, rhs: .constant(0))
                )
                .binary(op: .add, rhs: .parens(lhsMaker().binary(op: .nullCoalesce, rhs: .constant(0))))
                .binary(op: .add, rhs: Expression.identifier("c"))
        ); assertNotifiedChange()
    }
    
    /// Tests that arithmetic comparisons (<=, <, >=, >) where lhs and rhs are
    /// optional numeric values are coerced into default values using zeroes.
    func testNullCoalesceOnArithmeticComparisions() {
        let expMaker = { Expression.identifier("a") }
        
        let exp = expMaker().binary(op: .lessThan, rhs: Expression.identifier("b"))
        exp.lhs.resolvedType = .optional(.int)
        exp.rhs.resolvedType = .int
        
        assertTransform(
            // a < b
            expression: exp,
            // (a ?? 0) < b
            into:
            Expression
                .parens(expMaker().binary(op: .nullCoalesce, rhs: .constant(0)))
                .binary(op: .lessThan, rhs: Expression.identifier("b"))
        ); assertNotifiedChange()
    }
    
    /// Tests the corrector applies an integer correction to automatically null-coalesce
    /// into zero's (to match original Objective-C behavior)
    func testCorrectNullableInteger() {
        let expMaker = { Expression.identifier("a").dot("b") }
        
        let exp = expMaker()
        exp.resolvedType = .optional(.int)
        exp.expectedType = .int
        
        assertTransform(
            // a.b
            expression: exp,
            // (a.b ?? 0)
            into: .parens(expMaker().binary(op: .nullCoalesce, rhs: .constant(0)))
        ); assertNotifiedChange()
    }
    
    /// Tests the corrector applies a floating-point correction to automatically
    /// null-coalesce into zero's (to match original Objective-C behavior)
    func testCorrectNullableFloatingPoint() {
        let expMaker = { Expression.identifier("a").dot("b") }
        
        let exp = expMaker()
        exp.resolvedType = .optional(.float)
        exp.expectedType = .float
        
        assertTransform(
            // a.b
            expression: exp,
            // (a.b ?? 0.0)
            into: .parens(expMaker().binary(op: .nullCoalesce, rhs: .constant(0.0)))
        )
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
        ); assertNotifiedChange()
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
        ); assertNotifiedChange()
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
        ); assertNotifiedChange()
    }
    
    /// Also correct unary boolean checks
    func testCorrectsUnaryNegateExpressions() {
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
        ); assertNotifiedChange()
    }
    
    /// Tests inserting null-coalesces on optional types contained in unary
    /// expressions
    func testCorrectUnaryArithmeticExpression() {
        let expMaker = { Expression.identifier("a") }
        
        let innerExp = expMaker()
        innerExp.resolvedType = .optional(.int)
        innerExp.expectedType = .int
        
        let exp = Expression.unary(op: .subtract, innerExp)
        
        assertTransform(
            // -a
            expression: exp,
            // -(a ?? 0)
            into:
            Expression.unary(
                op: .subtract,
                Expression
                    .parens(expMaker().binary(op: .nullCoalesce, rhs: .constant(0)))
            )
        ); assertNotifiedChange()
    }
    
    /// Tests correcting receiving nullable struct on a non-null struct context,
    /// where the struct does feature a default empty constructor.
    func testCorrectNonnullStructWithNullableStructValue() {
        let str =
            KnownTypeBuilder(typeName: "A", kind: .struct)
                .constructor()
                .build()
        typeSystem.addType(str)
        let expMaker = { Expression.identifier("a") }
        let exp = expMaker()
        exp.resolvedType = .optional(.typeName("A"))
        exp.expectedType = .typeName("A")
        
        assertTransform(
            // a
            expression: exp,
            // (a ?? A())
            into: .parens(expMaker().binary(op: .nullCoalesce, rhs: Expression.identifier("A").call()))
        ); assertNotifiedChange()
    }
    
    func testDontCorrectNonnullStructWithImplicitlyUnwrappedStructValue() {
        let str =
            KnownTypeBuilder(typeName: "A", kind: .struct)
                .constructor()
                .build()
        typeSystem.addType(str)
        let expMaker = { Expression.identifier("a") }
        let exp = expMaker()
        exp.resolvedType = .implicitUnwrappedOptional(.typeName("A"))
        exp.expectedType = .typeName("A")
        
        assertTransform(
            // a
            expression: exp,
            // a
            into: expMaker()
        ); assertDidNotNotifyChange()
    }
    
    /// Tests that base expressions (i.e. those that form a complete statement,
    /// that form a function argument, or a subscript operand) have their nullability
    /// corrected by default.
    func testAlwaysCorrectBaseExpressionsScalarTypesThatResolveAsNull() {
        let funcMaker = { (arg: Expression) in Expression.identifier("f").call([arg]) }
        let expMaker = { Expression.identifier("a") }
        
        let exp = expMaker()
        exp.resolvedType = .optional(.int)
        
        assertTransform(
            // { f(a) }
            statement: .expression(funcMaker(exp)),
            // { f(a ?? 0) }
            into: .expression(
                funcMaker(Expression.parens(expMaker().binary(op: .nullCoalesce, rhs: .constant(0))))
            )
        ); assertNotifiedChange()
    }
    
    /// Tests that base expressions (i.e. those that form a complete statement,
    /// that form a function argument, or a subscript operand) have their nullability
    /// corrected by default.
    func testAlwaysCorrectBaseExpressionsScalarTypesThatResolveAsNullInFunctionArguments() {
        let expMaker = {
            Expression
                .identifier("a")
                .call([
                    Expression
                        .identifier("b")
                        .typed(.optional(.int))
                        .typed(expected: .int)
                ])
        }
        
        let exp = expMaker()
        
        assertTransform(
            // { a(b) }
            statement: Statement.expression(exp),
            // { a((b ?? 0)) }
            into:
            .expression(
                Expression
                    .identifier("a")
                    .call([.parens(Expression.identifier("b").binary(op: .nullCoalesce, rhs: .constant(0)))])
            )
        ); assertNotifiedChange()
    }
    
    /// Tests we don't correct base expressions for assignment expressions that
    /// are top-level (i.e. are a complete statement)
    func testDontCorrectBaseAssignmentExpressions() {
        let expMaker = {
            Expression
                .identifier("a")
                .typed(.optional(.typeName("A")))
                .optional()
                .dot("b", type: .optional(.int))
                .typed(.optional(.int))
                .assignment(op: .assign, rhs: .constant(0))
                .typed(.optional(.int))
        }
        
        let exp = expMaker()
        exp.expectedType = .int
        
        assertTransform(
            // { a?.b = 0 }
            statement: .expression(exp),
            // { a?.b = 0 }
            into: .expression(expMaker())
        ); assertDidNotNotifyChange()
    }
    
    /// Tests that base expressions (i.e. those that form a complete statement,
    /// that form a function argument, or a subscript operand) have their nullability
    /// corrected by default.
    func testDontCorrectBaseExpressionsScalarTypesForConstantExpressions() {
        let expMaker = { Expression.constant(0) }
        
        let exp = expMaker()
        exp.expectedType = .optional(.int)
        
        assertTransform(
            // { 0 }
            statement: .expression(exp),
            // { 0 }
            into: .expression(expMaker())
        ); assertDidNotNotifyChange()
    }
    
    /// Tests that making an access such as `self.superview?.bounds.midX` actually
    /// resolves into a null-coalesce before the `midX` access.
    /// This mimics the original Objective-C behavior where such an expression
    /// would be written as `CGRectGetMidX(self.superview.bounds)`, with the method
    /// always being invoked.
    ///
    /// It is generally safe to do this since in Objective-C, apart from conversions
    /// like above where struct-based functions are top-level and always execute,
    /// nullability is propagated such that invoking members in nil pointers result
    /// in zero'd returns, but accessing zero'd structs has no semantic impact in
    /// the resulting value than if it was a non-zero struct from a return value
    /// of a non-nil pointer.
    func testCorrectPostfixAccessToNullableValueType() {
        let str =
            KnownTypeBuilder(typeName: "B", kind: .struct)
                .constructor()
                .build()
        typeSystem.addType(str)
        let expMaker = { Expression.identifier("a").optional().dot("b") }
        let exp = expMaker()
        exp.exp.resolvedType = .optional(.typeName("A"))
        exp.op.returnType = .typeName("B")
        exp.resolvedType = .optional(.typeName("B"))
        exp.expectedType = .typeName("B")
        
        let res = assertTransform(
            // a?.b.c()
            expression: exp
                .dot("c", type: .block(returnType: .int, parameters: [])).typed(.optional(.block(returnType: .int, parameters: [])))
                .call([], callableSignature: .block(returnType: .int, parameters: [])).typed(.optional(.int)),
            // (a?.b ?? B()).c()
            into:
            Expression
                .parens(expMaker().binary(op: .nullCoalesce, rhs: Expression.identifier("B").call()))
                .dot("c").call()
        ); assertNotifiedChange()
        
        XCTAssertEqual(res.resolvedType, .int)
        XCTAssertEqual(res.asPostfix?.exp.resolvedType, .block(returnType: .int, parameters: []))
    }
    
    /// No need to correct accesses when the access is a plain member access over
    /// the struct's value. This can be corrected later on.
    func testDontCorrectPostfixAccessToNullableValueTypeWhenAccessIsMemberOnly() {
        let str =
            KnownTypeBuilder(typeName: "B", kind: .struct)
                .constructor()
                .build()
        typeSystem.addType(str)
        let expMaker = { Expression.identifier("a").dot("b") }
        let exp = expMaker()
        exp.exp.resolvedType = .optional(.typeName("A"))
        exp.op.returnType = .typeName("B")
        exp.resolvedType = .optional(.typeName("B"))
        
        assertTransform(
            // a.b.c
            expression: exp.dot("c"),
            // a.b.c
            into: expMaker().dot("c")
        ); assertDidNotNotifyChange()
    }
    
    /// Don't correct implicitly-unwrapped optional chains
    func testDontCorrectPostfixAccessToNullableValueTypeWhenAccessIsImplicitlyUnwrapped() {
        let str =
            KnownTypeBuilder(typeName: "B", kind: .struct)
                .constructor()
                .build()
        typeSystem.addType(str)
        let expMaker = { Expression.identifier("a").dot("b") }
        let exp = expMaker()
        exp.exp.resolvedType = .implicitUnwrappedOptional(.typeName("A"))
        exp.op.returnType = .typeName("B")
        exp.resolvedType = .implicitUnwrappedOptional(.typeName("B"))
        exp.expectedType = .typeName("B")
        
        assertTransform(
            // a.b.c()
            expression: exp
                .dot("c", type: .block(returnType: .int, parameters: []))
                .typed(.implicitUnwrappedOptional(.block(returnType: .int, parameters: [])))
                .call([], callableSignature: .block(returnType: .int, parameters: []))
                .typed(.implicitUnwrappedOptional(.int)),
            // a.b.c()
            into: expMaker().dot("c").call()
        ); assertDidNotNotifyChange()
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
            // if !a.b { }
            statement: stmt,
            // if (a.b != true) { }
            into: Statement.if(.parens(expMaker().binary(op: .unequals, rhs: .constant(true))),
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
            // if !num { }
            statement: stmt,
            // if (num == 0) { }
            into: Statement.if(.parens(Expression.identifier("num").binary(op: .equals, rhs: .constant(0))),
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
            // if !obj { }
            statement: stmt,
            // if (obj == nil) { }
            into: Statement.if(.parens(expMaker().binary(op: .equals, rhs: .constant(.nil))),
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
    
    /// Tests that the corrector is capable of doing simple if-let generations
    /// when a nullable value is passed to a non-null parameter of a function
    /// call expression.
    func testCorrectSimpleNullableValueInNonnullParameterToIfLet() {
        let funcType = SwiftType.block(returnType: .void, parameters: [.typeName("A")])
        
        let exp =
            Expression
                .identifier("a").typed(funcType)
                .call([Expression.identifier("b").typed(.optional(.typeName("A")))],
                      callableSignature: funcType)
        
        assertTransform(
            // a(b)
            statement: Statement.expression(exp),
            // if let b = b { a(b) }
            into: Statement.ifLet(
                Pattern.identifier("b"), .identifier("b"),
                body: [
                    .expression(Expression.identifier("a").call([Expression.identifier("b")]))
                ], else: nil)
        ); assertNotifiedChange()
    }
    
    /// Same as above, but as a member access
    func testCorrectMemberAccessNullableValueInNonnullParameterToIfLet() {
        let funcType = SwiftType.block(returnType: .void, parameters: [.typeName("A")])
        
        let exp =
            Expression
                .identifier("a").typed(funcType)
                .call([Expression.identifier("b").dot("c").typed(.optional(.typeName("A")))],
                      callableSignature: funcType)
        
        assertTransform(
            // a(b.c)
            statement: Statement.expression(exp),
            // if let c = b.c { a(c) }
            into: Statement.ifLet(
                Pattern.identifier("c"), Expression.identifier("b").dot("c"),
                body: [
                    .expression(Expression.identifier("a").call([Expression.identifier("c")]))
                ], else: nil)
        ); assertNotifiedChange()
    }
    
    /// Tests non-null arguments with nullable scalar types are not corrected to
    /// an if-let, since this is dealt at another point in the AST corrector.
    func testDontCorrectSimpleNullableValueInNonnullParameterToIfLetIfArgumentIsNullableScalarType() {
        let funcType = SwiftType.block(returnType: .void, parameters: [.int])
        
        let exp =
            Expression
                .identifier("a").typed(funcType)
                .call([Expression.identifier("b").dot("c").typed(.optional(.int))],
                      callableSignature: funcType)
        
        assertTransform(
            // a(b.c)
            statement: Statement.expression(exp),
            // a((b.c ?? 0))
            into: Statement.expression(Expression
                .identifier("a").typed(funcType)
                .call([Expression.parens(Expression.identifier("b").dot("c").binary(op: .nullCoalesce, rhs: .constant(0)))],
                      callableSignature: funcType))
        ); assertNotifiedChange()
    }
    
    /// Make sure we don't correct passing a nullable value to a nullable parameter
    func testDontCorrectNullableValuesPassedToNullableParameters() {
        let funcType = SwiftType.block(returnType: .void, parameters: [.optional(.typeName("A"))])
        let expMaker = {
            Expression
                .identifier("a").typed(funcType)
                .call([Expression.identifier("b").typed(.optional(.typeName("A")))],
                      callableSignature: funcType)
        }
        
        let exp = expMaker()
        
        assertTransform(
            // a(b)
            statement: Statement.expression(exp),
            // a(b)
            into: Statement.expression(expMaker())
        ); assertDidNotNotifyChange()
    }
    
    /// Test we don't require correcting implicitly unwrapped optionals on the
    /// rhs of an assignment
    func testDontCorrectImplicitlyUnwrappedOptionalRightHandSideOnAssignment() {
        let type = KnownTypeBuilder(typeName: "Value", kind: .struct)
            .constructor()
            .build()
        typeSystem.addType(type)
        let rhsMaker: () -> Expression = {
            let e = Expression.identifier("self")
                .dot("value", type: .implicitUnwrappedOptional(.typeName("Value")))
            e.resolvedType = .implicitUnwrappedOptional(.typeName("Value"))
            e.expectedType = .typeName("Value")
            return e
        }
        let exp =
            Expression.identifier("a").typed(.typeName("Value")).assignment(op: .assign, rhs: rhsMaker())
        
        assertTransform(
            // a = self.value
            statement: Statement.expression(exp),
            // a = self.value
            into: Statement.expression(Expression.identifier("a").assignment(op: .assign, rhs: rhsMaker()))
        ); assertDidNotNotifyChange()
    }
}
