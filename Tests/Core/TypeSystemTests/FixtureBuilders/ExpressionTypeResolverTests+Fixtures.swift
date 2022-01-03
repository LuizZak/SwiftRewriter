import Commons
import Intentions
import KnownType
import SwiftAST
import TestCommons
import TypeSystem
import XCTest

protocol ExpressionTestResolverTestFixture {
    var scope: CodeScopeNode { get }
    var intrinsics: CodeScope { get }
    var typeSystem: TypeSystem { get }

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

    /// Registers a given compounded type within the type system
    func usingCompoundedType(_ type: CompoundedMappingType) -> Self

    /// Defines an empty type with a given name on this fixture's mock type system
    func definingEmptyType(named name: String) -> Self

    /// Defines a type using a provided known type builder closure.
    /// The closure should return the resulting `build()` return from the type
    /// builder.
    func definingType(named name: String, with block: (KnownTypeBuilder) -> KnownType) -> Self
}

extension ExpressionTestResolverTestFixture {
    func definingLocal(name: String, type: SwiftType) -> Self {
        let definition =
            CodeDefinition
            .forLocalIdentifier(
                name,
                type: type,
                isConstant: false,
                location: .setterValue
            )

        return definingLocal(definition)
    }

    func definingLocal(_ definition: CodeDefinition) -> Self {
        scope.definitions.recordDefinition(definition, overwrite: false)

        return self
    }

    func definingIntrinsic(name: String, type: SwiftType) -> Self {
        let definition =
            CodeDefinition
            .forGlobalVariable(name: name, isConstant: false, type: type)

        return definingIntrinsic(definition)
    }

