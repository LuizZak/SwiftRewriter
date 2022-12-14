import SwiftAST
import XCTest

class SwiftTypeTests: XCTestCase {
    func testDescriptionTypeName() {
        XCTAssertEqual(
            SwiftType.typeName("A").description,
            "A"
        )
    }

    func testDescriptionGeneric() {
        XCTAssertEqual(
            SwiftType.generic("A", parameters: [.typeName("B")]).description,
            "A<B>"
        )
        XCTAssertEqual(
            SwiftType.generic("A", parameters: [.typeName("B"), .typeName("C")]).description,
            "A<B, C>"
        )
    }

    func testDescriptionProtocolComposition() {
        // These are not valid and will crash, since protocol compositions require
        // two or more nominal types.
        //
        // XCTAssertEqual(SwiftType.protocolComposition([]).description,
        //                "")
        //
        // XCTAssertEqual(SwiftType.protocolComposition([.typeName("A")]).description,
        //                "A")
        XCTAssertEqual(
            SwiftType.protocolComposition([.typeName("A"), .typeName("B")]).description,
            "A & B"
        )
        XCTAssertEqual(
            SwiftType.protocolComposition([.typeName("A"), .typeName("B"), .typeName("C")])
                .description,
            "A & B & C"
        )
    }

    func testDescriptionNestedType() {
        XCTAssertEqual(
            SwiftType.nested([.typeName("A"), .typeName("B")]).description,
            "A.B"
        )
        XCTAssertEqual(
            SwiftType.nested([.generic("A", parameters: [.typeName("B")]), .typeName("C")])
                .description,
            "A<B>.C"
        )
        XCTAssertEqual(
            SwiftType.nested([.typeName("A"), .typeName("B"), .typeName("C")]).description,
            "A.B.C"
        )
    }

    func testDescriptionMetadata() {
        XCTAssertEqual(
            SwiftType.metatype(for: .typeName("A")).description,
            "A.Type"
        )
        XCTAssertEqual(
            SwiftType.metatype(for: .metatype(for: .typeName("A"))).description,
            "A.Type.Type"
        )
    }

    func testDescriptionTupleType() {
        XCTAssertEqual(
            SwiftType.tuple(.empty).description,
            "Void"
        )

        // This is not valid and will crash, since tuples require either 0, or
        // two or more types
        //
        // XCTAssertEqual(SwiftType.tuple([.typeName("A")]).description,
        //                "(A)")

        XCTAssertEqual(
            SwiftType.tuple(.types([.typeName("A"), .typeName("B")])).description,
            "(A, B)"
        )
        XCTAssertEqual(
            SwiftType.tuple(.types([.typeName("A"), .typeName("B"), .typeName("C")])).description,
            "(A, B, C)"
        )
    }

    func testDescriptionBlockType() {
        XCTAssertEqual(
            SwiftType.swiftBlock(returnType: .void, parameters: []).description,
            "() -> Void"
        )
    }

    func testDescriptionBlockTypeWithReturnType() {
        XCTAssertEqual(
            SwiftType.swiftBlock(returnType: .typeName("A"), parameters: []).description,
            "() -> A"
        )
    }

    func testDescriptionBlockTypeWithParameters() {
        XCTAssertEqual(
            SwiftType.swiftBlock(returnType: .void, parameters: [.typeName("A")]).description,
            "(A) -> Void"
        )
        XCTAssertEqual(
            SwiftType.swiftBlock(returnType: .void, parameters: [.typeName("A"), .typeName("B")])
                .description,
            "(A, B) -> Void"
        )
    }

    func testDescriptionBlockFull() {
        XCTAssertEqual(
            SwiftType.block(
                returnType: .typeName("A"),
                parameters: [.typeName("B"), .typeName("C")],
                attributes: [.escaping, .autoclosure, .convention(.c)]
            ).description,
            "@autoclosure @convention(c) @escaping (B, C) -> A"
        )
    }

    func testDescriptionOptionalWithTypeName() {
        XCTAssertEqual(
            SwiftType.optional(.typeName("A")).description,
            "A?"
        )
    }

    func testDescriptionOptionalWithProtocolCompositionType() {
        XCTAssertEqual(
            SwiftType.optional(.protocolComposition([.typeName("A"), .typeName("B")])).description,
            "(A & B)?"
        )
    }

    func testDescriptionOptionalWithTupleType() {
        XCTAssertEqual(
            SwiftType.optional(.tuple(.types([.typeName("A"), .typeName("B")]))).description,
            "(A, B)?"
        )
    }

    func testDescriptionOptionalWithBlockTupleType() {
        XCTAssertEqual(
            SwiftType.optional(
                .swiftBlock(returnType: .void, parameters: [.typeName("A"), .typeName("B")])
            ).description,
            "((A, B) -> Void)?"
        )
    }

