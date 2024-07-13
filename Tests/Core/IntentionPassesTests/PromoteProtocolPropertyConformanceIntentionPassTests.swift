import SwiftAST
import SwiftRewriterLib
import TestCommons
import XCTest

@testable import IntentionPasses

class PromoteProtocolPropertyConformanceIntentionPassTests: XCTestCase {

    func testPromoteMethodIntoGetterComputedProperty() {
        let intentions = IntentionCollectionBuilder()
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

        Asserter(object: intentions).asserter(forTargetPathFile: "A.m") { file in
            file.asserter(forTypeNamed: "String") { type in
                let property = type[\.properties].assertCount(1)?[0]

                property?
                    .assert(type: .int)?
                    .assert(getterBody: [
                        .return(.constant(0))
                    ])
            }
        }
    }

    func testLookThroughNullabilityInSignatureOfMethodAndProperty() {
        let intentions = IntentionCollectionBuilder()
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
                        .createMethod(named: "a", returnType: .nullabilityUnspecified("A")) {
                            method in
                            method.setBody([.return(.constant(0))])
                        }
                }
            }.build()
        let sut = PromoteProtocolPropertyConformanceIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        Asserter(object: intentions).asserter(forTargetPathFile: "A.m") { file in
            file.asserter(forTypeNamed: "String") { type in
                let property = type[\.properties].assertCount(1)?[0]

                property?
                    .assert(type: .optional("A"))?
                    .assert(getterBody: [
                        .return(.constant(0))
                    ])
            }
        }
    }

    func testDontDuplicatePropertyImplementations() {
        // Tests that when a property is explicitly declared on a type's interface
        // that we don't eagerly transform the matching method implementation into
        // a property- this will be done later by other intention passes.

        let intentions = IntentionCollectionBuilder()
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

        Asserter(object: intentions).asserter(forTargetPathFile: "A.m") { file in
            file.asserter(forTypeNamed: "B") { type in
                type[\.methods].assertCount(1)
                type[\.properties].assertCount(0)
            }
        }
    }

    func testDontDuplicatePropertyImplementations_2() {
        // Tests a variant of the case above (of not emitting duplicated properties),
        // but this time post-file-merge

        let intentions = IntentionCollectionBuilder()
            .createFile(named: "A.m") { file in
                file.createProtocol(withName: "A") { prot in
                    prot.createProperty(named: "a", type: .int)
                }
                file.createClass(withName: "B") { builder in
                    builder
                        .createConformance(protocolName: "A")
                        .createProperty(named: "a", type: .int)
                        .createMethod(named: "a", returnType: .int) { method in
                            method.setBody([.return(.constant(0))])
                        }
                }
            }.build()
        let sut = PromoteProtocolPropertyConformanceIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        Asserter(object: intentions).asserter(forTargetPathFile: "A.m") { file in
            file.asserter(forTypeNamed: "B") { type in
                type[\.methods].assertCount(1)
                type[\.properties].assertCount(1)
            }
        }
    }
}
