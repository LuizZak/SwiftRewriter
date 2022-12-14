import XCTest

@testable import TypeSystem

class PatternMatcherTests: XCTestCase {
    var typeSystem: TypeSystem!

    override func setUp() {
        typeSystem = TypeSystem()
    }

    func testMatch_wildcard_declaration() {
        let sut = makeSut()

        let result = sut.match(
            pattern: .wildcard,
            to: .int,
            context: .declaration
        )

        XCTAssertEqual(result, [])
    }

    func testMatch_expression_declaration() {
        let sut = makeSut()

        let result = sut.match(
            pattern: .expression(.identifier("a")),
            to: .int,
            context: .declaration
        )

        XCTAssertEqual(result, [])
    }

    func testMatch_identifier_declaration() {
        let sut = makeSut()

        let result = sut.match(
            pattern: .identifier("a"),
            to: .int,
            context: .declaration
        )

        XCTAssertEqual(result, [
            .init(identifier: "a", type: .int, patternLocation: .`self`),
        ])
    }

    func testMatch_identifier_optionalBinding() {
        let sut = makeSut()

        let result = sut.match(
            pattern: .identifier("a"),
            to: .optional(.int),
            context: .optionalBinding
        )

        XCTAssertEqual(result, [
            .init(identifier: "a", type: .int, patternLocation: .`self`),
        ])
    }

    func testMatch_tuple_declaration() {
        let sut = makeSut()

        let result = sut.match(
            pattern: .tuple([.identifier("a"), .identifier("b")]),
            to: .tuple(["A", "B"]),
            context: .optionalBinding
        )

        XCTAssertEqual(result, [
            .init(identifier: "a", type: "A", patternLocation: .tuple(index: 0, pattern: .`self`)),
            .init(identifier: "b", type: "B", patternLocation: .tuple(index: 1, pattern: .`self`)),
        ])
    }

    func testMatch_tuple_in_tuple_declaration() {
        let sut = makeSut()

        let result = sut.match(
            pattern: .tuple([
                .identifier("a"),
                .tuple([
                    .identifier("b"),
                    .identifier("c"),
                ])
            ]),
            to: .tuple([
                "A",
                .tuple(["B", "C"])
            ]),
            context: .optionalBinding
        )

        XCTAssertEqual(result, [
            .init(
                identifier: "a",
                type: "A",
                patternLocation: .tuple(index: 0, pattern: .`self`)
            ),
            .init(
                identifier: "b",
                type: "B",
                patternLocation: .tuple(index: 1, pattern: .tuple(index: 0, pattern: .`self`))
            ),
            .init(
                identifier: "c",
                type: "C",
                patternLocation: .tuple(index: 1, pattern: .tuple(index: 1, pattern: .`self`))
            ),
        ])
    }

    func testMatch_tuple_declaration_unequalLengths_root_returnsEmptyList() {
        let sut = makeSut()

        let result = sut.match(
            pattern: .tuple([.identifier("a"), .identifier("b"), .identifier("c")]),
            to: .tuple(["A", "B"]),
            context: .optionalBinding
        )

        XCTAssertEqual(result, [])
    }

    func testMatch_tuple_in_tuple_declaration_unequalLengths_nested_returnsPartialList() {
        let sut = makeSut()

        let result = sut.match(
            pattern: .tuple([
                .identifier("a"),
                .tuple([
                    .identifier("b"),
                    .identifier("c"),
                ])
            ]),
            to: .tuple([
                "A",
                .tuple(["B", "C", "D"])
            ]),
            context: .optionalBinding
        )

        XCTAssertEqual(result, [
            .init(
                identifier: "a",
                type: "A",
                patternLocation: .tuple(index: 0, pattern: .`self`)
            ),
        ])
    }

    // MARK: - Test internals

    private func makeSut() -> PatternMatcher {
        return PatternMatcher(typeSystem: typeSystem)
    }
}
