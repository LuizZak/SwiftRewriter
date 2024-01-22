import KnownType
import SwiftAST
import SwiftSyntax
import TestCommons
import Utils
import XCTest

@testable import Intentions
@testable import SwiftSyntaxSupport

class SwiftProducerTests: BaseSwiftSyntaxProducerTests {

    func testGenerateEmptyFile() {
        let file = FileGenerationIntention(sourcePath: "", targetPath: "")
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(result, matches: "")
    }

    func testGenerateEmptyFileWithComments() {
        let file = FileGenerationIntention(sourcePath: "", targetPath: "")
        file.headerComments = ["Comment"]
        let sut = SwiftProducer()

        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
                // Comment
                """
        )
    }

    func testGenerateSingleLineComment() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalFunction(withName: "f") { builder in
                    builder.addComment("""
                        // Comment
                        """
                    )
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // Comment
                func f() {
                }
                """
        )
        let syntax = result.children(viewMode: .sourceAccurate).first
        XCTAssertEqual(
            syntax?.leadingTrivia.first,
            .lineComment("""
                // Comment
                """
            )
        )
    }

    func testGenerateMultilineComment() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalFunction(withName: "f") { builder in
                    builder.addComment(
                        .block("""
                            /**
                             * Comment
                             */
                            """ 
                        )
                    )
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                /**
                 * Comment
                 */
                func f() {
                }
                """
        )
        let syntax = result.children(viewMode: .sourceAccurate).first
        XCTAssertEqual(
            syntax?.leadingTrivia.first,
            .docBlockComment("""
                /**
                 * Comment
                 */
                """
            )
        )
    }

    func testGenerateEmptyMethodBodyWithComments() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createMethod(named: "a") { method in
                        method.setBody(
                            CompoundStatement().withComments(["// A Comment"])
                        )
                    }
                }
            }
        var settings = SwiftProducer.Settings.default
        settings.outputExpressionTypes = true
        let sut = SwiftProducer(settings: settings)

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A {
                    func a() {
                        // A Comment
                    }
                }
                """
        )
    }

    func testGenerateExpressionTypes() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalFunction(withName: "foo") { builder in
                    builder.setBody([
                        Statement.expression(Expression.identifier("foo").typed("Bar")),
                        Statement.expression(Expression.identifier("baz").typed(.errorType)),
                    ])
                }
            }
        var settings = SwiftProducer.Settings.default
        settings.outputExpressionTypes = true
        let sut = SwiftProducer(settings: settings)

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                func foo() {
                    // type: Bar
                    foo
                    // type: <<error type>>
                    baz
                }
                """
        )
    }

    func testGenerateVariableDeclarationTypes() {
        class LocalDelegate: SwiftProducerDelegate {
            func swiftProducer(
                _ producer: SwiftProducer,
                shouldEmitTypeFor storage: ValueStorage,
                intention: IntentionProtocol?,
                initialValue: Expression?
            ) -> Bool {
                
                return !(initialValue?.resolvedType == .int)
            }

            func swiftProducer(
                _ producer: SwiftProducer,
                initialValueFor intention: ValueStorageIntention
            ) -> SwiftAST.Expression? {
                return nil
            }
        }
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalFunction(withName: "foo") { builder in
                    builder.setBody([
                        Statement.variableDeclaration(
                            identifier: "foo",
                            type: .int,
                            initialization: Expression.constant(0).typed(.double)
                        ),
                        Statement.variableDeclaration(
                            identifier: "bar",
                            type: .int,
                            initialization: nil
                        ),
                        Statement.variableDeclaration(
                            identifier: "baz",
                            type: .int,
                            initialization: Expression.constant(0).typed(.int)
                        ),
                    ])
                }
            }
        var settings = SwiftProducer.Settings.default
        settings.outputExpressionTypes = true
        let sut = SwiftProducer(settings: settings)

        let delegate = LocalDelegate()
        sut.delegate = delegate
        withExtendedLifetime(delegate) {
            let result = sut.generateFile(file)

            assert(
                result,
                matches: """
                    func foo() {
                        // decl type: Int
                        // init type: Double
                        var foo: Int = 0
                        // decl type: Int
                        var bar: Int
                        // decl type: Int
                        // init type: Int
                        var baz = 0
                    }
                    """
            )
        }
    }

    func testGenerateIntentionHistory() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.addHistory(tag: "Tag", description: "History 1")
                    builder.addHistory(tag: "Tag", description: "History 2")

                    builder.createProperty(named: "prop", type: .int) { builder in
                        builder.addHistory(tag: "Tag", description: "History 3")
                    }
                    builder.createConstructor(withParameters: []) { builder in
                        builder.setBody([])
                        builder.addHistory(tag: "Tag", description: "History 4")
                    }
                    builder.createMethod(named: "method") { builder in
                        builder.addHistory(tag: "Tag", description: "History 5")
                    }
                }
            }
        var settings = SwiftProducer.Settings.default
        settings.printIntentionHistory = true
        let sut = SwiftProducer(settings: settings)

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // [Tag] History 1
                // [Tag] History 2
                class A {
                    // [Tag] History 3
                    var prop: Int

                    // [Tag] History 4
                    init() {
                    }

                    // [Tag] History 5
                    func method() {
                    }
                }
                """
        )
    }

    func testGenerateIntentionHistoryAndComments() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.addHistory(tag: "Tag", description: "History 1")
                    builder.addHistory(tag: "Tag", description: "History 2")
                    builder.addComment("// A comment")

                    builder.createProperty(named: "prop", type: .int) { builder in
                        builder.addHistory(tag: "Tag", description: "History 3")
                        builder.addComment("// A comment")
                    }
                    builder.createConstructor(withParameters: []) { builder in
                        builder.setBody([])
                        builder.addHistory(tag: "Tag", description: "History 4")
                        builder.addComment("// A comment")
                    }
                    builder.createMethod(named: "method") { builder in
                        builder.addHistory(tag: "Tag", description: "History 5")
                        builder.addComment("// A comment")
                    }
                }
            }
        var settings = SwiftProducer.Settings.default
        settings.printIntentionHistory = true
        let sut = SwiftProducer(settings: settings)

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // [Tag] History 1
                // [Tag] History 2
                // A comment
                class A {
                    // [Tag] History 3
                    // A comment
                    var prop: Int

                    // [Tag] History 4
                    // A comment
                    init() {
                    }

                    // [Tag] History 5
                    // A comment
                    func method() {
                    }
                }
                """
        )
    }

    func testEmitObjcCompatibility() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createProtocol(withName: "A")
                builder.createClass(withName: "B") { builder in
                    builder.createProperty(named: "prop", type: .int)
                    builder.createConstructor(withParameters: [])
                    builder.createMethod(named: "method")
                }
            }
        var settings = SwiftProducer.Settings.default
        settings.emitObjcCompatibility = true
        let sut = SwiftProducer(settings: settings)

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                @objc
                protocol A: NSObjectProtocol {
                }

                @objc
                class B {
                    @objc var prop: Int

                    @objc
                    init() {
                    }

                    @objc
                    func method() {
                    }
                }
                """
        )
    }

    func testGenerateSignature() {
        let signature = FunctionSignature(
            name: "f",
            parameters: [
                .init(
                    label: nil,
                    name: "param1",
                    type: .any,
                    isVariadic: false
                ),
                .init(
                    label: "p2",
                    name: "param2",
                    type: .string,
                    isVariadic: false
                ),
                .init(
                    label: "param3",
                    name: "param3",
                    type: .int,
                    isVariadic: true
                )
            ],
            returnType: .anyObject,
            isStatic: false,
            isMutating: false
        )
        let sut = SwiftProducer()

        sut.emit(signature)
        let result = sut.buffer
        
        assert(
            result,
            matches: """
                f(_ param1: Any, p2 param2: String, param3: Int...) -> AnyObject
                """
        )
    }

    func testGenerateSignature_promotesNullabilityUnspecifiedReturnsToOptional() {
        let signature = FunctionSignature(
            name: "f",
            returnType: .nullabilityUnspecified(.anyObject)
        )
        let sut = SwiftProducer()

        sut.emit(signature)
        let result = sut.buffer
        
        assert(
            result,
            matches: """
                f() -> AnyObject?
                """
        )
    }

    func testGenerateSignature_doesNotPromoteNullabilityUnspecifiedParametersToOptional() {
        let signature = FunctionSignature(
            name: "f",
            parameters: [
                .init(name: "a", type: .nullabilityUnspecified(.anyObject))
            ]
        )
        let sut = SwiftProducer()

        sut.emit(signature)
        let result = sut.buffer
        
        assert(
            result,
            matches: """
                f(a: AnyObject!)
                """
        )
    }

    func testGenerateSignature_promotesNestedNullabilityUnspecifiedParametersToOptional() {
        let signature = FunctionSignature(
            name: "f",
            parameters: [
                .init(name: "a", type: .generic("A", parameters: [.nullabilityUnspecified(.anyObject)]))
            ]
        )
        let sut = SwiftProducer()

        sut.emit(signature)
        let result = sut.buffer

        assert(
            result,
            matches: """
                f(a: A<AnyObject?>)
                """
        )
    }
}

