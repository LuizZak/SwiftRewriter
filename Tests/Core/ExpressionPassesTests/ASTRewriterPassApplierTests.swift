import SwiftAST
import TestCommons
import TypeSystem
import XCTest

@testable import ExpressionPasses

class ASTRewriterPassApplierTests: XCTestCase {
    func testIgnoresApplicationOnNonPrimaryFiles() {
        let intentions = IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.isPrimary(true)
                    .createClass(withName: "A") { type in
                        type.createVoidMethod(named: "a") { builder in
                            builder.setBody([
                                .expression(.identifier("original"))
                            ])
                        }
                    }
            }
            .createFile(named: "B.h") { file in
                file.isPrimary(false)
                    .createClass(withName: "B") { type in
                        type.createVoidMethod(named: "b") { builder in
                            builder.setBody([
                                .expression(.identifier("original"))
                            ])
                        }
                    }
            }.build(typeChecked: true)

        let sut = ASTRewriterPassApplier(
            passes: [TestExpressionPass.self],
            typeSystem: TypeSystem(),
            globals: ArrayDefinitionsSource()
        )

        sut.apply(on: intentions)

        let clsA = intentions.classIntentions()[0]
        let clsB = intentions.classIntentions()[1]
        XCTAssertEqual(clsA.methods[0].functionBody!.body, [.expression(.identifier("replaced"))])
        XCTAssertEqual(clsB.methods[0].functionBody!.body, [.expression(.identifier("original"))])
    }

    func testApplyGlobalVariableInitializers() {
        let intentions = IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createGlobalVariable(withName: "a", storage: .constant(ofType: .any), initialExpression: .identifier("original"))
            }.build(typeChecked: true)
        

        let sut = ASTRewriterPassApplier(
            passes: [TestExpressionPass.self],
            typeSystem: TypeSystem(),
            globals: ArrayDefinitionsSource()
        )

        sut.apply(on: intentions)
        let globalVar = intentions.globalVariables()[0]
        XCTAssertEqual(globalVar.initialValue, .identifier("replaced"))
    }

    func testApplyPropertyInitializers() {
        let intentions = IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createClass(withName: "AClass") { cls in
                    cls.createProperty(named: "String", type: .any) { prop in
                        prop.setInitialExpression(.identifier("replaced"))
                    }
                }
            }.build(typeChecked: true)
        

        let sut = ASTRewriterPassApplier(
            passes: [TestExpressionPass.self],
            typeSystem: TypeSystem(),
            globals: ArrayDefinitionsSource()
        )

        sut.apply(on: intentions)
        let clsA = intentions.classIntentions()[0]
        XCTAssertEqual(clsA.properties[0].initialValueIntention?.expression, .identifier("replaced"))
    }
}

private class TestExpressionPass: ASTRewriterPass {
    override func apply(
        on statement: Statement,
        context: ASTRewriterPassContext
    ) -> Statement {
        return .expression(.identifier("replaced"))
    }

    override func apply(
        on expression: Expression, 
        context: ASTRewriterPassContext
    ) -> Expression {
        return .identifier("replaced")
    }
}
