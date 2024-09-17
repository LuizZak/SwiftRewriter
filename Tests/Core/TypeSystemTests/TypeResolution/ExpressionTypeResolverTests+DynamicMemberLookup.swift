import XCTest
import SwiftAST
import KnownType
import TestCommons

@testable import TypeSystem

class ExpressionTypeResolverTests_DynamicMemberLookup: XCTestCase {
    func testResolveDynamicMemberLookup() {
        let type = KnownTypeBuilder(typeName: "A")
            .addingAttribute(.dynamicMemberLookup)
            .subscription(
                parameters: [
                    .init(label: "dynamicMember", name: "member", type: .string)
                ],
                returnType: .int
            )
            .build()
        let exp: SwiftAST.Expression = .identifier("a").dot("unknownMember")

        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingType(type)
            .definingLocal(name: "a", type: .typeName("A"))
            .resolve()
            .thenAssertExpression(resolvedAs: .int)
    }

    func testResolveDynamicMemberLookup_favorsExistingMembersInType() {
        let type = KnownTypeBuilder(typeName: "A")
            .addingAttribute(.dynamicMemberLookup)
            .property(named: "property", type: .double)
            .field(named: "field", type: .bool)
            .method(named: "method")
            .subscription(
                parameters: [
                    .init(label: "dynamicMember", name: "member", type: .string)
                ],
                returnType: .int
            )
            .build()

        let stmt: CompoundStatement = [
            .expression(.identifier("a").dot("property")),
            .expression(.identifier("a").dot("field")),
            .expression(.identifier("a").dot("method")),
            .expression(.identifier("a").dot("unknown")),
        ]

        startScopedTest(with: stmt, sut: ExpressionTypeResolver())
            .definingType(type)
            .definingLocal(name: "a", type: .typeName("A"))
            .resolve()
            .thenAssertExpression(
                at: \.statements[0].asExpressions?.expressions[0],
                resolvedAs: .double
            )
            .thenAssertExpression(
                at: \.statements[1].asExpressions?.expressions[0],
                resolvedAs: .bool
            )
            .thenAssertExpression(
                at: \.statements[2].asExpressions?.expressions[0],
                resolvedAs: .block(returnType: .void, parameters: [])
            )
            .thenAssertExpression(
                at: \.statements[3].asExpressions?.expressions[0],
                resolvedAs: .int
            )
    }

    func testResolveDynamicMemberLookup_respectsStaticModifier() {
        let type = KnownTypeBuilder(typeName: "A")
            .addingAttribute(.dynamicMemberLookup)
            .subscription(
                parameters: [
                    .init(label: "dynamicMember", name: "member", type: .string)
                ],
                returnType: .int
            )
            .subscription(
                parameters: [
                    .init(label: "dynamicMember", name: "member", type: .string)
                ],
                returnType: .double,
                isStatic: true
            )
            .build()

        let stmt: CompoundStatement = [
            .expression(.identifier("a").dot("unknown")),
            .expression(.identifier("A").dot("unknown")),
        ]

        startScopedTest(with: stmt, sut: ExpressionTypeResolver())
            .definingType(type)
            .definingLocal(name: "a", type: .typeName("A"))
            .resolve()
            .thenAssertExpression(
                at: \.statements[0].asExpressions?.expressions[0],
                resolvedAs: .int
            )
            .withExpression(at: \.statements[0].asExpressions?.expressions[0]) { exp in
                let member = exp?.asPostfix?.op

                Asserter(object: member)
                    .assertNotNil()?
                    .asserter(forKeyPath: \.definition) { member in
                        member.assertNotNil()?
                            .assert(isOfType: KnownSubscript.self)
                    }
            }
            .thenAssertExpression(
                at: \.statements[1].asExpressions?.expressions[0],
                resolvedAs: .double
            )
            .withExpression(at: \.statements[1].asExpressions?.expressions[0]) { exp in
                let member = exp?.asPostfix?.op

                Asserter(object: member)
                    .assertNotNil()?
                    .asserter(forKeyPath: \.definition) { member in
                        member.assertNotNil()?
                            .assert(isOfType: KnownSubscript.self)
                    }
            }
    }