// MARK: - Attribute writing
extension SwiftProducerTests {

    func testWriteClassAttributes() {
        let type = KnownTypeBuilder(typeName: "A", kind: .class)
            .settingAttributes([
                KnownAttribute(name: "attr"),
                KnownAttribute(name: "otherAttr", parameters: ""),
                KnownAttribute(name: "otherAttr", parameters: "type: Bool"),
            ])
            .buildIntention()
        let intent = type as! ClassGenerationIntention
        let sut = SwiftProducer()

        sut.emit(intent)
        let result = sut.buffer

        let expected = """
            @attr
            @otherAttr()
            @otherAttr(type: Bool)
            class A {
            }
            """
        XCTAssertEqual(
            result.trimmingCharacters(in: .whitespacesAndNewlines),
            expected
        )
    }

    func testWriteExtensionAttributes() {
        let type = KnownTypeBuilder(typeName: "A", kind: .class)
            .settingIsExtension(true)
            .settingAttributes([
                KnownAttribute(name: "attr"),
                KnownAttribute(name: "otherAttr", parameters: ""),
                KnownAttribute(name: "otherAttr", parameters: "type: Bool"),
            ])
            .buildIntention()
        let intent = type as! ClassExtensionGenerationIntention
        let sut = SwiftProducer()

        sut.emit(intent)
        let result = sut.buffer

        let expected = """
            // MARK: -
            @attr
            @otherAttr()
            @otherAttr(type: Bool)
            extension A {
            }
            """
        XCTAssertEqual(
            result.trimmingCharacters(in: .whitespacesAndNewlines),
            expected
        )
    }

