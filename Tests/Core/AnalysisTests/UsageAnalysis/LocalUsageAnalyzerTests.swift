import Intentions
import KnownType
import SwiftAST
import TestCommons
import TypeSystem
import XCTest

@testable import Analysis

class LocalsUsageAnalyzerTests: XCTestCase {
    func testFindUsagesOfLocalVariable() {
        let body: CompoundStatement = [
            // var a: Int
            .variableDeclaration(
                identifier: "a",
                type: .int,
                initialization: nil
            ),
            // a
            .expression(
                Expression
                    .identifier("a")
            ),
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: TypeSystem())
        _ = typeResolver.resolveTypes(in: body)

        let sut = LocalUsageAnalyzer(typeSystem: TypeSystem())

        let usages = sut.findUsagesOf(localNamed: "a", in: .statement(body), intention: nil)

        XCTAssertEqual(usages.count, 1)
        XCTAssertEqual(usages[0].isReadOnlyUsage, true)
    }

    func testFindUsagesOfLocalVariableDetectingWritingUsages() {
        let body: CompoundStatement = [
            // var a: Int
            .variableDeclaration(
                identifier: "a",
                type: .int,
                initialization: nil
            ),
            // a
            .expression(
                Expression
                    .identifier("a")
            ),
            // a = 0
            .expression(
                Expression
                    .identifier("a")
                    .assignment(op: .assign, rhs: .constant(0))
            ),
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: TypeSystem())
        _ = typeResolver.resolveTypes(in: body)

        let sut = LocalUsageAnalyzer(typeSystem: TypeSystem())

        let usages = sut.findUsagesOf(localNamed: "a", in: .statement(body), intention: nil)

        XCTAssertEqual(usages.count, 2)
        XCTAssertEqual(usages[0].isReadOnlyUsage, true)
        XCTAssertEqual(usages[1].isReadOnlyUsage, false)
    }

    func testFindUsagesOfLocalVariableDetectingWritingUsagesOfPostfixType() {
        // Writing to a local's member or member-of-member should be detected
        // as a writing usage

        let body: CompoundStatement = [
            // var a: Int
            .variableDeclaration(
                identifier: "a",
                type: .int,
                initialization: nil
            ),
            // a.b = 0
            .expression(
                Expression
                    .identifier("a")
                    .dot("b")
                    .assignment(op: .assign, rhs: .constant(0))
            ),
            // a[0] = 0
            .expression(
                Expression
                    .identifier("a")
                    .sub(.constant(0))
                    .assignment(op: .assign, rhs: .constant(0))
            ),
            // a.b?.c = 0
            .expression(
                Expression
                    .identifier("a")
                    .dot("b")
                    .optional()
                    .dot("c")
                    .assignment(op: .assign, rhs: .constant(0))
            ),
            // a.b[0].c = 0
            .expression(
                Expression
                    .identifier("a")
                    .dot("b")
                    .sub(.constant(0))
                    .dot("c")
                    .assignment(op: .assign, rhs: .constant(0))
            ),
            //
            // Usages where we write to the result of a function call's member
            // should not result in a write access, since the function call return
            // is independent of the local variable's structure.
            //
            // a.b().c = 0
            .expression(
                Expression
                    .identifier("a")
                    .dot("b")
                    .call()
                    .dot("c")
                    .assignment(op: .assign, rhs: .constant(0))
            ),
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: TypeSystem())
        _ = typeResolver.resolveTypes(in: body)

        let sut = LocalUsageAnalyzer(typeSystem: TypeSystem())

        let usages = sut.findUsagesOf(localNamed: "a", in: .statement(body), intention: nil)

        XCTAssertEqual(usages.count, 5)
        XCTAssertEqual(usages[0].isReadOnlyUsage, false)
        XCTAssertEqual(usages[1].isReadOnlyUsage, false)
        XCTAssertEqual(usages[2].isReadOnlyUsage, false)
        XCTAssertEqual(usages[3].isReadOnlyUsage, false)
        XCTAssertEqual(usages[4].isReadOnlyUsage, true)
    }

