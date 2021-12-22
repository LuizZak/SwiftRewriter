import SwiftAST
import XCTest

class FunctionIdentifierTests: XCTestCase {

    func testIdentifierDescription() {
        XCTAssertEqual(
            FunctionIdentifier(name: "function", argumentLabels: []).description,
            "function()"
        )
        XCTAssertEqual(
            FunctionIdentifier(name: "function", argumentLabels: [nil]).description,
            "function(_:)"
        )
        XCTAssertEqual(
            FunctionIdentifier(name: "function", argumentLabels: ["a"]).description,
            "function(a:)"
        )
        XCTAssertEqual(
            FunctionIdentifier(name: "function", argumentLabels: ["a", nil, "b"]).description,
            "function(a:_:b:)"
        )
    }

}