    func testWriteStructAttributes() {
        let type = KnownTypeBuilder(typeName: "A", kind: .struct)
            .settingAttributes([
                KnownAttribute(name: "attr"),
                KnownAttribute(name: "otherAttr", parameters: ""),
                KnownAttribute(name: "otherAttr", parameters: "type: Bool"),
            ])
            .buildIntention()
        let intent = type as! StructGenerationIntention
        let sut = SwiftProducer()

        sut.emit(intent)
        let result = sut.buffer

        let expected = """
            @attr
            @otherAttr()
            @otherAttr(type: Bool)
            struct A {
            }
            """
        XCTAssertEqual(
            result.trimmingCharacters(in: .whitespacesAndNewlines),
            expected
        )
    }

    func testWriteEnumAttributes() {
        let type = KnownTypeBuilder(typeName: "A", kind: .enum)
            .settingAttributes([
                KnownAttribute(name: "attr"),
                KnownAttribute(name: "otherAttr", parameters: ""),
                KnownAttribute(name: "otherAttr", parameters: "type: Bool"),
            ])
            .buildIntention()
        let intent = type as! EnumGenerationIntention
        let sut = SwiftProducer()

        sut.emit(intent)
        let result = sut.buffer

        let expected = """
            @attr
            @otherAttr()
            @otherAttr(type: Bool)
            enum A: Int {
            }
            """
        XCTAssertEqual(
            result.trimmingCharacters(in: .whitespacesAndNewlines),
            expected
        )
    }

