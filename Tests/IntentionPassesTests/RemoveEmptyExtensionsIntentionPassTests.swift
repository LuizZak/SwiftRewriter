import XCTest
import Intentions
import IntentionPasses
import TestCommons

class RemoveEmptyExtensionsIntentionPassTests: XCTestCase {
    func testRemoveEmptyExtensions() {
        let intentions = IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createExtension(forClassNamed: "A")
            }.build()
        let sut = RemoveEmptyExtensionsIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forTargetPathFile: "A.h") { file in
            file[\.extensionIntentions].assertIsEmpty()
        }
    }
    
    func testRemoveEmptyExtensionsWithName() {
        let intentions = IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createExtension(forClassNamed: "A", categoryName: "B")
            }.build()
        let sut = RemoveEmptyExtensionsIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forTargetPathFile: "A.h") { file in
            file[\.extensionIntentions].assertIsEmpty()
        }
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
        
        Asserter(object: intentions).asserter(forTargetPathFile: "A.h") { file in
            file[\.extensionIntentions].assertIsNotEmpty()
        }
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
        
        Asserter(object: intentions).asserter(forTargetPathFile: "A.h") { file in
            file[\.extensionIntentions].assertIsNotEmpty()
        }
    }
}