    func definingIntrinsic(_ definition: CodeDefinition) -> Self {
        intrinsics.recordDefinition(definition, overwrite: false)

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

    func usingCompoundedType(_ type: CompoundedMappingType) -> Self {
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

    func definingEnum(
        named name: String,
        rawValueType: SwiftType,
        with block: (EnumTypeBuilder) -> KnownType
    ) -> Self {

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
        let typeSystem = TypeSystem()
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
        func thenAssertDefined(
            localNamed name: String,
            type: SwiftType,
            ownership: Ownership = .strong,
            isConstant: Bool = false,
            file: StaticString = #filePath,
            line: UInt = #line
        ) -> StatementTypeTestBuilder {
            let storage =
                ValueStorage(type: type, ownership: ownership, isConstant: isConstant)

            return
                thenAssertDefined(
                    localNamed: name,
                    storage: storage,
                    file: file,
                    line: line
                )
        }

        /// Asserts a definition was created on the given scope.
        @discardableResult
        func thenAssertDefined(
            in scope: CodeScopeNode,
            localNamed name: String,
            type: SwiftType,
            ownership: Ownership = .strong,
            isConstant: Bool = false,
            file: StaticString = #filePath,
            line: UInt = #line
        ) -> StatementTypeTestBuilder {
            let storage =
                ValueStorage(type: type, ownership: ownership, isConstant: isConstant)

            return
                thenAssertDefined(
                    in: scope,
                    localNamed: name,
                    storage: storage,
                    file: file,
                    line: line
                )
        }

        /// Asserts a definition was created on the top-most scope.
        @discardableResult
        func thenAssertDefined(
            localNamed name: String,
            storage: ValueStorage,
            file: StaticString = #filePath,
            line: UInt = #line
        ) -> StatementTypeTestBuilder {

            return thenAssertDefined(
                in: scope,
                localNamed: name,
                storage: storage,
                file: file,
                line: line
            )
        }
        
        /// Asserts a local function definition was created on the given scope.
        @discardableResult
        func thenAssertDefined(
            localFunction: FunctionSignature,
            file: StaticString = #filePath,
            line: UInt = #line
        ) -> StatementTypeTestBuilder {

            return thenAssertDefined(
                in: scope,
                localFunction: localFunction,
                file: file,
                line: line
            )
        }

        /// Asserts a local function definition was created on the given scope.
        @discardableResult
        func thenAssertDefined(
            in scope: CodeScopeNode,
            localFunction: FunctionSignature,
            file: StaticString = #filePath,
            line: UInt = #line
        ) -> StatementTypeTestBuilder {

            // Make sure to apply definitions just before starting assertions
            if !applied {
                sut.typeSystem = typeSystem
                sut.intrinsicVariables = intrinsics
                sut.ignoreResolvedExpressions = true

                _ = statement.accept(sut)
                applied = true
            }

            guard let defined = scope.definitions.firstDefinition(named: localFunction.name) else {
                XCTFail(
                    """
                    Failed to find expected local function '\(localFunction.name)' on scope.
                    """,
                    file: file,
                    line: line
                )

                return self
            }

            guard case .function(let signature) = defined.kind else {
                XCTFail(
                    """
                    Expected to find a function definition, but found \(defined.kind) \
                    instead.
                    """,
                    file: file,
                    line: line
                )

                return self
            }

            if localFunction != signature {
                XCTFail(
                    """
                    Definition '\(localFunction.name)' has different signature \(signature) \
                    than expected signature \(localFunction)
                    """,
                    file: file,
                    line: line
                )
            }

            return self
        }

        /// Asserts a definition was created on the given scope.
        @discardableResult
        func thenAssertDefined(
            in scope: CodeScopeNode,
            localNamed name: String,
            storage: ValueStorage,
            file: StaticString = #filePath,
            line: UInt = #line
        ) -> StatementTypeTestBuilder {

            // Make sure to apply definitions just before starting assertions
            if !applied {
                sut.typeSystem = typeSystem
                sut.intrinsicVariables = intrinsics
                sut.ignoreResolvedExpressions = true

                _ = statement.accept(sut)
                applied = true
            }

            guard let defined = scope.definitions.firstDefinition(named: name) else {
                XCTFail(
                    """
                    Failed to find expected local definition '\(name)' on scope.
                    """,
                    file: file,
                    line: line
                )

                return self
            }

            guard case .variable(_, let definedStorage) = defined.kind else {
                XCTFail(
                    """
                    Expected to find a variable local, but found \(defined.kind) \
                    instead.
                    """,
                    file: file,
                    line: line
                )

                return self
            }

            if definedStorage != storage {
                XCTFail(
                    """
                    Definition '\(name)' has different storage \(definedStorage) \
                    than expected storage \(storage)
                    """,
                    file: file,
                    line: line
                )
            }

            return self
        }

        /// Makes an assertion the expression contained at a given keypath was
        /// set to expect a given type
        @discardableResult
        func thenAssertExpression(
            at keyPath: KeyPath<T, Expression?>,
            expectsType type: SwiftType?,
            file: StaticString = #filePath,
            line: UInt = #line
        ) -> StatementTypeTestBuilder {

            // Make sure to apply definitions just before starting assertions
            if !applied {
                sut.typeSystem = typeSystem
                sut.intrinsicVariables = intrinsics
                sut.ignoreResolvedExpressions = true

                _ = statement.accept(sut)
                applied = true
            }

            guard let exp = statement[keyPath: keyPath] else {
                XCTFail(
                    """
                    Could not locale expression at keypath \(keyPath)
                    """,
                    file: file,
                    line: line
                )
                return self
            }

            if exp.expectedType != type {
                XCTFail(
                    """
                    Expected expression to resolve as expecting type \(type?.description ?? "nil"), \
                    but it expects \(exp.expectedType?.description ?? "nil")"
                    """,
                    file: file,
                    line: line
                )
            }

            return self
        }

        /// Makes an assertion the expression contained at a given keypath was
        /// resolved to a specified type
        @discardableResult
        func thenAssertExpression(
            at keyPath: KeyPath<T, Expression?>,
            resolvedAs type: SwiftType?,
            file: StaticString = #filePath,
            line: UInt = #line
        ) -> StatementTypeTestBuilder {

            // Make sure to apply definitions just before starting assertions
            if !applied {
                sut.typeSystem = typeSystem
                sut.intrinsicVariables = intrinsics
                sut.ignoreResolvedExpressions = true

                _ = statement.accept(sut)
                applied = true
            }

            guard let exp = statement[keyPath: keyPath] else {
                XCTFail(
                    """
                    Could not locale expression at keypath \(keyPath)
                    """,
                    file: file,
                    line: line
                )
                return self
            }

            if exp.resolvedType != type {
                XCTFail(
                    """
                    Expected expression to resolve as type \(type?.description ?? "nil"), \
                    but it resolved as \(exp.resolvedType?.description ?? "nil")"
                    """,
                    file: file,
                    line: line
                )
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
        let typeSystem = TypeSystem()
        let intrinsics: CodeScope = DefaultCodeScope()
        let scope: CodeScopeNode

        init(testCase: XCTestCase, sut: ExpressionTypeResolver, expression: T) {
            self.testCase = testCase
            self.sut = sut
            self.expression = expression
            scope = CompoundStatement(statements: [.expression(expression)])
        }

        init(
            testCase: XCTestCase,
            sut: ExpressionTypeResolver,
            expression: T,
            scope: CodeScopeNode
        ) {
            self.testCase = testCase
            self.sut = sut
            self.expression = expression
            self.scope = scope
        }

        func resolve() -> Asserter {
            sut.typeSystem = typeSystem
            sut.intrinsicVariables = intrinsics
            sut.ignoreResolvedExpressions = true

            _ = sut.visitExpression(expression)

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
            func thenAssertExpression(
                resolvedAs type: SwiftType?,
                file: StaticString = #filePath,
                line: UInt = #line
            ) -> Asserter {

                if expression.resolvedType != type {
                    XCTFail(
                        """
                        Expected expression to resolve as \(type?.description ?? "nil"), \
                        but received \(expression.resolvedType?.description ?? "nil")
                        """,
                        file: file,
                        line: line
                    )
                }

                return self
            }

            /// Makes an assertion the initial expression was set to expect a given
            /// type
            @discardableResult
            func thenAssertExpression(
                expectsType type: SwiftType?,
                file: StaticString = #filePath,
                line: UInt = #line
            ) -> Asserter {

                if expression.expectedType != type {
                    XCTFail(
                        """
                        Expected expression to resolve as expecting type \(type?.description ?? "nil"), \
                        but it expects \(expression.expectedType?.description ?? "nil")
                        """,
                        file: file,
                        line: line
                    )
                }

                return self
            }

            /// Makes an assertion the expression contained at a given keypath was
            /// resolved as having a specified type
            @discardableResult
            func thenAssertExpression(
                at keyPath: KeyPath<T, Expression?>,
                resolvedAs type: SwiftType?,
                file: StaticString = #filePath,
                line: UInt = #line
            ) -> Asserter {

                guard let exp = expression[keyPath: keyPath] else {
                    XCTFail(
                        """
                        Could not locale expression at keypath \(keyPath)
                        """,
                        file: file,
                        line: line
                    )
                    return self
                }

                if exp.resolvedType != type {
                    XCTFail(
                        """
                        Expected expression to resolve with type \(type?.description ?? "nil"), \
                        but it resolved as \(exp.resolvedType?.description ?? "nil")
                        """,
                        file: file,
                        line: line
                    )
                }

                return self
            }

            /// Makes an assertion the expression contained at a given keypath was
            /// set to expect a given type
            @discardableResult
            func thenAssertExpression(
                at keyPath: KeyPath<T, Expression?>,
                expectsType type: SwiftType?,
                file: StaticString = #filePath,
                line: UInt = #line
            ) -> Asserter {

                guard let exp = expression[keyPath: keyPath] else {
                    XCTFail(
                        """
                        Could not locale expression at keypath \(keyPath)
                        """,
                        file: file,
                        line: line
                    )
                    return self
                }

                if exp.expectedType != type {
                    XCTFail(
                        """
                        Expected expression to resolve as expecting type \(type?.description ?? "nil"), \
                        but it expects \(exp.expectedType?.description ?? "nil")
                        """,
                        file: file,
                        line: line
                    )
                }

                return self
            }

            /// Opens a block to expose the original expression and allow the user to
            /// perform custom assertions
            func thenAssert(with block: (T) -> Void) {
                block(expression)
            }
        }
    }
}