    func testWriteProtocolAttributes() {
        let type = KnownTypeBuilder(typeName: "A", kind: .protocol)
            .settingAttributes([
                KnownAttribute(name: "attr"),
                KnownAttribute(name: "otherAttr", parameters: ""),
                KnownAttribute(name: "otherAttr", parameters: "type: Bool"),
            ])
            .buildIntention()
        let intent = type as! ProtocolGenerationIntention
        let sut = SwiftProducer()

        sut.emit(intent)
        let result = sut.buffer

        let expected = """
            @attr
            @otherAttr()
            @otherAttr(type: Bool)
            protocol A {
            }
            """
        XCTAssertEqual(result.trimmingCharacters(in: .whitespacesAndNewlines), expected)
    }

    func testWritePropertyAttributes() {
        let type = KnownTypeBuilder(typeName: "A")
            .property(
                named: "property",
                type: .int,
                attributes: [
                    KnownAttribute(name: "attr"),
                    KnownAttribute(name: "otherAttr", parameters: ""),
                    KnownAttribute(name: "otherAttr", parameters: "type: Bool"),
                ]
            )
            .buildIntention()
        let intent = type as! ClassGenerationIntention
        let sut = SwiftProducer()

        sut.emit(intent)
        let result = sut.buffer

        let expected = """
            class A {
                @attr @otherAttr() @otherAttr(type: Bool) var property: Int
            }
            """
        XCTAssertEqual(
            result.trimmingCharacters(in: .whitespacesAndNewlines),
            expected
        )
    }

    func testWriteMethodAttributes() {
        let type = KnownTypeBuilder(typeName: "A")
            .method(
                named: "method",
                parsingSignature: "()",
                attributes: [
                    KnownAttribute(name: "attr"),
                    KnownAttribute(name: "otherAttr", parameters: ""),
                    KnownAttribute(name: "otherAttr", parameters: "type: Bool"),
                ]
            )
            .buildIntention()
        let intent = type as! ClassGenerationIntention
        let sut = SwiftProducer()

        sut.emit(intent)
        let result = sut.buffer

        let expected = """
            class A {
                @attr
                @otherAttr()
                @otherAttr(type: Bool)
                func method() {
                }
            }
            """
        XCTAssertEqual(result.trimmingCharacters(in: .whitespacesAndNewlines), expected)
    }
}

// MARK: - File generation
extension SwiftProducerTests {
    func testGenerateImportDirective() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.addImportDirective(moduleName: "moduleA")
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                import moduleA
                """
        )
    }

    func testGenerateMultipleImportDirectives() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.addImportDirective(moduleName: "moduleA")
                builder.addImportDirective(moduleName: "moduleB")
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                import moduleA
                import moduleB
                """
        )
    }

    func testGenerateHeaderCommentsInEmptyFile() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.addHeaderComment("#import <Abc.h>")
                builder.addHeaderComment(
                    "#define MAX(a, b) ((a) > (b) ? (a) : (b))"
                )
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // #import <Abc.h>
                // #define MAX(a, b) ((a) > (b) ? (a) : (b))
                """
        )
    }

    func testGenerateHeaderCommentsInPopulatedFile() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.addHeaderComment("#import <Abc.h>")
                builder.addHeaderComment(
                    "#define MAX(a, b) ((a) > (b) ? (a) : (b))"
                )
                builder.createClass(withName: "A")
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // #import <Abc.h>
                // #define MAX(a, b) ((a) > (b) ? (a) : (b))
                class A {
                }
                """
        )
    }
}

