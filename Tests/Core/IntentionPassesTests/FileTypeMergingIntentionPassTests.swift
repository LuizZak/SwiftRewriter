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
                                            Expression.identifier("stmt").call()
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

        Asserter(object: intentions).asserterForFiles { files in
            files.assertCount(1)
            files[0]?.assert(sourcePath: "A.m")
            files[0]?.asserter(forClassNamed: "A") { type in
                type.assert(precedingComments: [
                    "// Header comment",
                    "// Implementation comment"
                ])

                type[\.methods][0]?.assert(precedingComments: [
                    "// Implementation comment"
                ])
                type[\.methods][1]?.assert(precedingComments: [
                    "// Header comment"
                ])
            }
        }
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
                                    Expression.identifier("stmt").call()
                                )
                            ])
                        }
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserterForFiles { files in
            files.assertCount(1)
            files[0]?.assert(sourcePath: "A.m")
            files[0]?.asserter(forTypeNamed: "A") { type in
                let methods = type[\.methods]
                methods[0]?.assert(name: "fromImplementation")
                methods[1]?.assert(name: "fromHeader")
            }
        }
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
        
        Asserter(object: intentions).asserterForFiles { files in
            files.assertCount(1)
            files[0]?.assert(sourcePath: "A.h")
        }
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
                                    Expression.identifier("stmt").call()
                                )
                            ])
                        }
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserterForFiles { files in
            files.assertCount(1)
            files[0]?.assert(sourcePath: "B.m")
            files[0]?.asserter(forTypeNamed: "A") { type in
                let methods = type[\.methods]
                methods[0]?.assert(name: "fromImplementation")
                methods[1]?.assert(name: "fromHeader")
            }
        }
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
                                    Expression.identifier("stmt").call()
                                )
                            ])
                        }
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserterForFiles { files in
            files.assertCount(1)
            files[0]?.assert(sourcePath: "A.m")
            files[0]?.asserter(forTypeNamed: "A") { type in
                let methods = type[\.methods]
                methods[0]?.assert(name: "amImplementation")
                methods[1]?.assert(name: "amInterface")
            }
        }
    }
    
    func testMergeKeepsEmptyFilesWithPreprocessorDirectives() {
        let intentions = IntentionCollectionBuilder()
            .createFile(named: "A.h") { file in
                file.addHeaderComment("#define Abcde")
            }
            .build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions)
            .assert(fileCount: 1)
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
                                    Expression.identifier("stmt").call()
                                )
                            ])
                        }
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserterForFiles { files in
            files.assertCount(1)
            files[0]?.asserter(forTypeNamed: "A") { type in
                type.assert(historySummary:
                    """
                    [TypeMerge:FileTypeMergingIntentionPass] Creating definition for newly found method A.fromHeader()
                    """
                )
            }
        }
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

        Asserter(object: intentions).asserterForFiles { files in
            files.assertCount(1)
            files[0]?.assert(sourcePath: "A.m")
            files[0]?.asserterForTypes {
                $0.assertCount(1)
            }
            files[0]?.assert(headerComments: [
                "#directive1", "#directive2"
            ])
        }
    }
    
    func testMergeFunctionDefinitionsToDeclarations() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createGlobalFunction(withName: "a", returnType: .typeName("A"))
                }
                .createFile(named: "A.m") { file in
                    file.createGlobalFunction(withName: "a",
                                              returnType: .nullabilityUnspecified(.typeName("A")),
                                              body: [
                                                .expression(
                                                    Expression
                                                        .identifier("a")
                                                        .call()
                                                )])
                }.build()
        intentions.fileIntentions()[0].globalFunctionIntentions[0].precedingComments = ["// Header comments"]
        intentions.fileIntentions()[1].globalFunctionIntentions[0].precedingComments = ["// Implementation comments"]
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserterForFiles { files in
            files.assertCount(1)
            files[0]?.assert(sourcePath: "A.m")?.asserterForGlobalFunctions { globals in
                globals.assertCount(1)
                let global = globals[0]
                global?.assert(signature:
                    .init(
                        name: "a",
                        parameters: [],
                        returnType: .typeName("A"),
                        isStatic: false
                    )
                )?.assert(functionBody: [
                    .expression(Expression.identifier("a").call())
                ])?.assert(precedingComments: [
                    "// Header comments",
                    "// Implementation comments"
                ])
            }
        }
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
                                Expression
                                    .identifier("a")
                                    .call()
                            )
                        ]
                    )
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserterForFiles { files in
            files.assertCount(1)
            files[0]?.assert(sourcePath: "A.m")?.asserterForGlobalFunctions { globals in
                globals.assertCount(2)
                // a()
                globals[0]?.assert(functionBody: [
                    .expression(Expression.identifier("a").call())
                ])
                // a(int)
                globals[1]?.asserterForFunctionBody {
                    $0.assertNil()
                }
            }
        }
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

        Asserter(object: intentions).asserterForFiles { files in
            let file = files.assertCount(1)?[0]?.assert(sourcePath: "A.m")
            file?.asserter(forClassNamed: "A") { type in
                type[\.methods].assertCount(2)
            }
        }
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
        
        Asserter(object: intentions).asserterForFiles { files in
            let file = files.assertCount(1)?[0]?.assert(sourcePath: "A.m")
            file?.asserter(forClassNamed: "A") { type in
                type[\.methods][0]?.assert(precedingComments: [
                    "// Header comment",
                    "// Implementation comment"
                ])
            }
        }
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
        
        Asserter(object: intentions).asserterForFiles { files in
            let file = files.assertCount(1)?[0]?.assert(sourcePath: "A.m")
            file?[\.typealiasIntentions].assertCount(1)
        }
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
        
        Asserter(object: intentions).asserterForFiles { files in
            let file = files.assertCount(1)?[0]?.assert(sourcePath: "A.m")
            file?[\.enumIntentions].assertCount(1)
        }
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
        
        Asserter(object: intentions).asserterForFiles { files in
            let file = files.assertCount(1)?[0]?.assert(sourcePath: "A.m")
            file?[\.protocolIntentions].assertCount(1)
        }
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
        
        Asserter(object: intentions).asserterForFiles { files in
            let file = files.assertCount(1)?[0]?.assert(sourcePath: "A.m")
            file?[\.globalVariableIntentions].assertCount(1)
        }
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
        
        Asserter(object: intentions).asserterForFiles { files in
            let file = files.assertCount(1)?[0]?.assert(sourcePath: "A.m")
            file?[\.globalVariableIntentions].assertCount(1)
        }
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
        
        Asserter(object: intentions).asserterForFiles { files in
            let file = files.assertCount(1)?[0]?.assert(sourcePath: "A.m")
            file?[\.globalFunctionIntentions].assertCount(1)
        }
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
        
        Asserter(object: intentions).asserterForFiles { files in
            let file = files.assertCount(1)?[0]?.assert(sourcePath: "A.m")
            file?[\.structIntentions].assertCount(1)
        }
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
        
        Asserter(object: intentions).asserterForFiles { files in
            let file = files.assertCount(1)?[0]?.assert(sourcePath: "A.m")
            file?[\.globalFunctionIntentions].assertCount(1)
        }
    }
    
    func testMergeBlockParameterNullability() {
        let headerBlock: SwiftType
            = .swiftBlock(returnType: .void, parameters: [.typeName("A")])
        
        let unspecifiedBlock: SwiftType
            = .nullabilityUnspecified(.swiftBlock(returnType: .void, parameters: [.nullabilityUnspecified(.typeName("A"))]))
        
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
                            parameters: [ParameterSignature(label: nil, name: "a", type: unspecifiedBlock)]
                        )
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserterForFiles { files in
            let file = files.assertCount(1)?[0]?.assert(sourcePath: "A.m")
            
            file?.asserter(forTypeNamed: "A") { type in
                let method = type[\.methods].assertCount(1)?[0]
                method?.asserter(forParameterAt: 0) { param in
                    param.assert(type:
                        .swiftBlock(
                            returnType: .void,
                            parameters: [.typeName("A")]
                        )
                    )
                }
            }
        }
    }
    
    func testKeepsAliasInMergedBlockSignatures() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "Aliases.h") { file in
                    file.beginNonnulContext()
                        .createTypealias(
                            withName: "ABlock",
                            swiftType: .swiftBlock(returnType: .void, parameters: ["A"]),
                            type: .blockType(name: "ABlock",
                                             returnType: .void,
                                             parameters: [.pointer(.typeName("A"))])
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
                                            .swiftBlock(returnType: .void,
                                                        parameters: [.nullabilityUnspecified("A")])
                                        )
                                    )
                                ]
                            ))
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).inClosureUnconditional { intentions in
            intentions.assert(fileCount: 2)
            intentions.asserter(forTargetPathFile: "A.m") { file in
                file.asserter(forTypeNamed: "A") { type in
                    let method = type[\.methods].assertCount(1)?[0]
                    method?.asserter(forParameterAt: 0) { param in
                        param.assert(type: "ABlock")
                    }
                }
            }
        }
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
        
        Asserter(object: intentions).asserterForFiles { files in
            let file = files.assertCount(1)?[0]?.assert(sourcePath: "A.m")
            file?.assertTrue{ $0.sourcePath.hasSuffix(".m") }

            let structDecl = file?[\.structIntentions].assertCount(1)?[0]
            structDecl?[\.instanceVariables].assertCount(1)
        }
    }
    
    func testMergeExtensions() {
        let intentions =
            IntentionCollectionBuilder()
                .createFile(named: "A.h") { file in
                    file.createExtension(forClassNamed: "A") { builder in
                        builder
                            .createMethod(named: "test") { builder in
                                builder.createSignature { builder in
                                    builder.addParameter(name: "test",
                                                         type: .string)
                                }
                            }
                            .setAsInterfaceSource()
                    }
                }.createFile(named: "A.m") { file in
                    file.createExtension(forClassNamed: "A") { builder in
                        builder
                            .createMethod(named: "test") { builder in
                                builder.createSignature { builder in
                                    builder.addParameter(name: "test",
                                                         type: .nullabilityUnspecified(.string))
                                }
                            }
                    }
                }.build()
        let sut = FileTypeMergingIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        Asserter(object: intentions).asserterForFiles { files in
            let file = files.assertCount(1)?[0]?.assert(sourcePath: "A.m")
            let extensionDecl = file?[\.extensionIntentions][0]
            let method = extensionDecl?[\.methods][0]
            method?.assert(signature: 
                .init(
                    name: "test",
                    parameters: [ParameterSignature(name: "test", type: .string)]
                )
            )
        }
    }
}
