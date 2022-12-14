import SwiftAST
import XCTest

class SelectorExpressionTests: XCTestCase {
    func testDescription() {
        XCTAssertEqual(
            SelectorExpression(
                functionIdentifier: FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])
            ).description,
            "#selector(f(_:b:))"
        )
        XCTAssertEqual(
            SelectorExpression(
                type: "T",
                functionIdentifier: FunctionIdentifier(name: "f", argumentLabels: [nil, "b"])
            ).description,
            "#selector(T.f(_:b:))"
        )
        XCTAssertEqual(
            SelectorExpression(getter: "p").description,
            "#selector(getter: p)"
        )
        XCTAssertEqual(
            SelectorExpression(type: "T", getter: "p").description,
            "#selector(getter: T.p)"
        )
        XCTAssertEqual(
            SelectorExpression(setter: "p").description,
            "#selector(setter: p)"
        )
        XCTAssertEqual(
            SelectorExpression(type: "T", setter: "p").description,
            "#selector(setter: T.p)"
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

    func testInequalityDifferentKinds() {
        let exp1 = SelectorExpression(
            functionIdentifier: FunctionIdentifier(name: "", argumentLabels: [])
        )
        let exp2 = SelectorExpression(
            type: "T",
            functionIdentifier: FunctionIdentifier(name: "", argumentLabels: [])
        )
        let exp3 = SelectorExpression(getter: "p")
        let exp4 = SelectorExpression(type: "T", getter: "p")
        let exp5 = SelectorExpression(setter: "p")
        let exp6 = SelectorExpression(type: "T", setter: "p")

        XCTAssertNotEqual(exp1, exp2)
        XCTAssertNotEqual(exp2, exp3)
        XCTAssertNotEqual(exp3, exp4)
        XCTAssertNotEqual(exp4, exp5)
        XCTAssertNotEqual(exp5, exp6)
    }
}
