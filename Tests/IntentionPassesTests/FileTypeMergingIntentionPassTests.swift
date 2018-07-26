import XCTest
import IntentionPasses
import SwiftRewriterLib
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
                        builder.createVoidMethod(named: "fromImplementation") { method in
                            method.setBody([.expression(.postfix(.identifier("stmt"), .functionCall()))])
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
                        builder.createVoidMethod(named: "fromImplementation") { method in
                            method.setBody([.expression(.postfix(.identifier("stmt"), .functionCall()))])
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
                        builder.createVoidMethod(named: "fromImplementation") { method in
                            method.setBody([.expression(.postfix(.identifier("stmt"), .functionCall()))])
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
                        builder.createVoidMethod(named: "amImplementation") { method in
                            method.setBody([.expression(.postfix(.identifier("stmt"), .functionCall()))])
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
                        builder.createVoidMethod(named: "fromImplementation") { method in
                            method.setBody([.expression(.postfix(.identifier("stmt"), .functionCall()))])
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
    
    func testMergeDirectivesIntoImplementationFile() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h")
                .createFile(named: "A.m") { file in
                    file.createClass(withName: "A")
                }
                .build()
        intentions.fileIntentions()[0].preprocessorDirectives = ["#directive1"]
        intentions.fileIntentions()[1].preprocessorDirectives = ["#directive2"]
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files[0].sourcePath, "A.m")
        XCTAssertEqual(files[0].preprocessorDirectives, ["#directive1", "#directive2"])
        XCTAssertEqual(files[0].classIntentions.count, 1)
    }
    
    func testRemovesEmptyExtensions() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.m") { file in
                    file.createClass(withName: "A")
                        .createExtension(forClassNamed: "A")
                        .createExtension(forClassNamed: "A", categoryName: "")
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files[0].classIntentions.count, 1)
        XCTAssertEqual(files[0].extensionIntentions.count, 0)
    }
    
    func testDoesNotRemovesExtensionsWithMembers() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.m") { file in
                    file.createClass(withName: "A")
                        .createExtension(forClassNamed: "A") { builder in
                            builder.createVoidMethod(named: "a")
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files[0].classIntentions.count, 1)
        XCTAssertEqual(files[0].extensionIntentions.count, 1)
    }
    
    func testDoesNotRemovesExtensionsWithCategoryName() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.m") { file in
                    file.createClass(withName: "A")
                        .createExtension(forClassNamed: "A", categoryName: "Abc")
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files[0].classIntentions.count, 1)
        XCTAssertEqual(files[0].extensionIntentions.count, 1)
    }
    
    func testDoesNotRemovesExtensionsWithInheritances() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.m") { file in
                    file.createClass(withName: "A")
                        .createExtension(forClassNamed: "A") { builder in
                            builder.createConformance(protocolName: "B")
                        }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files[0].classIntentions.count, 1)
        XCTAssertEqual(files[0].extensionIntentions.count, 1)
    }
    
    func testMergeFunctionDefinitionsToDeclarations() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createGlobalFunction(withName: "a", returnType: .typeName("A"))
                }
                .createFile(named: "A.m") { file in
                    file.createGlobalFunction(withName: "a",
                                              returnType: .implicitUnwrappedOptional(.typeName("A")),
                                              body: [
                                                .expression(
                                                    .postfix(
                                                        .identifier("a"),
                                                        .functionCall()
                                                    )
                                                )])
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files[0].sourcePath, "A.m")
        XCTAssertEqual(files[0].globalFunctionIntentions.count, 1)
        XCTAssertEqual(files[0].globalFunctionIntentions.first?.signature,
                       FunctionSignature(name: "a", parameters: [],
                                         returnType: .typeName("A"),
                                         isStatic: true)
                       )
        XCTAssertEqual(files[0].globalFunctionIntentions.first?.functionBody?.body,
                       [.expression(
                        .postfix(
                            .identifier("a"),
                            .functionCall()
                        )
                        )])
    }
    
    func testDontMergeSimilarButNotActuallyMatchingGlobalFunctions() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createGlobalFunction(withName: "a",
                                              parameters: [
                                                ParameterSignature(label: "_", name: "a", type: .int)
                                              ])
                }
                .createFile(named: "A.m") { file in
                    file.createGlobalFunction(withName: "a",
                                              body: [
                                                .expression(
                                                    .postfix(
                                                        .identifier("a"),
                                                        .functionCall()
                                                    )
                                                )])
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        let functions = files[0].globalFunctionIntentions
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files[0].sourcePath, "A.m")
        XCTAssertEqual(functions.count, 2)
        
        // a()
        XCTAssertEqual(functions[0].functionBody?.body,
                       [
                        .expression(
                            .postfix(
                                .identifier("a"),
                                .functionCall()
                            )
                        )])
        
        // a(int)
        XCTAssertNil(functions[1].functionBody?.body)
    }
    
    func testDoesntMergeStaticAndNonStaticSelectors() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createClass(withName: "A") { builder in
                        builder
                            .createVoidMethod(named: "a")
                            .setAsInterfaceSource()
                    }
                }.createFile(named: "A.m") { file in
                    file.createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "a") { method in
                            method.setIsStatic(true)
                        }
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        let methods = files[0].classIntentions[0].methods
        XCTAssertEqual(methods.count, 2)
    }
    
    func testProperMergeOfStaticSelectors() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createClass(withName: "A") { builder in
                        builder
                            .createVoidMethod(named: "a") { method in
                                method.setIsStatic(true)
                            }
                            .setAsInterfaceSource()
                    }
                }.createFile(named: "A.m") { file in
                    file.createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "a") { method in
                            method.setIsStatic(true)
                        }
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        let methods = files[0].classIntentions[0].methods
        XCTAssertEqual(methods.count, 1)
    }
    
    func testMovesTypealiasesToImplementationWhenAvailable() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createTypealias(withName: "Abc", type: .struct("NSInteger"))
                }.createFile(named: "A.m")
                .build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files.first?.sourcePath, "A.m")
        XCTAssertEqual(files.first?.typealiasIntentions.count, 1)
    }
    
    func testMovesEnumsToImplementationWhenAvailable() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createEnum(withName: "A", rawValue: .int)
                }.createFile(named: "A.m")
                .build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files.first?.sourcePath, "A.m")
        XCTAssertEqual(files.first?.enumIntentions.count, 1)
    }
    
    func testMovesProtocolsToImplementationWhenAvailable() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createProtocol(withName: "A")
                }.createFile(named: "A.m")
                .build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files.first?.sourcePath, "A.m")
        XCTAssertEqual(files.first?.protocolIntentions.count, 1)
    }
    
    func testMovesGlobalVariablesToImplementationWhenAvailable() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createGlobalVariable(withName: "abc", type: .int)
                }.createFile(named: "A.m")
                .build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files.first?.sourcePath, "A.m")
        XCTAssertEqual(files.first?.globalVariableIntentions.count, 1)
    }
    
    func testDontDuplicateGlobalVariableDeclarationsWhenMovingFromHeaderToImplementation() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createGlobalVariable(withName: "abc", type: .int)
                }.createFile(named: "A.m") { file in
                    file.createGlobalVariable(withName: "abc", type: .int, initialExpression: .constant(1))
                }
                .build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files.first?.sourcePath, "A.m")
        XCTAssertEqual(files.first?.globalVariableIntentions.count, 1)
    }
    
    func testMovesGlobalFunctionsToImplementationWhenAvailable() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createGlobalFunction(withName: "a")
                }.createFile(named: "A.m")
                .build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files.first?.sourcePath, "A.m")
        XCTAssertEqual(files.first?.globalFunctionIntentions.count, 1)
    }
    
    func testMovesStructsToImplementationWhenAvailable() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createStruct(withName: "a")
                }.createFile(named: "A.m")
                .build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files.first?.sourcePath, "A.m")
        XCTAssertEqual(files.first?.structIntentions.count, 1)
    }
    
    func testDontDuplicateGlobalFunctionsDeclarationsWhenMovingFromHeaderToImplementation() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createGlobalFunction(withName: "a")
                }.createFile(named: "A.m") { file in
                    file.createGlobalFunction(withSignature: FunctionSignature(name: "a", parameters: []),
                                              body: [])
                }
                .build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files.first?.sourcePath, "A.m")
        XCTAssertEqual(files.first?.globalFunctionIntentions.count, 1)
    }
    
    func testMergeBlockParameterNullability() {
        let headerBlock: SwiftType
            = .block(returnType: .void, parameters: [.typeName("A")])
        
        let implBlock: SwiftType
            = .implicitUnwrappedOptional(.block(returnType: .void, parameters: [.implicitUnwrappedOptional(.typeName("A"))]))
        
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createClass(withName: "A") { type in
                        type.setAsInterfaceSource()
                        type.createMethod(
                            named: "a",
                            parameters: [ParameterSignature(label: "_", name: "a", type: headerBlock)]
                        )
                    }
                }.createFile(named: "A.m") { file in
                    file.createClass(withName: "A") { type in
                        type.createMethod(
                            named: "a",
                            parameters: [ParameterSignature(label: "_", name: "a", type: implBlock)]
                        )
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let cls = intentions.fileIntentions()[0].typeIntentions[0]
        XCTAssertEqual(cls.methods[0].parameters[0].type,
                       .block(returnType: .void, parameters: [.typeName("A")]))
    }
}
