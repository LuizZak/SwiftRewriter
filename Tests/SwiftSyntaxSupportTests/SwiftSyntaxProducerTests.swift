import XCTest
import SwiftSyntax
import SwiftAST
@testable import SwiftSyntaxSupport
import KnownType
@testable import Intentions
import TestCommons
import Utils

class SwiftSyntaxProducerTests: BaseSwiftSyntaxProducerTests {
    
    func testGenerateEmptyFile() {
        let file = FileGenerationIntention(sourcePath: "", targetPath: "")
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(result, matches: "")
    }
    
    func testGenerateExpressionTypes() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalFunction(withName: "foo") { builder in
                    builder.setBody([
                        Statement.expression(Expression.identifier("foo").typed("Bar")),
                        Statement.expression(Expression.identifier("baz").typed(.errorType))
                        ])
                }
            }
        let sut = SwiftSyntaxProducer(settings: .init(outputExpressionTypes: true))
        
        let result = sut.generateFile(file)
        
        assert(result, matches: """
            func foo() {
                // type: Bar
                foo
                // type: <<error type>>
                baz
            }
            """)
    }
    
    func testGenerateIntentionHistory() {
        let file = FileIntentionBuilder
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
        let sut = SwiftSyntaxProducer(settings: .init(printIntentionHistory: true))
        
        let result = sut.generateFile(file)
        
        assert(result, matches: """
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
            """)
    }
}

// MARK: - Attribute writing
extension SwiftSyntaxProducerTests {
    
    func testWriteFailableInit() {
        let initMethod = InitGenerationIntention(parameters: [])
        initMethod.isFailable = true
        initMethod.functionBody = FunctionBodyIntention(body: [])
        let sut = SwiftSyntaxProducer()
        
        let output = sut.generateInitializer(initMethod).description
        
        let expected = """
            init?() {
            }
            """
        XCTAssertEqual(output.trimmingCharacters(in: .whitespacesAndNewlines),
                       expected)
    }
    
    func testWriteConvenienceInit() {
        let initMethod = InitGenerationIntention(parameters: [])
        initMethod.isConvenience = true
        initMethod.functionBody = FunctionBodyIntention(body: [])
        let sut = SwiftSyntaxProducer()
        
        let output = sut.generateInitializer(initMethod).description
        
        let expected = """
            convenience init() {
            }
            """
        XCTAssertEqual(output.trimmingCharacters(in: .whitespacesAndNewlines),
                       expected)
    }
    
    func testWriteClassAttributes() {
        let type = KnownTypeBuilder(typeName: "A", kind: .class)
            .settingAttributes([
                KnownAttribute(name: "attr"),
                KnownAttribute(name: "otherAttr", parameters: ""),
                KnownAttribute(name: "otherAttr", parameters: "type: Bool")
            ])
            .buildIntention()
        let intent = type as! ClassGenerationIntention
        let sut = SwiftSyntaxProducer()
        
        let output = sut.generateClass(intent).description
        
        let expected = """
            @attr
            @otherAttr()
            @otherAttr(type: Bool)
            class A {
            }
            """
        XCTAssertEqual(output.trimmingCharacters(in: .whitespacesAndNewlines),
                       expected)
    }
    
    func testWriteStructAttributes() {
        let type = KnownTypeBuilder(typeName: "A", kind: .struct)
            .settingAttributes([
                KnownAttribute(name: "attr"),
                KnownAttribute(name: "otherAttr", parameters: ""),
                KnownAttribute(name: "otherAttr", parameters: "type: Bool")
                ])
            .buildIntention()
        let intent = type as! StructGenerationIntention
        let sut = SwiftSyntaxProducer()
        
        let output = sut.generateStruct(intent).description
        
        let expected = """
            @attr
            @otherAttr()
            @otherAttr(type: Bool)
            struct A {
            }
            """
        XCTAssertEqual(output.trimmingCharacters(in: .whitespacesAndNewlines),
                       expected)
    }
    
    func testWriteEnumAttributes() {
        let type = KnownTypeBuilder(typeName: "A", kind: .enum)
            .settingAttributes([
                KnownAttribute(name: "attr"),
                KnownAttribute(name: "otherAttr", parameters: ""),
                KnownAttribute(name: "otherAttr", parameters: "type: Bool")
            ])
            .buildIntention()
        let intent = type as! EnumGenerationIntention
        let sut = SwiftSyntaxProducer()
        
        let output = sut.generateEnum(intent).description
        
        let expected = """
            @attr
            @otherAttr()
            @otherAttr(type: Bool)
            enum A: Int {
            }
            """
        XCTAssertEqual(output.trimmingCharacters(in: .whitespacesAndNewlines),
                       expected)
    }
    
