import Utils
import KnownType
import SwiftAST
import SwiftRewriterLib
import AntlrCommons
import Intentions
import TypeSystem
import JsParserAntlr
import TestCommons
import XCTest

@testable import JavaScriptFrontend

final class JavaScriptExpressionPassTestAdapter: ExpressionPassTestCaseAdapter {
    static var _state: JsParserState = JsParserState()

    typealias Lexer = JavaScriptLexer
    typealias Parser = JavaScriptParser

    init() {

    }

    func makeParser(for source: String) -> AntlrParser<Lexer, Parser> {
        return try! Self._state.makeMainParser(input: source)
    }

    func parseExpression(
        _ parser: Parser,
        source: Source,
        typeSystem: TypeSystem,
        intentionContext: FunctionBodyCarryingIntention?,
        container: StatementContainer?
    ) throws -> Expression? {
        let expression = try parser.singleExpression()

        let context = JavaScriptASTReaderContext(
            source: StringCodeSource(source: "", fileName: ".js"),
            typeSystem: typeSystem,
            typeContext: nil,
            comments: [],
            options: .default
        )

        let reader = JavaScriptExprASTReader(
            context: context,
            delegate: nil
        )

        return expression.accept(reader)
    }

    func parseStatement(
        _ parser: Parser,
        source: Source,
        typeSystem: TypeSystem,
        intentionContext: FunctionBodyCarryingIntention?,
        container: StatementContainer?
    ) throws -> Statement? {
        let stmt = try parser.statement()

        let expReader =
            JavaScriptExprASTReader(
                context: JavaScriptASTReaderContext(
                    source: StringCodeSource(source: "", fileName: ".js"),
                    typeSystem: typeSystem,
                    typeContext: nil,
                    comments: [],
                    options: .default
                ),
                delegate: nil
            )

        let reader = JavaScriptStatementASTReader(
            expressionReader: expReader,
            context: expReader.context,
            delegate: nil
        )

        return stmt.accept(reader)
    }
}

class JavaScriptASTCorrectorExpressionPassTests: ExpressionPassTestCase<JavaScriptExpressionPassTestAdapter> {
    override func setUp() {
        super.setUp()

        sutType = JavaScriptASTCorrectorExpressionPass.self
    }

    func testNullCoalesceOnLogicalOrExpression() {
        let expMaker = { Expression.identifier("a") }

        let exp = expMaker().binary(op: .or, rhs: .constant(0))
        exp.lhs.resolvedType = .optional(.int)
        exp.rhs.resolvedType = .int

        assertTransform(
            // a || 100
            expression: exp,
            // a ?? 100
            into: expMaker().binary(op: .nullCoalesce, rhs: .constant(0))
        )
    }

    func testNullCoalesceOnLogicalOrExpression_dontConvertOnBooleanOperands() {
        let expMaker = { Expression.identifier("a") }

        let exp = expMaker().binary(op: .or, rhs: .identifier("b"))
        exp.lhs.resolvedType = .bool
        exp.rhs.resolvedType = .bool
        
        assertNoTransform(
            // a || b
            expression: exp
        )
    }

    /// Tests inserting null-coalesces on optional numeric types on the left
    /// and right side of arithmetic operators
    func testNullCoalesceOnArithmeticOperators() {
        let expMaker = { Expression.identifier("a") }

        let exp = expMaker().binary(op: .add, rhs: .identifier("b"))
        exp.lhs.resolvedType = .optional(.int)

        assertTransform(
            // a + b
            expression: exp,
            // (a ?? 0) + b
            into:
                .parens(expMaker().binary(op: .nullCoalesce, rhs: .constant(0)))
                .binary(op: .add, rhs: .identifier("b"))
        )
    }

    /// Tests null-coalescing on deep nested binary expressions
    func testNullCoalesceOnNestedArithmeticOperators() {
        let lhsLhsMaker = { Expression.identifier("a") }
        let lhsMaker = { Expression.identifier("b") }

        let exp = (lhsLhsMaker().binary(op: .add, rhs: lhsMaker())).binary(
            op: .add,
            rhs: .identifier("c")
        )
        exp.lhs.asBinary?.lhs.resolvedType = .optional(.int)
        exp.lhs.asBinary?.rhs.resolvedType = .optional(.int)

        assertTransform(
            // a + b + c
            expression: exp,
            // (a ?? 0) + (b ?? 0) + c
            into:
                .parens(
                    lhsLhsMaker()
                        .binary(op: .nullCoalesce, rhs: .constant(0))
                )
                .binary(
                    op: .add,
                    rhs: .parens(lhsMaker().binary(op: .nullCoalesce, rhs: .constant(0)))
                )
                .binary(op: .add, rhs: .identifier("c"))
        )
    }

