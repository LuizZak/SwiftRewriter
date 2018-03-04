import XCTest
import SwiftRewriterLib
import SwiftAST

class ExpressionTypeResolverTests: XCTestCase {
    func testStatementResolve() {
        let sut = ExpressionTypeResolver()
        
        let stmt = Statement.expression(.constant(1))
        
        sut.resolveTypes(in: stmt)
        
        XCTAssertEqual(stmt.asExpressions?.expressions[0].resolvedType, .int)
    }
    
    func testIntrinsicVariable() {
        startScopedTest(with: .identifier("self"), sut: ExpressionTypeResolver())
            .definingIntrinsic(name: "self", type: .typeName("MyType"))
            .resolve()
            .thenAssertExpression(resolvedAs: .typeName("MyType"))
    }
    
    func testIntrinsicVariableTakesPrecedenceOverLocal() {
        startScopedTest(with: .identifier("self"), sut: ExpressionTypeResolver())
            .definingLocal(name: "sef", type: .errorType)
            .definingIntrinsic(name: "self", type: .typeName("MyType"))
            .resolve()
            .thenAssertExpression(resolvedAs: .typeName("MyType"))
    }
    
    func testIntrinsicVariableTakesPrecedenceOverTypeName() {
        startScopedTest(with: .identifier("self"), sut: ExpressionTypeResolver())
            .definingEmptyType(named: "self")
            .definingIntrinsic(name: "self", type: .typeName("MyType"))
            .resolve()
            .thenAssertExpression(resolvedAs: .typeName("MyType"))
    }
    
    func testParens() {
        assertResolve(.parens(.constant(1)), expect: .int)
    }
    
    func testConstant() {
        assertResolve(.constant(1), expect: .int)
        assertResolve(.constant(1.1), expect: .float)
        assertResolve(.constant(false), expect: .bool)
        assertResolve(.constant("abc"), expect: .string)
        assertResolve(.constant(.nil), expect: .optional(.anyObject))
        assertResolve(.constant(.rawConstant("12.3-a,bc")), expect: .any)
    }
    
    func testUnary() {
        assertResolve(.unary(op: .subtract, .constant(1)), expect: .int)
        assertResolve(.unary(op: .subtract, .constant(1.0)), expect: .float)
        assertResolve(.unary(op: .add, .constant(1)), expect: .int)
        assertResolve(.unary(op: .add, .constant(1.0)), expect: .float)
        assertResolve(.unary(op: .negate, .constant(true)), expect: .bool)
        assertResolve(.unary(op: .subtract, .constant("abc")), expect: nil)
        assertResolve(.unary(op: .bitwiseNot, .constant(1)), expect: .int)
        assertResolve(.unary(op: .bitwiseNot, .constant("abc")), expect: nil)
    }
    
    func testCast() {
        assertResolve(Expression.cast(.constant(1), type: .int),
                      expect: .int) // Same-type casts don't need to result in optional
        
        assertResolve(Expression.cast(.constant(1), type: .float),
                      expect: .optional(.float))
        
        assertResolve(Expression.cast(.constant(1), type: .string),
                      expect: .optional(.string))
        
        assertResolve(Expression.cast(.identifier("Error Type"), type: .string),
                      expect: .errorType) // Propagate error types
    }
    
