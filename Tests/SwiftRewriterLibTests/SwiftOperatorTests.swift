import XCTest
import SwiftAST

class SwiftOperatorTests: XCTestCase {
    func testOperatorCategoryArithmetic() {
        assert(.add, is: .arithmetic)
        assert(.subtract, is: .arithmetic)
        assert(.multiply, is: .arithmetic)
        assert(.divide, is: .arithmetic)
        assert(.mod, is: .arithmetic)
    }
    
    func testOperatorCategoryLogical() {
        assert(.and, is: .logical)
        assert(.or, is: .logical)
        assert(.negate, is: .logical)
    }
    
    func testOperatorCategoryAssignment() {
        assert(.assign, is: .assignment)
        assert(.addAssign, is: .assignment)
        assert(.subtractAssign, is: .assignment)
        assert(.multiplyAssign, is: .assignment)
        assert(.divideAssign, is: .assignment)
        assert(.bitwiseOrAssign, is: .assignment)
        assert(.bitwiseAndAssign, is: .assignment)
        assert(.bitwiseNotAssign, is: .assignment)
        assert(.bitwiseXorAssign, is: .assignment)
        assert(.bitwiseShiftLeftAssign, is: .assignment)
        assert(.bitwiseShiftRightAssign, is: .assignment)
    }
    
    func testOperatorCategoryComparison() {
        assert(.lessThan, is: .comparison)
        assert(.lessThanOrEqual, is: .comparison)
        assert(.greaterThan, is: .comparison)
        assert(.greaterThanOrEqual, is: .comparison)
        assert(.equals, is: .comparison)
        assert(.unequals, is: .comparison)
    }
    
    func testOperatorCategoryNullCoallesce() {
        assert(.nullCoallesce, is: .nullCoallesce)
    }
    
    func testOperatorCategoryRangeMaking() {
        assert(.openRange, is: .range)
        assert(.closedRange, is: .range)
    }
    
    private func assert(_ op: SwiftOperator, is category: SwiftOperatorCategory, line: Int = #line) {
        if op.category != category {
            recordFailure(withDescription: "Assertion failure: Expected '\(op)' to be '\(category)', received '\(op.category)'",
                          inFile: #file, atLine: line, expected: false)
        }
    }
}