// MARK: - Global Function generation
extension SwiftProducerTests {
    func testGenerateFileWithEmptyFunction() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalFunction(withName: "a") { builder in
                    builder.addComment("// A comment")
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // A comment
                func a() {
                }
                """
        )
    }

    func testGenerateFileWithFunctionBody() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalFunction(withName: "a") { builder in
                    builder.setBody([
                        Statement.if(
                            Expression.identifier("abc").binary(op: .equals, rhs: .constant(true)),
                            body: [
                                .expression(
                                    Expression
                                        .identifier("print")
                                        .call([
                                            .constant("Hello,"),
                                            .constant("World!"),
                                        ])
                                )
                            ]
                        ),
                        .return(nil),
                    ])
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                func a() {
                    if abc == true {
                        print("Hello,", "World!")
                    }

                    return
                }
                """
        )
    }

    func testGenerateFileWithGlobalFunction() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalFunction(withName: "a") { builder in
                    builder.addComment("// A comment")
                    builder.setBody([])
                    builder.createSignature { builder in
                        builder.addParameter(name: "test", type: .int)
                    }
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // A comment
                func a(test: Int) {
                }
                """
        )
    }

    func testGenerateFileWithGlobalFunctionWithReturnType() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalFunction(withName: "a") { builder in
                    builder.setBody([])
                    builder.createSignature { builder in
                        builder.setReturnType(.int)
                    }
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                func a() -> Int {
                }
                """
        )
    }
}

