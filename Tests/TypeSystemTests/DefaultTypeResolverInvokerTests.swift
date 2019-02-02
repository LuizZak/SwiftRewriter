import XCTest
import TypeSystem
import SwiftAST
import TestCommons

class DefaultTypeResolverInvokerTests: XCTestCase {
    func testExposesGlobalVariablesAsIntrinsics() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.m") { file in
                    file.createGlobalVariable(withName: "a", type: .int, accessLevel: .private)
                        .createClass(withName: "A") { cls in
                            cls.createMethod(named: "b") { method in
                                method.setBody([
                                        .expression(.assignment(lhs: .identifier("a"), op: .assign, rhs: .constant(1)))
                                    ])
                            }
                        }
                }.createFile(named: "B") { file in
                    file.createClass(withName: "B") { cls in
                            cls.createMethod(named: "b") { method in
                                method.setBody([
                                        .expression(.assignment(lhs: .identifier("a"), op: .assign, rhs: .constant(1)))
                                    ])
                            }
                        }
                }
                .build()
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentions)
        let sut = DefaultTypeResolverInvoker(globals: ArrayDefinitionsSource(), typeSystem: typeSystem, numThreads: 8)
        let methodA = intentions.classIntentions()[0].methods[0]
        let methodB = intentions.classIntentions()[1].methods[0]
        
        sut.resolveExpressionTypes(in: methodA, force: true)
        sut.resolveExpressionTypes(in: methodB, force: true)
        
        XCTAssertEqual(
            methodA.functionBody?
                .body.statements[0]
                .asExpressions?
                .expressions[0]
                .resolvedType
            , .int)
        XCTAssertEqual(
            methodB.functionBody?
                .body.statements[0]
                .asExpressions?
                .expressions[0]
                .resolvedType,
            .errorType)
    }
    
    func testExposesParametersBeforeTypeMembers() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.m") { file in
                    file.createClass(withName: "A") { type in
                        type.createProperty(named: "b", type: .typeName("B"))
                            .createMethod(named: "a") { method in
                                method.createSignature(name: "b") { builder in
                                    builder.addParameter(name: "b", type: .optional(.typeName("B")))
                                }
                                method
                                    .setBody([
                                        .expression(Expression.identifier("b").optional().dot("value"))
                                    ])
                            }
                    }
                }.createFile(named: "B") { file in
                    file.createClass(withName: "B") { type in
                        type.createProperty(named: "value", type: .cgFloat)
                    }
                }
                .build()
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentions)
        let sut = DefaultTypeResolverInvoker(globals: ArrayDefinitionsSource(), typeSystem: typeSystem, numThreads: 8)
        let method = intentions.classIntentions()[0].methods[0]
        
        sut.resolveExpressionTypes(in: method, force: true)
        
        XCTAssertEqual(
            method.functionBody?
                .body.statements[0]
                .asExpressions?
                .expressions[0]
                .resolvedType
            , .optional(.cgFloat))
    }
    
    func testProperlyExposesReturnTypeOfMethodsToExpressionResolver() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { type in
                    type.createMethod(named: "a", returnType: .typeName("A")) { method in
                        method.setBody([.return(.identifier("self"))])
                    }
                }
                .build()
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentions)
        let sut = DefaultTypeResolverInvoker(globals: ArrayDefinitionsSource(), typeSystem: typeSystem, numThreads: 8)
        let method = intentions.classIntentions()[0].methods[0]
        
        sut.resolveExpressionTypes(in: method, force: true)
        
        XCTAssertEqual(
            method.functionBody?
                .body.statements[0]
                .asReturn?
                .exp?.expectedType
            , .typeName("A"))
    }
    
    func testProperlyExposesReturnTypeOfPropertyGettersToExpressionResolver() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { type in
                    type.createProperty(named: "a", type: .typeName("A")) { builder in
                        builder.setAsComputedProperty(body: [
                            .return(.identifier("self"))
                        ])
                    }
                }
                .build()
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentions)
        let sut = DefaultTypeResolverInvoker(globals: ArrayDefinitionsSource(), typeSystem: typeSystem, numThreads: 8)
        let property = intentions.classIntentions()[0].properties[0]
        
        sut.resolveExpressionTypes(in: property, force: true)
        
        XCTAssertEqual(
            property.getter?
                .body.statements[0]
                .asReturn?
                .exp?.expectedType
            , .typeName("A"))
    }
}
