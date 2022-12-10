import Intentions
import SwiftAST
import SwiftRewriterLib
import TestCommons
import XCTest

@testable import IntentionPasses

class SubscriptDeclarationIntentionPassTests: XCTestCase {
    func testConvertSubscriptGetter() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createMethod("objectAtIndexSubscript(_ index: UInt) -> NSObject") { method in
                    method
                        .setAccessLevel(.private)
                        .setBody([
                            .return(.identifier("value"))
                        ])
                }
            }.build()
        let sut = SubscriptDeclarationIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertIsEmpty()
            type[\.subscripts].assertCount(1)
            type[\.subscripts][0]?
                .assert(accessLevel: .private)?
                .assert(returnType: "NSObject")?
                .assertIsGetterOnly()?
                .assert(parameters: [
                    .init(name: "index", type: .uint)
                ])?
                .assert(getterBody: [
                    .return(.identifier("value"))
                ])
        }
    }

    func testConvertSubscriptGetterHistoryTracking() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createMethod("objectAtIndexSubscript(_ index: UInt) -> NSObject") { method in
                    method.setBody([.return(.identifier("value"))])
                        .addHistory(tag: "Test", description: "Method description")
                }
            }.build()
        let sut = SubscriptDeclarationIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.subscripts][0]?.assert(historySummary:
                """
                [Test] Method description
                [Creation] Creating subscript declaration from objectAtIndexSubscript(_:) method
                """
            )
        }
    }

    func testConvertSubscriptGetterAndSetter() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type
                    .createMethod("objectAtIndexSubscript(_ index: UInt) -> NSObject") { method in
                        method
                            .setAccessLevel(.private)
                            .setBody([
                                .return(.identifier("value"))
                            ])
                    }.createMethod("setObject(_ object: NSObject, atIndexedSubscript index: UInt)")
                { method in
                    method.setBody([.expression(.identifier("object"))])
                }
            }.build()
        let sut = SubscriptDeclarationIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertIsEmpty()
            type[\.subscripts].assertCount(1)
            type[\.subscripts][0]?
                .assert(accessLevel: .private)?
                .assert(returnType: "NSObject")?
                .assertIsGetterAndSetter()?
                .assert(parameters: [
                    .init(name: "index", type: .uint)
                ])?
                .assert(getterBody: [
                    .return(.identifier("value"))
                ])?
                .assert(setterBody: [
                    .expression(.identifier("object"))
                ])?
                .assert(setterValueIdentifier: "object")
        }
    }

    func testConvertSubscriptGetterAndSetterHistoryTracking() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type
                    .createMethod("objectAtIndexSubscript(_ index: UInt) -> NSObject") { method in
                        method
                            .setAccessLevel(.private)
                            .setBody([
                                .return(.identifier("value"))
                            ])
                            .addHistory(tag: "Test", description: "Getter history")
                    }.createMethod("setObject(_ object: NSObject, atIndexedSubscript index: UInt)")
                { method in
                    method.setBody([.expression(.identifier("object"))])
                        .addHistory(tag: "Test", description: "Setter history")
                }
            }.build()
        let sut = SubscriptDeclarationIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.subscripts][0]?.assert(historySummary:
                """
                [Test] Getter history
                [Test] Setter history
                [Creation] Creating subscript declaration from objectAtIndexSubscript(_:) and setObject(_:atIndexedSubscript:) pair
                """
            )
        }
    }

    func testDontConvertSubscriptWithSetterOnly() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createMethod("setObject(_ object: NSObject, atIndexedSubscript index: UInt)") {
                    method in
                    method.setBody([.expression(.identifier("object"))])
                }
            }.build()
        let sut = SubscriptDeclarationIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(1)
            type[\.subscripts].assertIsEmpty()
        }
    }

    func testDontConvertGetterWithVoidReturnType() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createMethod("objectAtIndexSubscript(_ index: UInt) -> Void")
            }.build()
        let sut = SubscriptDeclarationIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(1)
            type[\.subscripts].assertIsEmpty()
        }
    }

    func testDontMergeGetterWithSetterWithDifferentObjectParameter() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type
                    .createMethod("objectAtIndexSubscript(_ index: UInt) -> NSObject") { method in
                        method
                            .setAccessLevel(.private)
                            .setBody([
                                .return(.identifier("value"))
                            ])
                    }.createMethod("setObject(_ object: NSArray, atIndexedSubscript index: UInt)") {
                        method in
                        method.setBody([.expression(.identifier("object"))])
                    }
            }.build()
        let sut = SubscriptDeclarationIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(1)
            type[\.subscripts].assertCount(1)
            type[\.subscripts][0]?
                .assert(accessLevel: .private)?
                .assertIsGetterOnly()?
                .assert(returnType: "NSObject")?
                .assert(parameters: [
                    .init(name: "index", type: .uint)
                ])?
                .assert(getterBody: [
                    .return(.identifier("value"))
                ])
        }
    }

    func testDontMergeGetterWithSetterWithDifferentIndexParameters() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type
                    .createMethod("objectAtIndexSubscript(_ index: NSString) -> NSObject") {
                        method in
                        method
                            .setAccessLevel(.private)
                            .setBody([
                                .return(.identifier("value"))
                            ])
                    }.createMethod("setObject(_ object: NSObject, atIndexedSubscript index: UInt)")
                { method in
                    method.setBody([.expression(.identifier("object"))])
                }
            }.build()
        let sut = SubscriptDeclarationIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(1)
            type[\.subscripts].assertCount(1)
            type[\.subscripts][0]?
                .assert(accessLevel: .private)?
                .assertIsGetterOnly()?
                .assert(returnType: "NSObject")?
                .assert(parameters: [
                    .init(name: "index", type: "NSString")
                ])?
                .assert(getterBody: [
                    .return(.identifier("value"))
                ])
        }
    }

    func testDontMergeGetterWithSetterWithNonVoidReturnType() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type
                    .createMethod("objectAtIndexSubscript(_ index: UInt) -> NSObject") { method in
                        method
                            .setAccessLevel(.private)
                            .setBody([
                                .return(.identifier("value"))
                            ])
                    }.createMethod(
                        "setObject(_ object: NSObject, atIndexedSubscript index: UInt) -> NSInteger"
                    ) { method in
                        method.setBody([.expression(.identifier("object"))])
                    }
            }.build()
        let sut = SubscriptDeclarationIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(1)
            type[\.subscripts].assertCount(1)
            type[\.subscripts][0]?
                .assert(accessLevel: .private)?
                .assertIsGetterOnly()?
                .assert(returnType: "NSObject")?
                .assert(parameters: [
                    .init(name: "index", type: .uint)
                ])?
                .assert(getterBody: [
                    .return(.identifier("value"))
                ])
        }
    }

    func testConvertSubscriptGetterKeepsComments() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createMethod("objectAtIndexSubscript(_ index: UInt) -> NSObject") { method in
                    method
                        .addComment("// A comment")
                        .setAccessLevel(.private)
                        .setBody([
                            .return(.identifier("value"))
                        ])
                }
            }.build()
        let sut = SubscriptDeclarationIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(0)
            type[\.subscripts].assertCount(1)
            type[\.subscripts][0]?
                .assert(precedingComments: [
                    "// A comment",
                ])
        }
    }

    func testConvertSubscriptGetterSetterKeepsComments() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createMethod("objectAtIndexSubscript(_ index: UInt) -> NSObject") { method in
                    method
                        .addComment("// Getter comment")
                        .setAccessLevel(.private)
                        .setBody([
                            .return(.identifier("value"))
                        ])
                }.createMethod("setObject(_ object: NSObject, atIndexedSubscript index: UInt)") {
                    method in
                    method.addComment("// Setter comment")
                }
            }.build()
        let sut = SubscriptDeclarationIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserter(forClassNamed: "A") { type in
            type[\.methods].assertCount(0)
            type[\.subscripts].assertCount(1)
            type[\.subscripts][0]?
                .assert(precedingComments: [
                    "// Getter comment",
                    "// Setter comment",
                ])
        }
    }
}
