import XCTest
import SwiftAST
import KnownType
import Intentions
import SwiftRewriterLib
import TestCommons
import IntentionPasses

class PromoteNSMutableArrayIntentionPassTests: XCTestCase {
    func testPromoteUnusedProperty() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder.createProperty(
                        named: "a",
                        type: nsMutableArrayType("A")
                    )
                }.build(typeChecked: true)
        let sut = PromoteNSMutableArrayIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.typeIntentions()[0]
        XCTAssertEqual(type.properties[0].type, .array("A"))
    }
    
    func testPromoteUsingKnownMemberOfNSMutableArray() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder.createProperty(
                        named: "a",
                        type: nsMutableArrayType("A")
                    )
                    builder.createVoidMethod(named: "test") { builder in
                        builder.setBody([
                            .expression(
                                Expression
                                    .identifier("a")
                                    .dot("count")
                            )
                            ])
                    }
                }.build(typeChecked: true)
        let sut = PromoteNSMutableArrayIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.typeIntentions()[0]
        XCTAssertEqual(type.properties[0].type, .array("A"))
    }
    
    // TODO: Audit this behavior and check if it wouldn't be beneficial to only
    // allow known members of NSMutableArray to be detected as valid cases, even
    // if not all of these members are currently available via the compounded type
    // we have.
    func testPromoteUsingUnknownMemberOfNSMutableArray() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder.createProperty(
                        named: "a",
                        type: nsMutableArrayType("A")
                    )
                    builder.createVoidMethod(named: "test") { builder in
                        builder.setBody([
                            .expression(
                                Expression
                                    .identifier("a")
                                    .dot("unknownMember")
                            )
                            ])
                    }
                }.build(typeChecked: true)
        let sut = PromoteNSMutableArrayIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.typeIntentions()[0]
        XCTAssertEqual(type.properties[0].type, .array("A"))
    }
    
    func testPromotePropertyPassedToMethodsTakingNSArray() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder.createProperty(
                        named: "a",
                        type: nsMutableArrayType("A")
                    )
                    builder.createVoidMethod(named: "takesNSArray") { builder in
                        builder.createSignature { builder in
                            builder.addParameter(name: "a", type: nsArrayType("A"))
                        }
                    }
                    builder.createVoidMethod(named: "test") { builder in
                        builder.setBody([
                            .expression(
                                Expression
                                    .identifier("self")
                                    .dot("takesNSArray")
                                    .call([Expression.identifier("self").dot("a")])
                            )
                            ])
                    }
                }.build(typeChecked: true)
        let sut = PromoteNSMutableArrayIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.typeIntentions()[0]
        XCTAssertEqual(type.properties[0].type, .array("A"))
    }
    
    func testPromotePropertyIfUsingNativeNSMutableArrayExtension() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder.createProperty(
                        named: "a",
                        type: nsMutableArrayType("A")
                    )
                    builder.createVoidMethod(named: "test") { builder in
                        builder.setBody([
                            .expression(
                                Expression
                                    .identifier("self")
                                    .dot("a")
                                    .dot("addObject")
                                    .call([.constant(.nil)])
                            )
                            ])
                    }
                }.build()
        let sut = PromoteNSMutableArrayIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions, resolveTypes: true))
        
        let type = intentions.classIntentions()[0]
        XCTAssertEqual(type.properties[0].type, .array("A"))
    }
    
    func testDontPromotePropertyPassedToMethodTakingNSMutableArray() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder.createProperty(
                        named: "a",
                        type: nsMutableArrayType("A")
                    )
                    builder.createVoidMethod(named: "takesNSMutableArray") { builder in
                        builder.createSignature { builder in
                            builder.addParameter(name: "a", type: nsMutableArrayType("A"))
                        }
                    }
                    builder.createVoidMethod(named: "test") { builder in
                        builder.setBody([
                            .expression(
                                Expression
                                    .identifier("self")
                                    .dot("takesNSMutableArray")
                                    .call([Expression.identifier("self").dot("a")])
                            )
                            ])
                    }
                }.build(typeChecked: true)
        let sut = PromoteNSMutableArrayIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.typeIntentions()[0]
        XCTAssertEqual(type.properties[0].type, nsMutableArrayType("A"))
    }
    
    func testDontPromotePropertyIfUsingExclusiveNSMutableArrayExtension() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "NSMutableArray+Ext") { builder in
                    builder.createExtension(forClassNamed: "NSMutableArray") { builder in
                        builder.createVoidMethod(named: "testMethod")
                    }
                }
                .createFileWithClass(named: "A") { builder in
                    builder.createProperty(
                        named: "a",
                        type: nsMutableArrayType("A")
                    )
                    builder.createVoidMethod(named: "test") { builder in
                        builder.setBody([
                            .expression(
                                Expression
                                    .identifier("self")
                                    .dot("a")
                                    .dot("testMethod")
                                    .call()
                            )
                            ])
                    }
                }.build(typeChecked: true)
        let sut = PromoteNSMutableArrayIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.classIntentions()[0]
        XCTAssertEqual(type.properties[0].type, nsMutableArrayType("A"))
    }
    
    func testDontPromotePropertyIfUsingExclusiveNSArrayExtension() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "NSArray+Ext") { builder in
                    builder.createExtension(forClassNamed: "NSArray") { builder in
                        builder.createVoidMethod(named: "testMethod")
                    }
                }
                .createFileWithClass(named: "A") { builder in
                    builder.createProperty(
                        named: "a",
                        type: nsMutableArrayType("A")
                    )
                    builder.createVoidMethod(named: "test") { builder in
                        builder.setBody([
                            .expression(
                                Expression
                                    .identifier("self")
                                    .dot("a")
                                    .dot("testMethod")
                                    .call()
                            )
                            ])
                    }
                }.build(typeChecked: true)
        let sut = PromoteNSMutableArrayIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions, resolveTypes: true))
        
        let type = intentions.classIntentions()[0]
        XCTAssertEqual(type.properties[0].type, nsMutableArrayType("A"))
    }
    
    func testDontPromotePropertyIfUsingProtocolImplementedByNSArray() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "Extension") { builder in
                    builder.createProtocol(withName: "Prot") { builder in
                        builder.createVoidMethod(named: "testMethod")
                    }
                }
                .createFile(named: "NSArray+Ext") { builder in
                    builder.createProtocol(withName: "Prot")
                    builder.createExtension(forClassNamed: "NSArray", categoryName: "Ext") { ext in
                        ext.createConformance(protocolName: "Prot")
                    }
                }
                .createFileWithClass(named: "A") { builder in
                    builder.createProperty(
                        named: "a",
                        type: nsMutableArrayType("A")
                    )
                    builder.createVoidMethod(named: "test") { builder in
                        builder.setBody([
                            .expression(
                                Expression
                                    .identifier("self")
                                    .dot("a")
                                    .dot("testMethod")
                                    .call()
                            )
                            ])
                    }
                }.build(typeChecked: true)
        let sut = PromoteNSMutableArrayIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions, resolveTypes: true))
        
        let type = intentions.classIntentions()[0]
        XCTAssertEqual(type.properties[0].type, nsMutableArrayType("A"))
    }
    
    func testDontPromotePropertyIfUsingUnknownMemberDeclaration() {
        let intentions =
            IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder.createProperty(
                        named: "a",
                        type: nsMutableArrayType("A")
                    )
                    builder.createVoidMethod(named: "test") { builder in
                        builder.setBody([
                            .expression(
                                Expression
                                    .identifier("self")
                                    .dot("a")
                                    .dot("unknownMember")
                                    .call()
                            )
                            ])
                    }
                }.build(typeChecked: true)
        let sut = PromoteNSMutableArrayIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions, resolveTypes: true))
        
        let type = intentions.classIntentions()[0]
        XCTAssertEqual(type.properties[0].type, nsMutableArrayType("A"))
    }
}

private func nsArrayType(_ element: SwiftType) -> SwiftType {
    return .generic("NSArray", parameters: [element])
}

private func nsMutableArrayType(_ element: SwiftType) -> SwiftType {
    return .generic("NSMutableArray", parameters: [element])
}
