import XCTest
import SwiftAST
import SwiftRewriterLib

class FunctionSignatureTests: XCTestCase {
    func testPossibleSelectorSignatures() throws {
        let signature1 =
            try FunctionSignature(signatureString: "foo(bar: Int)")
        let signature2 =
            try FunctionSignature(signatureString: "foo(bar: Int, baz: Int = default)")
        let signature3 =
            try FunctionSignature(signatureString: "foo(bar: Int, baz: Int = default, zaz: Int)")
        let signature4 =
            try FunctionSignature(signatureString: "foo(bar: Int, baz: Int = default, zaz: Int = default)")
        
        XCTAssertEqual(signature1.possibleSelectorSignatures(),
                       [SelectorSignature(isStatic: false, keywords: ["foo", "bar"])])
        XCTAssertEqual(signature2.possibleSelectorSignatures(),
                       [SelectorSignature(isStatic: false, keywords: ["foo", "bar"]),
                        SelectorSignature(isStatic: false, keywords: ["foo", "bar", "baz"])])
        XCTAssertEqual(signature3.possibleSelectorSignatures(),
                       [SelectorSignature(isStatic: false, keywords: ["foo", "bar", "zaz"]),
                        SelectorSignature(isStatic: false, keywords: ["foo", "bar", "baz", "zaz"])])
        XCTAssertEqual(signature4.possibleSelectorSignatures(),
                       [SelectorSignature(isStatic: false, keywords: ["foo", "bar"]),
                        SelectorSignature(isStatic: false, keywords: ["foo", "bar", "baz"]),
                        SelectorSignature(isStatic: false, keywords: ["foo", "bar", "zaz"]),
                        SelectorSignature(isStatic: false, keywords: ["foo", "bar", "baz", "zaz"])])
    }
}