    func testWriteProtocolAttributes() {
        let type = KnownTypeBuilder(typeName: "A", kind: .protocol)
            .settingAttributes([
                KnownAttribute(name: "attr"),
                KnownAttribute(name: "otherAttr", parameters: ""),
                KnownAttribute(name: "otherAttr", parameters: "type: Bool")
            ])
            .buildIntention()
        let intent = type as! ProtocolGenerationIntention
        let sut = SwiftSyntaxProducer()
        
        let output = sut.generateProtocol(intent).description
        
        let expected = """
            @attr
            @otherAttr()
            @otherAttr(type: Bool)
            protocol A {
            }
            """
        XCTAssertEqual(output.trimmingCharacters(in: .whitespacesAndNewlines), expected)
    }
    
    func testWritePropertyAttributes() {
        let type = KnownTypeBuilder(typeName: "A")
            .property(
                named: "property",
                type: .int,
                attributes: [
                    KnownAttribute(name: "attr"),
                    KnownAttribute(name: "otherAttr", parameters: ""),
                    KnownAttribute(name: "otherAttr", parameters: "type: Bool")
                ]
            )
            .buildIntention()
        let intent = type as! ClassGenerationIntention
        let sut = SwiftSyntaxProducer()
        
        let output = sut.generateClass(intent).description
        
        let expected = """
            class A {
                @attr @otherAttr() @otherAttr(type: Bool) var property: Int
            }
            """
        XCTAssertEqual(output.trimmingCharacters(in: .whitespacesAndNewlines),
                       expected)
    }
    
    func testWriteMethodAttributes() {
        let type = KnownTypeBuilder(typeName: "A")
            .method(
                named: "method",
                parsingSignature: "()",
                attributes: [
                    KnownAttribute(name: "attr"),
                    KnownAttribute(name: "otherAttr", parameters: ""),
                    KnownAttribute(name: "otherAttr", parameters: "type: Bool")
                ]
            )
            .buildIntention()
        let intent = type as! ClassGenerationIntention
        let sut = SwiftSyntaxProducer()
        
        let output = sut.generateClass(intent).description
        
        let expected = """
            class A {
                @attr
                @otherAttr()
                @otherAttr(type: Bool)
                func method() {
                }
            }
            """
        XCTAssertEqual(output.trimmingCharacters(in: .whitespacesAndNewlines), expected)
    }
}

// MARK: - File generation
extension SwiftSyntaxProducerTests {
    func testGeneratePreprocessorDirectivesInEmptyFile() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.addPreprocessorDirective("#import <Abc.h>")
                builder.addPreprocessorDirective("#define MAX(a, b) ((a) > (b) ? (a) : (b))")
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        // TODO: Consider removing the extra line feed in case an empty file is
        // generated.
        assert(
            result,
            matches: """
            // Preprocessor directives found in file:
            // #import <Abc.h>
            // #define MAX(a, b) ((a) > (b) ? (a) : (b))
            
            """)
    }
    
    func testGeneratePreprocessorDirectivesInPopulatedFile() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.addPreprocessorDirective("#import <Abc.h>")
                builder.addPreprocessorDirective("#define MAX(a, b) ((a) > (b) ? (a) : (b))")
                builder.createClass(withName: "A")
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            // Preprocessor directives found in file:
            // #import <Abc.h>
            // #define MAX(a, b) ((a) > (b) ? (a) : (b))
            class A {
            }
            """)
    }
}

// MARK: - Function body generation
extension SwiftSyntaxProducerTests {
    func testGenerateFileWithFunctionBody() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalFunction(withName: "a") { builder in
                    builder.setBody([
                        Statement.if(
                            Expression.identifier("abc").binary(op: .equals, rhs: .constant(true)),
                            body: [
                                .expression(Expression
                                    .identifier("print")
                                    .call([.constant("Hello,"),
                                           .constant("World!")]))
                            ],
                            else: nil
                        ),
                        .return(nil)
                    ])
                }
            }
        let sut = SwiftSyntaxProducer()
        
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
            """)
    }
}

// MARK: - Global function generation
extension SwiftSyntaxProducerTests {
    func testGenerateFileWithGlobalFunction() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalFunction(withName: "a") { builder in
                    builder.setBody([])
                    builder.createSignature(name: "a") { builder in
                        builder.addParameter(name: "test", type: .int)
                    }
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            func a(test: Int) {
            }
            """)
    }
    
    func testGenerateFileWithGlobalFunctionWithReturnType() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalFunction(withName: "a") { builder in
                    builder.setBody([])
                    builder.createSignature(name: "a") { builder in
                        builder.setReturnType(.int)
                    }
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            func a() -> Int {
            }
            """)
    }
}

