import SwiftAST
import XCTest

class SwiftOperatorTests: XCTestCase {
    func testOperatorCategoryAndPrecedence() {
        assert(.negate, is: .logical, precedenceAsInfix: .prefixPostfixPrecedence)
        assert(.bitwiseNot, is: .bitwise, precedenceAsInfix: .prefixPostfixPrecedence)

        assert(.bitwiseShiftLeft, is: .bitwise, precedenceAsInfix: .bitwiseShiftPrecedence)
        assert(.bitwiseShiftRight, is: .bitwise, precedenceAsInfix: .bitwiseShiftPrecedence)

        assert(.multiply, is: .arithmetic, precedenceAsInfix: .multiplicationPrecedence)
        assert(.divide, is: .arithmetic, precedenceAsInfix: .multiplicationPrecedence)
        assert(.mod, is: .arithmetic, precedenceAsInfix: .multiplicationPrecedence)
        assert(.bitwiseAnd, is: .bitwise, precedenceAsInfix: .multiplicationPrecedence)

        assert(.add, is: .arithmetic, precedenceAsInfix: .additionPrecedence)
        assert(.subtract, is: .arithmetic, precedenceAsInfix: .additionPrecedence)
        assert(.bitwiseOr, is: .bitwise, precedenceAsInfix: .additionPrecedence)
        assert(.bitwiseXor, is: .bitwise, precedenceAsInfix: .additionPrecedence)
        
        assert(.openRange, is: .range, precedenceAsInfix: .rangePrecedence)
        assert(.closedRange, is: .range, precedenceAsInfix: .rangePrecedence)
        
        assert(.nullCoalesce, is: .nullCoalesce, precedenceAsInfix: .nullCoalescePrecedence)
        
        assert(.lessThan, is: .comparison, precedenceAsInfix: .comparisonPrecedence)
        assert(.lessThanOrEqual, is: .comparison, precedenceAsInfix: .comparisonPrecedence)
        assert(.greaterThan, is: .comparison, precedenceAsInfix: .comparisonPrecedence)
        assert(.greaterThanOrEqual, is: .comparison, precedenceAsInfix: .comparisonPrecedence)
        assert(.equals, is: .comparison, precedenceAsInfix: .comparisonPrecedence)
        assert(.unequals, is: .comparison, precedenceAsInfix: .comparisonPrecedence)

        assert(.and, is: .logical, precedenceAsInfix: .logicalConjunctionPrecedence)
        assert(.or, is: .logical, precedenceAsInfix: .logicalDisjunctionPrecedence)

        assert(.assign, is: .assignment, precedenceAsInfix: .assignmentPrecedence)
        assert(.addAssign, is: .assignment, precedenceAsInfix: .assignmentPrecedence)
        assert(.subtractAssign, is: .assignment, precedenceAsInfix: .assignmentPrecedence)
        assert(.multiplyAssign, is: .assignment, precedenceAsInfix: .assignmentPrecedence)
        assert(.divideAssign, is: .assignment, precedenceAsInfix: .assignmentPrecedence)
        assert(.bitwiseOrAssign, is: .assignment, precedenceAsInfix: .assignmentPrecedence)
        assert(.bitwiseAndAssign, is: .assignment, precedenceAsInfix: .assignmentPrecedence)
        assert(.bitwiseNotAssign, is: .assignment, precedenceAsInfix: .assignmentPrecedence)
        assert(.bitwiseXorAssign, is: .assignment, precedenceAsInfix: .assignmentPrecedence)
        assert(.bitwiseShiftLeftAssign, is: .assignment, precedenceAsInfix: .assignmentPrecedence)
        assert(.bitwiseShiftRightAssign, is: .assignment, precedenceAsInfix: .assignmentPrecedence)
    }

    // MARK: - Test internals

    private func assert(
        _ op: SwiftOperator,
        is category: SwiftOperatorCategory,
        precedenceAsInfix: SwiftOperatorPrecedence,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        let opPrecedence = op.precedence(asInfix: true)

        XCTAssertEqual(
            op.category,
            category,
            "Category for '\(op)' expected to be '\(category)', received '\(op.category)'",
            file: file,
            line: line
        )

        XCTAssertEqual(
            opPrecedence,
            precedenceAsInfix,
            "Infix precedence for '\(op)' expected to be '\(precedenceAsInfix)', received '\(opPrecedence)'",
            file: file,
            line: line
        )
    }
}
