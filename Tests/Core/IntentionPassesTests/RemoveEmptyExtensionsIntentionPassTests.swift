import Intentions
import TestCommons
import XCTest

@testable import IntentionPasses

class RemoveEmptyExtensionsIntentionPassTests: XCTestCase {
    func testRemoveEmptyExtensions() {
        let intentions = IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createExtension(forClassNamed: "A")
            }.build()
        let sut = RemoveEmptyExtensionsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssert(intentions.extensionIntentions().isEmpty)
    }

    func testRemoveEmptyExtensionsWithName() {
        let intentions = IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createExtension(forClassNamed: "A", categoryName: "B")
            }.build()
        let sut = RemoveEmptyExtensionsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssert(intentions.extensionIntentions().isEmpty)
    }

    func testDontRemoveExtensionsImplementingProtocols() {
        let intentions = IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createExtension(forClassNamed: "A", categoryName: "B") { ext in
                    ext.createConformance(protocolName: "C")
                }
            }.build()
        let sut = RemoveEmptyExtensionsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(intentions.extensionIntentions().count, 1)
    }

    func testDontRemoveInhabitedExtensions() {
        let intentions = IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createExtension(forClassNamed: "A", categoryName: "B") { ext in
                    ext.createMethod(named: "a")
                }
            }.build()
        let sut = RemoveEmptyExtensionsIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        XCTAssertEqual(intentions.extensionIntentions().count, 1)
    }
}
