import Intentions
import KnownType
import ObjcParser
import SwiftAST
import SwiftFormatConfiguration
import SwiftSyntax
import SwiftParser
import SwiftSyntaxSupport
import TestCommons
import TypeSystem
import Utils
import XCTest

@testable import SwiftRewriterLib

class SwiftSyntaxWriterTests: XCTestCase {
    var sut: SwiftSyntaxWriter!
    var output: WriterOutput!
    var typeSystem: TypeSystem!

    override func setUp() {
        super.setUp()

        output = TestWriterOutput()
        typeSystem = TypeSystem()
        let provider = ArraySwiftSyntaxRewriterPassProvider(passes: [])
        let passApplier = SwiftSyntaxRewriterPassApplier(provider: provider)
        sut = SwiftSyntaxWriter(
            options: .default,
            diagnostics: Diagnostics(),
            output: output,
            typeSystem: typeSystem,
            syntaxRewriterApplier: passApplier
        )
    }

    func testShouldEmitTypeSignature_optionalInitializedVar_returnsTrue() {
        typeSystem.addType(KnownTypeBuilder(typeName: "A").build())
        let producer = SwiftSyntaxProducer()
        let storage = ValueStorage(
            type: .optional("A"),
            ownership: .strong,
            isConstant: false
        )

        let result =
            sut.swiftSyntaxProducer(
                producer,
                shouldEmitTypeFor: storage,
                intention: nil,
                initialValue: Expression.identifier("a").typed("A")
            )

        XCTAssertTrue(result)
    }

    func testShouldEmitTypeSignature_weakInitializedVar_returnsFalse() {
        typeSystem.addType(KnownTypeBuilder(typeName: "A").build())
        let producer = SwiftSyntaxProducer()
        let storage = ValueStorage(
            type: .optional("A"),
            ownership: .weak,
            isConstant: false
        )

        let result =
            sut.swiftSyntaxProducer(
                producer,
                shouldEmitTypeFor: storage,
                intention: nil,
                initialValue: Expression.identifier("a").typed("A")
            )

        XCTAssertFalse(result)
    }

    func testShouldEmitTypeSignature_weakInitializedVarOfBaseType_returnsTrue() {
        let typeA = KnownTypeBuilder(typeName: "A").build()
        let typeB = KnownTypeBuilder(typeName: "B").settingSupertype(typeA).build()
        typeSystem.addType(typeA)
        typeSystem.addType(typeB)
        let producer = SwiftSyntaxProducer()
        let storage = ValueStorage(
            type: .optional("A"),
            ownership: .weak,
            isConstant: false
        )

        let result =
            sut.swiftSyntaxProducer(
                producer,
                shouldEmitTypeFor: storage,
                intention: nil,
                initialValue: Expression.identifier("b").typed("B")
            )

        XCTAssertTrue(result)
    }

    func testShouldEmitTypeSignature_alwaysEmitVariableTypesTrue_returnsTrue() {
        typeSystem.addType(KnownTypeBuilder(typeName: "A").build())
        let producer = SwiftSyntaxProducer()
        let storage = ValueStorage(
            type: .optional("A"),
            ownership: .weak,
            isConstant: false
        )
        var lazyResult: Bool {
            sut.swiftSyntaxProducer(
                producer,
                shouldEmitTypeFor: storage,
                intention: nil,
                initialValue: Expression.identifier("a").typed("A")
            )
        }

        XCTAssertFalse(lazyResult)
        sut.options.alwaysEmitVariableTypes = true
        XCTAssertTrue(lazyResult)
    }

    func testFormatOutput_noFormatting() throws {
        let original = """
            import      Module

            class   AClass
            {
            init() { }
                }
            """
        let fileSyntax = Parser.parse(source: original)

        let result = try sut.formatSyntax(fileSyntax, fileUrl: URL(fileURLWithPath: "path.swift"), format: .noFormatting)

        XCTAssertEqual(result.description, original)
    }

    func testFormatOutput_swiftFormat_defaultConfiguration() throws {
        let original = """
            import      Module

            class   AClass
            {
            init() { }
                }
            """
        let fileSyntax = Parser.parse(source: original)

        let result = try sut.formatSyntax(fileSyntax, fileUrl: URL(fileURLWithPath: "path.swift"), format: .swiftFormat(configuration: nil))

        XCTAssertEqual(result.description, """
            import Module

            class AClass {
              init() {}
            }

            """)
    }

    func testFormatOutput_swiftFormat_customConfiguration() throws {
        let original = """
            import      Module

            class   AClass
            {
            init() { }
                }
            """
        let fileSyntax = Parser.parse(source: original)

        var configuration = Configuration()
        configuration.indentation = .spaces(4)

        let result = try sut.formatSyntax(fileSyntax, fileUrl: URL(fileURLWithPath: "path.swift"), format: .swiftFormat(configuration: configuration))

        XCTAssertEqual(result.description, """
            import Module

            class AClass {
                init() {}
            }
            
            """)
    }
}
