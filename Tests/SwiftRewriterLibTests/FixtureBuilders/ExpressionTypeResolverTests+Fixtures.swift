import XCTest
import SwiftRewriterLib
import SwiftAST
import TestCommons

protocol ExpressionTestResolverTestFixture {
    var scope: CodeScopeNode { get }
    var intrinsics: CodeScope { get }
    var typeSystem: DefaultTypeSystem { get }
    
    /// Defines a variable on the test fixture's context
    func definingLocal(name: String, type: SwiftType) -> Self
    
    /// Defines a given local variable on the test fixture's context
    func definingLocal(_ definition: CodeDefinition) -> Self
    
    /// Defines an intrinsic variable for the context of the type resolver.
    /// Intrinsic variables should take precedence over any type/local during type
    /// resolving.
    func definingIntrinsic(_ definition: CodeDefinition) -> Self
    
    /// Defines a given type to the test fixture's mock type system
    func definingType(_ type: KnownType) -> Self
    
    /// Defines an empty type with a given name on this fixture's mock type system
    func definingEmptyType(named name: String) -> Self
    
    /// Defines a type using a provided known type builder closure.
    /// The closure should return the resulting `build()` return from the type
    /// builder.
    func definingType(named name: String, with block: (KnownTypeBuilder) -> KnownType) -> Self
}

extension ExpressionTestResolverTestFixture {
    func definingLocal(name: String, type: SwiftType) -> Self {
        let definition = CodeDefinition(variableNamed: name, type: type, intention: nil)
        
        return definingLocal(definition)
    }
    
    func definingLocal(_ definition: CodeDefinition) -> Self {
        scope.definitions.recordDefinition(definition)
        
        return self
    }
    
    func definingIntrinsic(name: String, type: SwiftType) -> Self {
        let definition = CodeDefinition(variableNamed: name, type: type, intention: nil)
        
        return definingIntrinsic(definition)
    }
    
    func definingIntrinsic(_ definition: CodeDefinition) -> Self {
        intrinsics.recordDefinition(definition)
        
        return self
    }
    
    func definingTypeAlias(_ alias: String, type: SwiftType) -> Self {
        typeSystem.addTypealias(aliasName: alias, originalType: type)
        
        return self
    }
    
    func definingType(_ type: KnownType) -> Self {
        typeSystem.addType(type)
        
        return self
    }
    
    func definingEmptyType(named name: String) -> Self {
        let builder = KnownTypeBuilder(typeName: name)
        return definingType(builder.build())
    }
    
    func definingType(named name: String, with block: (KnownTypeBuilder) -> KnownType) -> Self {
        let builder = KnownTypeBuilder(typeName: name)
        let type = block(builder)
        
        return definingType(type)
    }
    
    func definingEnum(named name: String, rawValueType: SwiftType, with block: (EnumTypeBuilder) -> KnownType) -> Self {
        let en = EnumGenerationIntention(typeName: name, rawValueType: rawValueType)
        let builder = EnumTypeBuilder(targetEnum: en)
        let type = block(builder)
        
        return definingType(type)
    }
}

extension ExpressionTypeResolverTests {
    final class StatementTypeTestBuilder<T: Statement>: ExpressionTestResolverTestFixture {
        let testCase: XCTestCase
        let sut: ExpressionTypeResolver
        let statement: T
        let typeSystem = DefaultTypeSystem()
        let scope: CodeScopeNode
        let intrinsics: CodeScope = DefaultCodeScope()
        var applied: Bool = false
        
        init(testCase: XCTestCase, sut: ExpressionTypeResolver, statement: T) {
            self.testCase = testCase
            self.sut = sut
            self.statement = statement
            scope = CompoundStatement(statements: [statement])
        }
        
        /// Asserts a definition was created on the top-most scope.
        @discardableResult
        func thenAssertDefined(localNamed name: String, type: SwiftType,
                               file: String = #file, line: Int = #line) -> StatementTypeTestBuilder {
            let storage =
                ValueStorage(type: type, ownership: .strong, isConstant: false)
            
            return
                thenAssertDefined(localNamed: name,
                                  storage: storage,
                                  file: file,
                                  line: line)
        }
        
        /// Asserts a definition was created on the given scope.
        @discardableResult
        func thenAssertDefined(in scope: CodeScopeNode, localNamed name: String,
                               type: SwiftType, file: String = #file, line: Int = #line) -> StatementTypeTestBuilder {
            let storage =
                ValueStorage(type: type, ownership: .strong, isConstant: false)
                
            return
                thenAssertDefined(in: scope,
                                  localNamed: name,
                                  storage: storage,
                                  file: file,
                                  line: line)
        }
        
        /// Asserts a definition was created on the top-most scope.
        @discardableResult
        func thenAssertDefined(localNamed name: String, storage: ValueStorage,
                               file: String = #file, line: Int = #line) -> StatementTypeTestBuilder {
            return thenAssertDefined(in: scope, localNamed: name, storage: storage,
                                     file: file, line: line)
        }
        