    func testAssignment() {
        // From C11 Standard, section 6.5.16:
        // An assignment expression has the value of the left operand after the assignment
        let exp = Expression.assignment(lhs: .identifier("a"), op: .assign, rhs: .constant(1))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "a", type: .int)
            .resolve()
            .thenAssertExpression(resolvedAs: .int)
    }
    
    func testBinary() {
        // Arithmetic
        assertResolve(.binary(lhs: .constant(1), op: .add, rhs: .constant(1)),
                      expect: .int)
        assertResolve(.binary(lhs: .constant(1), op: .multiply, rhs: .constant(1)),
                      expect: .int)
        assertResolve(.binary(lhs: .constant(1), op: .subtract, rhs: .constant(1)),
                      expect: .int)
        assertResolve(.binary(lhs: .constant(1), op: .divide, rhs: .constant(1)),
                      expect: .int)
        assertResolve(.binary(lhs: .constant(1.0), op: .add, rhs: .constant(1.0)),
                      expect: .float)
        assertResolve(.binary(lhs: .constant(false), op: .add, rhs: .constant(true)),
                      expect: nil) // Invalid operands
        
        // Comparison
        assertResolve(.binary(lhs: .constant(1.0), op: .lessThan, rhs: .constant(1.0)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(1.0), op: .lessThanOrEqual, rhs: .constant(1.0)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(1.0), op: .equals, rhs: .constant(1.0)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(1.0), op: .unequals, rhs: .constant(1.0)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(1.0), op: .greaterThan, rhs: .constant(1.0)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(1.0), op: .greaterThanOrEqual, rhs: .constant(1.0)),
                      expect: .bool)
        
        // Logical
        assertResolve(.binary(lhs: .constant(true), op: .and, rhs: .constant(true)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(true), op: .or, rhs: .constant(true)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(1), op: .and, rhs: .constant(2)),
                      expect: nil) // Invalid operands
    }
    
    func testBitwiseBinary() {
        func test(_ op: SwiftOperator, line: Int = #line) {
            assertResolve(.binary(lhs: .constant(1), op: op, rhs: .constant(2)),
                          expect: .int, line: line)
            assertResolve(.binary(lhs: .constant(2.0), op: op, rhs: .constant(2.0)),
                          expect: nil, line: line) // Invalid operands
            assertResolve(.binary(lhs: .constant(true), op: op, rhs: .constant(2)),
                          expect: nil, line: line) // Invalid operands
        }
        
        test(.bitwiseAnd)
        test(.bitwiseOr)
        test(.bitwiseXor)
        
        assertResolve(.binary(lhs: .constant(1), op: .bitwiseNot, rhs: .constant(2)),
                      expect: nil) // Bitwise not is a unary operator
    }
    
    func testTernary() {
        // Same-type on left and right result to that type
        assertResolve(.ternary(.constant(false),
                               true: .constant(1),
                               false: .constant(1)),
                      expect: .int)
        
        // Different types on left and right result on an error type
        assertResolve(.ternary(.constant(false),
                               true: .constant(1),
                               false: .constant(false)),
                      expect: .errorType)
    }
    
    func testNullCoallesce() {
        // Null-coallesce with non-null right-handside
        assertResolve(.binary(lhs: makeAnOptional(.constant(1)),
                              op: .nullCoallesce,
                              rhs: .constant(1)),
                      expect: .int)
        
        // Null-coallesce with nullable right-handside
        assertResolve(.binary(lhs: makeAnOptional(.constant(1)),
                              op: .nullCoallesce,
                              rhs: makeAnOptional(.constant(1))),
                      expect: .optional(.int))
        
        // Nonnull type
        assertResolve(.binary(lhs: .constant(1), op: .nullCoallesce, rhs: .constant(1)),
                      expect: .int)
    }
    
    func testArray() {
        assertResolve(.arrayLiteral([.constant(1), .constant(2), .constant(3)]),
                      expect: .array(.int))
        
        assertResolve(.arrayLiteral([.constant("abc"), .constant("def"), .constant("jhi")]),
                      expect: .array(.string))
        
        assertResolve(.arrayLiteral([.identifier("Error Type")]),
                      expect: .errorType) // Error types must propagate
        assertResolve(.arrayLiteral([]),
                      expect: .nsArray) // Empty arrays must resolve to NSArray
        assertResolve(.arrayLiteral([.constant("abc"), .constant(1)]),
                      expect: .nsArray) // Heterogeneous arrays must resolve to NSArray
    }
    
    func testDictionary() {
        assertResolve(.dictionaryLiteral([.constant(1): .constant(2)]),
                      expect: .dictionary(key: .int, value: .int))
        
        assertResolve(.dictionaryLiteral([.constant(1): .constant("abc"), .constant(1): .constant("abc")]),
                      expect: .dictionary(key: .int, value: .string))
        
        assertResolve(.dictionaryLiteral([.constant(1): .identifier("Error Type")]),
                      expect: .errorType) // Error types must propagate
        assertResolve(.dictionaryLiteral([.constant(1): .constant("abc"), .constant("<DIFFER>"): .constant("abc")]),
                      expect: .nsDictionary) // Heterogeneous dictionaries must resolve to NSDictionary
        assertResolve(.dictionaryLiteral([]),
                      expect: .nsDictionary) // Empty dictionaries must resolve to NSDictionary
    }
    
    func testSubscriptionInArray() {
        let exp = Expression.postfix(.identifier("value"), .subscript(.constant(1)))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .array(.string))
            .resolve()
            .thenAssertExpression(resolvedAs: .string)
    }
    
    func testSubscriptionInArrayWithNonInteger() {
        let exp = Expression.postfix(.identifier("value"), .subscript(.constant("Not an integer!")))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .nsArray)
            .resolve()
            .thenAssertExpression(resolvedAs: .errorType)
    }
    
    func testSubscriptionInNSArray() {
        let exp = Expression.postfix(.identifier("value"), .subscript(.constant(1)))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .nsArray)
            .resolve()
            .thenAssertExpression(resolvedAs: .anyObject)
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .typeName("NSMutableArray"))
            .resolve()
            .thenAssertExpression(resolvedAs: .anyObject)
    }
    
    func testSubscriptionInNSArrayWithNonInteger() {
        let exp = Expression.postfix(.identifier("value"), .subscript(.constant("Not an integer!")))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .nsArray)
            .resolve()
            .thenAssertExpression(resolvedAs: .errorType)
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .typeName("NSMutableArray"))
            .resolve()
            .thenAssertExpression(resolvedAs: .errorType)
    }
    
    func testSubscriptionInDictionary() {
        let exp = Expression.postfix(.identifier("value"), .subscript(.constant("abc")))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .dictionary(key: .string, value: .string))
            .resolve()
            .thenAssertExpression(resolvedAs: .optional(.string))
    }
    
    func testSubscriptionInNSDictionary() {
        let exp = Expression.postfix(.identifier("value"), .subscript(.constant("abc")))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .nsDictionary)
            .resolve()
            .thenAssertExpression(resolvedAs: .optional(.anyObject))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .typeName("NSMutableDictionary"))
            .resolve()
            .thenAssertExpression(resolvedAs: .optional(.anyObject))
    }
    
    func testIdentifier() {
        let definition = CodeDefinition(name: "i", type: .int, intention: nil)
        
        startScopedTest(with: IdentifierExpression(identifier: "i"), sut: ExpressionTypeResolver())
            .definingLocal(definition)
            .resolve()
            .thenAssertExpression(resolvedAs: .int)
            .thenAssert(with: { ident in
                XCTAssert(ident.definition?.local === definition)
            })
    }
    
    func testIdentifierLackingReference() {
        startScopedTest(with: IdentifierExpression(identifier: "i"), sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(resolvedAs: .errorType)
    }
    
    func testIdentifierTypePropagation() {
        let lhs = IdentifierExpression(identifier: "a")
        let rhs = IdentifierExpression(identifier: "b")
        let exp = Expression.binary(lhs: lhs, op: .add, rhs: rhs)
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "a", type: .int)
            .definingLocal(name: "b", type: .int)
            .resolve()
            .thenAssertExpression(resolvedAs: .int)
    }
    
    func testDefinitionCollecting() {
        let stmt = Statement.variableDeclarations([
            StatementVariableDeclaration(identifier: "a", type: .int, ownership: .strong, isConstant: false, initialization: nil)
            ])
        
        startScopedTest(with: stmt, sut: ExpressionTypeResolver())
            .thenAssertDefined(localNamed: "a", type: .int)
    }
    
    func testMetatypeFetching() {
        // An expression `TypeName` should match the metatype resolution to
        // `TypeName`...
        startScopedTest(with:
                Expression.identifier("TypeName"),
                sut: ExpressionTypeResolver()
            )
            .definingEmptyType(named: "TypeName")
            .resolve()
            .thenAssertExpression(resolvedAs: .metatype(for: .typeName("TypeName")))
        
        // ...so should be `TypeName.self`...
        startScopedTest(with:
                Expression.postfix(.identifier("TypeName"), .member("self")),
                sut: ExpressionTypeResolver()
            )
            .definingEmptyType(named: "TypeName")
            .resolve()
            .thenAssertExpression(resolvedAs: .metatype(for: .typeName("TypeName")))
        
        // ...or `TypeName.self.self`, and so on.
        startScopedTest(with:
                Expression.postfix(.postfix(.identifier("TypeName"), .member("self")), .member("self")),
                sut: ExpressionTypeResolver()
            )
            .definingEmptyType(named: "TypeName")
            .resolve()
            .thenAssertExpression(resolvedAs: .metatype(for: .typeName("TypeName")))
    }
    
    func testMetatypeFetchingOnNonMetatype() {
        // Invoking `.self` on an expression that is _not_ of Swift.metatype type
        // should return the same type as the expression, as well.
        assertResolve(.postfix(.constant(1), .member("self")),
                      expect: .int)
        
        assertResolve(.postfix(.identifier("Error Type"), .member("self")),
                      expect: .errorType)
    }
    
    func testConstructorInvocation() {
        // Invoking `TypeName()` for a type with an empty constructor should
        // return an instance of that type
        let exp = Expression.postfix(.identifier("TypeName"), .functionCall(arguments: []))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingType(named: "TypeName") { builder in
                return builder.addingConstructor().build()
            }
            .resolve()
            .thenAssertExpression(resolvedAs: .typeName("TypeName"))
    }
    
    func testConstructorInvocationOnTypeWithNoMatchingConstructor() {
        // Invoking `TypeName()` for a type _without_ an empty constructor should
        // return an .errorType
        let exp = Expression.postfix(.identifier("TypeName"), .functionCall(arguments: []))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingEmptyType(named: "TypeName")
            .resolve()
            .thenAssertExpression(resolvedAs: .errorType)
    }
    
    func testForLoopArrayTypeResolving() {
        let exp = Expression.identifier("")
        exp.resolvedType = .array(.int)
        
        let stmt: ForStatement =
            .for(.identifier("i"), exp, body: [])
        
        startScopedTest(with: stmt, sut: ExpressionTypeResolver())
            .thenAssertDefined(in: stmt.body, localNamed: "i", type: .int)
    }
    
    func testForLoopArrayTypeResolving_NSArray() {
        // Iterating over an NSArray should produce `AnyObject` values
        
        let exp = Expression.identifier("")
        exp.resolvedType = .nsArray
        
        let stmt: ForStatement =
            .for(.identifier("i"), exp, body: [])
        
        startScopedTest(with: stmt, sut: ExpressionTypeResolver())
            .thenAssertDefined(in: stmt.body, localNamed: "i", type: .anyObject)
    }

    func testForLoopArrayTypeResolving_NSMutableArray() {
        // Iterating over an NSMutableArray should produce `AnyObject` values
        
        let exp = Expression.identifier("")
        exp.resolvedType = .typeName("NSMutableArray")
        
        let stmt: ForStatement =
            .for(.identifier("i"), exp, body: [])
        
        startScopedTest(with: stmt, sut: ExpressionTypeResolver())
            .thenAssertDefined(in: stmt.body, localNamed: "i", type: .anyObject)
    }
    
    func testForLoopArrayTypeResolving_NonArray() {
        // Iterating over non-array types should produce error types
        
        let exp = Expression.identifier("")
        exp.resolvedType = .typeName("ANonArrayType")
        
        let stmt: ForStatement =
            .for(.identifier("i"), exp, body: [])
        
        startScopedTest(with: stmt, sut: ExpressionTypeResolver())
            .thenAssertDefined(in: stmt.body, localNamed: "i", type: .errorType)
    }
    
    func testMemberLookup() {
        // a.b
        let exp = Expression.postfix(.identifier("a"), .member("b"))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingType(named: "A") { builder in
                return
                    builder
                        .addingProperty(named: "b", type: .int)
                        .build()
            }
            .definingLocal(name: "a", type: .typeName("A"))
            .resolve()
            .thenAssertExpression(resolvedAs: .int)
    }
    
    func testMethodLookup() {
        // a.aMethod(1, secondParameter: 1)
        let exp = Expression.postfix(.postfix(.identifier("a"),
                                              .member("aMethod")),
                                     .functionCall(arguments: [
                                        .unlabeled(.constant(1)),
                                        .labeled("secondParam", .constant(1))
                                        ]))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingType(named: "A") { builder in
                return
                    builder.addingMethod(withSignature:
                        FunctionSignature(name: "aMethod",
                                          parameters: [
                                            ParameterSignature(label: "_", name: "arg0", type: .int),
                                            ParameterSignature(label: "secondParam", name: "arg1", type: .int)],
                                          returnType: .int
                        )
                    ).build()
            }
            .definingLocal(name: "a", type: .typeName("A"))
            .resolve()
            .thenAssertExpression(resolvedAs: .int)
    }
    
    func testStaticMemberLookup() {
        // A.a
        let asClass = Expression.postfix(.identifier("A"), .member("a"))
        
        let Atype =
            KnownTypeBuilder(typeName: "A")
                .addingConstructor()
                .addingProperty(named: "a",
                                storage: ValueStorage(type: .int,
                                                      ownership: .strong,
                                                      isConstant: false),
                                isStatic: true)
                .build()
        
        startScopedTest(with: asClass, sut: ExpressionTypeResolver())
            .definingType(Atype)
            .resolve()
            .thenAssertExpression(resolvedAs: .int)
        
        // Test that instance accessing doesn't work
        // A().a
        let asInstance =
            Expression.postfix(.postfix(.identifier("A"),
                                        .functionCall(arguments: [])),
                               .member("a"))
        
        startScopedTest(with: asInstance, sut: ExpressionTypeResolver())
            .definingType(Atype)
            .resolve()
            .thenAssertExpression(resolvedAs: .errorType)
    }
    
    func testOptionalAccess() {
        // a?.b
        let exp =
            Expression.postfix(.identifier("a"), .optionalAccess(.member("b")))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingType(named: "A") { builder in
                return
                    builder
                        .addingProperty(named: "b", type: .int)
                        .build()
            }
            .definingLocal(name: "a", type: .optional(.typeName("A")))
            .resolve()
            .thenAssertExpression(resolvedAs: .optional(.int))
    }
    
    func testCallClosureType() {
        // closure()
        let exp = Expression.postfix(.identifier("closure"), .functionCall())
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "closure", type: .block(returnType: .void, parameters: []))
            .resolve()
            .thenAssertExpression(resolvedAs: .void)
    }
    
    func testEnumCaseLookup() {
        // A.a
        let exp = Expression.postfix(.identifier("A"), .member("a"))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingEnum(named: "A", rawValueType: .int) { builder in
                return
                    builder
                        .createCase(name: "a")
                        .build()
            }
            .resolve()
            .thenAssertExpression(resolvedAs: .typeName("A"))
    }
}

// MARK: - Test Building Helpers

private extension ExpressionTypeResolverTests {
    func startScopedTest<T: Statement>(with stmt: T, sut: ExpressionTypeResolver) -> StatementTypeTestBuilder<T> {
        return StatementTypeTestBuilder(testCase: self, sut: sut, statement: stmt)
    }
    
    func startScopedTest<T: Expression>(with exp: T, sut: ExpressionTypeResolver) -> ExpressionTypeTestBuilder<T> {
        return ExpressionTypeTestBuilder(testCase: self, sut: sut, expression: exp)
    }
    
    func makeAnOptional(_ exp: Expression) -> Expression {
        let typeSystem = DefaultTypeSystem()
        let sut = ExpressionTypeResolver(typeSystem: typeSystem)
        
        _=sut.visitExpression(exp)
        
        exp.resolvedType = exp.resolvedType.map { .optional($0) }
        return exp
    }
    
    func assertResolve(_ exp: Expression, expect type: SwiftType?, file: String = #file, line: Int = #line) {
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(resolvedAs: type, file: file, line: line)
    }
}