// MARK: - Property / global variable generation
extension SwiftSyntaxProducerTests {
    func testGenerateFileWithOwnershippedGlobalVariables() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createGlobalVariable(withName: "foo",
                                             type: .optional(.anyObject),
                                             ownership: .weak)
                builder.createGlobalVariable(withName: "bar",
                                             type: .optional(.anyObject),
                                             ownership: .unownedSafe)
                builder.createGlobalVariable(withName: "baz",
                                             type: .optional(.anyObject),
                                             ownership: .unownedUnsafe)
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            weak var foo: AnyObject?
            unowned(safe) var bar: AnyObject?
            unowned(unsafe) var baz: AnyObject?
            """)
    }
    
    func testGenerateFileWithClassWithComputedProperty() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createProperty(named: "foo", type: .int) { builder in
                        builder.setAsComputedProperty(body: [
                            .return(.constant(1))
                            ])
                    }
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            class A {
                var foo: Int {
                    return 1
                }
            }
            """)
    }
    
    func testGenerateFileWithClassWithGetterAndSetterProperties() {
        let file = FileIntentionBuilder
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
                                    .expression(Expression
                                        .identifier("_foo")
                                        .assignment(op: .assign,
                                                    rhs: .identifier("newValue")))
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
                                    .expression(Expression
                                        .identifier("_bar")
                                        .assignment(op: .assign,
                                                    rhs: .identifier("_newBar")))
                                ]
                            )
                        )
                    }
                }
        }
        let sut = SwiftSyntaxProducer()
        
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
            """)
    }
}

// MARK: - Typealias Generation
extension SwiftSyntaxProducerTests {
    func testGenerateFileWithTypealias() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createTypealias(withName: "Alias",
                                        swiftType: .int,
                                        type: .void)
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            typealias Alias = Int
            """)
    }
}

// MARK: - Extension Generation
extension SwiftSyntaxProducerTests {
    func testGenerateFileWithExtension() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createExtension(forClassNamed: "A")
                builder.createExtension(forClassNamed: "B", categoryName: "BExtension")
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            // MARK: -
            extension A {
            }
            // MARK: - BExtension
            extension B {
            }
            """)
    }
}

// MARK: - Enum Generation
extension SwiftSyntaxProducerTests {
    func testGenerateFileWithEmptyEnum() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createEnum(withName: "A", rawValue: .int)
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            enum A: Int {
            }
            """)
    }
    
    func testGenerateFileWithEnumWithOneCase() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createEnum(withName: "A", rawValue: .int) { builder in
                    builder.createCase(name: "case1", expression: .constant(1))
                    builder.createCase(name: "case2")
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            enum A: Int {
                case case1 = 1
                case case2
            }
            """)
    }
}

// MARK: - Class Generation
extension SwiftSyntaxProducerTests {
    func testGenerateFileWithEmptyClass() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A")
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            class A {
            }
            """)
    }
    
    func testGenerateFileWithEmptyClasses() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A")
                builder.createClass(withName: "B")
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            class A {
            }
            class B {
            }
            """)
    }
    
    func testGenerateFileWithClassWithInheritance() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.inherit(from: "Supertype")
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            class A: Supertype {
            }
            """)
    }
    
    func testGenerateFileWithClassWithProtocolConformances() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createConformance(protocolName: "ProtocolA")
                    builder.createConformance(protocolName: "ProtocolB")
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            class A: ProtocolA, ProtocolB {
            }
            """)
    }
    
    func testGenerateFileWithClassWithProperty() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createProperty(named: "property", type: .int)
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            class A {
                var property: Int
            }
            """)
    }
    
    func testGenerateFileWithClassWithField() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createInstanceVariable(named: "ivarA", type: .int)
                }
        }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            class A {
                var ivarA: Int
            }
            """)
    }
    
    func testGenerateFileWithClassWithFieldAndProperty() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder
                        .createProperty(named: "propertyA", type: .int)
                        .createInstanceVariable(named: "ivarA", type: .int)
                }
        }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            class A {
                var ivarA: Int
                var propertyA: Int
            }
            """)
    }
    
    func testGenerateFileWithClassWithInit() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createConstructor()
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            class A {
                init() {
                }
            }
            """)
    }
    
    func testGenerateFileWithClassWithMethod() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createClass(withName: "A") { builder in
                    builder.createMethod("foo(_ a: Bar)")
                }
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            class A {
                func foo(_ a: Bar) {
                }
            }
            """)
    }
    
}

// MARK: - Struct Generation
extension SwiftSyntaxProducerTests {
    func testGenerateFileWithStruct() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createStruct(withName: "A")
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            struct A {
            }
            """)
    }
}

// MARK: - Protocol Generation
extension SwiftSyntaxProducerTests {
    func testGenerateFileWithProtocol() {
        let file = FileIntentionBuilder
            .makeFileIntention(fileName: "Test.swift") { builder in
                builder.createProtocol(withName: "A")
            }
        let sut = SwiftSyntaxProducer()
        
        let result = sut.generateFile(file)
        
        assert(
            result,
            matches: """
            protocol A {
            }
            """)
    }
}
