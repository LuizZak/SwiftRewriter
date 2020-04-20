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
                                    parameters: [ParameterSignature(name: "value", type: .nullabilityUnspecified(.string))])
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
                                    parameters: [ParameterSignature(name: "value", type: .nullabilityUnspecified(.string))])
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
    
    func testProperlyOrganizePropagationToTypeExtensions() {
        // Make sure when we're propagating nullability, that we target the proper
        // members of conformers.
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.m") { file in
                    file.createClass(withName: "A") {
                        $0.setAsInterfaceSource()
                    }
                }
                .createFile(named: "A.m") { file in
                    file.createClass(withName: "A")
                }
                .createFile(named: "P.h") { file in
                    file.createProtocol(withName: "P") { prot in
                        prot.createMethod(named: "a", returnType: .string)
                            .createMethod(named: "b", returnType: .optional(.string))
                    }
                }
                .createFile(named: "A+P.h") { file in
                    file.createExtension(forClassNamed: "A", categoryName: "P") { ext in
                        ext.createConformance(protocolName: "P")
                            .setAsCategoryInterfaceSource()
                            .createMethod(named: "a", returnType: .string)
                    }
                }.createFile(named: "A+P.m") { file in
                    file.createExtension(forClassNamed: "A", categoryName: "P") { ext in
                        ext.setAsCategoryImplementation(categoryName: "P")
                            .createMethod(named: "a", returnType: .nullabilityUnspecified(.string)) {
                                $0.setBody([.return(.constant(""))])
                            }
                            .createMethod(named: "b", returnType: .nullabilityUnspecified(.string)) {
                                $0.setBody([.return(.constant(.nil))])
                            }
                    }
                }.build()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let classDef = intentions.fileIntentions()[0].classIntentions[0]
        let extDef = intentions.fileIntentions()[4].extensionIntentions[0]
        XCTAssertEqual(classDef.typeName, "A")
        XCTAssertFalse(classDef.isExtension)
        XCTAssertEqual(extDef.typeName, "A")
        XCTAssert(extDef.isExtension)
        XCTAssert(classDef.methods.isEmpty)
        XCTAssertEqual(extDef.methods.count, 2)
        XCTAssertEqual(extDef.methods[0].returnType, .string)
        XCTAssertEqual(extDef.methods[1].returnType, .optional(.string))
    }
    
    func testDoNotMergeProtocolToClassMethodComments() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createProtocol(withName: "Prot") { prot in
                        prot.createMethod("test()") { m in
                            m.addComment("// Comment")
                        }
                    }.createClass(withName: "A") { type in
                        type.createConformance(protocolName: "Prot")
                        type.createMethod("test()") { m in
                            m.addComment("// Method comment")
                        }
                    }
            }.build()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let file = intentions.fileIntentions()[0]
        let cls = file.classIntentions[0]
        let method = cls.methods[0]
        XCTAssertEqual(method.precedingComments, [
            "// Method comment"
        ])
    }
}
