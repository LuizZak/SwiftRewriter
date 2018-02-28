//
//  FileTypeMergingIntentionPassTests.swift
//  IntentionPassesTests
//
//  Created by Luiz Silva on 28/02/2018.
//

import XCTest
import IntentionPasses
import SwiftAST
import TestCommons

class FileTypeMergingIntentionPassTests: XCTestCase {
    
    func testMergeFiles() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createClass(withName: "A") { builder in
                        builder
                            .createVoidMethod(named: "fromHeader")
                            .setAsInterfaceSource()
                    }
                }.createFile(named: "A.m") { file in
                    file.createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "fromImplementation") {
                            return [.expression(.postfix(.identifier("stmt"), .functionCall()))]
                        }
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files[0].sourcePath, "A.m")
        XCTAssertEqual(files[0].classIntentions.count, 1)
        XCTAssertEqual(files[0].classIntentions[0].typeName, "A")
    }
    
    func testMergingTypesSortsMethodsFromImplementationAboveMethodsFromInterface() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createClass(withName: "A") { builder in
                        builder
                            .createVoidMethod(named: "fromHeader")
                            .setAsInterfaceSource()
                    }
                }.createFile(named: "A.m") { file in
                    file.createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "fromImplementation") {
                            return [.expression(.postfix(.identifier("stmt"), .functionCall()))]
                        }
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files[0].classIntentions[0].methods.count, 2)
        XCTAssertEqual(files[0].classIntentions[0].methods[0].name, "fromImplementation")
        XCTAssertEqual(files[0].classIntentions[0].methods[1].name, "fromHeader")
    }
    
    func testKeepsInterfaceFilesWithNoMatchingImplementationFileAlone() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createClass(withName: "A") { builder in
                        builder.setAsInterfaceSource()
                    }
                }
                .build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files[0].sourcePath, "A.h")
    }
    
    func testMovesClassesFromHeaderToImplementationWithMismatchesFileNames() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createClass(withName: "A") { builder in
                        builder
                            .createVoidMethod(named: "fromHeader")
                            .setAsInterfaceSource()
                    }
                }.createFile(named: "B.m") { file in
                    file.createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "fromImplementation") {
                            return [.expression(.postfix(.identifier("stmt"), .functionCall()))]
                        }
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files[0].sourcePath, "B.m")
        XCTAssertEqual(files[0].classIntentions.count, 1)
        XCTAssertEqual(files[0].classIntentions[0].methods.count, 2)
        XCTAssertEqual(files[0].classIntentions[0].methods[0].name, "fromImplementation")
        XCTAssertEqual(files[0].classIntentions[0].methods[1].name, "fromHeader")
    }
    
    func testMergeFromSameFile() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.m") { file in
                    file.createClass(withName: "A") { builder in
                        builder
                            .createVoidMethod(named: "amInterface")
                            .setAsInterfaceSource()
                    }
                    
                    file.createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "amImplementation") {
                            return [.expression(.postfix(.identifier("stmt"), .functionCall()))]
                        }
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files[0].sourcePath, "A.m")
        XCTAssertEqual(files[0].classIntentions.count, 1)
        XCTAssertEqual(files[0].classIntentions[0].methods.count, 2)
        XCTAssertEqual(files[0].classIntentions[0].methods[0].name, "amImplementation")
        XCTAssertEqual(files[0].classIntentions[0].methods[1].name, "amInterface")
    }
    
    func testMergeKeepsEmptyFilesWithPreprocessorDirectives() {
        let intentions = IntentionCollectionBuilder().createFile(named: "A.h").build()
        intentions.fileIntentions()[0].preprocessorDirectives = ["#define Abcde"]
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
    }
    
    func testHistoryTracking() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createClass(withName: "A") { builder in
                        builder
                            .createVoidMethod(named: "fromHeader")
                            .setAsInterfaceSource()
                    }
                }.createFile(named: "A.m") { file in
                    file.createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "fromImplementation") {
                            return [.expression(.postfix(.identifier("stmt"), .functionCall()))]
                        }
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(
            files[0].classIntentions[0].history.summary,
            """
            [TypeMerge] Creating definition for newly found method A.fromHeader()
            """
            )
    }
}
