import SwiftAST
import XCTest

class TypeFormatterTests: XCTestCase {
    func testAsStringFunctionSignature() {
        let sig1 = FunctionSignature.init(
            name: "abc",
            parameters: [],
            returnType: .int,
            traits: []
        )

        let sig2 = FunctionSignature(
            name: "abc",
            parameters: [ParameterSignature(label: "a", name: "b", type: .float)],
            returnType: .void,
            traits: []
        )

        let sig3 = FunctionSignature(
            name: "abc",
            parameters: [
                ParameterSignature(label: "a", name: "b", type: .float),
                ParameterSignature(label: "c", name: "c", type: .int),
            ],
            returnType: .void,
            traits: [.static, .throwing]
        )

        XCTAssertEqual("abc() -> Int", TypeFormatter.asString(signature: sig1, includeName: true))
        XCTAssertEqual("() -> Int", TypeFormatter.asString(signature: sig1, includeName: false))

        XCTAssertEqual(
            "abc(a b: Float)",
            TypeFormatter.asString(signature: sig2, includeName: true)
        )
        XCTAssertEqual("(a b: Float)", TypeFormatter.asString(signature: sig2, includeName: false))

        XCTAssertEqual(
            "static throwing abc(a b: Float, c: Int)",
            TypeFormatter.asString(signature: sig3, includeName: true)
        )
        XCTAssertEqual(
            "static abc(a b: Float, c: Int)",
            TypeFormatter.asString(signature: sig3, includeName: true, includeTraits: false)
        )
        XCTAssertEqual(
            "static throwing (a b: Float, c: Int)",
            TypeFormatter.asString(signature: sig3, includeName: false)
        )
        XCTAssertEqual(
            "throwing (a b: Float, c: Int)",
            TypeFormatter.asString(signature: sig3, includeName: false, includeStatic: false)
        )
        XCTAssertEqual(
            "(a b: Float, c: Int)",
            TypeFormatter.asString(signature: sig3, includeName: false, includeTraits: false, includeStatic: false)
        )

        // Test default values for `includeName`
        XCTAssertEqual("() -> Int", TypeFormatter.asString(signature: sig1))
        XCTAssertEqual("(a b: Float)", TypeFormatter.asString(signature: sig2))
        XCTAssertEqual("static throwing (a b: Float, c: Int)", TypeFormatter.asString(signature: sig3))
    }

    func testAsStringSubscriptSignature() {
        let sig1 = SubscriptSignature.init(
            parameters: [.init(name: "i", type: .int)],
            returnType: .int
        )
        let sig2 = SubscriptSignature.init(
            parameters: [.init(name: "i", type: .int)],
            returnType: .int,
            isStatic: true
        )

        XCTAssertEqual("subscript(i: Int) -> Int", TypeFormatter.asString(signature: sig1, includeSubscriptKeyword: true))
        XCTAssertEqual("(i: Int) -> Int", TypeFormatter.asString(signature: sig1, includeSubscriptKeyword: false))

        XCTAssertEqual("static subscript(i: Int) -> Int", TypeFormatter.asString(signature: sig2, includeStatic: true))
        XCTAssertEqual("subscript(i: Int) -> Int", TypeFormatter.asString(signature: sig2, includeStatic: false))

        // Test default parameters
        XCTAssertEqual("subscript(i: Int) -> Int", TypeFormatter.asString(signature: sig1))
        XCTAssertEqual("static subscript(i: Int) -> Int", TypeFormatter.asString(signature: sig2))
    }

    func testAsStringParameterDefaultValue() {
        let parameters = [
            ParameterSignature(label: "label", name: "name", type: .int, hasDefaultValue: true)
        ]
        XCTAssertEqual(
            "(label name: Int = default)",
            TypeFormatter.asString(parameters: parameters)
        )
    }
}
