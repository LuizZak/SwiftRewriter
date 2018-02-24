import XCTest
import SwiftRewriterLib
import SwiftAST

class ExpressionTypeResolverTests: XCTestCase {
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
        
        startScopedTest(with: exp)
            .definingLocal(name: "value", type: .array(.string))
            .resolve()
            .thenAssertExpression(resolvedAs: .string)
    }
    
    func testSubscriptionInArrayWithNonInteger() {
        let exp = Expression.postfix(.identifier("value"), .subscript(.constant("Not an integer!")))
        
        startScopedTest(with: exp)
            .definingLocal(name: "value", type: .nsArray)
            .resolve()
            .thenAssertExpression(resolvedAs: .errorType)
    }
    
    func testSubscriptionInNSArray() {
        let exp = Expression.postfix(.identifier("value"), .subscript(.constant(1)))
        
        startScopedTest(with: exp)
            .definingLocal(name: "value", type: .nsArray)
            .resolve()
            .thenAssertExpression(resolvedAs: .optional(.anyObject))
    }
    
    func testSubscriptionInDictionary() {
        let exp = Expression.postfix(.identifier("value"), .subscript(.constant("abc")))
        
        startScopedTest(with: exp)
            .definingLocal(name: "value", type: .dictionary(key: .string, value: .string))
            .resolve()
            .thenAssertExpression(resolvedAs: .optional(.string))
    }
    
    func testSubscriptionInNSDictionary() {
        let exp = Expression.postfix(.identifier("value"), .subscript(.constant("abc")))
        
        startScopedTest(with: exp)
            .definingLocal(name: "value", type: .nsDictionary)
            .resolve()
            .thenAssertExpression(resolvedAs: .optional(.anyObject))
    }
    
    func testIdentifier() {
        let definition = CodeDefinition(name: "i", type: .int)
        
        startScopedTest(with: IdentifierExpression(identifier: "i"))
            .definingLocal(definition)
            .resolve()
            .thenAssertExpression(resolvedAs: .int)
            .thenAssert(with: { ident in
                XCTAssert(ident.definition?.local === definition)
            })
    }
    
    func testIdentifierLackingReference() {
        startScopedTest(with: IdentifierExpression(identifier: "i"))
            .resolve()
            .thenAssertExpression(resolvedAs: .errorType)
    }
    
    func testIdentifierTypePropagation() {
        let lhs = IdentifierExpression(identifier: "a")
        let rhs = IdentifierExpression(identifier: "b")
        let exp = Expression.binary(lhs: lhs, op: .add, rhs: rhs)
        
        startScopedTest(with: exp)
            .definingLocal(name: "a", type: .int)
            .definingLocal(name: "b", type: .int)
            .resolve()
            .thenAssertExpression(resolvedAs: .int)
    }
    
    func testDefinitionCollecting() {
        let stmt = Statement.variableDeclarations([
            StatementVariableDeclaration(identifier: "a", type: .int, ownership: .strong, isConstant: false, initialization: nil)
            ])
        
        startScopedTest(with: stmt)
            .thenAssertDefined(name: "a", type: .int)
    }
    
    func testMetatypeFetching() {
        // An expression `TypeName` should match the metatype resolution to
        // `TypeName`...
        startScopedTest(with:
                Expression.identifier("TypeName")
            )
            .definingEmptyType(named: "TypeName")
            .resolve()
            .thenAssertExpression(resolvedAs: .metatype(for: .typeName("TypeName")))
        
        // ...so should be `TypeName.self`...
        startScopedTest(with:
                Expression.postfix(.identifier("TypeName"), .member("self"))
            )
            .definingEmptyType(named: "TypeName")
            .resolve()
            .thenAssertExpression(resolvedAs: .metatype(for: .typeName("TypeName")))
        
        // ...or `TypeName.self.self`, and so on.
        startScopedTest(with:
            Expression.postfix(.postfix(.identifier("TypeName"), .member("self")), .member("self"))
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
        
        startScopedTest(with: exp)
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
        
        startScopedTest(with: exp)
            .definingEmptyType(named: "TypeName")
            .resolve()
            .thenAssertExpression(resolvedAs: .errorType)
    }
    
    func testForLoopArrayTypeResolving() {
        let exp = Expression.identifier("")
        exp.resolvedType = .array(.int)
        
        let stmt: ForStatement =
            .for(.identifier("i"), exp, body: [])
        
        startScopedTest(with: stmt)
            .thenAssertDefined(in: stmt.body, name: "i", type: .int)
    }
    
    func testForLoopArrayTypeResolving_NSArray() {
        // Iterating over an NSArray should produce `AnyObject` values
        
        let exp = Expression.identifier("")
        exp.resolvedType = .nsArray
        
        let stmt: ForStatement =
            .for(.identifier("i"), exp, body: [])
        
        startScopedTest(with: stmt)
            .thenAssertDefined(in: stmt.body, name: "i", type: .anyObject)
    }

    func testForLoopArrayTypeResolving_NSMutableArray() {
        // Iterating over an NSMutableArray should produce `AnyObject` values
        
        let exp = Expression.identifier("")
        exp.resolvedType = .typeName("NSMutableArray")
        
        let stmt: ForStatement =
            .for(.identifier("i"), exp, body: [])
        
        startScopedTest(with: stmt)
            .thenAssertDefined(in: stmt.body, name: "i", type: .anyObject)
    }
    
    func testForLoopArrayTypeResolving_NonArray() {
        // Iterating over non-array types should produce error types
        
        let exp = Expression.identifier("")
        exp.resolvedType = .typeName("ANonArrayType")
        
        let stmt: ForStatement =
            .for(.identifier("i"), exp, body: [])
        
        startScopedTest(with: stmt)
            .thenAssertDefined(in: stmt.body, name: "i", type: .errorType)
    }
}

// MARK: - Test Building Helpers

private extension ExpressionTypeResolverTests {
    func startScopedTest<T: Statement>(with stmt: T) -> StatementTypeTestBuilder<T> {
        return StatementTypeTestBuilder(testCase: self, statement: stmt)
    }
    
    func startScopedTest<T: Expression>(with exp: T) -> ExpressionTypeTestBuilder<T> {
        return ExpressionTypeTestBuilder(testCase: self, expression: exp)
    }
    
    func makeAnOptional(_ exp: Expression) -> Expression {
        let typeSystem = DefaultTypeSystem()
        let resolver = ExpressionTypeResolver(typeSystem: typeSystem)
        
        _=resolver.visitExpression(exp)
        
        exp.resolvedType = exp.resolvedType.map { .optional($0) }
        return exp
    }
    
    func assertResolve(_ exp: Expression, expect type: SwiftType?, file: String = #file, line: Int = #line) {
        startScopedTest(with: exp)
            .resolve()
            .thenAssertExpression(resolvedAs: type, file: file, line: line)
    }
}
