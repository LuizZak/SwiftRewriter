import XCTest
import SwiftAST
import TestCommons

@testable import IntentionPasses

class DetectNoReturnsIntentionPassTests: XCTestCase {
    func testApply_globalFunction() throws {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "file") { file in
                file.createGlobalFunction(withName: "f1") { f in
                    f.setBody([

                    ]).createSignature { sign in
                        sign.setReturnType(.any)
                    }
                }.createGlobalFunction(withName: "f2") { f in
                    f.setBody([
                        .return(.constant(0))
                    ]).createSignature { sign in
                        sign.setReturnType(.any)
                    }
                }
            }.build()
        let sut = DetectNoReturnsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let file = try intentions.fileIntentions()[try: 0]
        let f1 = try file.globalFunctionIntentions[try: 0]
        let f2 = try file.globalFunctionIntentions[try: 1]
        XCTAssertEqual(f1.signature.returnType, .void)
        XCTAssertEqual(f2.signature.returnType, .any)
    }

    func testApply_ignoreReturnStatementsInNestedFunctions() throws {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "file") { file in
                file.createGlobalFunction(withName: "f1") { f in
                    f.setBody([
                        .localFunction(
                            identifier: "lf",
                            parameters: [],
                            returnType: .any,
                            body: [
                                .return(.constant(0))
                            ]
                        ),
                        .expression(
                            .block(body: [
                                .return(.constant(0))
                            ])
                        )
                    ]).createSignature { sign in
                        sign.setReturnType(.any)
                    }
                }
            }.build()
        let sut = DetectNoReturnsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let file = try intentions.fileIntentions()[try: 0]
        let f1 = try file.globalFunctionIntentions[try: 0]
        XCTAssertEqual(f1.signature.returnType, .void)
    }

    func testApply_appliesInLocalFunctions() throws {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "file") { file in
                file.createGlobalFunction(withName: "f1") { f in
                    f.setBody([
                        .localFunction(
                            identifier: "lf1",
                            parameters: [],
                            returnType: .any,
                            body: [
                                
                            ]
                        ),
                        .localFunction(
                            identifier: "lf2",
                            parameters: [],
                            returnType: .any,
                            body: [
                                .return(.constant(0))
                            ]
                        )
                    ])
                }
            }.build()
        let sut = DetectNoReturnsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let file = try intentions.fileIntentions()[try: 0]
        let f1 = try file.globalFunctionIntentions[try: 0]
        let lf1 = try XCTUnwrap(f1.functionBody?.body.statements[try: 0].asLocalFunction)
        let lf2 = try XCTUnwrap(f1.functionBody?.body.statements[try: 1].asLocalFunction)
        XCTAssertEqual(lf1.function.returnType, .void)
        XCTAssertEqual(lf2.function.returnType, .any)
    }

    func testApply_globalVariableInitializer() throws {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "file") { file in
                file.createGlobalVariable(
                    withName: "v1",
                    type: .any,
                    initialExpression: .block(body: [
                        .localFunction(
                            identifier: "lf",
                            parameters: [],
                            returnType: .any,
                            body: [
                                
                            ]
                        )
                    ]))
            }.build()
        let sut = DetectNoReturnsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let file = try intentions.fileIntentions()[try: 0]
        let v1 = try file.globalVariableIntentions[try: 0]
        let lf = try XCTUnwrap(v1.initialValue?.asBlock?.body.statements[try: 0].asLocalFunction)
        XCTAssertEqual(lf.function.returnType, .void)
    }

    func testApply_propertyInitializer() throws {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "file") { file in
                file.createClass(withName: "A") { type in
                    type.createProperty(named: "prop", type: .any) { prop in
                        prop.setInitialExpression(
                            .block(body: [
                                .localFunction(
                                    identifier: "lf",
                                    parameters: [],
                                    returnType: .any,
                                    body: [
                                        
                                    ]
                                )
                            ])
                        )
                    }
                }
            }.build()
        let sut = DetectNoReturnsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let file = try intentions.fileIntentions()[try: 0]
        let aClass = try file.classIntentions[try: 0]
        let prop = try aClass.properties[try: 0]
        let lf = try XCTUnwrap(prop.initialValue?.asBlock?.body.statements[try: 0].asLocalFunction)
        XCTAssertEqual(lf.function.returnType, .void)
    }
}
