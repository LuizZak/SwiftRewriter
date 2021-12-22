import SwiftAST
import XCTest

class FunctionSignatureTests: XCTestCase {
    func testPossibleSelectorSignatures() throws {
        let signature1 =
            try FunctionSignature(signatureString: "foo(bar: Int)")
        let signature2 =
            try FunctionSignature(signatureString: "foo(bar: Int, baz: Int = default)")
        let signature3 =
            try FunctionSignature(signatureString: "foo(bar: Int, baz: Int = default, _ zaz: Int)")
        let signature4 =
            try FunctionSignature(
                signatureString: "foo(bar: Int, baz: Int = default, _ zaz: Int = default)"
            )

        XCTAssertEqual(
            signature1.possibleSelectorSignatures(),
            [SelectorSignature(isStatic: false, keywords: ["foo", "bar"])]
        )
        XCTAssertEqual(
            signature2.possibleSelectorSignatures(),
            [
                SelectorSignature(isStatic: false, keywords: ["foo", "bar"]),
                SelectorSignature(isStatic: false, keywords: ["foo", "bar", "baz"]),
            ]
        )
        XCTAssertEqual(
            signature3.possibleSelectorSignatures(),
            [
                SelectorSignature(isStatic: false, keywords: ["foo", "bar", nil]),
                SelectorSignature(isStatic: false, keywords: ["foo", "bar", "baz", nil]),
            ]
        )
        XCTAssertEqual(
            signature4.possibleSelectorSignatures(),
            [
                SelectorSignature(isStatic: false, keywords: ["foo", "bar"]),
                SelectorSignature(isStatic: false, keywords: ["foo", "bar", "baz"]),
                SelectorSignature(isStatic: false, keywords: ["foo", "bar", nil]),
                SelectorSignature(isStatic: false, keywords: ["foo", "bar", "baz", nil]),
            ]
        )
    }

    func testPossibleIdentifierSignatures() throws {
        let signature1 =
            try FunctionSignature(signatureString: "foo(bar: Int)")
        let signature2 =
            try FunctionSignature(signatureString: "foo(bar: Int, baz: Int = default)")
        let signature3 =
            try FunctionSignature(signatureString: "foo(bar: Int, baz: Int = default, _ zaz: Int)")
        let signature4 =
            try FunctionSignature(
                signatureString: "foo(bar: Int, baz: Int = default, _ zaz: Int = default)"
            )

        XCTAssertEqual(
            signature1.possibleIdentifierSignatures(),
            [FunctionIdentifier(name: "foo", argumentLabels: ["bar"])]
        )
        XCTAssertEqual(
            signature2.possibleIdentifierSignatures(),
            [
                FunctionIdentifier(name: "foo", argumentLabels: ["bar"]),
                FunctionIdentifier(name: "foo", argumentLabels: ["bar", "baz"]),
            ]
        )
        XCTAssertEqual(
            signature3.possibleIdentifierSignatures(),
            [
                FunctionIdentifier(name: "foo", argumentLabels: ["bar", nil]),
                FunctionIdentifier(name: "foo", argumentLabels: ["bar", "baz", nil]),
            ]
        )
        XCTAssertEqual(
            signature4.possibleIdentifierSignatures(),
            [
                FunctionIdentifier(name: "foo", argumentLabels: ["bar"]),
                FunctionIdentifier(name: "foo", argumentLabels: ["bar", "baz"]),
                FunctionIdentifier(name: "foo", argumentLabels: ["bar", nil]),
                FunctionIdentifier(name: "foo", argumentLabels: ["bar", "baz", nil]),
            ]
        )
    }
}
