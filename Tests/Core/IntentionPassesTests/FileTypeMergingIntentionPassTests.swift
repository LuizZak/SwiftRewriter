import XCTest
import ObjcGrammarModels
import SwiftAST
import SwiftRewriterLib
import TestCommons

@testable import IntentionPasses

class FileTypeMergingIntentionPassTests: XCTestCase {

    func testMergeFiles() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createClass(withName: "A") { builder in
                    builder
                        .addComment("// Header comment")
                        .createVoidMethod(named: "fromHeader") { method in
                            method.addComment("// Header comment")
                        }
                        .setAsInterfaceSource()
                }
                file.createExtension(forClassNamed: "A") { builder in
                    builder
                        .createVoidMethod(named: "fromHeaderExt")
                        .setAsInterfaceSource()
                }
            }.createFile(named: "A.m") { file in
                file.createClass(withName: "A") { builder in
                    builder
                        .addComment("// Implementation comment")
                        .createVoidMethod(named: "fromImplementation") { method in
                            method
                                .addComment("// Implementation comment")
                                .setBody([
                                    .expression(
                                        .identifier("stmt").call()
                                    )
                                ])
                        }
                }
                file.createExtension(forClassNamed: "A") { builder in
                    builder.createVoidMethod(named: "fromImplementationExt")
                }
            }.build()
        let sut = FileTypeMergingIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files[0].sourcePath, "A.m")
        XCTAssertEqual(files[0].classIntentions.count, 1)
        XCTAssertEqual(files[0].extensionIntentions.count, 1)
        XCTAssertEqual(files[0].extensionIntentions[0].typeName, "A")
        XCTAssertEqual(
            files[0].classIntentions[0].precedingComments,
            [
                "// Header comment",
                "// Implementation comment",
            ]
        )
        XCTAssertEqual(files[0].classIntentions[0].typeName, "A")
        XCTAssertEqual(
            files[0].classIntentions[0].methods[0].precedingComments,
            [
                "// Implementation comment"
            ]
        )
        XCTAssertEqual(
            files[0].classIntentions[0].methods[1].precedingComments,
            [
                "// Header comment"
            ]
        )
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
                        method.setBody([
                            .expression(
                                .identifier("stmt").call()
                            )
                        ])
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
                        method.setBody([
                            .expression(
                                .identifier("stmt").call()
                            )
                        ])
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
                        method.setBody([
                            .expression(
                                .identifier("stmt").call()
                            )
                        ])
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
        let intentions = IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.addHeaderComment("#define Abcde")
            }
            .build()
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
                        method.setBody([
                            .expression(
                                .identifier("stmt").call()
                            )
                        ])
                    }
                }
            }.build()
        let sut = FileTypeMergingIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let files = intentions.fileIntentions()
        XCTAssertEqual(
            files[0].classIntentions[0].history.summary,
            """
            [TypeMerge:FileTypeMergingIntentionPass] Creating definition for newly found method A.fromHeader()
            """
        )
    }

    func testMergeDirectivesIntoImplementationFile() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.addHeaderComment("#directive1")
            }
            .createFile(named: "A.m") { file in
                file.addHeaderComment("#directive2")
                file.createClass(withName: "A")
            }
            .build()
        let sut = FileTypeMergingIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files[0].sourcePath, "A.m")
        XCTAssertEqual(
            files[0].headerComments,
            ["#directive1", "#directive2"]
        )
        XCTAssertEqual(files[0].classIntentions.count, 1)
    }

    func testMergeFunctionDefinitionsToDeclarations() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createGlobalFunction(withName: "a", returnType: .typeName("A"))
            }
            .createFile(named: "A.m") { file in
                file.createGlobalFunction(
                    withName: "a",
                    returnType: .nullabilityUnspecified(.typeName("A")),
                    body: [
                        .expression(
                            .identifier("a")
                                .call()
                        )
                    ]
                )
            }.build()
        intentions.fileIntentions()[0].globalFunctionIntentions[0].precedingComments = [
            "// Header comments"
        ]
        intentions.fileIntentions()[1].globalFunctionIntentions[0].precedingComments = [
            "// Implementation comments"
        ]
        let sut = FileTypeMergingIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let files = intentions.fileIntentions()
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files[0].sourcePath, "A.m")
        XCTAssertEqual(files[0].globalFunctionIntentions.count, 1)
        XCTAssertEqual(
            files[0].globalFunctionIntentions.first?.signature,
            FunctionSignature(
                name: "a",
                parameters: [],
                returnType: .typeName("A"),
                isStatic: false
            )
        )
        XCTAssertEqual(
            files[0].globalFunctionIntentions.first?.functionBody?.body,
            [.expression(.identifier("a").call())]
        )
        XCTAssertEqual(
            files[0].globalFunctionIntentions.first?.precedingComments,
            [
                "// Header comments",
                "// Implementation comments",
            ]
        )
    }

    func testDontMergeSimilarButNotActuallyMatchingGlobalFunctions() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createGlobalFunction(
                    withName: "a",
                    parameters: [
                        ParameterSignature(label: nil, name: "a", type: .int)
                    ]
                )
            }
            .createFile(named: "A.m") { file in
                file.createGlobalFunction(
                    withName: "a",
                    body: [
                        .expression(
                            .identifier("a")
                                .call()
                        )
                    ]
                )
            }.build()
        let sut = FileTypeMergingIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let files = intentions.fileIntentions()
        let functions = files[0].globalFunctionIntentions
        XCTAssertEqual(files.count, 1)
        XCTAssertEqual(files[0].sourcePath, "A.m")
        XCTAssertEqual(functions.count, 2)

        // a()
        XCTAssertEqual(
            functions[0].functionBody?.body,
            [.expression(.identifier("a").call())]
        )

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
                        method.signature.isStatic = true
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
                            method
                                .addComment("// Header comment")
                                .signature.isStatic = true
                        }
                        .setAsInterfaceSource()
                }
            }.createFile(named: "A.m") { file in
                file.createClass(withName: "A") { builder in
                    builder.createVoidMethod(named: "a") { method in
                        method
                            .addComment("// Implementation comment")
                            .signature.isStatic = true
                    }
                }
            }.build()
        let sut = FileTypeMergingIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let files = intentions.fileIntentions()
        let methods = files[0].classIntentions[0].methods
        XCTAssertEqual(
            methods[0].precedingComments,
            [
                "// Header comment",
                "// Implementation comment",
            ]
        )
        XCTAssertEqual(methods.count, 1)
    }

    func testMovesTypealiasesToImplementationWhenAvailable() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createTypealias(withName: "Abc", type: .typeName("NSInteger"))
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
                file.createGlobalVariable(
                    withName: "abc",
                    type: .int,
                    initialExpression: .constant(1)
                )
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
                file.createGlobalFunction(
                    withSignature: FunctionSignature(name: "a", parameters: []),
                    body: []
                )
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
        let headerBlock: SwiftType = .swiftBlock(returnType: .void, parameters: [.typeName("A")])

        let unspecifiedBlock: SwiftType = .nullabilityUnspecified(
            .swiftBlock(returnType: .void, parameters: [.nullabilityUnspecified(.typeName("A"))])
        )

        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createClass(withName: "A") { type in
                    type.setAsInterfaceSource()
                    type.createMethod(
                        named: "a",
                        parameters: [ParameterSignature(label: nil, name: "a", type: headerBlock)]
                    )
                }
            }.createFile(named: "A.m") { file in
                file.createClass(withName: "A") { type in
                    type.createMethod(
                        named: "a",
                        parameters: [
                            ParameterSignature(label: nil, name: "a", type: unspecifiedBlock)
                        ]
                    )
                }
            }.build()
        let sut = FileTypeMergingIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let cls = intentions.fileIntentions()[0].typeIntentions[0]
        XCTAssertEqual(
            cls.methods[0].parameters[0].type,
            .swiftBlock(returnType: .void, parameters: [.typeName("A")])
        )
    }

    func testKeepsAliasInMergedBlockSignatures() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "Aliases.h") { file in
                file.beginNonnulContext()
                    .createTypealias(
                        withName: "ABlock",
                        swiftType: .swiftBlock(returnType: .void, parameters: ["A"]),
                        type: .blockType(
                            name: "ABlock",
                            returnType: .void,
                            parameters: [.pointer(.typeName("A"))]
                        )
                    )
                    .endNonnullContext()
            }
            .createFile(named: "A.h") { file in
                file.createClass(withName: "A") { type in
                    type.setAsInterfaceSource()
                        .createMethod("a(_ a: ABlock)")
                }
            }.createFile(named: "A.m") { file in
                file.createClass(withName: "A") { type in
                    type.createMethod(
                        FunctionSignature(
                            name: "a",
                            parameters: [
                                ParameterSignature(
                                    label: nil,
                                    name: "a",
                                    type: .nullabilityUnspecified(
                                        .swiftBlock(
                                            returnType: .void,
                                            parameters: [.nullabilityUnspecified("A")]
                                        )
                                    )
                                )
                            ]
                        )
                    )
                }
            }.build()
        let sut = FileTypeMergingIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let cls = intentions.fileIntentions()[1].typeIntentions[0]
        XCTAssertEqual(cls.methods[0].parameters[0].type, "ABlock")
    }

    func testMergeStructTypeDefinitions() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createStruct(withName: "A")
            }
            .createFile(named: "A.m") { file in
                file.createStruct(withName: "A") { str in
                    str.createInstanceVariable(named: "a", type: .int)
                        .createConstructor()
                        .createConstructor(
                            withParameters: [
                                ParameterSignature(name: "a", type: .int)
                            ])
                }
            }.build()
        let sut = FileTypeMergingIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let file = intentions.fileIntentions()[0]
        XCTAssertEqual(intentions.fileIntentions().count, 1)
        XCTAssert(file.sourcePath.hasSuffix(".m"))
        XCTAssertEqual(file.structIntentions.count, 1)
        XCTAssertEqual(file.structIntentions[0].instanceVariables.count, 1)
    }

    func testMergeExtensions() {
        let intentions =
            IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.createExtension(forClassNamed: "A") { builder in
                    builder
                        .createMethod(named: "test") { builder in
                            builder.createSignature { builder in
                                builder.addParameter(
                                    name: "test",
                                    type: .string
                                )
                            }
                        }
                        .setAsInterfaceSource()
                }
            }.createFile(named: "A.m") { file in
                file.createExtension(forClassNamed: "A") { builder in
                    builder
                        .createMethod(named: "test") { builder in
                            builder.createSignature { builder in
                                builder.addParameter(
                                    name: "test",
                                    type: .nullabilityUnspecified(.string)
                                )
                            }
                        }
                }
            }.build()
        let sut = FileTypeMergingIntentionPass()

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let files = intentions.fileIntentions()
        XCTAssertEqual(files[0].extensionIntentions[0].methods.count, 1)
        XCTAssertEqual(files[0].extensionIntentions[0].methods[0].name, "test")
        XCTAssertEqual(
            files[0].extensionIntentions[0].methods[0].signature,
            FunctionSignature(
                name: "test",
                parameters: [ParameterSignature(name: "test", type: .string)]
            )
        )
    }
}
