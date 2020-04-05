import XCTest
import ExpressionPasses
import SwiftAST
import TypeSystem
import TestCommons

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
        
        let sut = ASTRewriterPassApplier(passes: [TestExpressionPass.self],
                                         typeSystem: TypeSystem(),
                                         globals: ArrayDefinitionsSource())
        
        sut.apply(on: intentions)
        
        let clsA = intentions.classIntentions()[0]
        let clsB = intentions.classIntentions()[1]
        XCTAssertEqual(clsA.methods[0].functionBody!.body, [.expression(.identifier("replaced"))])
        XCTAssertEqual(clsB.methods[0].functionBody!.body, [.expression(.identifier("original"))])
    }
}

private class TestExpressionPass: ASTRewriterPass {
    override func apply(on statement: Statement,
                        context: ASTRewriterPassContext) -> Statement {
        return .expression(.identifier("replaced"))
    }
}
