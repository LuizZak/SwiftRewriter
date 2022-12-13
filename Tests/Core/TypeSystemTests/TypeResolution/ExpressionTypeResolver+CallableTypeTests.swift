import XCTest
import SwiftAST
import KnownType
import TestCommons

@testable import TypeSystem

class ExpressionTypeResolver_CallableTypeTests: XCTestCase {
    func testResolveTypeInstanceCall() {
        let exp: Expression = .identifier("v").call()

        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingType(named: "MyType") { type in
                type.method(named: "callAsFunction", returning: .int)
                    .build()
            }
            .definingLocal(name: "v", type: .typeName("MyType"))
            .resolve()
            .thenAssertExpression(resolvedAs: .int)
    }

    func testResolveTypeInstanceCall_noCallAsFunctionPresent() {
        let exp: Expression = .identifier("v").call()

        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingType(named: "MyType") { type in
                type.build()
            }
            .definingLocal(name: "v", type: .typeName("MyType"))
            .resolve()
            .thenAssertExpression(resolvedAs: .errorType)
    }

    func testResolveCall() {
        let type = KnownTypeBuilder(typeName: "A")
            .method(named: "callAsFunction", returning: .int)
            .build()
        let typeSystem = TypeSystem()
        typeSystem.addType(type)

        let sut = CallableTypeResolver(typeSystem: typeSystem, type: type)

        let result = sut.resolveCall([])

        Asserter(object: result).inClosureUnconditional { result in
            result.assertCount(1)?.asserter(forItemAt: 0) { callable in
                callable[\.method]
                    .assert(isOfType: AnyObject.self)?
                    .assert(identical: type.knownMethods[0] as AnyObject)

                callable[\.resolvedType]
                    .assert(equals: .int)
            }
        }
    }
}

// MARK: - Test Building Helpers

extension XCTestCase {
    fileprivate func startScopedTest<T: Statement>(with stmt: T, sut: ExpressionTypeResolver)
        -> StatementTypeTestBuilder<T>
    {
        return StatementTypeTestBuilder(testCase: self, sut: sut, statement: stmt)
    }

    fileprivate func startScopedTest<T: Expression>(with exp: T, sut: ExpressionTypeResolver)
        -> ExpressionTypeTestBuilder<T>
    {
        return ExpressionTypeTestBuilder(testCase: self, sut: sut, expression: exp)
    }

    fileprivate func assertResolve(
        _ exp: Expression,
        expect type: SwiftType?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(resolvedAs: type, file: file, line: line)
    }

    fileprivate func assertExpects(
        _ exp: Expression,
        expect type: SwiftType?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(expectsType: type, file: file, line: line)
    }
}