    func testFindUsagesOfLocalVariableDetectingWritingUsagesOfPointerType() {
        let body: CompoundStatement = [
            // var a: Int
            .variableDeclaration(
                identifier: "a",
                type: .int,
                initialization: nil
            ),
            // f(a)
            .expression(
                Expression
                    .identifier("f")
                    .call([
                        .identifier("a")
                    ])
            ),
            // f(&a)
            .expression(
                Expression
                    .identifier("f")
                    .call([
                        Expression
                            .unary(
                                op: .bitwiseAnd,
                                .identifier("a")
                            )
                    ])
            ),
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: TypeSystem())
        _ = typeResolver.resolveTypes(in: body)

        let sut = LocalUsageAnalyzer(typeSystem: TypeSystem())

        let usages = sut.findUsagesOf(localNamed: "a", in: .statement(body), intention: nil)

        XCTAssertEqual(usages.count, 2)
        XCTAssertEqual(usages[0].isReadOnlyUsage, true)
        XCTAssertEqual(usages[1].isReadOnlyUsage, false)
    }

    func testFindUsagesOfLocalVariableDetectingWritingUsagesOfReferenceFields() {
        // Mutating fields of reference types embedded within value types should
        // not produce write usage references
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A", kind: .struct)
                .property(named: "b", type: "B")
                .property(named: "d", type: .int)
                .build()
        )
        typeSystem.addType(
            KnownTypeBuilder(typeName: "B", kind: .class)
                .property(named: "c", type: .int)
                .build()
        )

        let body: CompoundStatement = [
            // var a: A
            .variableDeclaration(
                identifier: "a",
                type: "A",
                initialization: nil
            ),
            // a.b.c = 0
            .expression(
                Expression
                    .identifier("a")
                    .dot("b")
                    .dot("c")
                    .assignment(op: .assign, rhs: .constant(0))
            ),
            // a.d = 0
            .expression(
                Expression
                    .identifier("a")
                    .dot("d")
                    .assignment(op: .assign, rhs: .constant(0))
            ),
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        _ = typeResolver.resolveTypes(in: body)

        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        let usages = sut.findUsagesOf(localNamed: "a", in: .statement(body), intention: nil)

        XCTAssertEqual(usages.count, 2)
        XCTAssertEqual(usages[0].isReadOnlyUsage, true)
        XCTAssertEqual(usages[1].isReadOnlyUsage, false)
    }

    func testFindUsagesOfLocalVariableDoesNotReportWritingUsagesWhenMutatingFieldsOfReferenceType()
    {
        // Mutating any field of a reference type local variable should not be
        // considered a variable writing usage.
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A", kind: .class)
                .property(named: "b", type: .int)
                .build()
        )

        let body: CompoundStatement = [
            // var a: A
            .variableDeclaration(
                identifier: "a",
                type: "A",
                initialization: nil
            ),
            // a.b = 0
            .expression(
                Expression
                    .identifier("a")
                    .dot("b")
                    .assignment(op: .assign, rhs: .constant(0))
            ),
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        _ = typeResolver.resolveTypes(in: body)

        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        let usages = sut.findUsagesOf(localNamed: "a", in: .statement(body), intention: nil)

        XCTAssertEqual(usages.count, 1)
        XCTAssertEqual(usages[0].isReadOnlyUsage, true)
    }

    func testFindUsagesOfLocalVariableDetectingMutatingCallsToValueType() {
        // Make sure we can properly detect calls of mutating functions on value-types
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A", kind: .struct)
                .method(named: "b", isMutating: true)
                .method(named: "c", isMutating: false)
                .build()
        )

        let body: CompoundStatement = [
            // var a: A
            .variableDeclaration(
                identifier: "a",
                type: "A",
                initialization: nil
            ),
            // a.b()
            .expression(
                Expression
                    .identifier("a")
                    .dot("b")
                    .call()
            ),
            // a.c()
            .expression(
                Expression
                    .identifier("a")
                    .dot("c")
                    .call()
            ),
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        _ = typeResolver.resolveTypes(in: body)

        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        let usages = sut.findUsagesOf(localNamed: "a", in: .statement(body), intention: nil)

        XCTAssertEqual(usages.count, 2)
        XCTAssertEqual(usages[0].isReadOnlyUsage, false)
        XCTAssertEqual(usages[1].isReadOnlyUsage, true)
    }

    func testFindUsagesOfLocalVariableDetectingMutatingCallsToReferenceTypes() {
        // Calling mutating members on reference types should not be considered
        // writing usages of locals.
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A", kind: .class)
                .method(named: "b", isMutating: true)
                .method(named: "c", isMutating: false)
                .build()
        )

