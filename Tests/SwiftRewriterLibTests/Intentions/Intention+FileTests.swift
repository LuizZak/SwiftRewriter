import XCTest
import SwiftAST
import SwiftRewriterLib

class Intention_FileTests: XCTestCase {
    func testFunctionSignatureAsSelector() {
        XCTAssertEqual(
            FunctionSignature(name: "test", parameters: []).asSelector,
            SelectorSignature(isStatic: false, keywords: ["test"])
        )
        XCTAssertEqual(
            FunctionSignature(name: "test", parameters: [], isStatic: true).asSelector,
            SelectorSignature(isStatic: true, keywords: ["test"])
        )
        XCTAssertEqual(
            FunctionSignature(name: "test", parameters: [.init(label: "_", name: "arg", type: .int)]).asSelector,
            SelectorSignature(isStatic: false, keywords: ["test", nil])
        )
        XCTAssertEqual(
            FunctionSignature(name: "addObserver",
                              parameters: [
                                .init(label: "_", name: "observer", type: .anyObject),
                                .init(label: "forEventType", name: "eventType", type: .string)
                              ]).asSelector,
            SelectorSignature(isStatic: false, keywords: ["addObserver", nil, "forEventType"])
        )
        
        // Tests that if the first label from a function signature is not empty
        // that it is joined with the function name to form a single camelcased
        // method name
        XCTAssertEqual(
            FunctionSignature(name: "add",
                              parameters: [
                                .init(label: "observer", name: "observer", type: .anyObject),
                                .init(label: "forEventType", name: "eventType", type: .string)
                ]).asSelector,
            SelectorSignature(isStatic: false, keywords: ["addObserver", nil, "forEventType"])
        )
    }
}
