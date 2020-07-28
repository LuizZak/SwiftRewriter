import XCTest
import SwiftAST

class SelectorExpressionTests: XCTestCase {
    func testDescription() {
        XCTAssertEqual(
            SelectorExpression(functionIdentifier: FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])).description,
            "#selector(f(_:b:))"
        )
        XCTAssertEqual(
            SelectorExpression(type: "T", functionIdentifier: FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])).description,
            "#selector(T.f(_:b:))"
        )
    }
    
    func testEquality() {
        let identifier1 = FunctionIdentifier(name: "f1", argumentLabels: [nil, "b"])
        let identifier2 = FunctionIdentifier(name: "f2", argumentLabels: ["a", "c"])
        let exp1 = SelectorExpression(functionIdentifier: identifier1)
        let exp2 = SelectorExpression(functionIdentifier: identifier1)
        let exp3 = SelectorExpression(functionIdentifier: identifier2)
        
        XCTAssertEqual(exp1, exp1)
        XCTAssertEqual(exp1, exp2)
        XCTAssertNotEqual(exp2, exp3)
    }
}
