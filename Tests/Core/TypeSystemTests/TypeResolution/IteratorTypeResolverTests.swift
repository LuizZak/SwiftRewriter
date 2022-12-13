import XCTest
import SwiftAST
import KnownType
import TestCommons

@testable import TypeSystem

class IteratorTypeResolverTests: XCTestCase {
    var typeSystem: TypeSystem!

    override func setUp() {
        self.typeSystem = TypeSystem()
    }

    func testIterationElementType_swiftType_closedRange() {
        let sut = makeSut()

        XCTAssertEqual(
            sut.iterationElementType(for: .closedRange(.int)),
            .int
        )
        XCTAssertEqual(
            sut.iterationElementType(for: .closedRange(.uint)),
            .uint
        )
        XCTAssertEqual(
            sut.iterationElementType(for: .closedRange("Int64")),
            "Int64"
        )
    }

    func testIterationElementType_swiftType_openRange() {
        let sut = makeSut()

        XCTAssertEqual(
            sut.iterationElementType(for: .openRange(.int)),
            .int
        )
        XCTAssertEqual(
            sut.iterationElementType(for: .openRange(.uint)),
            .uint
        )
        XCTAssertEqual(
            sut.iterationElementType(for: .openRange("Int64")),
            "Int64"
        )
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

    func makeSut() -> IteratorTypeResolver {
        IteratorTypeResolver(typeSystem: typeSystem)
    }
}
