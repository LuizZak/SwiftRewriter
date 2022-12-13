import XCTest
import SwiftAST
import KnownType
import TestCommons

@testable import TypeSystem

class IterationTypeResolverTests: XCTestCase {
    var typeSystem: TypeSystem!

    override func setUp() {
        self.typeSystem = TypeSystem()
    }

    func testIterationElementType_swiftType_array() {
        let sut = makeSut()

        XCTAssertEqual(
            sut.iterationElementType(for: .array(.int)),
            .int
        )
        XCTAssertEqual(
            sut.iterationElementType(for: .array(.string)),
            .string
        )
        XCTAssertEqual(
            sut.iterationElementType(for: .array(.array(.bool))),
            .array(.bool)
        )
    }

    func testIterationElementType_swiftType_array_typeAliased() {
        typeSystem.addTypealias(aliasName: "Alias1", originalType: .array(.int))
        typeSystem.addTypealias(aliasName: "Alias2", originalType: .array("Alias1"))
        let sut = makeSut()

        XCTAssertEqual(
            sut.iterationElementType(for: "Alias1"),
            .int
        )
        XCTAssertEqual(
            sut.iterationElementType(for: "Alias2"),
            .array(.int)
        )
    }

    func testIterationElementType_swiftType_dictionary() {
        let sut = makeSut()

        XCTAssertEqual(
            sut.iterationElementType(for: .dictionary(key: .int, value: .string)),
            .tuple([.int, .string])
        )
    }

    func testIterationElementType_swiftType_dictionary_typeAliased() {
        typeSystem.addTypealias(aliasName: "Alias1", originalType: .array(.int))
        typeSystem.addTypealias(aliasName: "Alias2", originalType: .dictionary(key: .int, value: "Alias1"))
        let sut = makeSut()

        XCTAssertEqual(
            sut.iterationElementType(for: "Alias2"),
            .tuple([.int, .array(.int)])
        )
    }

    // MARK: - Test internals

    func makeSut() -> IterationTypeResolver {
        IterationTypeResolver(typeSystem: typeSystem)
    }
}
