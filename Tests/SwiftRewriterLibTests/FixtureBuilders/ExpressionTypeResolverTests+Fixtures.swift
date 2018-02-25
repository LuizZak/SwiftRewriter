import XCTest
import SwiftRewriterLib
import SwiftAST

protocol ExpressionTestResolverTestFixture {
    var scope: CodeScopeStatement { get }
    var typeSystem: DefaultTypeSystem { get }
    
    /// Defines a variable on the test fixture's context
    func definingLocal(name: String, type: SwiftType) -> Self
    
    /// Defines a given local variable on the test fixture's context
    func definingLocal(_ definition: CodeDefinition) -> Self
    
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
        let definition = CodeDefinition(name: name, type: type)
        scope.definitions.recordDefinition(definition)
        
        return self
    }
    
    func definingLocal(_ definition: CodeDefinition) -> Self {
        scope.definitions.recordDefinition(definition)
        
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
}

extension ExpressionTypeResolverTests {
    final class StatementTypeTestBuilder<T: Statement>: ExpressionTestResolverTestFixture {
        let testCase: XCTestCase
        let sut: ExpressionTypeResolver
        let statement: T
        let typeSystem = DefaultTypeSystem()
        let scope: CodeScopeStatement
        var applied: Bool = false
        
        init(testCase: XCTestCase, sut: ExpressionTypeResolver, statement: T) {
            self.testCase = testCase
            self.sut = sut
            self.statement = statement
            scope = CompoundStatement(statements: [statement])
        }
        
        /// Asserts a definition was created on the top-most scope.
        @discardableResult
        func thenAssertDefined(localNamed name: String, type: SwiftType, file: String = #file, line: Int = #line) -> StatementTypeTestBuilder {
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
        func thenAssertDefined(in scope: CodeScopeStatement, localNamed name: String, type: SwiftType, file: String = #file, line: Int = #line) -> StatementTypeTestBuilder {
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
        func thenAssertDefined(localNamed name: String, storage: ValueStorage, file: String = #file, line: Int = #line) -> StatementTypeTestBuilder {
            return thenAssertDefined(in: scope, localNamed: name, storage: storage, file: file, line: line)
        }
        
        /// Asserts a definition was created on the given scope.
        @discardableResult
        func thenAssertDefined(in scope: CodeScopeStatement, localNamed name: String, storage: ValueStorage, file: String = #file, line: Int = #line) -> StatementTypeTestBuilder {
            // Make sure to apply definitions just before starting assertions
            if !applied {
                sut.typeSystem = typeSystem
                sut.ignoreResolvedExpressions = true
                
                _=statement.accept(sut)
                applied = true
            }
            
            guard let defined = scope.definitions.definition(named: name) else {
                testCase.recordFailure(withDescription: """
                    Failed to find expected local definition '\(name)' on scope.
                    """,
                    inFile: file, atLine: line, expected: false)
                
                return self
            }
            
            if defined.storage != storage {
                testCase.recordFailure(withDescription: """
                    Definition '\(name)' has different storage \(defined.storage) than \
                    expected storage \(storage)
                    """,
                    inFile: file, atLine: line, expected: false)
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
        let scope: CodeScopeStatement
        
        init(testCase: XCTestCase, sut: ExpressionTypeResolver, expression: T) {
            self.testCase = testCase
            self.sut = sut
            self.expression = expression
            scope = CompoundStatement(statements: [.expression(expression)])
        }
        
        init(testCase: XCTestCase, sut: ExpressionTypeResolver, expression: T, scope: CodeScopeStatement) {
            self.testCase = testCase
            self.sut = sut
            self.expression = expression
            self.scope = scope
        }
        
        func resolve() -> Asserter {
            sut.typeSystem = typeSystem
            sut.ignoreResolvedExpressions = true
            
            _=sut.visitExpression(expression)
            
            return Asserter(testCase: testCase, expression: expression, scope: scope)
        }
        
        /// Asserter for an ExpressionTypeTestBuilder
        class Asserter {
            let testCase: XCTestCase
            let expression: T
            let scope: CodeScopeStatement
            
            init(testCase: XCTestCase, expression: T, scope: CodeScopeStatement) {
                self.testCase = testCase
                self.expression = expression
                self.scope = scope
            }
            
            /// Makes an assertion the initial expression resolved to a given type
            @discardableResult
            func thenAssertExpression(resolvedAs type: SwiftType?, file: String = #file, line: Int = #line) -> Asserter {
                if expression.resolvedType != type {
                    testCase.recordFailure(withDescription: """
                        Expected expression to resolve as \(type?.description ?? "nil"), \
                        but received \(expression.resolvedType?.description ?? "nil")"
                        """,
                        inFile: file, atLine: line, expected: false)
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
