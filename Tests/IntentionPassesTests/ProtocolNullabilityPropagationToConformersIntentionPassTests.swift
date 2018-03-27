import XCTest
import SwiftAST
import SwiftRewriterLib
import TestCommons
import IntentionPasses

class ProtocolNullabilityPropagationToConformersIntentionPassTests: XCTestCase {
    var sut: ProtocolNullabilityPropagationToConformersIntentionPass!
    
    override func setUp() {
        super.setUp()
        
        sut = ProtocolNullabilityPropagationToConformersIntentionPass()
    }
    
    func testPropagatesNullability() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file
                        .createProtocol(withName: "A") { prot in
                            prot.createMethod(named: "takesValue",
                                              returnType: .void,
                                              parameters: [ParameterSignature(name: "value", type: .string)])
                        }
                        .createClass(withName: "B") { type in
                            type.createConformance(protocolName: "A")
                                .createMethod(
                                    named: "takesValue",
                                    returnType: .void,
                                    parameters: [ParameterSignature(name: "value", type: .implicitUnwrappedOptional(.string))])
                        }
                }.build()
        let type = intentions.fileIntentions()[0].classIntentions[0]
        let method = type.methods[0]
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(method.parameters[0].type, .string)
    }
    
    func testPropagatesNullabilityLookingThroughProtocolConformancesInExtensions() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file
                        .createProtocol(withName: "A") { prot in
                            prot.createMethod(named: "takesValue",
                                              returnType: .void,
                                              parameters: [ParameterSignature(name: "value", type: .string)])
                        }
                        .createClass(withName: "B") { type in
                            type.createMethod(
                                    named: "takesValue",
                                    returnType: .void,
                                    parameters: [ParameterSignature(name: "value", type: .implicitUnwrappedOptional(.string))])
                        }
                        .createExtension(forClassNamed: "B", categoryName: nil) { ext in
                            ext.createConformance(protocolName: "A")
                        }
                }.build()
        let type = intentions.fileIntentions()[0].classIntentions[0]
        let method = type.methods[0]
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(method.parameters[0].type, .string)
    }
}
