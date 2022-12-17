import XCTest

@testable import SwiftAST

class BinaryExpressionBalancerTests: XCTestCase {
    func testBalance_bitwiseShift() {
        func test(_ op: SwiftOperator) {
            assert(operator: op, associatesEquallyWith: .bitwiseShiftLeft)
            assert(operator: op, precedes: .add)
            assert(operator: op, precedes: .openRange)
            assert(operator: op, precedes: .nullCoalesce)
            assert(operator: op, precedes: .lessThan)
            assert(operator: op, precedes: .and)
            assert(operator: op, precedes: .or)
        }

        test(.bitwiseShiftLeft)
        test(.bitwiseShiftRight)
    }

    func testBalance_multiplicative() {
        func test(_ op: SwiftOperator) {
            assert(operator: .bitwiseShiftLeft, precedes: op)
            assert(operator: op, associatesEquallyWith: .multiply)
            assert(operator: op, precedes: .add)
            assert(operator: op, precedes: .openRange)
            assert(operator: op, precedes: .nullCoalesce)
            assert(operator: op, precedes: .lessThan)
            assert(operator: op, precedes: .and)
            assert(operator: op, precedes: .or)
        }

        test(.multiply)
        test(.divide)
        test(.mod)
        test(.bitwiseAnd)
    }

    func testBalance_additive() {
        func test(_ op: SwiftOperator) {
            assert(operator: .bitwiseShiftLeft, precedes: op)
            assert(operator: .multiply, precedes: op)
            assert(operator: op, associatesEquallyWith: .add)
            assert(operator: op, precedes: .openRange)
            assert(operator: op, precedes: .nullCoalesce)
            assert(operator: op, precedes: .lessThan)
            assert(operator: op, precedes: .and)
            assert(operator: op, precedes: .or)
        }

        test(.add)
        test(.subtract)
        test(.bitwiseXor)
        test(.bitwiseOr)
    }

    func testBalance_range() {
        func test(_ op: SwiftOperator) {
            assert(operator: .bitwiseShiftLeft, precedes: op)
            assert(operator: .multiply, precedes: op)
            assert(operator: .add, precedes: op)
            assert(operator: op, associatesEquallyWith: .openRange)
            assert(operator: op, precedes: .nullCoalesce)
            assert(operator: op, precedes: .lessThan)
            assert(operator: op, precedes: .and)
            assert(operator: op, precedes: .or)
        }

        test(.openRange)
        test(.closedRange)
    }

    func testBalance_nullCoalesce() {
        func test(_ op: SwiftOperator) {
            assert(operator: .bitwiseShiftLeft, precedes: op)
            assert(operator: .multiply, precedes: op)
            assert(operator: .add, precedes: op)
            assert(operator: .openRange, precedes: op)
            assert(operator: op, associatesEquallyWith: .nullCoalesce)
            assert(operator: op, precedes: .lessThan)
            assert(operator: op, precedes: .and)
            assert(operator: op, precedes: .or)
        }

        test(.nullCoalesce)
    }

    func testBalance_comparison() {
        func test(_ op: SwiftOperator) {
            assert(operator: .bitwiseShiftLeft, precedes: op)
            assert(operator: .multiply, precedes: op)
            assert(operator: .add, precedes: op)
            assert(operator: .openRange, precedes: op)
            assert(operator: .nullCoalesce, precedes: op)
            assert(operator: op, associatesEquallyWith: .lessThan)
            assert(operator: op, precedes: .and)
            assert(operator: op, precedes: .or)
        }

        test(.equals)
        test(.unequals)
        test(.identityEquals)
        test(.identityUnequals)
        test(.lessThan)
        test(.lessThanOrEqual)
        test(.greaterThan)
        test(.greaterThanOrEqual)
    }

    func testBalance_logicalConjunction() {
        func test(_ op: SwiftOperator) {
            assert(operator: .bitwiseShiftLeft, precedes: op)
            assert(operator: .multiply, precedes: op)
            assert(operator: .add, precedes: op)
            assert(operator: .openRange, precedes: op)
            assert(operator: .nullCoalesce, precedes: op)
            assert(operator: .lessThan, precedes: op)
            assert(operator: op, associatesEquallyWith: .and)
            assert(operator: op, precedes: .or)
        }

        test(.and)
    }

    func testBalance_logicalDisjunction() {
        func test(_ op: SwiftOperator) {
            assert(operator: .bitwiseShiftLeft, precedes: op)
            assert(operator: .multiply, precedes: op)
            assert(operator: .add, precedes: op)
            assert(operator: .openRange, precedes: op)
            assert(operator: .nullCoalesce, precedes: op)
            assert(operator: .lessThan, precedes: op)
            assert(operator: .and, precedes: op)
            assert(operator: op, associatesEquallyWith: .or)
        }

        test(.or)
    }