    /// Tests that arithmetic comparisons (<=, <, >=, >) where lhs and rhs are
    /// optional numeric values are coerced into default values using zeroes.
    func testNullCoalesceOnArithmeticComparison() {
        let expMaker = { Expression.identifier("a") }

        let exp = expMaker().binary(op: .lessThan, rhs: .identifier("b"))
        exp.lhs.resolvedType = .optional(.int)
        exp.rhs.resolvedType = .int

        assertTransform(
            // a < b
            expression: exp,
            // (a ?? 0) < b
            into:
                .parens(expMaker().binary(op: .nullCoalesce, rhs: .constant(0)))
                .binary(op: .lessThan, rhs: .identifier("b"))
        )
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
        )
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
            into:
                .binary(
                    lhs: .parens(lhsMaker().binary(op: .equals, rhs: .constant(true))),
                    op: .and,
                    rhs: rhsMaker()
                )
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
            into:
                .binary(
                    lhs: .parens(lhsMaker().binary(op: .unequals, rhs: .constant(.nil))),
                    op: .and,
                    rhs: .parens(rhsMaker().binary(op: .unequals, rhs: .constant(.nil)))
                )
        )
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
        )
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
                .unary(
                    op: .subtract,
                    .parens(expMaker().binary(op: .nullCoalesce, rhs: .constant(0)))
                )
        )
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
            into: .parens(expMaker().binary(op: .nullCoalesce, rhs: .identifier("A").call()))
        )
    }

    func testDontCorrectNonnullStructWithNullabilityUnspecifiedStructValue() {
        let str =
            KnownTypeBuilder(typeName: "A", kind: .struct)
            .constructor()
            .build()
        typeSystem.addType(str)
        let expMaker = { Expression.identifier("a") }
        let exp = expMaker()
        exp.resolvedType = .nullabilityUnspecified(.typeName("A"))
        exp.expectedType = .typeName("A")

        assertNoTransform(
            // a
            expression: exp
        )
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
                funcMaker(.parens(expMaker().binary(op: .nullCoalesce, rhs: .constant(0))))
            )
        )
    }

    /// Tests that base expressions (i.e. those that form a complete statement,
    /// that form a function argument, or a subscript operand) have their nullability
    /// corrected by default.
    func testAlwaysCorrectBaseExpressionsScalarTypesThatResolveAsNullInFunctionArguments() {
        let expMaker: () -> Expression = {
            .identifier("a")
                .call([
                    .identifier("b")
                        .typed(.optional(.int))
                        .typed(expected: .int)
                ])
        }

        let exp = expMaker()

        assertTransform(
            // { a(b) }
            statement: .expression(exp),
            // { a((b ?? 0)) }
            into:
                .expression(
                    .identifier("a")
                        .call([
                            .parens(.identifier("b").binary(op: .nullCoalesce, rhs: .constant(0)))
                        ])
                )
        )
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

        assertNoTransform(
            // { a?.b = 0 }
            statement: .expression(exp)
        )
    }

    /// Tests that base expressions (i.e. those that form a complete statement,
    /// that form a function argument, or a subscript operand) do not have their
    /// nullability corrected by default.
    func testDontCorrectBaseExpressionsScalarTypesForConstantExpressions() {
        let expMaker = { Expression.constant(0) }

        let exp = expMaker()
        exp.expectedType = .optional(.int)

        assertNoTransform(
            // { 0 }
            statement: .expression(exp)
        )
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
            expression:
                exp
                .dot("c", type: .swiftBlock(returnType: .int, parameters: [])).typed(
                    .optional(.swiftBlock(returnType: .int, parameters: []))
                )
                .call([], callableSignature: .swiftBlock(returnType: .int, parameters: [])).typed(
                    .optional(.int)
                ),
            // (a?.b ?? B()).c()
            into:
                .parens(expMaker().binary(op: .nullCoalesce, rhs: .identifier("B").call()))
                .dot("c").call()
        )

        XCTAssertEqual(res.resolvedType, .int)
        XCTAssertEqual(
            res.asPostfix?.exp.resolvedType,
            .swiftBlock(returnType: .int, parameters: [])
        )
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

        assertNoTransform(
            // a.b.c
            expression: exp.dot("c")
        )
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
        exp.exp.resolvedType = .nullabilityUnspecified(.typeName("A"))
        exp.op.returnType = .typeName("B")
        exp.resolvedType = .implicitUnwrappedOptional(.typeName("B"))
        exp.expectedType = .typeName("B")

        assertNoTransform(
            // a.b.c()
            expression:
                exp
                .dot("c", type: .swiftBlock(returnType: .int, parameters: []))
                .typed(.nullabilityUnspecified(.swiftBlock(returnType: .int, parameters: [])))
                .call([], callableSignature: .swiftBlock(returnType: .int, parameters: []))
                .typed(.nullabilityUnspecified(.int))
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

        let stmt = Statement.if(exp, body: [])

        assertTransform(
            // if (a.b) { }
            statement: stmt,
            // if (a.b == true) { }
            into: .if(
                expMaker().binary(op: .equals, rhs: .constant(true)),
                body: []
            )
        )
    }

    /// On boolean expressions that are unary-reversed ("!<exp>"), we simply drop
    /// the unary operator and plug in an inequality to true
    func testCorrectsIfStatementNegatedBooleanExpressions() {
        let expMaker = { Expression.identifier("a").dot("b") }

        let exp = Expression.unary(op: .negate, expMaker())
        exp.exp.resolvedType = .optional(.bool)
        exp.expectedType = .bool

        let stmt = Statement.if(exp, body: [])

        assertTransform(
            // if !a.b { }
            statement: stmt,
            // if (a.b != true) { }
            into: .if(
                .parens(expMaker().binary(op: .unequals, rhs: .constant(true))),
                body: []
            )
        )
    }

    /// In Objective-C, numbers can be used in place of an if expression statement,
    /// and the expression evaluates to true if the number is different from 0
    func testCorrectsIfStatementWithNumericExpression() {
        let expMaker = { Expression.identifier("num") }

        let exp = expMaker()
        exp.resolvedType = .int
        exp.expectedType = .bool

        let stmt = Statement.if(exp, body: [])

        assertTransform(
            // if (num) { }
            statement: stmt,
            // if (num != 0) { }
            into: .if(
                expMaker().binary(op: .unequals, rhs: .constant(0)),
                body: []
            )
        )
    }

    /// Negated numeric expressions simply compare as equals to zero.
    func testCorrectsIfStatementWithNegatedNumericExpression() {
        let expMaker = { Expression.unary(op: .negate, .identifier("num")) }

        let exp = expMaker()
        exp.exp.resolvedType = .int
        exp.expectedType = .bool

        let stmt = Statement.if(exp, body: [])

        assertTransform(
            // if !num { }
            statement: stmt,
            // if (num == 0) { }
            into: .if(
                .parens(.identifier("num").binary(op: .equals, rhs: .constant(0))),
                body: []
            )
        )
    }

    /// Same as above, but testing an optional value instead.
    func testCorrectsIfStatementWithNullableNumericExpressions() {
        let expMaker = { Expression.identifier("num") }

        let exp = expMaker()
        exp.resolvedType = .optional(.implicitUnwrappedOptional(.int))
        exp.expectedType = .bool

        let stmt = Statement.if(exp, body: [])

        assertTransform(
            // if (num) { }
            statement: stmt,
            // if (num != 0) { }
            into: .if(
                expMaker().binary(op: .unequals, rhs: .constant(0)),
                body: []
            )
        )
    }

    /// For otherwise unknown optional expressions, replace check
    /// with an 'if-not-nil'-style check
    func testCorrectsIfStatementWithNullableValue() {
        let expMaker = { Expression.identifier("obj") }

        let exp = expMaker()
        exp.resolvedType = .optional(.typeName("NSObject"))
        exp.expectedType = .bool

        let stmt = Statement.if(exp, body: [])

        assertTransform(
            // if (obj) { }
            statement: stmt,
            // if (obj != nil) { }
            into: .if(
                expMaker().binary(op: .unequals, rhs: .constant(.nil)),
                body: []
            )
        )
    }

    /// For otherwise unknown optional expressions, replace check
    /// with an 'if-nil'-style check
    func testCorrectsIfStatementWithNegatedNullableValue() {
        let expMaker = { Expression.identifier("obj") }

        let exp = Expression.unary(op: .negate, expMaker())
        exp.exp.resolvedType = .optional(.typeName("NSObject"))
        exp.expectedType = .bool
        exp.exp.expectedType = .bool

        let stmt = Statement.if(exp, body: [])

        assertTransform(
            // if !obj { }
            statement: stmt,
            // if (obj == nil) { }
            into: .if(
                .parens(expMaker().binary(op: .equals, rhs: .constant(.nil))),
                body: []
            )
        )
    }

    /// For unknown typed expressions, perform no attempts to correct.
    func testDontCorrectUnknownExpressions() {
        let expMaker = { Expression.identifier("a").dot("b") }

        let exp = expMaker()
        exp.expectedType = .bool

        let stmt = Statement.if(exp, body: [])

        assertNoTransform(
            // if (a.b) { }
            statement: stmt
        )
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
            into: .while(
                expMaker().binary(op: .equals, rhs: .constant(true)),
                body: []
            )
        )
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
            into: .while(
                expMaker().binary(op: .unequals, rhs: .constant(0)),
                body: []
            )
        )
    }

    /// Same as above, but testing an optional value instead.
    func testCorrectsWhileStatementWithNullableNumericExpressions() {
        let expMaker = { Expression.identifier("num") }

        let exp = expMaker()
        exp.resolvedType = .optional(.implicitUnwrappedOptional(.int))
        exp.expectedType = .bool

        let stmt = Statement.while(exp, body: [])

        assertTransform(
            // while (num) { }
            statement: stmt,
            // while (num != 0) { }
            into: .while(
                expMaker().binary(op: .unequals, rhs: .constant(0)),
                body: []
            )
        )
    }

    /// For otherwise unknown optional expressions, replace check
    /// with an 'while-not-nil'-style check
    func testCorrectsWhileStatementWithNullableValue() {
        let expMaker = { Expression.identifier("obj") }

        let exp = expMaker()
        exp.resolvedType = .optional(.typeName("NSObject"))
        exp.expectedType = .bool

        let stmt = Statement.while(exp, body: [])

        assertTransform(
            // while (obj) { }
            statement: stmt,
            // while (obj != nil) { }
            into: .while(
                expMaker().binary(op: .unequals, rhs: .constant(.nil)),
                body: []
            )
        )
    }

    /// For unknown typed expressions, perform no attempts to correct.
    func testDontCorrectUnknownExpressionsOnWhile() {
        let expMaker = { Expression.identifier("a").dot("b") }

        let exp = expMaker()
        exp.expectedType = .bool

        let stmt = Statement.while(exp, body: [])

        assertNoTransform(
            // while (a.b) { }
            statement: stmt
        )
    }

    /// Tests that the corrector is capable of doing simple if-let generations
    /// when a nullable value is passed to a non-null parameter of a function
    /// call expression.
    func testCorrectSimpleNullableValueInNonnullParameterToIfLet() {
        let funcType = SwiftType.swiftBlock(returnType: .void, parameters: [.typeName("A")])

        let exp =
            Expression
            .identifier("a").typed(funcType)
            .call(
                [.identifier("b").typed(.optional(.typeName("A")))],
                callableSignature: funcType
            )

        assertTransform(
            // a(b)
            statement: Statement.expression(exp),
            // if let b = b { a(b) }
            into: .ifLet(
                .identifier("b"),
                .identifier("b"),
                body: [
                    .expression(.identifier("a").call([.identifier("b")]))
                ]
            )
        )
    }

    /// Same as above, but as a member access.
    func testCorrectMemberAccessNullableValueInNonnullParameterToIfLet() {
        let funcType = SwiftType.swiftBlock(returnType: .void, parameters: [.typeName("A")])

        let exp =
            Expression
            .identifier("a").typed(funcType)
            .call(
                [.identifier("b").dot("c").typed(.optional(.typeName("A")))],
                callableSignature: funcType
            )

        assertTransform(
            // a(b.c)
            statement: Statement.expression(exp),
            // if let c = b.c { a(c) }
            into: .ifLet(
                .identifier("c"),
                .identifier("b").dot("c"),
                body: [
                    .expression(.identifier("a").call([.identifier("c")]))
                ]
            )
        )
    }

    /// Use the member name of a nullable-method invocation as the name of the
    /// pattern local variable.
    func testCorrectMethodInvocationNullableValueInNonnullParameterToIfLet() {
        let funcType = SwiftType.swiftBlock(returnType: .void, parameters: [.typeName("A")])

        let exp =
            Expression
            .identifier("a").typed(funcType)
            .call(
                [.identifier("b").dot("c").call().typed(.optional(.typeName("A")))],
                callableSignature: funcType
            )

        assertTransform(
            // a(b.c())
            statement: .expression(exp),
            // if let c = b.c() { a(c) }
            into: .ifLet(
                .identifier("c"),
                .identifier("b").dot("c").call(),
                body: [
                    .expression(.identifier("a").call([.identifier("c")]))
                ]
            )
        )
    }

    /// Correct method invocation returns as well by assigning the return value
    /// to a `value` local variable using an if-let.
    func testCorrectMethodReturnNullableValueInNonnullParameterToIfLet() {
        let funcTypeA = SwiftType.swiftBlock(returnType: .void, parameters: ["A"])
        let funcTypeB = SwiftType.swiftBlock(returnType: .optional("A"), parameters: [])

        let exp =
            Expression
            .identifier("a").typed(funcTypeA)
            .call(
                [Expression.identifier("b").typed(funcTypeB).call().typed(.optional("A"))],
                callableSignature: funcTypeA
            )

        assertTransform(
            // a(b())
            statement: .expression(exp),
            // if let value = b() { a(value) }
            into: .ifLet(
                .identifier("value"),
                .identifier("b").call(),
                body: [
                    .expression(.identifier("a").call([.identifier("value")]))
                ]
            )
        )
    }

    /// Tests non-null arguments with nullable scalar types are not corrected to
    /// an if-let, since this is dealt at another point in the AST corrector.
    func testDontCorrectSimpleNullableValueInNonnullParameterToIfLetIfArgumentIsNullableScalarType()
    {
        let funcType = SwiftType.swiftBlock(returnType: .void, parameters: [.int])

        let exp =
            Expression
            .identifier("a").typed(funcType)
            .call(
                [.identifier("b").dot("c").typed(.optional(.int))],
                callableSignature: funcType
            )

        assertTransform(
            // a(b.c)
            statement: .expression(exp),
            // a((b.c ?? 0))
            into: .expression(
                .identifier("a").typed(funcType)
                    .call(
                        [
                            .parens(
                                .identifier("b").dot("c").binary(
                                    op: .nullCoalesce,
                                    rhs: .constant(0)
                                )
                            )
                        ],
                        callableSignature: funcType
                    )
            )
        )
    }

    /// Make sure we don't correct passing a nullable value to a nullable parameter
    func testDontCorrectNullableValuesPassedToNullableParameters() {
        let funcType = SwiftType.swiftBlock(
            returnType: .void,
            parameters: [.optional(.typeName("A"))]
        )
        let expMaker: () -> Expression = {
            .identifier("a").typed(funcType)
                .call(
                    [.identifier("b").typed(.optional(.typeName("A")))],
                    callableSignature: funcType
                )
        }

        let exp = expMaker()

        assertNoTransform(
            // a(b)
            statement: .expression(exp)
        )
    }

    /// Test we don't require correcting implicitly unwrapped optionals on the
    /// rhs of an assignment
    func testDontCorrectImplicitlyUnwrappedOptionalRightHandSideOnAssignment() {
        let type =
            KnownTypeBuilder(typeName: "Value", kind: .struct)
            .constructor()
            .build()
        typeSystem.addType(type)
        let rhsMaker: () -> Expression = {
            return
                .identifier("self")
                .dot("value", type: .nullabilityUnspecified("Value"))
                .typed(expected: .nullabilityUnspecified("Value"))
        }
        let exp =
            Expression
            .identifier("a").typed("Value").assignment(op: .assign, rhs: rhsMaker())

        assertNoTransform(
            // a = self.value
            statement: .expression(exp)
        )
    }

    func testCorrectExpressionsWithExpectedTypeDifferentThanTheirResolvedType() {
        let valueType =
            KnownTypeBuilder(typeName: "Value", kind: .struct)
            .constructor()
            .build()
        typeSystem.addType(valueType)
        let expMaker = {
            Expression
                .identifier("a")
                .typed(.optional("Value"))
                .typed(expected: .int)
        }

        let exp = expMaker()

        assertTransform(
            // a
            expression: exp,
            // (a ?? Value())
            into: .parens(expMaker().binary(op: .nullCoalesce, rhs: .identifier("Value").call()))
        )
    }

    func testDontRemoveNullableAccessFromCastExpressions() {
        assertNoTransform(
            expression: .identifier("exp").casted(to: .string).optional().dot("count")
        )
    }

    func testCastDifferentNumericTypesInArithmeticOperations() {
        // CGFloat, Int -> CGFloat, CGFloat(Int)
        assertTransform(
            expression:
                .binary(
                    lhs: .identifier("a").typed(.cgFloat),
                    op: .add,
                    rhs: .identifier("b").typed(.int)
                ),
            into:
                .binary(
                    lhs: .identifier("a"),
                    op: .add,
                    rhs: .identifier("CGFloat").call([.identifier("b")])
                )
        )

        // Int, CGFloat -> CGFloat(Int), CGFloat
        assertTransform(
            expression:
                .binary(
                    lhs: .identifier("a").typed(.int),
                    op: .add,
                    rhs: .identifier("b").typed(.cgFloat)
                ),
            into:
                .binary(
                    lhs: .identifier("CGFloat").call([.identifier("a")]),
                    op: .add,
                    rhs: .identifier("b")
                )
        )

        // Int64, Int32 -> Int64, Int64(Int32)
        assertTransform(
            expression:
                .binary(
                    lhs: .identifier("a").typed("Int64"),
                    op: .add,
                    rhs: .identifier("b").typed("Int32")
                ),
            into:
                .binary(
                    lhs: .identifier("a"),
                    op: .add,
                    rhs: .identifier("Int64").call([.identifier("b")])
                )
        )

        // Int32, Int64 -> Int64(Int32), Int64
        assertTransform(
            expression:
                .binary(
                    lhs: .identifier("a").typed("Int32"),
                    op: .add,
                    rhs: .identifier("b").typed("Int64")
                ),
            into:
                .binary(
                    lhs: .identifier("Int64").call([.identifier("a")]),
                    op: .add,
                    rhs: .identifier("b")
                )
        )
    }

    func testNoCastForSameBitWidthNumerics() {
        // CGFloat, Double -> CGFloat, Double
        assertNoTransform(
            expression:
                .binary(
                    lhs: .identifier("a").typed(.cgFloat),
                    op: .add,
                    rhs: .identifier("b").typed(.double)
                )
        )

        // CGFloat, Double -> Double, CGFloat
        assertNoTransform(
            expression:
                .binary(
                    lhs: .identifier("a").typed(.double),
                    op: .add,
                    rhs: .identifier("b").typed(.cgFloat)
                )
        )

        // Int64, UInt64 -> Int64, UInt64
        assertNoTransform(
            expression:
                .binary(
                    lhs: .identifier("a").typed("Int64"),
                    op: .add,
                    rhs: .identifier("b").typed("UInt64")
                )
        )

        // UInt64, Int64 -> UInt64, Int64
        assertNoTransform(
            expression:
                .binary(
                    lhs: .identifier("a").typed("UInt64"),
                    op: .add,
                    rhs: .identifier("b").typed("Int64")
                )
        )
    }

    func testBreakSequentialAssignments() {
        assertTransform(
            statement:
                // a = b = c[0]
                .expressions([
                    .identifier("a")
                    .assignment(
                        op: .assign,
                        rhs: .identifier("b")
                        .assignment(
                            op: .assign,
                            rhs: .identifier("c")
                                .sub(.constant(0))
                        )
                    )
                ]),
            into:
                // b = c[0]
                // a = b
                .expressions([
                    .identifier("b")
                    .assignment(
                        op: .assign,
                        rhs: .identifier("c")
                            .sub(.constant(0))
                    ),
                    .identifier("a")
                    .assignment(
                        op: .assign,
                        rhs: .identifier("b")
                    ),
                ])
        )
    }

    func testBreakSequentialAssignments_chainedMemberAccess() {
        assertTransform(
            statement:
                // a = b.c.d = e
                .expressions([
                    .identifier("a")
                    .assignment(
                        op: .assign,
                        rhs: .identifier("b")
                        .dot("c")
                        .dot("d")
                        .assignment(
                            op: .assign,
                            rhs: .identifier("e")
                                .sub(.constant(0))
                        )
                    )
                ]),
            into:
                // b.c.d = e[0]
                // a = b.c.d
                .expressions([
                    .identifier("b")
                    .dot("c")
                    .dot("d")
                    .assignment(
                        op: .assign,
                        rhs: .identifier("e")
                            .sub(.constant(0))
                    ),
                    .identifier("a")
                    .assignment(
                        op: .assign,
                        rhs: .identifier("b")
                        .dot("c")
                        .dot("d")
                    ),
                ])
        )
    }

    func testBreakSequentialAssignmentsInVariableDeclaration() {
        assertTransform(
            statement:
                // {
                //     var a = b = c[0]
                // }
                .compound([
                    .variableDeclaration(
                        identifier: "a",
                        type: .any,
                        initialization:
                            .identifier("b")
                            .assignment(
                                op: .assign,
                                rhs: .identifier("c").sub(.constant(0))
                            )
                    )
                ]),
            into:
                // {
                //     b = c[0]
                //     var a = b
                // }
                .compound([
                    .expressions([
                        .identifier("b")
                        .assignment(
                            op: .assign,
                            rhs: .identifier("c")
                                .sub(.constant(0))
                        ),
                    ]),
                    .variableDeclaration(
                        identifier: "a",
                        type: .any,
                        initialization: .identifier("b")
                    )
                ])
        )
    }

    func testBreakSequentialAssignmentsInVariableDeclaration_chainedMemberAccess() {
        assertTransform(
            statement:
                // {
                //     var a = b.c.d = e[0]
                // }
                .compound([
                    .variableDeclaration(
                        identifier: "a",
                        type: .any,
                        initialization:
                            .identifier("b")
                            .dot("c")
                            .dot("d")
                            .assignment(
                                op: .assign,
                                rhs: .identifier("e").sub(.constant(0))
                            )
                    )
                ]),
            into:
                // {
                //     b.c.d = e[0]
                //     var a = b.c.d
                // }
                .compound([
                    .expressions([
                        .identifier("b")
                        .dot("c")
                        .dot("d")
                        .assignment(
                            op: .assign,
                            rhs: .identifier("e")
                                .sub(.constant(0))
                        ),
                    ]),
                    .variableDeclaration(
                        identifier: "a",
                        type: .any,
                        initialization: 
                            .identifier("b")
                            .dot("c")
                            .dot("d")
                    )
                ])
        )
    }

    func testDontBreakSequentialAssignmentsWithNonIdentifierLhs() {
        assertNoTransform(
            statement:
                // a = b[0] = c
                .expressions([
                    .identifier("a")
                    .assignment(
                        op: .assign,
                        rhs: .identifier("b")
                        .sub(.constant(0))
                        .assignment(
                            op: .assign,
                            rhs: .identifier("c")
                        )
                    )
                ])
        )

        assertNoTransform(
            statement:
                // a = b().c = d
                .expressions([
                    .identifier("a")
                    .assignment(
                        op: .assign,
                        rhs: .identifier("b")
                        .call()
                        .dot("c")
                        .assignment(
                            op: .assign,
                            rhs: .identifier("d")
                        )
                    )
                ])
        )
    }

    func testDontBreakSequentialAssignmentsInVariableDeclarationWithNonIdentifiers() {
        assertNoTransform(
            statement:
                // {
                //     var a = b().c = d[0]
                // }
                .compound([
                    .variableDeclaration(
                        identifier: "a",
                        type: .any,
                        initialization:
                            .identifier("b")
                            .call()
                            .dot("c")
                            .assignment(
                                op: .assign,
                                rhs: .identifier("d").sub(.constant(0))
                            )
                    )
                ])
        )
    }
}
