import SwiftAST
import SwiftRewriterLib
import TestCommons
import XCTest

@testable import IntentionPasses

class DetectNonnullReturnsIntentionPassTests: XCTestCase {
    func testApplyOnMethod() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createMethod(named: "a", returnType: .nullabilityUnspecified(.typeName("A"))) {
                    method in
                    method.setBody([
                        .return(.identifier("self").typed(.typeName("A")))
                    ])
                }
            }.build()
        let sut = DetectNonnullReturnsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let file = intentions.fileIntentions()[0]
        XCTAssertEqual(file.classIntentions[0].methods[0].returnType, .typeName("A"))
    }

    func testApplyOnMethodPolymorphicDetection() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "B") { type in
                type.inherit(from: "A")
            }
            .createFileWithClass(named: "A") { type in
                type.createProperty(named: "b", type: "B")
                    .createMethod(named: "a", returnType: .nullabilityUnspecified(.typeName("A"))) {
                        method in
                        method.setBody([
                            .return(.identifier("self").dot("b").typed(.typeName("B")))
                        ])
                    }
            }.build()
        let sut = DetectNonnullReturnsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let file = intentions.fileIntentions()[1]
        XCTAssertEqual(file.classIntentions[0].methods[0].returnType, .typeName("A"))
    }

    func testDontApplyOnMethodWithExplicitOptionalReturnType() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createMethod(named: "a", returnType: .optional(.typeName("A"))) { method in
                    method.setBody([
                        .return(.identifier("self").typed(.typeName("A")))
                    ])
                }
            }.build()
        let sut = DetectNonnullReturnsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let file = intentions.fileIntentions()[0]
        XCTAssertEqual(file.classIntentions[0].methods[0].returnType, .optional(.typeName("A")))
    }

    func testDontApplyOnMethodWithErrorReturnType() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createMethod(named: "a", returnType: .nullabilityUnspecified(.typeName("A"))) {
                    method in
                    method.setBody([
                        .return(.identifier("self").typed(.errorType))
                    ])
                }
            }.build()
        let sut = DetectNonnullReturnsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let file = intentions.fileIntentions()[0]
        XCTAssertEqual(
            file.classIntentions[0].methods[0].returnType,
            .nullabilityUnspecified(.typeName("A"))
        )
    }

    func testDontApplyOnOverrides() {
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createMethod(named: "a", returnType: .nullabilityUnspecified(.typeName("A"))) {
                    method in
                    method.setIsOverride(true)
                    method.setBody([
                        .return(.identifier("self").typed(.typeName("A")))
                    ])
                }
            }.build()
        let sut = DetectNonnullReturnsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let file = intentions.fileIntentions()[0]
        XCTAssertEqual(
            file.classIntentions[0].methods[0].returnType,
            .nullabilityUnspecified(.typeName("A"))
        )
    }
}