// MARK: - Property / global variable generation
extension SwiftProducerTests {
    func testGenerateFileWithOwnershippedGlobalVariables() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalVariable(
                    withName: "foo",
                    type: .optional(.anyObject),
                    ownership: .weak
                )
                builder.createGlobalVariable(
                    withName: "bar",
                    type: .optional(.anyObject),
                    ownership: .unownedSafe
                )
                builder.createGlobalVariable(
                    withName: "baz",
                    type: .optional(.anyObject),
                    ownership: .unownedUnsafe
                )
            }
        file.globalVariableIntentions[0].precedingComments = ["// A comment"]
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // A comment
                weak var foo: AnyObject?
                unowned(safe) var bar: AnyObject?
                unowned(unsafe) var baz: AnyObject?
                """
        )
    }

    func testGenerateFileWithClassWithComputedProperty() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createProperty(named: "foo", type: .int) { builder in
                        builder.setAsComputedProperty(body: [
                            .return(.constant(1))
                        ])
                    }
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A {
                    var foo: Int {
                        return 1
                    }
                }
                """
        )
    }

    func testGenerateFileWithClassWithGetterAndSetterProperties() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createProperty(named: "foo", type: .int) { builder in
                        builder.setAsGetterSetter(
                            getter: [
                                .return(.constant(1))
                            ],
                            setter: .init(
                                valueIdentifier: "newValue",
                                body: [
                                    .expression(
                                        Expression
                                            .identifier("_foo")
                                            .assignment(
                                                op: .assign,
                                                rhs: .identifier("newValue")
                                            )
                                    )
                                ]
                            )
                        )
                    }

                    builder.createProperty(named: "bar", type: .int) { builder in
                        builder.setAsGetterSetter(
                            getter: [
                                .return(.constant(1))
                            ],
                            setter: .init(
                                valueIdentifier: "_newBar",
                                body: [
                                    .expression(
                                        Expression
                                            .identifier("_bar")
                                            .assignment(
                                                op: .assign,
                                                rhs: .identifier("_newBar")
                                            )
                                    )
                                ]
                            )
                        )
                    }
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A {
                    var foo: Int {
                        get {
                            return 1
                        }
                        set {
                            _foo = newValue
                        }
                    }
                    var bar: Int {
                        get {
                            return 1
                        }
                        set(_newBar) {
                            _bar = _newBar
                        }
                    }
                }
                """
        )
    }
}

// MARK: - Init writing
extension SwiftProducerTests {
    
    func testWriteFallibleInit() {
        let initMethod = InitGenerationIntention(parameters: [])
        initMethod.isFallible = true
        initMethod.functionBody = FunctionBodyIntention(body: [])
        let sut = SwiftProducer()

        sut.emit(initMethod)
        let output = sut.buffer

        let expected = """
            init?() {
            }
            """
        XCTAssertEqual(
            output.trimmingCharacters(in: .whitespacesAndNewlines),
            expected
        )
    }

    func testWriteConvenienceInit() {
        let initMethod = InitGenerationIntention(parameters: [])
        initMethod.isConvenience = true
        initMethod.functionBody = FunctionBodyIntention(body: [])
        let sut = SwiftProducer()

        sut.emit(initMethod)
        let output = sut.buffer

        let expected = """
            convenience init() {
            }
            """
        XCTAssertEqual(
            output.trimmingCharacters(in: .whitespacesAndNewlines),
            expected
        )
    }

}

// MARK: - Subscript Generation
extension SwiftProducerTests {
    func testGenerateSubscript() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { type in
                    type.createSubscript(
                        parameters: [ParameterSignature(name: "index", type: .int)],
                        returnType: .int
                    )
                }
            }
        file.typeIntentions[0].subscripts[0].precedingComments = ["// A comment"]
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A {
                    // A comment
                    subscript(index: Int) -> Int {
                    }
                }
                """
        )
    }

    func testGenerateSubscriptGetterAndSetter() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { type in
                    type.createSubscript(
                        parameters: [ParameterSignature(name: "index", type: .int)],
                        returnType: .int
                    ) { sub in
                        let setter: CompoundStatement = [
                            .expression(
                                Expression
                                    .identifier("print")
                                    .call([.identifier("newValue")])
                            )
                        ]

                        sub.setAsGetterSetter(
                            getter: [.return(.constant(0))],
                            setter: .init(
                                valueIdentifier: "newValue",
                                body: setter
                            )
                        )
                    }
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A {
                    subscript(index: Int) -> Int {
                        get {
                            return 0
                        }
                        set {
                            print(newValue)
                        }
                    }
                }
                """
        )
    }
}

// MARK: - Typealias Generation
extension SwiftProducerTests {
    func testGenerateFileWithTypealias() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createTypealias(
                    withName: "Alias",
                    swiftType: .int,
                    type: .void
                )
            }
        file.typealiasIntentions[0].precedingComments = ["// A comment"]
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // A comment
                typealias Alias = Int
                """
        )
    }

    func testGenerateFileWithTypealias_nullabilityUnspecifiedToOptional_baseType() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createTypealias(
                    withName: "Alias",
                    swiftType: .nullabilityUnspecified(.anyObject),
                    type: .void
                )
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                typealias Alias = AnyObject!
                """
        )
    }

    func testGenerateFileWithTypealias_nullabilityUnspecifiedToOptional_blockReturnType() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createTypealias(
                    withName: "Alias",
                    swiftType: .swiftBlock(returnType: .nullabilityUnspecified(.anyObject)),
                    type: .void
                )
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                typealias Alias = () -> AnyObject?
                """
        )
    }

    func testGenerateFileWithTypealias_nullabilityUnspecifiedToOptional_blockParameter() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createTypealias(
                    withName: "Alias",
                    swiftType: .swiftBlock(returnType: .void, parameters: [.nullabilityUnspecified(.anyObject), .implicitUnwrappedOptional(.anyObject)]),
                    type: .void
                )
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                typealias Alias = (AnyObject?, AnyObject!) -> Void
                """
        )
    }
}

// MARK: - Extension Generation
extension SwiftProducerTests {
    func testGenerateFileWithExtension() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createExtension(forClassNamed: "A") { ext in
                    ext.addComment("// A comment")
                }
                builder.createExtension(forClassNamed: "B", categoryName: "BExtension")
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // MARK: -
                // A comment
                extension A {
                }
                // MARK: - BExtension
                extension B {
                }
                """
        )
    }
}