    func testDescriptionOptionalWithGenericType() {
        XCTAssertEqual(
            SwiftType.optional(
                .generic("A", parameters: .fromCollection([.typeName("B"), .typeName("C")]))
            ).description,
            "A<B, C>?"
        )
    }

    func testDescriptionOptionalWithNestedType() {
        XCTAssertEqual(
            SwiftType.optional(.nested([.typeName("A"), .typeName("B")])).description,
            "A.B?"
        )
    }

    func testDescriptionOptionalWithProtocolComposition() {
        XCTAssertEqual(
            SwiftType.optional(.protocolComposition([.typeName("A"), .typeName("B")])).description,
            "(A & B)?"
        )
    }

    func testDescriptionOptionalWithOptionalType() {
        XCTAssertEqual(
            SwiftType.optional(.optional(.typeName("A"))).description,
            "A??"
        )
    }

    func testDescriptionImplicitOptionalWithOptionalType() {
        XCTAssertEqual(
            SwiftType.implicitUnwrappedOptional(.optional(.typeName("A"))).description,
            "A?!"
        )
    }

    func testDescriptionImplicitOptionalWithTypeName() {
        XCTAssertEqual(
            SwiftType.implicitUnwrappedOptional(.typeName("A")).description,
            "A!"
        )
    }

    func testDescriptionArrayType() {
        XCTAssertEqual(
            SwiftType.array(.typeName("A")).description,
            "[A]"
        )
    }

    func testDescriptionDictionaryType() {
        XCTAssertEqual(
            SwiftType.dictionary(key: .typeName("A"), value: .typeName("B")).description,
            "[A: B]"
        )
    }

    func testWithSameOptionalityAs() {
        XCTAssertEqual(
            SwiftType.int.withSameOptionalityAs(.any),
            .int
        )
        XCTAssertEqual(
            SwiftType.int.withSameOptionalityAs(.optional(.any)),
            .optional(.int)
        )
        XCTAssertEqual(
            SwiftType.int.withSameOptionalityAs(.optional(.implicitUnwrappedOptional(.any))),
            .optional(.implicitUnwrappedOptional(.int))
        )
        XCTAssertEqual(
            SwiftType.optional(.int).withSameOptionalityAs(.any),
            .int
        )
        XCTAssertEqual(
            SwiftType.optional(.int).withSameOptionalityAs(
                .optional(.implicitUnwrappedOptional(.any))
            ),
            .optional(.implicitUnwrappedOptional(.int))
        )
    }

    func testOptionalityDepth() {
        XCTAssertEqual(SwiftType.int.optionalityDepth, 0)
        XCTAssertEqual(SwiftType.optional(.int).optionalityDepth, 1)
        XCTAssertEqual(SwiftType.implicitUnwrappedOptional(.int).optionalityDepth, 1)
        XCTAssertEqual(SwiftType.nullabilityUnspecified(.int).optionalityDepth, 1)
        XCTAssertEqual(SwiftType.optional(.optional(.int)).optionalityDepth, 2)
    }

    func testEncode() throws {
        let type = SwiftType.swiftBlock(returnType: .void, parameters: [.array(.string)])

        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)