    func testBalance_deepNested() throws {
        let expected: BinaryExpression = .binary(
            lhs: .binary(
                lhs: .identifier("a").binary(
                    op: .multiply,
                    rhs: .identifier("b")
                ),
                op: .add,
                rhs: .identifier("c").binary(
                    op: .bitwiseShiftLeft,
                    rhs: .identifier("a")
                )
            ),
            op: .and,
            rhs: .binary(
                lhs: .identifier("b"),
                op: .nullCoalesce,
                rhs: .identifier("c")
            )
        )
        let exp1 = associateRight(.multiply, .add)
        let exp2 = associateLeft(.and, .nullCoalesce)
        let root = exp1.binary(op: .bitwiseShiftLeft, rhs: exp2)
        let sut = BinaryExpressionBalancer()

        let result = sut.balance(root)

        XCTAssertEqual(result, expected, #"("\#(toString(result))") != ("\#(toString(expected))")"#)
    }
}

// MARK: - Test internals

extension BinaryExpressionBalancerTests {

    /// Asserts that `op` always precedes `lowerOp` in binary expressions.
    private func assert(
        operator op: SwiftOperator,
        precedes lowerOp: SwiftOperator,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        guard let (exp1Binary, exp2Binary) = produceBinaryExpressions(
            op,
            lowerOp,
            file: file,
            line: line
        ) else {
            return
        }

        assert(
            isLeftPrecedence: exp1Binary,
            leftOperator: op,
            rightOperator: lowerOp,
            file: file,
            line: line
        )
        assert(
            isRightPrecedence: exp2Binary,
            leftOperator: lowerOp,
            rightOperator: op,
            file: file,
            line: line
        )
    }

    /// Asserts that `op` and `otherOp` produce equally precedent expressions.
    private func assert(
        operator op: SwiftOperator,
        associatesEquallyWith otherOp: SwiftOperator,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        let exp1 = associateLeft(op, otherOp)
        let exp2 = associateLeft(otherOp, op)

        let sut = BinaryExpressionBalancer()

        let exp1Result = sut.balance(exp1)
        let exp2Result = sut.balance(exp2)

        XCTAssertEqual(exp1, exp1Result, "\(toString(exp1)) != \(toString(exp1Result))")
        XCTAssertEqual(exp2, exp2Result, "\(toString(exp2)) != \(toString(exp2Result))")
    }

    /// Produces two nested binary expressions of the form `((a lhs b) rhs c)`
    /// and `(a lhs (b rhs c))` for testing operator precedence.
    private func produceBinaryExpressions(
        _ lhs: SwiftOperator,
        _ rhs: SwiftOperator,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (lhsBinary: BinaryExpression, rhsBinary: BinaryExpression)? {

        let exp1 = associateLeft(lhs, rhs)
        let exp2 = associateLeft(rhs, lhs)

        let sut = BinaryExpressionBalancer()
        
        return (sut.balance(exp1), sut.balance(exp2))
    }

    /// Creates a nested binary expression of the form `((a lhs b) rhs c)`
    private func associateLeft(
        _ lhs: SwiftOperator,
        _ rhs: SwiftOperator
    ) -> BinaryExpression {

        .binary(
            lhs: .identifier("a"),
            op: lhs,
            rhs: .binary(
                lhs: .identifier("b"),
                op: rhs,
                rhs: .identifier("c")
            )
        )
    }

    /// Creates a nested binary expression of the form `(a lhs (b rhs c))`
    private func associateRight(
        _ lhs: SwiftOperator,
        _ rhs: SwiftOperator
    ) -> BinaryExpression {

        .binary(
            lhs: .binary(
                lhs: .identifier("a"),
                op: lhs,
                rhs: .identifier("b")
            ),
            op: rhs,
            rhs: .identifier("c")
        )
    }

    /// Asserts that `exp` is of the form `((a lhs b) rhs c)`.
    private func assert(
        isLeftPrecedence exp: BinaryExpression,
        leftOperator: SwiftOperator,
        rightOperator: SwiftOperator,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard let lhs = exp.lhs.asBinary, exp.rhs.asBinary == nil else {
            XCTFail(
                "Expected binary expression to be left-precedence but it was not: \(toString(exp))",
                file: file,
                line: line
            )
            return
        }

        XCTAssertEqual(
            lhs.op,
            leftOperator,
            file: file,
            line: line
        )
        XCTAssertEqual(
            exp.op,
            rightOperator,
            file: file,
            line: line
        )
    }

    /// Asserts that `exp` is of the form `(a lhs (b rhs c))`.
    private func assert(
        isRightPrecedence exp: BinaryExpression,
        leftOperator: SwiftOperator,
        rightOperator: SwiftOperator,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard exp.lhs.asBinary == nil, let rhs = exp.rhs.asBinary else {
            XCTFail(
                "Expected binary expression to be right-precedence but it was not: \(toString(exp))",
                file: file,
                line: line
            )
            return
        }

        XCTAssertEqual(
            exp.op,
            leftOperator,
            file: file,
            line: line
        )
        XCTAssertEqual(
            rhs.op,
            rightOperator,
            file: file,
            line: line
        )
    }

    private func toString(_ exp: BinaryExpression) -> String {
        let lhsString: String
        if let lhs = exp.lhs.asBinary {
            lhsString = "(\(toString(lhs)))"
        } else {
            lhsString = exp.lhs.description
        }

        let rhsString: String
        if let rhs = exp.rhs.asBinary {
            rhsString = "(\(toString(rhs)))"
        } else {
            rhsString = exp.rhs.description
        }

        return "\(lhsString) \(exp.op) \(rhsString)"
    }
}