// MARK: - Enum Generation
extension SwiftProducerTests {
    func testGenerateFileWithEmptyEnum() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createEnum(withName: "A", rawValue: .int) { e in
                    e.addComment("// A comment")
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // A comment
                enum A: Int {
                }
                """
        )
    }

    func testGenerateFileWithEnumWithOneCase() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createEnum(withName: "A", rawValue: .int) { builder in
                    builder.createCase(name: "case1", expression: .constant(1))
                    builder.createCase(name: "case2")
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                enum A: Int {
                    case case1 = 1
                    case case2
                }
                """
        )
    }

    func testGenerateFileWithEnum_objcCompatibilityEnabled_dontEmitAttributesInEnumCases() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createEnum(withName: "A", rawValue: .int) { builder in
                    builder.createCase(name: "case1")
                }
            }
        let settings: SwiftProducer.Settings =
            .default
            .with(\.emitObjcCompatibility, true)
        let sut = SwiftProducer(settings: settings)

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                @objc
                enum A: Int {
                    case case1
                }
                """
        )
    }
}

// MARK: - Class Generation
extension SwiftProducerTests {
    func testGenerateFileWithEmptyClass() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { type in
                    type.addComment("// A comment")
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // A comment
                class A {
                }
                """
        )
    }

    func testGenerateFileWithEmptyClasses() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A")
                builder.createClass(withName: "B")
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A {
                }
                class B {
                }
                """
        )
    }

    func testGenerateFileWithClassWithInheritance() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.inherit(from: "Supertype")
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A: Supertype {
                }
                """
        )
    }

    func testGenerateFileWithClassWithProtocolConformances() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createConformance(protocolName: "ProtocolA")
                    builder.createConformance(protocolName: "ProtocolB")
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A: ProtocolA, ProtocolB {
                }
                """
        )
    }

    func testGenerateFinalClass() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.setIsFinal(true)
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                final class A {
                }
                """
        )
    }

    func testGenerateFileWithClassWithProperty() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createProperty(named: "property", type: .int)
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A {
                    var property: Int
                }
                """
        )
    }

    func testGenerateFileWithClassWithField() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createInstanceVariable(named: "ivarA", type: .int)
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A {
                    var ivarA: Int
                }
                """
        )
    }

    func testGenerateFileWithClassWithFieldAndProperty() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder
                        .createProperty(named: "propertyA", type: .int)
                        .createInstanceVariable(named: "ivarA", type: .int)
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A {
                    var ivarA: Int
                    var propertyA: Int
                }
                """
        )
    }

    func testGenerateFileWithClassWithInit() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createConstructor()
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A {
                    init() {
                    }
                }
                """
        )
    }

    func testGenerateFileWithClassWithMethod() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createMethod("foo(_ a: Bar)")
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A {
                    func foo(_ a: Bar) {
                    }
                }
                """
        )
    }

    func testGenerateFileWithClassWithDeinit() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createDeinit()
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                class A {
                    deinit {
                    }
                }
                """
        )
    }
}