    func testResolveDynamicMemberLookup_favorsExistingMembersInSuperTypes() {
        let superType = KnownTypeBuilder(typeName: "B")
            .property(named: "property", type: .double)
            .build()
        let type = KnownTypeBuilder(typeName: "A")
            .addingAttribute(.dynamicMemberLookup)
            .settingSupertype(superType)
            .subscription(
                parameters: [
                    .init(label: "dynamicMember", name: "member", type: .string)
                ],
                returnType: .int
            )
            .build()
        let exp: SwiftAST.Expression = .identifier("a").dot("property")

        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingType(superType)
            .definingType(type)
            .definingLocal(name: "a", type: .typeName("A"))
            .resolve()
            .thenAssertExpression(resolvedAs: .double)
    }

    func testResolveDynamicMemberLookup_detectsTypeAliasesForMemberParameter() {
        let type = KnownTypeBuilder(typeName: "A")
            .addingAttribute(.dynamicMemberLookup)
            .subscription(
                parameters: [
                    .init(label: "dynamicMember", name: "member", type: "StringTypeAlias")
                ],
                returnType: .int
            )
            .build()
        let exp: SwiftAST.Expression = .identifier("a").dot("unknownMember")

        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingType(type)
            .definingTypeAlias("StringTypeAlias", type: .string)
            .definingLocal(name: "a", type: .typeName("A"))
            .resolve()
            .thenAssertExpression(resolvedAs: .int)
    }

    func testResolveDynamicMemberLookup_ignoresIfNotDecoratedByAttribute() {
        let type = KnownTypeBuilder(typeName: "A")
            .subscription(
                parameters: [
                    .init(label: "dynamicMember", name: "member", type: .string)
                ],
                returnType: .int
            )
            .build()
        let exp: SwiftAST.Expression = .identifier("a").dot("unknownMember")

        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingType(type)
            .definingLocal(name: "a", type: .typeName("A"))
            .resolve()
            .thenAssertExpression(resolvedAs: .errorType)
    }

    func testResolveDynamicMemberLookup_ignoresIfNoSuitableSubscriptIsFound() {
        let type = KnownTypeBuilder(typeName: "A")
            .addingAttribute(.dynamicMemberLookup)
            .subscription(
                parameters: [
                    .init(label: nil, name: "dynamicMember", type: .string)
                ],
                returnType: .int
            )
            .subscription(
                parameters: [
                    .init(label: "dynamicMember", name: "member", type: "AnUnknownType")
                ],
                returnType: .int
            )
            .subscription(
                parameters: [
                    .init(name: "other", type: .string)
                ],
                returnType: .double
            )
            .build()
        let exp: SwiftAST.Expression = .identifier("a").dot("unknownMember")

        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .definingType(type)
            .definingLocal(name: "a", type: .typeName("A"))
            .resolve()
            .thenAssertExpression(resolvedAs: .errorType)
    }
}

// MARK: - Test Building Helpers

extension XCTestCase {
    fileprivate func startScopedTest<T: Statement>(with stmt: T, sut: ExpressionTypeResolver)
        -> StatementTypeTestBuilder<T>
    {
        return StatementTypeTestBuilder(testCase: self, sut: sut, statement: stmt)
    }

    fileprivate func startScopedTest<T: SwiftAST.Expression>(with exp: T, sut: ExpressionTypeResolver)
        -> ExpressionTypeTestBuilder<T>
    {
        return ExpressionTypeTestBuilder(testCase: self, sut: sut, expression: exp)
    }

    fileprivate func assertResolve(
        _ exp: SwiftAST.Expression,
        expect type: SwiftType?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(resolvedAs: type, file: file, line: line)
    }

    fileprivate func assertExpects(
        _ exp: SwiftAST.Expression,
        expect type: SwiftType?,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        startScopedTest(with: exp, sut: ExpressionTypeResolver())
            .resolve()
            .thenAssertExpression(expectsType: type, file: file, line: line)
    }
}