        let body: CompoundStatement = [
            // var a: A
            .variableDeclaration(
                identifier: "a",
                type: "A",
                initialization: nil
            ),
            // a.b()
            .expression(
                Expression
                    .identifier("a")
                    .dot("b")
                    .call()
            ),
            // a.c()
            .expression(
                Expression
                    .identifier("a")
                    .dot("c")
                    .call()
            ),
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        _ = typeResolver.resolveTypes(in: body)

        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        let usages = sut.findUsagesOf(localNamed: "a", in: .statement(body), intention: nil)

        XCTAssertEqual(usages.count, 2)
        XCTAssertEqual(usages[0].isReadOnlyUsage, true)
        XCTAssertEqual(usages[1].isReadOnlyUsage, true)
    }

    func testUsageKindContext() {
        let typeSystem = TypeSystem()
        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        XCTAssertEqual(sut.usageKindContext(.identifier("a")), .readOnly)
    }

    func testUsageKindContext_writeToVariable() {
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A")
                .constructor()
                .build()
        )
        let exp = Expression.identifier("a").assignment(op: .assign, rhs: .identifier("A").call())
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        typeResolver.intrinsicVariables = ArrayDefinitionsSource(definitions: [
            .forLocalIdentifier("a", type: "A", isConstant: false, location: .parameter(index: 0))
        ])
        _ = typeResolver.resolveTypes(in: .expression(exp))
        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        XCTAssertEqual(sut.usageKindContext(exp.asAssignment!.lhs), .writeOnly)
    }

    func testUsageKindContext_compoundAssignmentWriteToVariable() {
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A")
                .constructor()
                .build()
        )
        let exp = Expression.identifier("a").assignment(op: .addAssign, rhs: .identifier("A").call())
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        typeResolver.intrinsicVariables = ArrayDefinitionsSource(definitions: [
            .forLocalIdentifier("a", type: "A", isConstant: false, location: .parameter(index: 0))
        ])
        _ = typeResolver.resolveTypes(in: .expression(exp))
        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        XCTAssertEqual(sut.usageKindContext(exp.asAssignment!.lhs), .readWrite)
    }

    func testUsageKindContext_mutableReference() {
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A")
                .constructor()
                .build()
        )
        let exp = Expression.identifier("a").unary(op: .bitwiseAnd)
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        typeResolver.intrinsicVariables = ArrayDefinitionsSource(definitions: [
            .forLocalIdentifier("a", type: "A", isConstant: false, location: .parameter(index: 0))
        ])
        _ = typeResolver.resolveTypes(in: .expression(exp))
        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        XCTAssertEqual(sut.usageKindContext(exp.asUnary!.exp), .readWrite)
    }

    func testUsageKindContext_writingPropertyOnValueType() {
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A", kind: .struct)
                .property(named: "b", type: .int)
                .build()
        )
        let exp = Expression.identifier("a").dot("b").assignment(op: .assign, rhs: .constant(1))
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        typeResolver.intrinsicVariables = ArrayDefinitionsSource(definitions: [
            .forLocalIdentifier("a", type: "A", isConstant: false, location: .parameter(index: 0))
        ])
        _ = typeResolver.resolveTypes(in: .expression(exp))
        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        XCTAssertEqual(sut.usageKindContext(exp.asAssignment!.lhs.asPostfix!.exp), .writeOnly)
    }

    func testUsageKindContext_writingPropertyOnReferenceType() {
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A")
                .property(named: "b", type: .int)
                .build()
        )
        let exp = Expression.identifier("a").dot("b").assignment(op: .assign, rhs: .constant(1))
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        typeResolver.intrinsicVariables = ArrayDefinitionsSource(definitions: [
            .forLocalIdentifier("a", type: "A", isConstant: false, location: .parameter(index: 0))
        ])
        _ = typeResolver.resolveTypes(in: .expression(exp))
        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        XCTAssertEqual(sut.usageKindContext(exp.asAssignment!.lhs.asPostfix!.exp), .readOnly)
    }

    func testUsageKindContext_mutatingMethodOnValueType() {
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A", kind: .struct)
                .method(named: "nonMut")
                .method(named: "mut", isMutating: true)
                .build()
        )
        let expNonMut = Expression.identifier("a").typed("A").dot("nonMut").call()
        let expMut = Expression.identifier("a").typed("A").dot("mut").call()
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        typeResolver.intrinsicVariables = ArrayDefinitionsSource(definitions: [
            .forLocalIdentifier("a", type: "A", isConstant: false, location: .parameter(index: 0))
        ])
        _ = typeResolver.resolveTypes(in: .expression(expNonMut))
        _ = typeResolver.resolveTypes(in: .expression(expMut))
        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        XCTAssertEqual(sut.usageKindContext(expNonMut.asPostfix!.exp.asPostfix!.exp), .readOnly)
        XCTAssertEqual(sut.usageKindContext(expMut.asPostfix!.exp.asPostfix!.exp), .readWrite)
    }

    func testUsageKindContext_mutatingMethodOnReferenceType() {
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A")
                .method(named: "nonMut")
                .method(named: "mut", isMutating: true)
                .build()
        )
        let expNonMut = Expression.identifier("a").typed("A").dot("nonMut").call()
        let expMut = Expression.identifier("a").typed("A").dot("mut").call()
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        typeResolver.intrinsicVariables = ArrayDefinitionsSource(definitions: [
            .forLocalIdentifier("a", type: "A", isConstant: false, location: .parameter(index: 0))
        ])
        _ = typeResolver.resolveTypes(in: .expression(expNonMut))
        _ = typeResolver.resolveTypes(in: .expression(expMut))
        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        XCTAssertEqual(sut.usageKindContext(expNonMut.asPostfix!.exp.asPostfix!.exp), .readOnly)
        XCTAssertEqual(sut.usageKindContext(expMut.asPostfix!.exp.asPostfix!.exp), .readOnly)
    }

    func testUsageKindContext_writingSubscriptOnValueType() {
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A", kind: .struct)
                .subscription(indexType: .int, type: .int)
                .build()
        )
        let exp = Expression.identifier("a").sub(.constant(1)).assignment(
            op: .assign,
            rhs: .constant(1)
        )
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        typeResolver.intrinsicVariables = ArrayDefinitionsSource(definitions: [
            .forLocalIdentifier("a", type: "A", isConstant: false, location: .parameter(index: 0))
        ])
        _ = typeResolver.resolveTypes(in: .expression(exp))
        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        XCTAssertEqual(sut.usageKindContext(exp.asAssignment!.lhs.asPostfix!.exp), .writeOnly)
    }

    func testUsageKindContext_writingSubscriptOnReferenceType() {
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A")
                .subscription(indexType: .int, type: .int)
                .build()
        )
        let exp = Expression.identifier("a").sub(.constant(1)).assignment(
            op: .assign,
            rhs: .constant(1)
        )
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        typeResolver.intrinsicVariables = ArrayDefinitionsSource(definitions: [
            .forLocalIdentifier("a", type: "A", isConstant: false, location: .parameter(index: 0))
        ])
        _ = typeResolver.resolveTypes(in: .expression(exp))
        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        XCTAssertEqual(sut.usageKindContext(exp.asAssignment!.lhs.asPostfix!.exp), .readOnly)
    }

    func testUsageKindContext_writeToResultOfValueTypeMethodCall() {
        let typeSystem = TypeSystem()
        typeSystem.addType(
            KnownTypeBuilder(typeName: "A", kind: .struct)
                .property(named: "b", type: .int)
                .method(named: "method", returning: "A")
                .build()
        )
        let exp = Expression.identifier("a").dot("method").call().dot("b").assignment(
            op: .assign,
            rhs: .constant(0)
        )
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        typeResolver.intrinsicVariables = ArrayDefinitionsSource(definitions: [
            .forLocalIdentifier("a", type: "A", isConstant: false, location: .parameter(index: 0))
        ])
        _ = typeResolver.resolveTypes(in: .expression(exp))
        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        XCTAssertEqual(
            sut.usageKindContext(
                exp.asAssignment!.lhs.asPostfix!.exp.asPostfix!.exp.asPostfix!.exp
            ),
            .readOnly
        )
    }

    func testUsageKindContext_parameterToMutatingSubscript() {
        let typeSystem = TypeSystem()
        let identifier = Expression.identifier("b")
        let exp = Expression.identifier("a").sub(identifier).assignment(
            op: .assign,
            rhs: .constant(1)
        )
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        typeResolver.intrinsicVariables = ArrayDefinitionsSource(definitions: [
            .forLocalIdentifier("a", type: .array(.int), isConstant: false, location: .parameter(index: 0)),
            .forLocalIdentifier("b", type: .int, isConstant: false, location: .parameter(index: 1))
        ])
        _ = typeResolver.resolveTypes(in: .expression(exp))
        let sut = LocalUsageAnalyzer(typeSystem: typeSystem)

        XCTAssertEqual(sut.usageKindContext(identifier), .readOnly)
    }
}
