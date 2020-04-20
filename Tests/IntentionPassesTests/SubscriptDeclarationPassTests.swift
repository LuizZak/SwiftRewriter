import XCTest
import IntentionPasses
import SwiftAST
import Intentions
import SwiftRewriterLib
import TestCommons

class SubscriptDeclarationPassTests: XCTestCase {
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
        let sut = SubscriptDeclarationPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.classIntentions()[0]
        XCTAssert(type.methods.isEmpty)
        XCTAssertEqual(type.subscripts.count, 1)
        XCTAssertEqual(type.subscripts.first?.accessLevel, .private)
        XCTAssertEqual(type.subscripts.first?.parameters, [ParameterSignature(name: "index", type: .uint)])
        XCTAssertEqual(type.subscripts.first?.returnType, "NSObject")
        XCTAssertEqual(type.subscripts.first?.mode.getter.body, [
            .return(.identifier("value"))
        ])
    }
    
    func testConvertSubscriptGetterHistoryTracking() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createMethod("objectAtIndexSubscript(_ index: UInt) -> NSObject") { method in
                    method.setBody([.return(.identifier("value"))])
                        .addHistory(tag: "Test", description: "Method description")
                }
            }.build()
        let sut = SubscriptDeclarationPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.classIntentions()[0]
        
        diffTest(expected: """
            [Test] Method description
            [Creation] Creating subscript declaration from objectAtIndexSubscript(_:) method
            """).diff(type.subscripts[0].history.summary)
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
                    }.createMethod("setObject(_ object: NSObject, atIndexedSubscript index: UInt)") { method in
                        method.setBody([.expression(.identifier("object"))])
                    }
            }.build()
        let sut = SubscriptDeclarationPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.classIntentions()[0]
        XCTAssert(type.methods.isEmpty)
        XCTAssertEqual(type.subscripts.count, 1)
        XCTAssertEqual(type.subscripts.first?.accessLevel, .private)
        XCTAssertEqual(type.subscripts.first?.parameters, [ParameterSignature(name: "index", type: .uint)])
        XCTAssertEqual(type.subscripts.first?.returnType, "NSObject")
        XCTAssertEqual(type.subscripts.first?.mode.getter.body, [
            .return(.identifier("value"))
        ])
        XCTAssertEqual(type.subscripts.first?.mode.setter?.valueIdentifier, "object")
        XCTAssertEqual(type.subscripts.first?.mode.setter?.body.body, [
            .expression(.identifier("object"))
        ])
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
                    }.createMethod("setObject(_ object: NSObject, atIndexedSubscript index: UInt)") { method in
                        method.setBody([.expression(.identifier("object"))])
                            .addHistory(tag: "Test", description: "Setter history")
                    }
            }.build()
        let sut = SubscriptDeclarationPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.classIntentions()[0]
        
        diffTest(expected: """
            [Test] Getter history
            [Test] Setter history
            [Creation] Creating subscript declaration from objectAtIndexSubscript(_:) and setObject(_:atIndexedSubscript:) pair
            """).diff(type.subscripts[0].history.summary)
    }
    
    func testDontConvertSubscriptWithSetterOnly() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createMethod("setObject(_ object: NSObject, atIndexedSubscript index: UInt)") { method in
                    method.setBody([.expression(.identifier("object"))])
                }
            }.build()
        let sut = SubscriptDeclarationPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.classIntentions()[0]
        XCTAssertEqual(type.methods.count, 1)
        XCTAssert(type.subscripts.isEmpty)
    }
    
    func testDontConvertGetterWithVoidReturnType() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createMethod("objectAtIndexSubscript(_ index: UInt) -> Void")
            }.build()
        let sut = SubscriptDeclarationPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.classIntentions()[0]
        XCTAssertEqual(type.methods.count, 1)
        XCTAssert(type.subscripts.isEmpty)
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
                    }.createMethod("setObject(_ object: NSArray, atIndexedSubscript index: UInt)") { method in
                        method.setBody([.expression(.identifier("object"))])
                    }
            }.build()
        let sut = SubscriptDeclarationPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.classIntentions()[0]
        XCTAssertEqual(type.methods.count, 1)
        XCTAssertEqual(type.subscripts.count, 1)
        XCTAssertEqual(type.subscripts.first?.accessLevel, .private)
        XCTAssertEqual(type.subscripts.first?.parameters, [ParameterSignature(name: "index", type: .uint)])
        XCTAssertEqual(type.subscripts.first?.returnType, "NSObject")
        XCTAssertEqual(type.subscripts.first?.mode.getter.body, [
            .return(.identifier("value"))
        ])
        XCTAssertNil(type.subscripts.first?.mode.setter)
    }
    
    func testDontMergeGetterWithSetterWithDifferentIndexParameters() {
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type
                    .createMethod("objectAtIndexSubscript(_ index: NSString) -> NSObject") { method in
                        method
                            .setAccessLevel(.private)
                            .setBody([
                                .return(.identifier("value"))
                            ])
                    }.createMethod("setObject(_ object: NSObject, atIndexedSubscript index: UInt)") { method in
                        method.setBody([.expression(.identifier("object"))])
                    }
            }.build()
        let sut = SubscriptDeclarationPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.classIntentions()[0]
        XCTAssertEqual(type.methods.count, 1)
        XCTAssertEqual(type.subscripts.count, 1)
        XCTAssertEqual(type.subscripts.first?.accessLevel, .private)
        XCTAssertEqual(type.subscripts.first?.parameters, [ParameterSignature(name: "index", type: "NSString")])
        XCTAssertEqual(type.subscripts.first?.returnType, "NSObject")
        XCTAssertEqual(type.subscripts.first?.mode.getter.body, [
            .return(.identifier("value"))
        ])
        XCTAssertNil(type.subscripts.first?.mode.setter)
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
                    }.createMethod("setObject(_ object: NSObject, atIndexedSubscript index: UInt) -> NSInteger") { method in
                        method.setBody([.expression(.identifier("object"))])
                    }
            }.build()
        let sut = SubscriptDeclarationPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.classIntentions()[0]
        XCTAssertEqual(type.methods.count, 1)
        XCTAssertEqual(type.subscripts.count, 1)
        XCTAssertEqual(type.subscripts.first?.accessLevel, .private)
        XCTAssertEqual(type.subscripts.first?.parameters, [ParameterSignature(name: "index", type: .uint)])
        XCTAssertEqual(type.subscripts.first?.returnType, "NSObject")
        XCTAssertEqual(type.subscripts.first?.mode.getter.body, [
            .return(.identifier("value"))
        ])
        XCTAssertNil(type.subscripts.first?.mode.setter)
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
        let sut = SubscriptDeclarationPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.classIntentions()[0]
        XCTAssertEqual(type.subscripts[0].precedingComments, [
            "// A comment"
        ])
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
                }.createMethod("setObject(_ object: NSObject, atIndexedSubscript index: UInt)") { method in
                    method.addComment("// Setter comment")
                }
            }.build()
        let sut = SubscriptDeclarationPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.classIntentions()[0]
        XCTAssertEqual(type.subscripts[0].precedingComments, [
            "// Getter comment",
            "// Setter comment"
        ])
    }
}
