import SwiftAST
import SwiftRewriterLib
import TestCommons
import XCTest

@testable import IntentionPasses

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
                file.createProtocol(withName: "A") { prot in
                    prot.createMethod(
                        named: "takesValue",
                        returnType: .void,
                        parameters: [ParameterSignature(name: "value", type: .string)]
                    )
                }
                .createClass(withName: "B") { type in
                    type.createConformance(protocolName: "A")
                        .createMethod(
                            named: "takesValue",
                            returnType: .void,
                            parameters: [
                                ParameterSignature(
                                    name: "value",
                                    type: .nullabilityUnspecified(.string)
                                )
                            ]
                        )
                }
            }.build()
        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        Asserter(object: intentions).asserter(forClassNamed: "B") { type in
            type[\.methods][0]?.asserter(forParameterAt: 0) { param in
                param.assert(type: .string)
            }
        }
    }

    func testPropagatesNullabilityLookingThroughProtocolConformancesInExtensions() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createProtocol(withName: "A") { prot in
                    prot.createMethod(
                        named: "takesValue",
                        returnType: .void,
                        parameters: [ParameterSignature(name: "value", type: .string)]
                    )
                }
                .createClass(withName: "B") { type in
                    type.createMethod(
                        named: "takesValue",
                        returnType: .void,
                        parameters: [
                            ParameterSignature(
                                name: "value",
                                type: .nullabilityUnspecified(.string)
                            )
                        ]
                    )
                }
                .createExtension(forClassNamed: "B", categoryName: nil) { ext in
                    ext.createConformance(protocolName: "A")
                }
            }.build()
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "B") { type in
            type[\.methods][0]?.asserter(forParameterAt: 0) { param in
                param.assert(type: .string)
            }
        }
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
        
        Asserter(object: intentions).asserter(forTargetPathFile: "A+P.m") { file in
            let type = file[\.extensionIntentions].assertCount(1)?[0]
            type?
                .assert(typeName: "A")?
                .assert(isExtension: true)
            
            let methods = type?[\.methods]
            methods?.assertCount(2)
            methods?[0]?.assert(returnType: .string)
            methods?[1]?.assert(returnType: .optional(.string))
        }
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

        Asserter(object: intentions).asserter(forTypeNamed: "A") { type in
            type[\.methods].assertCount(1)
            type[\.methods][0]?.assert(precedingComments: [
                "// Method comment"
            ])
        }
    }
}