// MARK: - Struct Generation
extension SwiftProducerTests {
    func testGenerateFileWithStruct() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createStruct(withName: "A") { str in
                    str.addComment("// A comment")
                    str.createInstanceVariable(named: "field", type: .int)
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // A comment
                struct A {
                    var field: Int
                }
                """
        )
    }
}

// MARK: - Protocol Generation
extension SwiftProducerTests {
    func testGenerateFileWithProtocol() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createProtocol(withName: "A") { prot in
                    prot.addComment("// A comment")
                        .createProperty(named: "a", type: .int)
                        .createProperty(named: "b", type: .int)
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                // A comment
                protocol A {
                    var a: Int { get set }
                    var b: Int { get set }
                }
                """
        )
    }

    func testGenerateFileWithProtocolWithInitializerAndMethodRequirements() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createProtocol(withName: "A") { builder in
                    builder.createConstructor()
                    builder.createVoidMethod(named: "method")
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                protocol A {
                    init()

                    func method()
                }
                """
        )
    }

    func testProtocol_readOnlyProperty() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createProtocol(withName: "A") { builder in
                    builder.createProtocolProperty(named: "a", type: .int) { prop in
                        prop.setAsReadOnly()
                    }
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                protocol A {
                    var a: Int { get }
                }
                """
        )
    }

    func testGenerateFileWithProtocol_optionalMethod_optionalProperty_forceEmitObjcCompatibility() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createProtocol(withName: "A") { prot in
                    prot.createProtocolMethod(named: "method") { method in
                        method.setIsOptional(true)
                    }
                }
                builder.createProtocol(withName: "B") { prot in
                    prot.createProtocolProperty(named: "prop", type: .int) { prop in
                        prop.setIsOptional(true)
                    }
                }
                builder.createProtocol(withName: "C") { prot in
                    prot.createProtocolProperty(named: "prop", type: .int)
                    prot.createProtocolMethod(named: "method")
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                @objc
                protocol A: NSObjectProtocol {
                    @objc
                    optional func method()
                }
                @objc
                protocol B: NSObjectProtocol {
                    @objc optional var prop: Int { get set }
                }
                protocol C {
                    var prop: Int { get set }

                    func method()
                }
                """
        )
    }

    func testGenerateFileWithProtocol_objcCompatibilityDisabled_discardNSObjectProtocolConformances() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createProtocol(withName: "A") { prot in
                    prot.createConformance(protocolName: "NSObjectProtocol")
                }
            }
        let sut = SwiftProducer()

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                protocol A {
                }
                """
        )
    }

    func testGenerateFileWithProtocol_objcCompatibilityEnabled_dontEmitDuplicatedConformanceToNSObjectProtocol() {
        let file =
            FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createProtocol(withName: "A") { prot in
                    prot.createConformance(protocolName: "NSObjectProtocol")
                }
            }
        let settings: SwiftProducer.Settings = 
            .default
            .with(\.emitObjcCompatibility, true)
        let sut = SwiftProducer(settings: settings)

        let result = sut.generateFile(file)

        assert(
            result,
            matches: """
                @objc
                protocol A: NSObjectProtocol {
                }
                """
        )
    }
}

// MARK: - Test internals

extension SwiftProducerTests {
    func assert(
        _ value: String,
        matches expected: String,
        line: UInt = #line
    ) {

        diffTest(expected: expected, line: line).diff(value, line: line)
    }
}

private class SyntaxDebugPrinter: SyntaxAnyVisitor {
    private var _indent = 0

    override func visitAny(_ node: Syntax) -> SyntaxVisitorContinueKind {
        _line(node.syntaxNodeType)
        _indent += 1

        for token in node.tokens(viewMode: .sourceAccurate) {
            _line(token.leadingTrivia)
            _line(token.trimmed)
            _line(token.trailingTrivia)
        }

        _indent += 1
        return .skipChildren
    }

    override func visitAnyPost(_ node: Syntax) {
        _indent -= 2
    }

    private func _line<T>(_ message: T) {
        print(String(repeating: " ", count: _indent) + "\(message)")
    }

    static func debugPrint<S: SyntaxProtocol>(_ syntax: S) {
        let visitor = SyntaxDebugPrinter(viewMode: .sourceAccurate)

        visitor.walk(syntax)
    }
}
