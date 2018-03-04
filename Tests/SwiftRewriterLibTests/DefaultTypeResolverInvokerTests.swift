import XCTest
import SwiftRewriterLib
import SwiftAST
import TestCommons

class DefaultTypeResolverInvokerTests: XCTestCase {
    func testExposesGlobalVariablesFromIntrinsics() {
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
        let sut = DefaultTypeResolverInvoker(typeSystem: typeSystem)
        let methodA = intentions.classIntentions()[0].methods[0]
        let methodB = intentions.classIntentions()[1].methods[0]
        
        sut.resolveExpressionTypes(in: methodA, force: true)
        sut.resolveExpressionTypes(in: methodB, force: true)
        
        XCTAssertEqual(
            methodA.functionBody?
                .body.statements[0]
                .asExpressions?
                .expressions[0]
                .resolvedType, .int)
        
        XCTAssertEqual(methodB.functionBody?.body.statements[0].asExpressions?.expressions[0].resolvedType, .errorType)
    }
}
