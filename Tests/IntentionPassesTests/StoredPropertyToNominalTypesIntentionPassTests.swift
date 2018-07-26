import XCTest
import SwiftRewriterLib
import IntentionPasses
import SwiftAST
import TestCommons

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
        let cls = intentions.classIntentions()[0]
        let ext = intentions.extensionIntentions()[0]
        let sut = StoredPropertyToNominalTypesIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.properties.count, 1)
        XCTAssertEqual(cls.instanceVariables.count, 1)
        XCTAssertEqual(ext.properties.count, 0)
        XCTAssertEqual(ext.instanceVariables.count, 0)
    }
    
    func testDontMovePropertyWithFullGetterAndSetterDefinitions() {
        let mode =
            PropertyGenerationIntention
                .Mode.property(get: FunctionBodyIntention(body: []),
                               set: .init(valueIdentifier: "abc", body: FunctionBodyIntention(body: [])))
        
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createClass(withName: "A")
                    file.createExtension(forClassNamed: "A") { builder in
                        builder.createProperty(named: "a", type: .int, mode: mode)
                    }
                }.build()
        let cls = intentions.classIntentions()[0]
        let ext = intentions.extensionIntentions()[0]
        let sut = StoredPropertyToNominalTypesIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.properties.count, 0)
        XCTAssertEqual(cls.instanceVariables.count, 0)
        XCTAssertEqual(ext.properties.count, 1)
        XCTAssertEqual(ext.instanceVariables.count, 0)
    }
    
    func testDontMoveReadonlyPropertyWithGetterDefinition() {
        let mode = PropertyGenerationIntention.Mode.computed(FunctionBodyIntention(body: []))
        
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createClass(withName: "A")
                    file.createExtension(forClassNamed: "A") { builder in
                        builder.createProperty(named: "a", type: .int, mode: mode,
                                               attributes: [PropertyAttribute.attribute("readonly")])
                    }
                }.build()
        let cls = intentions.classIntentions()[0]
        let ext = intentions.extensionIntentions()[0]
        let sut = StoredPropertyToNominalTypesIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(cls.properties.count, 0)
        XCTAssertEqual(cls.instanceVariables.count, 0)
        XCTAssertEqual(ext.properties.count, 1)
        XCTAssertEqual(ext.instanceVariables.count, 0)
    }
}
