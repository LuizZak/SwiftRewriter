import Intentions
import SwiftAST
import SwiftRewriterLib
import TestCommons
import XCTest

@testable import IntentionPasses

class StoredPropertyToNominalTypesIntentionPassTests: XCTestCase {

    func testMovePropertyFromExtensionToMainDeclaration() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createClass(withName: "A")
                    file.createExtension(forClassNamed: "A") { builder in
                        builder.createProperty(named: "a", type: .int)
                            .createInstanceVariable(named: "b", type: .int)
                    }
                }.build()
        let sut = StoredPropertyToNominalTypesIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions)
            .asserter(forClassNamed: "A") { type in
                type[\.properties].assertCount(1)
                type[\.instanceVariables].assertCount(1)
            }?
            .asserter(forClassExtensionNamed: "A") { extType in
                extType[\.properties].assertCount(0)
                extType[\.instanceVariables].assertCount(0)
            }
    }

    func testDontMovePropertyWithFullGetterAndSetterDefinitions() {
        let mode: PropertyGenerationIntention.Mode =
            .property(
                get: FunctionBodyIntention(body: []),
                set: .init(valueIdentifier: "abc", body: FunctionBodyIntention(body: []))
            )
        
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createClass(withName: "A")
                    file.createExtension(forClassNamed: "A") { builder in
                        builder.createProperty(named: "a", type: .int, mode: mode)
                    }
                }.build()
        let sut = StoredPropertyToNominalTypesIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions)
            .asserter(forClassNamed: "A") { type in
                type[\.properties].assertCount(0)
                type[\.instanceVariables].assertCount(0)
            }?
            .asserter(forClassExtensionNamed: "A") { extType in
                extType[\.properties].assertCount(1)
                extType[\.instanceVariables].assertCount(0)
            }
    }

    func testDontMoveReadonlyPropertyWithGetterDefinition() {
        let mode = PropertyGenerationIntention.Mode.computed(FunctionBodyIntention(body: []))

        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createClass(withName: "A")
                    file.createExtension(forClassNamed: "A") { builder in
                        builder.createProperty(
                            named: "a",
                            type: .int,
                            mode: mode,
                            objcAttributes: [.attribute("readonly")]
                        )
                    }
                }.build()
        let sut = StoredPropertyToNominalTypesIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions)
            .asserter(forClassNamed: "A") { type in
                type[\.properties].assertCount(0)
                type[\.instanceVariables].assertCount(0)
            }?
            .asserter(forClassExtensionNamed: "A") { extType in
                extType[\.properties].assertCount(1)
                extType[\.instanceVariables].assertCount(0)
            }
    }
}