        XCTAssertEqual(type, decoded)
    }

    func testEncodeEmptyTuple() throws {
        let type = SwiftType.tuple(.empty)

        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)

        XCTAssertEqual(type, decoded)
    }

    func testEncodeSingleTypeTuple() throws {
        let type = SwiftType.tuple(.types([.int, .string]))

        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)

        XCTAssertEqual(type, decoded)
    }

    func testEncodeTwoTypedTuple() throws {
        let type = SwiftType.tuple(.types([.int, .string]))

        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)

        XCTAssertEqual(type, decoded)
    }

    func testEncodeNAryTypedTuple() throws {
        let type = SwiftType.tuple(.types([.int, .string, .float, .double, .any]))

        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)

        XCTAssertEqual(type, decoded)
    }

    func testEncodeAsNested() throws {
        struct Test: Codable {
            var type: SwiftType
        }

        let test =
            Test(
                type: .swiftBlock(
                    returnType: .implicitUnwrappedOptional(
                        .protocolComposition([.typeName("A"), .typeName("B")])
                    ),
                    parameters: [
                        .generic(
                            "C",
                            parameters: [
                                .optional(
                                    .nested([
                                        .typeName("D"), .generic("E", parameters: [.typeName("D")]),
                                    ])
                                )
                            ]
                        )
                    ]
                )
            )

        let encoded = try JSONEncoder().encode(test)
        let decoded = try JSONDecoder().decode(Test.self, from: encoded)

        XCTAssertEqual(test.type, decoded.type)
    }

    func testOneOrMoreInitializing() {
        let sut = OneOrMore.fromCollection([1, 2, 3])

        XCTAssertEqual(sut, OneOrMore(first: 1, remaining: [2, 3]))
    }

    func testTwoOrMoreInitializing() {
        let sut = TwoOrMore.fromCollection([1, 2, 3])

        XCTAssertEqual(sut, TwoOrMore(first: 1, second: 2, remaining: [3]))
    }

    func testIterateOneOrMoreOneItem() {
        let sut: OneOrMore<Int> = .one(1)

        let result = Array(sut)

        XCTAssertEqual(result, [1])
    }

    func testIterateOneOrMore() {
        let sut: OneOrMore<Int> = [1, 2, 3]

        let result = Array(sut)

        XCTAssertEqual(result, [1, 2, 3])
    }

    func testIterateTwoOrMore() {
        let sut: TwoOrMore<Int> = [1, 2, 3]

        let result = Array(sut)

        XCTAssertEqual(result, [1, 2, 3])
    }

    func testPrependArrayOneOrMore() {
        let sut: OneOrMore<Int> = [1, 2]

        let result = [3, 4] + sut

        XCTAssertEqual(result, [3, 4, 1, 2])
    }

    func testPrependOneOrMore() {
        let sut: OneOrMore<Int> = [1, 2]

        let result = [3, 4] as OneOrMore<Int> + sut

        XCTAssertEqual(result, [3, 4, 1, 2])
    }

    func testPrependArraySingleElementOneOrMore() {
        let sut: OneOrMore<Int> = [1, 2]

        let result = [3] + sut

        XCTAssertEqual(result, [3, 1, 2])
    }

    func testPrependArrayEmptyOneOrMore() {
        let sut: OneOrMore<Int> = [1, 2]

        let result = [] + sut

        XCTAssertEqual(result, [1, 2])
    }

    func testAppendArrayOneOrMore() {
        let sut: OneOrMore<Int> = [1, 2]

        let result = sut + [3, 4]

        XCTAssertEqual(result, [1, 2, 3, 4])
    }

    func testAppendOneOrMore() {
        let sut: OneOrMore<Int> = [1, 2]

        let result = sut + [3, 4] as OneOrMore<Int>

        XCTAssertEqual(result, [1, 2, 3, 4])
    }

    func testAppendArraySingleElementOneOrMore() {
        let sut: OneOrMore<Int> = [1, 2]

        let result = sut + [3]

        XCTAssertEqual(result, [1, 2, 3])
    }

    func testAppendArrayEmptyOneOrMore() {
        let sut: OneOrMore<Int> = [1, 2]

        let result = sut + []

        XCTAssertEqual(result, [1, 2])
    }

    func testPrependArrayTwoOrMore() {
        let sut: TwoOrMore<Int> = [1, 2, 3]

        let result = [4, 5] + sut

        XCTAssertEqual(result, [4, 5, 1, 2, 3])
    }

    func testPrependTwoOrMore() {
        let sut: TwoOrMore<Int> = [1, 2, 3]

        let result = [4, 5] as TwoOrMore<Int> + sut

        XCTAssertEqual(result, [4, 5, 1, 2, 3])
    }

    func testPrependArraySingleElementTwoOrMore() {
        let sut: TwoOrMore<Int> = [1, 2, 3]

        let result = [4] + sut

        XCTAssertEqual(result, [4, 1, 2, 3])
    }

    func testPrependArrayEmptyTwoOrMore() {
        let sut: TwoOrMore<Int> = [1, 2, 3]

        let result = [] + sut

        XCTAssertEqual(result, [1, 2, 3])
    }

    func testAppendArrayTwoOrMore() {
        let sut: TwoOrMore<Int> = [1, 2, 3]

        let result = sut + [4, 5]

        XCTAssertEqual(result, [1, 2, 3, 4, 5])
    }

    func testAppendTwoOrMore() {
        let sut: TwoOrMore<Int> = [1, 2, 3]

        let result = sut + [4, 5] as TwoOrMore<Int>

        XCTAssertEqual(result, [1, 2, 3, 4, 5])
    }

    func testAppendArraySingleElementTwoOrMore() {
        let sut: TwoOrMore<Int> = [1, 2, 3]

        let result = sut + [4]

        XCTAssertEqual(result, [1, 2, 3, 4])
    }

    func testAppendArrayEmptyTwoOrMore() {
        let sut: TwoOrMore<Int> = [1, 2, 3]

        let result = sut + []

        XCTAssertEqual(result, [1, 2, 3])
    }
}
