import XCTest
import SwiftAST
import SwiftRewriterLib
import TestCommons
import IntentionPasses

class PromoteProtocolPropertyConformanceIntentionPassTests: XCTestCase {
    
    func testPromoteMethodIntoGetterComputedProperty() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createProtocol(withName: "A") { prot in
                        prot.createProperty(named: "a", type: .int)
                    }
                    file.createExtension(forClassNamed: "String", categoryName: "A") { builder in
                        builder
                            .createConformance(protocolName: "A")
                            .setAsInterfaceSource()
                    }
                }.createFile(named: "A.m") { file in
                    file.createExtension(forClassNamed: "String", categoryName: "A") { builder in
                        builder
                            .createMethod(named: "a", returnType: .int) { method in
                                method.setBody([.return(.constant(0))])
                            }
                    }
                }.build()
        let sut = PromoteProtocolPropertyConformanceIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.fileIntentions()[1].typeIntentions[0]
        XCTAssertEqual(intentions.fileIntentions()[1].sourcePath, "A.m")
        XCTAssertEqual(type.methods.count, 0)
        XCTAssertEqual(type.properties.count, 1)
        XCTAssertEqual(type.properties.first?.type, .int)
        XCTAssertEqual(type.properties.first?.getter?.body, [.return(.constant(0))])
    }
    
    func testLookThroughNullabilityInSignatureOfMethodAndProperty() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createProtocol(withName: "A") { prot in
                        prot.createProperty(named: "a", type: .optional("A"))
                    }
                    file.createExtension(forClassNamed: "String", categoryName: "A") { builder in
                        builder
                            .createConformance(protocolName: "A")
                            .setAsInterfaceSource()
                    }
                }.createFile(named: "A.m") { file in
                    file.createExtension(forClassNamed: "String", categoryName: "A") { builder in
                        builder
                            .createMethod(named: "a", returnType: .nullabilityUnspecified("A")) { method in
                                method.setBody([.return(.constant(0))])
                        }
                    }
                }.build()
        let sut = PromoteProtocolPropertyConformanceIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.fileIntentions()[1].typeIntentions[0]
        XCTAssertEqual(intentions.fileIntentions()[1].sourcePath, "A.m")
        XCTAssertEqual(type.methods.count, 0)
        XCTAssertEqual(type.properties.count, 1)
        XCTAssertEqual(type.properties.first?.type, .optional("A"))
        XCTAssertEqual(type.properties.first?.getter?.body, [.return(.constant(0))])
    }
    
    func testDontDuplicatePropertyImplementations() {
        // Tests that when a property is explicitly declared on a type's interface
        // that we don't eagerly transform the matching method implementation into
        // a property- this will be done later by other intention passes.
        
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createProtocol(withName: "A") { prot in
                        prot.createProperty(named: "a", type: .int)
                    }
                    file.createClass(withName: "B") { builder in
                        builder
                            .setAsInterfaceSource()
                            .createConformance(protocolName: "A")
                            .createProperty(named: "a", type: .int)
                    }
                }.createFile(named: "A.m") { file in
                    file.createClass(withName: "B") { builder in
                        builder
                            .createMethod(named: "a", returnType: .int) { method in
                                method.setBody([.return(.constant(0))])
                            }
                    }
                }.build()
        let sut = PromoteProtocolPropertyConformanceIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.fileIntentions()[1].typeIntentions[0]
        XCTAssertEqual(intentions.fileIntentions()[1].sourcePath, "A.m")
        XCTAssertEqual(type.methods.count, 1)
        XCTAssertEqual(type.properties.count, 0)
    }
}
