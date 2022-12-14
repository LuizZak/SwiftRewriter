import XCTest
import SwiftAST
import KnownType

@testable import TypeSystem

class OverloadResolverTests: XCTestCase {
    var typeSystem: TypeSystem!
    var sut: OverloadResolver!

    override func setUp() {
        super.setUp()

        typeSystem = TypeSystem()
        sut = OverloadResolver(typeSystem: typeSystem, state: OverloadResolverState())
    }

    func testOverloadResolver() throws {
        let argumentTypes: [SwiftType?] = [
            .int,
            .bool,
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Bool, b: Bool)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertEqual(index, 1)
    }

    func testOverloadResolverIgnoresErrorTypes() throws {
        let argumentTypes: [SwiftType?] = [
            .errorType,
            .cgFloat,
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: Int, b: Int)"),
            try FunctionSignature(signatureString: "foo(a: CGFloat, b: CGFloat)"),
            try FunctionSignature(signatureString: "foo(a: Double, b: Double)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertEqual(index, 1)
    }

    func testOverloadResolverWithEmptyFunction() throws {
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)"),
            try FunctionSignature(signatureString: "foo()"),
            try FunctionSignature(signatureString: "foo(a: Int)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: [])

        XCTAssertEqual(index, 1)
    }

    func testResolveWithIncompleteArgumentTypes() throws {
        let argumentTypes: [SwiftType?] = [
            .int,
            nil,
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Bool, b: Bool)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertEqual(index, 1)
    }

    func testResolveWithNilArgumentTypes() throws {
        let argumentTypes: [SwiftType?] = [
            nil,
            nil,
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Bool, b: Bool)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertNil(index)
    }

    func testResolveWithMismatchedArgumentCount() throws {
        let argumentTypes: [SwiftType?] = [
            nil
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Bool, b: Bool)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertNil(index)
    }

    func testReturnFirstMatchOnAmbiguousCases() throws {
        let argumentTypes: [SwiftType?] = [
            nil,
            .bool,
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Bool, b: Bool)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertEqual(index, 0)
    }

    func testMatchLooksThroughOptionalArgumentTypes() throws {
        let argumentTypes: [SwiftType?] = [
            .optional(.int),
            .bool,
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Bool, b: Bool)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertEqual(index, 1)
    }

    func testMatchLooksThroughOptionalParameterTypes() throws {
        let argumentTypes: [SwiftType?] = [
            .int,
            .bool,
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String?, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int?, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Bool?, b: Bool)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertEqual(index, 1)
    }

    func testMatchFavoringSameOptionality() throws {
        let argumentTypes: [SwiftType?] = [
            .optional(.int),
            .bool,
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int?, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Bool, b: Bool)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertEqual(index, 1)
    }

    func testPolymorphicResolving() throws {
        typeSystem.addType(KnownTypeBuilder(typeName: "A").build())
        typeSystem.addType(
            KnownTypeBuilder(typeName: "B")
                .settingSupertype(KnownTypeReference.typeName("A"))
                .build()
        )
        let argumentTypes: [SwiftType?] = [
            "B"
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String)"),
            try FunctionSignature(signatureString: "foo(a: A)"),
            try FunctionSignature(signatureString: "foo(a: Int)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertEqual(index, 1)
    }

    func testPolymorphicResolvingFavorsExactMatching() throws {
        typeSystem.addType(KnownTypeBuilder(typeName: "A").build())
        typeSystem.addType(
            KnownTypeBuilder(typeName: "B")
                .settingSupertype(KnownTypeReference.typeName("A"))
                .build()
        )
        let argumentTypes: [SwiftType?] = [
            "B"
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: A)"),
            try FunctionSignature(signatureString: "foo(a: B)"),
            try FunctionSignature(signatureString: "foo(a: Int)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertEqual(index, 1)
    }

    func testPolymorphicResolvingLooksThroughOptionalArgumentTypes() throws {
        typeSystem.addType(KnownTypeBuilder(typeName: "A").build())
        typeSystem.addType(
            KnownTypeBuilder(typeName: "B")
                .settingSupertype(KnownTypeReference.typeName("A"))
                .build()
        )
        let argumentTypes: [SwiftType?] = [
            .optional("B")
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String)"),
            try FunctionSignature(signatureString: "foo(a: A)"),
            try FunctionSignature(signatureString: "foo(a: Int)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertEqual(index, 1)
    }

    func testOverloadResolveWithDefaultArgument() throws {
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(b: Int, c: Int)"),
            try FunctionSignature(signatureString: "foo(a: Int = default)"),
            try FunctionSignature(signatureString: "foo(a: Int)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: [])

        XCTAssertEqual(index, 1)
    }

    func testOverloadResolveWithDefaultArgumentNonEmptyArgumentCount() throws {
        let argumentTypes: [SwiftType?] = [
            .int, .int, .int,
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(b: Int, c: Int)"),
            try FunctionSignature(signatureString: "foo(a: Int, c: Int, d: Int = default)"),
            try FunctionSignature(signatureString: "foo(b: Bool, c: Bool)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertEqual(index, 1)
    }

    func testResolveWithOverloadWithDefaultArgumentValueAtEnd() throws {
        let argumentTypes: [SwiftType?] = [
            .int, .int,
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(b: Int)"),
            try FunctionSignature(signatureString: "foo(a: Int, c: Int, d: Int = default)"),
            try FunctionSignature(signatureString: "foo(b: Bool, c: Bool)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertEqual(index, 1)
    }

    func testOverloadsWithDefaultArgumentsNoResolution() throws {
        let argumentTypes: [SwiftType?] = [
            .int
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo()"),
            try FunctionSignature(signatureString: "foo(a: Int, c: Int, d: Int = default)"),
            try FunctionSignature(signatureString: "foo(b: Bool, c: Bool)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertNil(index)
    }

    func testResolveLiteralsUsingTypeCompatibility() throws {
        let arguments: [OverloadResolver.Argument] = [
            OverloadResolver.Argument(type: .int, isLiteral: false, literalKind: nil),
            OverloadResolver.Argument(type: .float, isLiteral: true, literalKind: .float),
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: Int, b: Int)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: Float)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: String)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, arguments: arguments)

        XCTAssertEqual(index, 1)
    }

    func testResolveLiteralsUsingTypeCompatibilityLookingThroughArgumentNullability() throws {
        let arguments: [OverloadResolver.Argument] = [
            OverloadResolver.Argument(
                type: .optional(.int),
                isLiteral: true,
                literalKind: .integer
            ),
            OverloadResolver.Argument(
                type: .optional(.float),
                isLiteral: true,
                literalKind: .float
            ),
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: Int, b: Int)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: Float)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: String)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, arguments: arguments)

        XCTAssertEqual(index, 1)
    }

    func testResolveLiteralsUsingTypeCompatibilityLookingThroughParameterNullability() throws {
        let arguments: [OverloadResolver.Argument] = [
            OverloadResolver.Argument(type: .int, isLiteral: true, literalKind: .integer),
            OverloadResolver.Argument(type: .float, isLiteral: true, literalKind: .float),
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: Int, b: Int?)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: Float?)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: String?)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, arguments: arguments)

        XCTAssertEqual(index, 1)
    }

    func testResolveLiteralsFavorsNaturalLiteralType() throws {
        let arguments: [OverloadResolver.Argument] = [
            OverloadResolver.Argument(type: .int, isLiteral: true, literalKind: .integer)
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: Float)"),
            try FunctionSignature(signatureString: "foo(a: Int64)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, arguments: arguments)

        XCTAssertEqual(index, 1)
    }

    func testMatchFavoringSameOptionalityWithPolymorphism() throws {
        typeSystem.addType(KnownTypeBuilder(typeName: "A").build())
        typeSystem.addType(
            KnownTypeBuilder(typeName: "B")
                .settingSupertype(KnownTypeReference.typeName("A"))
                .build()
        )
        let argumentTypes: [SwiftType?] = [
            .optional("B")
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: A)"),
            try FunctionSignature(signatureString: "foo(a: A?)"),
        ]

        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)

        XCTAssertEqual(index, 1)
    }
}
