import XCTest
import SwiftRewriterLib
import SwiftAST
import TestCommons

class DefaultUsageAnalyzerTests: XCTestCase {
    func testFindMethodUsages() {
        let builder = IntentionCollectionBuilder()
        let body: CompoundStatement = [
            // B().b()
            .expression(
                Expression
                    .identifier("B").call()
                    .dot("b").call()
            )
        ]
        
        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") { method in
                            method.setBody(body)
                        }
                    }
                    .createClass(withName: "B") { builder in
                        builder
                            .createConstructor()
                            .createVoidMethod(named: "b")
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let sut = DefaultUsageAnalyzer(intentions: intentions, typeSystem: DefaultTypeSystem())
        let method = intentions.fileIntentions()[0].typeIntentions[1].methods[0]
        
        let usages = sut.findUsagesOf(method: method)
        
        XCTAssertEqual(usages[0].expression,
                       Expression
                        .identifier("B").call()
                        .dot("b"))
        
        XCTAssertEqual(usages.count, 1)
    }
    
    func testFindMethodUsagesWithRecursiveCall() {
        let builder = IntentionCollectionBuilder()
        
        let body: CompoundStatement = [
            // B().b().b()
            .expression(
                Expression
                    .identifier("B").call()
                    .dot("b").call()
                    .dot("b").call()
            )
        ]
        
        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") {method in
                            method.setBody(body)
                        }
                    }
                    .createClass(withName: "B") { builder in
                        builder
                            .createConstructor()
                            .createMethod(named: "b", returnType: .typeName("B"),
                                          parameters: [])
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let sut = DefaultUsageAnalyzer(intentions: intentions, typeSystem: DefaultTypeSystem())
        let method = intentions.fileIntentions()[0].typeIntentions[1].methods[0]
        
        let usages = sut.findUsagesOf(method: method)
        
        XCTAssertEqual(usages.count, 2)
    }
    
    func testFindPropertyUsages() {
        let builder = IntentionCollectionBuilder()
        
        let body: CompoundStatement = [
            // B().b()
            .expression(
                Expression
                    .identifier("B").call()
                    .dot("b").call()
            )
        ]
        
        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") {method in
                            method.setBody(body)
                        }
                    }
                    .createClass(withName: "B") { builder in
                        builder
                            .createConstructor()
                            .createProperty(named: "b", type: .int)
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let sut = DefaultUsageAnalyzer(intentions: intentions, typeSystem: DefaultTypeSystem())
        let property = intentions.fileIntentions()[0].typeIntentions[1].properties[0]
        
        let usages = sut.findUsagesOf(property: property)
        
        XCTAssertEqual(usages.count, 1)
    }
    
    func testFindEnumMemberUsage() {
        let builder = IntentionCollectionBuilder()
        
        let body: CompoundStatement = [
            // B.B_a
            .expression(
                Expression.identifier("B").dot("B_a")
            )
        ]
        
        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") {method in
                            method.setBody(body)
                        }
                    }
                    .createEnum(withName: "B", rawValue: .int) { builder in
                        builder.createCase(name: "B_a")
                    }
            }
        
        let intentions = builder.build(typeChecked: true)
        let sut = DefaultUsageAnalyzer(intentions: intentions, typeSystem: DefaultTypeSystem())
        let property = intentions.fileIntentions()[0].enumIntentions[0].cases[0]
        
        let usages = sut.findUsagesOf(property: property)
        
        XCTAssertEqual(usages.count, 1)
    }
    
    /// Tests that we can properly find usages of class members on subclass
    /// instances
    func testFindUsagesOfSuperclassMemberInSubclassInstances() {
        let builder = IntentionCollectionBuilder()
        
        let body: CompoundStatement = [
            // self.a
            .expression(
                Expression
                    .identifier("self")
                    .dot("a")
            )
        ]
        
        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createProperty(named: "a", type: .int)
                    }
                    .createClass(withName: "B") { builder in
                        builder
                            .createConstructor()
                            .inherit(from: "A")
                            .createVoidMethod(named: "test") { method in
                                method.setBody(body)
                            }
                    }
            }
        
        let intentions = builder.build(typeChecked: true)
        let sut = DefaultUsageAnalyzer(intentions: intentions, typeSystem: DefaultTypeSystem())
        let property = intentions.fileIntentions()[0].classIntentions[0].properties[0]
        
        let usages = sut.findUsagesOf(property: property)
        
        XCTAssertEqual(usages.count, 1)
    }
    
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
            )
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: DefaultTypeSystem())
        _=typeResolver.resolveTypes(in: body)
        
        let sut = LocalUsageAnalyzer(functionBody: FunctionBodyIntention(body: body),
                                     typeSystem: DefaultTypeSystem())
        
        let usages = sut.findUsagesOf(localNamed: "a")
        
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
            )
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: DefaultTypeSystem())
        _=typeResolver.resolveTypes(in: body)
        
        let sut = LocalUsageAnalyzer(functionBody: FunctionBodyIntention(body: body),
                                     typeSystem: DefaultTypeSystem())
        
        let usages = sut.findUsagesOf(localNamed: "a")
        
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
            )
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: DefaultTypeSystem())
        _=typeResolver.resolveTypes(in: body)
        
        let sut = LocalUsageAnalyzer(functionBody: FunctionBodyIntention(body: body),
                                     typeSystem: DefaultTypeSystem())
        
        let usages = sut.findUsagesOf(localNamed: "a")
        
        XCTAssertEqual(usages.count, 4)
        XCTAssertEqual(usages[0].isReadOnlyUsage, false)
        XCTAssertEqual(usages[1].isReadOnlyUsage, false)
        XCTAssertEqual(usages[2].isReadOnlyUsage, false)
        XCTAssertEqual(usages[3].isReadOnlyUsage, true)
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
                            .unary(op: .bitwiseAnd,
                                   .identifier("a"))
                    ])
            )
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: DefaultTypeSystem())
        _=typeResolver.resolveTypes(in: body)
        
        let sut = LocalUsageAnalyzer(functionBody: FunctionBodyIntention(body: body),
                                     typeSystem: DefaultTypeSystem())
        
        let usages = sut.findUsagesOf(localNamed: "a")
        
        XCTAssertEqual(usages.count, 2)
        XCTAssertEqual(usages[0].isReadOnlyUsage, true)
        XCTAssertEqual(usages[1].isReadOnlyUsage, false)
    }
    
    func testFindUsagesOfLocalVariableDetetingWritingUsagesOfReferenceFields() {
        // Mutating fields of reference types embedded within value types should
        // not produce write usage references
        let typeSystem = DefaultTypeSystem()
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
            )
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        _=typeResolver.resolveTypes(in: body)
        
        let sut = LocalUsageAnalyzer(functionBody: FunctionBodyIntention(body: body),
                                     typeSystem: typeSystem)
        
        let usages = sut.findUsagesOf(localNamed: "a")
        
        XCTAssertEqual(usages.count, 2)
        XCTAssertEqual(usages[0].isReadOnlyUsage, true)
        XCTAssertEqual(usages[1].isReadOnlyUsage, false)
    }
    
    func testFindUsagesOfLocalVariableDoesNotReportWritingUsagesWhenMutatingFieldsOfReferenceType() {
        // Mutating any field of a reference type local variable should not be
        // considered a variable writing usage.
        let typeSystem = DefaultTypeSystem()
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
            )
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        _=typeResolver.resolveTypes(in: body)
        
        let sut = LocalUsageAnalyzer(functionBody: FunctionBodyIntention(body: body),
                                     typeSystem: typeSystem)
        
        let usages = sut.findUsagesOf(localNamed: "a")
        
        XCTAssertEqual(usages.count, 1)
        XCTAssertEqual(usages[0].isReadOnlyUsage, true)
    }
    
    func testFindUsagesOfLocalVariableDetectingMutatingCallsToValueType() {
        // Make sure we can properly detect calls of mutating functions on value-types
        let typeSystem = DefaultTypeSystem()
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
            )
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        _=typeResolver.resolveTypes(in: body)
        
        let sut = LocalUsageAnalyzer(functionBody: FunctionBodyIntention(body: body),
                                     typeSystem: typeSystem)
        
        let usages = sut.findUsagesOf(localNamed: "a")
        
        XCTAssertEqual(usages.count, 2)
        XCTAssertEqual(usages[0].isReadOnlyUsage, false)
        XCTAssertEqual(usages[1].isReadOnlyUsage, true)
    }
    
    func testFindUsagesOfLocalVariableDetectingMutatingCallsToReferenceTypes() {
        // Calling mutating members on reference types should not be considered
        // writing usages of locals.
        let typeSystem = DefaultTypeSystem()
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
            )
        ]
        let typeResolver = ExpressionTypeResolver(typeSystem: typeSystem)
        _=typeResolver.resolveTypes(in: body)
        
        let sut = LocalUsageAnalyzer(functionBody: FunctionBodyIntention(body: body),
                                     typeSystem: typeSystem)
        
        let usages = sut.findUsagesOf(localNamed: "a")
        
        XCTAssertEqual(usages.count, 2)
        XCTAssertEqual(usages[0].isReadOnlyUsage, true)
        XCTAssertEqual(usages[1].isReadOnlyUsage, true)
    }
}
