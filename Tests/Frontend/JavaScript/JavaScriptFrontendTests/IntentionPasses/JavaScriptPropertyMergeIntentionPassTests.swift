import SwiftAST
import SwiftRewriterLib
import TestCommons
import XCTest
import IntentionPasses
import JsGrammarModels

@testable import JavaScriptFrontend

class JavaScriptPropertyMergeIntentionPassTests: XCTestCase {
    func testMergeGetterAndSetter_underscoredMethodNames() {
        let propType = SwiftType.any
        let getterBody: CompoundStatement = [
            .return(.identifier("self").dot("_id"))
        ]
        let setterBody: CompoundStatement = [
            .expression(.identifier("self").dot("_id").assignment(op: .assign, rhs: .identifier("v")))
        ]

        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { builder in
                builder
                    .createMethod(named: "get_id", returnType: propType) { builder in
                        let getterNode = JsMethodDefinitionNode()
                        getterNode.context = .isGetter

                        builder.setBody(getterBody).setSource(getterNode)
                    }
                    .createMethod(
                        named: "set_id",
                        parameters: [ParameterSignature(label: nil, name: "v", type: propType)]
                    ) { builder in
                        let setterNode = JsMethodDefinitionNode()
                        setterNode.context = .isSetter

                        builder.setBody(setterBody).setSource(setterNode)
                    }
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = JavaScriptPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(cls.methods.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        XCTAssertEqual(cls.properties[0].name, "id")
        switch cls.properties[0].mode {
        case .property(let getter, let setter):
            XCTAssertEqual(getter.body, getterBody)
            XCTAssertEqual(setter.valueIdentifier, "v")
            XCTAssertEqual(setter.body.body, setterBody)
            
        default:
            XCTFail("Unexpected property mode \(cls.properties[0].mode)")
        }
    }
    func testMergeGetter_underscoredMethodNames() {
        let propType = SwiftType.any
        let getterBody: CompoundStatement = [
            .return(.identifier("self").dot("_id"))
        ]

        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { builder in
                builder
                    .createMethod(named: "get_id", returnType: propType) { builder in
                        let getterNode = JsMethodDefinitionNode()
                        getterNode.context = .isGetter

                        builder.setBody(getterBody).setSource(getterNode)
                    }
            }.build()
        let cls = intentions.classIntentions()[0]
        let sut = JavaScriptPropertyMergeIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(cls.methods.count, 0)
        XCTAssertEqual(cls.properties.count, 1)
        XCTAssertEqual(cls.properties[0].name, "id")
        switch cls.properties[0].mode {
        case .computed(let getter):
            XCTAssertEqual(getter.body, getterBody)
            
        default:
            XCTFail("Unexpected property mode \(cls.properties[0].mode)")
        }
    }
}
