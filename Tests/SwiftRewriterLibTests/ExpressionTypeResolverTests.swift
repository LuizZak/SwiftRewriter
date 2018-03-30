import XCTest
import SwiftRewriterLib
import SwiftAST

class ExpressionTypeResolverTests: XCTestCase {
    func testStatementResolve() {
        let sut = ExpressionTypeResolver()
        
        let stmt = Statement.expression(.constant(1))
        
        _=sut.resolveTypes(in: stmt)
        
        XCTAssertEqual(stmt.asExpressions?.expressions[0].resolvedType, .int)
    }
    
    func testIntrinsicVariable() {
        startScopedTest(with: .identifier("self"), sut: ExpressionTypeResolver())
            .definingIntrinsic(name: "self", type: .typeName("MyType"))
            .resolve()
            .thenAssertExpression(resolvedAs: .typeName("MyType"))
    }
    
    func testLocalValuesTakesPrecedenceOverIntrinsicVariable() {
        startScopedTest(with: .identifier("self"), sut: ExpressionTypeResolver())
            .definingLocal(name: "self", type: .typeName("MyType"))
            .definingIntrinsic(name: "self", type: .errorType)
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
    
    func testCastWithTypeAlias() {
        startScopedTest(with: Expression.cast(.constant("a"), type: .typeName("A")),
                        sut: ExpressionTypeResolver())
            .definingTypeAlias("A", type: .int)
            .resolve()
            .thenAssertExpression(resolvedAs: .optional("A"))
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
    
    func testBitwiseBinaryDeducesResultAsOperandTypes() {
        func test(_ op: SwiftOperator, line: Int = #line) {
            assertResolve(.binary(lhs: .constant(1), op: op, rhs: .constant(2)),
                          expect: .int, line: line)
            
            assertResolve(.binary(lhs: Expression.constant(1).typed("UInt32"),
                                  op: op,
                                  rhs: Expression.constant(2).typed("UInt32")),
                          expect: .typeName("UInt32"), line: line)
            
            assertResolve(.binary(lhs: .constant(2.0), op: op, rhs: .constant(2.0)),
                          expect: nil, line: line) // Invalid operands
            
            assertResolve(.binary(lhs: .constant(true), op: op, rhs: .constant(2)),
                          expect: nil, line: line) // Invalid operands
        }
        
        test(.bitwiseAnd)
        test(.bitwiseOr)
        test(.bitwiseXor)
    }
    
    func testBitwiseBinaryDeducesResultAsOperandTypesWithTypealiases() {
        func test(_ op: SwiftOperator, line: Int = #line) {
            startScopedTest(with: .binary(lhs: Expression.constant(1).typed("GLenum"),
                                          op: op,
                                          rhs: Expression.constant(2).typed("GLenum")),
                            sut: ExpressionTypeResolver())
                .definingTypeAlias("GLenum", type: "UInt32")
                .resolve()
                .thenAssertExpression(resolvedAs: "GLenum")
        }
        
        test(.bitwiseAnd)
        test(.bitwiseOr)
        test(.bitwiseXor)
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
    
    func testNullCoalesce() {
        // Null-coalesce with non-null right-handside
        assertResolve(.binary(lhs: Expression.constant(1).typed(.optional(.int)),
                              op: .nullCoalesce,
                              rhs: .constant(1)),
                      expect: .int)
        
        // Null-coalesce with nullable right-handside
        assertResolve(.binary(lhs: Expression.constant(1).typed(.optional(.int)),
                              op: .nullCoalesce,
                              rhs: Expression.constant(1).typed(.optional(.int))),
                      expect: .optional(.int))
        
        // Nonnull type
        assertResolve(.binary(lhs: .constant(1), op: .nullCoalesce, rhs: .constant(1)),
                      expect: .int)
    }
    
    func testSizeOf() {
        let exp = Expression.sizeof(.identifier("a"))
        
        assertResolve(exp, expect: .int)
    }
    
    func testExpressionWithinSizeOf() {
        let exp = Expression.sizeof(.constant(0))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(at: \Expression.asSizeOf?.exp, resolvedAs: .int)
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
        let definition = CodeDefinition(variableNamed: "i", type: .int)
        
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
                return builder.constructor().build()
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
    
    func testForLoopArrayIteratorTypeResolving() {
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
                        .property(named: "b", type: .int)
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
                    builder.method(withSignature:
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
                .constructor()
                .property(named: "a",
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
        let exp = Expression.identifier("a").optional().dot("b")
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingType(named: "A") { builder in
                return
                    builder
                        .property(named: "b", type: .int)
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
    
    func testCallOptionalClosureType() {
        // closure()
        let exp = Expression.postfix(.identifier("closure"), .functionCall())
        exp.exp.resolvedType = .optional(.block(returnType: .void, parameters: []))
        
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "closure", type: .block(returnType: .void, parameters: []))
            .resolve()
            .thenAssertExpression(resolvedAs: .optional(.void))
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
    
    func testLocalLookupOnDeepNestedStatement() {
        // { { A.a } }
        let a = Expression.identifier("a")
        let stmt = Statement.compound([.compound([.expression(a)])])
        
        startScopedTest(with: stmt, sut: ExpressionTypeResolver())
            .definingLocal(name: "a", type: .int)
            .thenAssertDefined(localNamed: "a", type: .int)
        
        XCTAssertEqual(a.resolvedType, .int)
    }
    
    func testLooksDeepIntoBlocks() {
        var callbacks: [Expression] = []
        let makeCallback: () -> Expression = {
            let callback = Expression.identifier("callback").optional().call()
            callbacks.append(callback)
            return callback
        }
        
        let exp = Expression
            .identifier("self").dot("member").call()
            .dot("then").call([
                .unlabeled(
                    .block(parameters: [],
                           return: .void,
                           body: [
                            .expression(makeCallback())
                        ]))
                ])
            .dot("then").call([
                .unlabeled(
                    .block(parameters: [],
                           return: .void,
                           body: [
                            .expression(makeCallback())
                        ]))
                ])
            .dot("always").call([
                .unlabeled(
                    .block(parameters: [],
                           return: .void,
                           body: [
                            .expression(makeCallback())
                        ]))
                ])
        
        _=startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingLocal(name: "callback", type: .optional(.block(returnType: .void, parameters: [])))
            .resolve()
        
        XCTAssertEqual(callbacks[0].asPostfix?.resolvedType, .optional(.void))
        XCTAssertEqual(callbacks[1].asPostfix?.resolvedType, .optional(.void))
        XCTAssertEqual(callbacks[2].asPostfix?.resolvedType, .optional(.void))
    }
    
    func testChainedOptionalAccess() {
        let exp = Expression.identifier("a").optional().dot("b").dot("c")
        
        _=startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingType(named: "A") { builder in
                builder.property(named: "b", type: .typeName("B")).build()
            }.definingType(named: "B") { builder in
                builder.property(named: "c", type: .int).build()
            }.definingLocal(name: "a", type: .optional(.typeName("A")))
            .resolve()
            .thenAssertExpression(resolvedAs: .optional(.int))
    }
    
    func testVariableDeclarationTransmitsOptionalFromInitializerValue() {
        _=startScopedTest(with:
            Statement.variableDeclaration(identifier: "a",
                                          type: .implicitUnwrappedOptional(.string),
                                          initialization: Expression.identifier("value")),
                          sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .string)
            .thenAssertDefined(localNamed: "a", type: .string)
        
        _=startScopedTest(with:
            Statement.variableDeclaration(identifier: "a",
                                          type: .implicitUnwrappedOptional(.string),
                                          initialization: Expression.identifier("value")),
                          sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .optional(.string))
            .thenAssertDefined(localNamed: "a", type: .optional(.string))
        
        _=startScopedTest(with:
            Statement.variableDeclaration(identifier: "a",
                                          type: .implicitUnwrappedOptional(.string),
                                          initialization: Expression.identifier("value")),
                          sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .implicitUnwrappedOptional(.string))
            .thenAssertDefined(localNamed: "a", type: .optional(.string))
    }
    
    func testVariableDeclarationDoesNotTransmitOptionalFromInitializerValueForStructTypes() {
        _=startScopedTest(with:
            Statement.variableDeclaration(identifier: "a",
                                          type: .int,
                                          initialization: Expression.identifier("value")),
                          sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .int)
            .thenAssertDefined(localNamed: "a", type: .int)
        
        _=startScopedTest(with:
            Statement.variableDeclaration(identifier: "a",
                                          type: .int,
                                          initialization: Expression.identifier("value")),
                          sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .optional(.int))
            .thenAssertDefined(localNamed: "a", type: .int)
        
        _=startScopedTest(with:
            Statement.variableDeclaration(identifier: "a",
                                          type: .int,
                                          initialization: Expression.identifier("value")),
                          sut: ExpressionTypeResolver())
            .definingLocal(name: "value", type: .implicitUnwrappedOptional(.int))
            .thenAssertDefined(localNamed: "a", type: .int)
    }
    
    /// Tests that on an assignment expression, the right-hand-side of the expression
    /// is set to expect the type from the left-hand-side.
    func testAssignmentExpectedType() {
        _=startScopedTest(with:
            Expression.assignment(lhs: .identifier("a"), op: .assign, rhs: .constant(false)),
                          sut: ExpressionTypeResolver())
            .definingLocal(name: "a", type: .int)
            .resolve()
            .thenAssertExpression(at: \Expression.asAssignment?.rhs, expectsType: .int)
    }
    
    /// Tests invoking a known selector function sets the parameters to the properly
    /// expected types.
    func testFunctionParameterExpectedType() {
        _=startScopedTest(with:
            Expression.identifier("self").dot("a").call([.constant(false)]),
                          sut: ExpressionTypeResolver())
            .definingType(named: "A") { type in
                type.method(withSignature:
                        FunctionSignature(name: "a", parameters: [.init(label: "_", name: "a", type: .int)])
                    ).build()
            }
            .definingIntrinsic(name: "self", type: .typeName("A"))
            .resolve()
            .thenAssertExpression(at: \Expression.asPostfix?.functionCall?.arguments[0].expression, expectsType: .int)
    }
    
    /// Tests invoking a block sets the parameters to the properly expected
    /// types.
    func testBlockParameterExpectedType() {
        _=startScopedTest(with:
            Expression.identifier("a").call([.constant(false)]),
                          sut: ExpressionTypeResolver())
            .definingLocal(name: "a", type: SwiftType.block(returnType: .void, parameters: [.int]))
            .resolve()
            .thenAssertExpression(at: \Expression.asPostfix?.functionCall?.arguments[0].expression, expectsType: .int)
    }
    
    /// Tests invoking a constructor sets the parameters to the properly expected
    /// types.
    func testConstructorParameterExpectedType() {
        _=startScopedTest(with:
            Expression.identifier("A").call([.constant(false)]),
                          sut: ExpressionTypeResolver())
            .definingType(named: "A", with: { builder -> KnownType in
                builder
                    .constructor(withParameters: [.init(label: "_", name: "a", type: .int)])
                    .build()
            })
            .resolve()
            .thenAssertExpression(at: \Expression.asPostfix?.functionCall?.arguments[0].expression, expectsType: .int)
    }
    
    /// Tests ternary expressions `<exp> ? <ifTrue> : <ifFalse>` have `<exp>`
    /// properly set as expecting a boolean result type
    func testTernaryExpressionSetsExpectedTypeOfTestExpressionToBoolean() {
        _=startScopedTest(with:
            Expression.ternary(.identifier("a"), true: .constant(0), false: .constant(0)),
                          sut: ExpressionTypeResolver())
            .definingLocal(name: "a", type: .bool)
            .resolve()
            .thenAssertExpression(at: \Expression.asTernary?.exp, expectsType: .bool)
    }
    
    /// Tests expressions on `if` statements have expectedType set to boolean.
    func testIfStatementSetsExpectedTypeOfExpressionsToBoolean() {
        _=startScopedTest(with:
            Statement.if(.constant(0), body: [], else: nil),
                          sut: ExpressionTypeResolver())
            .thenAssertExpression(at: \Statement.asIf?.exp, expectsType: .bool)
    }
    
    /// Tests expressions on `while` statements have expectedType set to boolean.
    func testWhileStatementSetsExpectedTypeOfExpressionsToBoolean() {
        _=startScopedTest(with:
            Statement.while(.constant(0), body: []),
                          sut: ExpressionTypeResolver())
            .thenAssertExpression(at: \Statement.asWhile?.exp, expectsType: .bool)
    }
    
    /// On logical binary operations (i.e. `lhs || rhs`, `lhs && rhs`, etc.),
    /// expect the type resolver to mark both operands as expecting to be resolved
    /// as boolean types.
    func testLogicalBinaryExpressionSetsOperandsToBooleanExpectedTypes() {
        _=startScopedTest(with: Expression.binary(lhs: .constant(0), op: .and, rhs: .constant(0)),
                          sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(at: \Expression.asBinary?.lhs, expectsType: .bool)
            .thenAssertExpression(at: \Expression.asBinary?.rhs, expectsType: .bool)
        
        _=startScopedTest(with: Expression.binary(lhs: .constant(0), op: .or, rhs: .constant(0)),
                          sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(at: \Expression.asBinary?.lhs, expectsType: .bool)
            .thenAssertExpression(at: \Expression.asBinary?.rhs, expectsType: .bool)
    }
    
    /// Unary `!` operator must expect operand to be a boolean type.
    func testLogicalUnaryOperatorSetsOperandToBooleanExpectedType() {
        _=startScopedTest(with: Expression.unary(op: .negate, .constant(0)),
                          sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(at: \Expression.asUnary?.exp, expectsType: .bool)
    }
    
    /// Tests that on contexts where the expected type of a block literal type is
    /// set, try to infer the nullability of that block's parameters based on the
    /// expected type signature.
    func testPropagateBlockParameterNullabilityFromExpectedType() {
        let exp =
            Expression.block(
                parameters: [BlockParameter(name: "a", type: .implicitUnwrappedOptional(.typeName("A")))],
                return: .void,
                body: [])
        exp.expectedType = .block(returnType: .void, parameters: [.typeName("A")])
        let sut = ExpressionTypeResolver()
        
        _=sut.resolveType(exp)
        
        XCTAssertEqual(exp.parameters[0].type, .typeName("A"))
    }
    
    /// Tests propagation of expected block type to block expression doesn't alter
    /// parameters that are not implicitly unwrapped optionals.
    func testDontPropagateBlockParameterNullabilityFromExpectedTypeWhenNotImplicitlyUnwrapped() {
        let exp =
            Expression.block(
                parameters: [BlockParameter(name: "a", type: .optional(.typeName("A")))],
                return: .void,
                body: [])
        exp.expectedType = .block(returnType: .void, parameters: [.typeName("A")])
        let sut = ExpressionTypeResolver()
        
        _=sut.resolveType(exp)
        
        XCTAssertEqual(exp.parameters[0].type, .optional(.typeName("A")))
    }
    
    /// Tests propagation of expected block type to block expression doesn't alter
    /// parameters when the count of parameters between the expression and its
    /// expected block type mismatch.
    func testDontPropagateBlockParameterNullabilityFromExpectedTypeWhenParameterCountMismatches() {
        let exp =
            Expression.block(
                parameters: [BlockParameter(name: "a", type: .implicitUnwrappedOptional(.typeName("A")))],
                return: .void,
                body: [])
        exp.expectedType =
            .block(returnType: .void,
                   parameters: [.typeName("A"),
                                .typeName("B"),
                                ])
        let sut = ExpressionTypeResolver()
        
        _=sut.resolveType(exp)
        
        XCTAssertEqual(exp.parameters[0].type, .implicitUnwrappedOptional(.typeName("A")))
    }
    
    /// Tests proper deduction of optionality from an invocation of a function
    /// that returns an optional type
    func testOptionalReturnTypeFromCodeDefinition() {
        startScopedTest(with: Expression.identifier("a").call(),
                        sut: ExpressionTypeResolver())
            .definingLocal(CodeDefinition(functionSignature: FunctionSignature(name: "a", returnType: .optional(.string))))
            .resolve()
            .thenAssertExpression(resolvedAs: .optional(.string))
    }
    
    /// Tests resolving expressions like `(object?.width ?? 0.0)`
    func testResolveNullCoalesceOptionalsIntoConstantNumbers() {
        startScopedTest(with: Expression.identifier("a").optional().dot("width").binary(op: .nullCoalesce, rhs: .constant(0.0)),
                        sut: ExpressionTypeResolver())
            .definingType(named: "A", with: { type -> KnownType in
                type
                    .property(named: "width", type: .cgFloat)
                    .build()
            })
            .definingLocal(name: "a", type: .optional(.typeName("A")))
            .resolve()
            .thenAssertExpression(resolvedAs: .cgFloat)
    }
    
    /// Tests resolving expressions like `(object?.inner ?? nil)`
    func testResolveNullCoalesceOptionalsWithOptionalObjects() {
        startScopedTest(with: Expression.identifier("a").optional().dot("inner").binary(op: .nullCoalesce, rhs: .constant(.nil)),
                        sut: ExpressionTypeResolver())
            .definingType(named: "A", with: { type -> KnownType in
                type
                    .property(named: "inner", type: .optional(.typeName("A")))
                    .build()
            })
            .definingLocal(name: "a", type: .optional(.typeName("A")))
            .resolve()
            .thenAssertExpression(resolvedAs: .optional(.typeName("A")))
    }
    
    func testResolveNilConstantBasedOnExpectedType() {
        assertResolve(
            Expression.constant(.nil).typed(expected: .optional("NSObject")),
            expect: .optional("NSObject")
        )
    }
    
    /// When resolving the type of expressions that contain block literals, make
    /// sure we're able to propagate the expected return types of the block to
    /// return statements present within.
    func testSetsExpectedTypeForReturnExpressionInBlockExpression() {
        startScopedTest(
            //  { () -> Int in
            //      return 0
            //  }
            with: Expression.block(parameters: [],
                                   return: .int,
                                   body: [.return(.constant(0))]),
            sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(at: \Expression.asBlock?.body.statements[0].asReturn?.exp,
                                  expectsType: .int)
    }
    
    /// Make sure when we're handling a block type with a pointer return that we're
    /// able to correctly pass down the expected nullability type based on an existing
    /// expected type signature for the block, if present.
    func testSetsExpectedTypeForReturnExpressionInBlockExpressionTakingIntoAccountExpectedTypeOfBlockReturn() {
        startScopedTest(
            //  { () -> NSObject! in
            //      return 0
            //  }
            with: Expression.block(parameters: [],
                                   return: .implicitUnwrappedOptional(.typeName("NSObject")),
                                   body: [.return(.constant(0))])
                .typed(expected: SwiftType.block(returnType: .typeName("NSObject"), parameters: [])),
            sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(at: \Expression.asBlock?.body.statements[0].asReturn?.exp,
                                  expectsType: .typeName("NSObject")) // Should be non-nil!
    }
    
    /// When resolving the type of expressions that contain block literals, make
    /// sure we can correctly handle nested block literals.
    func testSetsExpectedTypeForReturnExpressionInBlockExpressionNested() {
        startScopedTest(
            //  { () -> Int in
            //      return 0
            //      { () -> Bool in
            //          return false
            //      }
            //      return 0
            //  }
            with: Expression
                .block(parameters: [],
                       return: .int,
                       body: [
                        .return(.constant(0)),
                        .expression(
                            Expression
                            .block(parameters: [],
                                   return: .bool,
                                   body: [
                                    .return(.constant(0))
                                ])),
                        .return(.constant(0))
                    ]),
            sut: ExpressionTypeResolver())
            .resolve()
            // First return
            .thenAssertExpression(at: \Expression.asBlock?.body.statements[0].asReturn?.exp,
                                  expectsType: .int)
            //
            .thenAssertExpression(at:
                \Expression.asBlock?
                    .body.statements[1]
                    .asExpressions?
                    .expressions[0]
                    .asBlock?.body.statements[0]
                    .asReturn?.exp,
                                  expectsType: .bool)
            .thenAssertExpression(at: \Expression.asBlock?.body.statements[2].asReturn?.exp,
                                  expectsType: .int)
    }
    
    func testResolvesTypeAliasWhenPropagatingExpectedTypeOfFunctionArguments() {
        startScopedTest(
            with: Expression
                .identifier("a")
                .typed(SwiftType.block(returnType: .void, parameters: ["GLenum"]))
                .call([Expression.constant(1).typed("GLint")]),
            sut: ExpressionTypeResolver())
            .definingTypeAlias("GLenum", type: "UInt32")
            .definingTypeAlias("GLint", type: "Int32")
            .resolve()
            .thenAssertExpression(
                at: \Expression.asPostfix?.op.asFuntionCall?.arguments[0].expression,
                expectsType: "GLenum")
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
    
    func assertResolve(_ exp: Expression, expect type: SwiftType?,
                       file: String = #file, line: Int = #line) {
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(resolvedAs: type, file: file, line: line)
    }
    
    func assertExpects(_ exp: Expression, expect type: SwiftType?,
                       file: String = #file, line: Int = #line) {
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(expectsType: type, file: file, line: line)
    }
}
