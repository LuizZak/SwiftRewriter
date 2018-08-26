import XCTest
import SwiftAST

class FunctionIdentifierTests: XCTestCase {
    
    func testIdentifierDescription() {
        XCTAssertEqual(
            FunctionIdentifier(name: "function", parameterNames: []).description,
            "function()"
        )
        XCTAssertEqual(
            FunctionIdentifier(name: "function", parameterNames: [nil]).description,
            "function(_:)"
        )
        XCTAssertEqual(
            FunctionIdentifier(name: "function", parameterNames: ["a"]).description,
            "function(a:)"
        )
        XCTAssertEqual(
            FunctionIdentifier(name: "function", parameterNames: ["a", nil, "b"]).description,
            "function(a:_:b:)"
        )
    }
    
}