        /// Asserts a definition was created on the given scope.
        @discardableResult
        func thenAssertDefined(in scope: CodeScopeNode, localNamed name: String,
                               storage: ValueStorage, file: String = #file, line: Int = #line) -> StatementTypeTestBuilder {
            // Make sure to apply definitions just before starting assertions
            if !applied {
                sut.typeSystem = typeSystem
                sut.intrinsicVariables = intrinsics
                sut.ignoreResolvedExpressions = true
                
                _=statement.accept(sut)
                applied = true
            }
            
            guard let defined = scope.definitions.definition(named: name) else {
                testCase.recordFailure(withDescription: """
                    Failed to find expected local definition '\(name)' on scope.
                    """,
                    inFile: file, atLine: line, expected: true)
                
                return self
            }
            
            guard case .variable(_, let definedStorage) = defined.kind else {
                testCase.recordFailure(withDescription: """
                    Expected to find a variable local, but found \(defined.kind) \
                    instead.
                    """,
                    inFile: file, atLine: line, expected: true)
                
                return self
            }
            
            if definedStorage != storage {
                testCase.recordFailure(withDescription: """
                    Definition '\(name)' has different storage \(definedStorage) \
                    than expected storage \(storage)
                    """,
                    inFile: file, atLine: line, expected: true)
            }
            
            return self
        }
        
        
        /// Makes an assertion the expression contained at a given keypath was
        /// set to expect a given type
        @discardableResult
        func thenAssertExpression(at keyPath: KeyPath<Statement, Expression?>,
                                  expectsType type: SwiftType?, file: String = #file,
                                  line: Int = #line) -> StatementTypeTestBuilder {
            // Make sure to apply definitions just before starting assertions
            if !applied {
                sut.typeSystem = typeSystem
                sut.intrinsicVariables = intrinsics
                sut.ignoreResolvedExpressions = true
                
                _=statement.accept(sut)
                applied = true
            }
            
            
            guard let exp = statement[keyPath: keyPath] else {
                testCase.recordFailure(withDescription: """
                    Could not locale expression at keypath \(keyPath)
                    """,
                    inFile: file, atLine: line, expected: true)
                return self
            }
            
            if exp.expectedType != type {
                testCase.recordFailure(withDescription: """
                    Expected expression to resolve as expecting type \(type?.description ?? "nil"), \
                    but it expects \(exp.expectedType?.description ?? "nil")"
                    """,
                    inFile: file, atLine: line, expected: true)
            }
            
            return self
        }
    }
    
    /// Test builder for expression type resolver tests that require scope for expression
    /// resolving.
    final class ExpressionTypeTestBuilder<T: Expression>: ExpressionTestResolverTestFixture {
        let testCase: XCTestCase
        let sut: ExpressionTypeResolver
        let expression: T
        let typeSystem = DefaultTypeSystem()
        let intrinsics: CodeScope = DefaultCodeScope()
        let scope: CodeScopeNode
        
        init(testCase: XCTestCase, sut: ExpressionTypeResolver, expression: T) {
            self.testCase = testCase
            self.sut = sut
            self.expression = expression
            scope = CompoundStatement(statements: [.expression(expression)])
        }
        
        init(testCase: XCTestCase, sut: ExpressionTypeResolver, expression: T,
             scope: CodeScopeNode) {
            self.testCase = testCase
            self.sut = sut
            self.expression = expression
            self.scope = scope
        }
        
        func resolve() -> Asserter {
            sut.typeSystem = typeSystem
            sut.intrinsicVariables = intrinsics
            sut.ignoreResolvedExpressions = true
            
            _=sut.visitExpression(expression)
            
            return Asserter(testCase: testCase, expression: expression, scope: scope)
        }
        
        /// Asserter for an ExpressionTypeTestBuilder
        class Asserter {
            let testCase: XCTestCase
            let expression: T
            let scope: CodeScopeNode
            
            init(testCase: XCTestCase, expression: T, scope: CodeScopeNode) {
                self.testCase = testCase
                self.expression = expression
                self.scope = scope
            }
            
            /// Makes an assertion the initial expression resolved to a given type
            @discardableResult
            func thenAssertExpression(resolvedAs type: SwiftType?, file: String = #file,
                                      line: Int = #line) -> Asserter {
                if expression.resolvedType != type {
                    testCase.recordFailure(withDescription: """
                        Expected expression to resolve as \(type?.description ?? "nil"), \
                        but received \(expression.resolvedType?.description ?? "nil")"
                        """,
                        inFile: file, atLine: line, expected: true)
                }
                
                return self
            }
            
            /// Makes an assertion the initial expression was set to expect a given
            /// type
            @discardableResult
            func thenAssertExpression(expectsType type: SwiftType?, file: String = #file,
                                      line: Int = #line) -> Asserter {
                if expression.expectedType != type {
                    testCase.recordFailure(withDescription: """
                        Expected expression to resolve as expecting type \(type?.description ?? "nil"), \
                        but it expects \(expression.expectedType?.description ?? "nil")"
                        """,
                        inFile: file, atLine: line, expected: true)
                }
                
                return self
            }
            
            /// Makes an assertion the expression contained at a given keypath was
            /// set to expect a given type
            @discardableResult
            func thenAssertExpression(at keyPath: KeyPath<Expression, Expression?>,
                                      expectsType type: SwiftType?, file: String = #file,
                                      line: Int = #line) -> Asserter {
                
                guard let exp = expression[keyPath: keyPath] else {
                    testCase.recordFailure(withDescription: """
                        Could not locale expression at keypath \(keyPath)
                        """,
                        inFile: file, atLine: line, expected: true)
                    return self
                }
                
                if exp.expectedType != type {
                    testCase.recordFailure(withDescription: """
                        Expected expression to resolve as expecting type \(type?.description ?? "nil"), \
                        but it expects \(exp.expectedType?.description ?? "nil")"
                        """,
                        inFile: file, atLine: line, expected: true)
                }
                
                return self
            }
            
            /// Opens a block to expose the original expression and allow the user to
            /// perform custom assertions
            func thenAssert(with block: (T) -> ()) {
                block(expression)
            }
        }
    }
}
