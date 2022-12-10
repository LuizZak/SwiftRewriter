import SwiftAST

public extension Asserter where Object: Expression {
    /// Asserts that the underlying `Expression` object being tested tests true
    /// under equality against a given instance of the same type.
    ///
    /// Used as a convenience over `assert(equals:)` in tests for printing the
    /// underlying expression syntax properly in diagnostic messages.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        expressionEquals expected: Object,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object == expected else {
            let objStr = ExpressionPrinter.toString(expression: object)
            let expStr = ExpressionPrinter.toString(expression: object)

            return assertFailed(
                message: #"assert(expressionEquals:) failed: ("\#(objStr)") != ("\#(expStr)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
    
    /// Asserts that the underlying `Expression` object being tested tests false
    /// under equality against a given instance of the same type.
    ///
    /// Used as a convenience over `assert(notEquals:)` in tests for printing the
    /// underlying expression syntax properly in diagnostic messages.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        expressionNotEquals expected: Object,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object != expected else {
            let objStr = ExpressionPrinter.toString(expression: object)
            let expStr = ExpressionPrinter.toString(expression: object)

            return assertFailed(
                message: #"assert(expressionNotEquals:) failed: ("\#(objStr)") == ("\#(expStr)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
}

public extension Asserter {
    /// Asserts that the underlying `Optional<Expression>` object being tested
    /// tests true under equality against a given instance of the same type.
    ///
    /// Used as a convenience over `assert(equals:)` in tests for printing the
    /// underlying expression syntax properly in diagnostic messages.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert<S: Expression>(
        expressionEquals expected: S?,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? where Object == S? {

        guard object == expected else {
            let objStr = object.map(ExpressionPrinter.toString(expression:)) ?? "<nil>"
            let expStr = expected.map(ExpressionPrinter.toString(expression:)) ?? "<nil>"

            return assertFailed(
                message: #"assert(expressionEquals:) failed: ("\#(objStr)") != ("\#(expStr)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
    
    /// Asserts that the underlying `Optional<Expression>` object being tested
    /// tests false under equality against a given instance of the same type.
    ///
    /// Used as a convenience over `assert(notEquals:)` in tests for printing the
    /// underlying expression syntax properly in diagnostic messages.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert<S: Expression>(
        expressionNotEquals expected: S?,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? where Object == S? {

        guard object != expected else {
            let objStr = object.map(ExpressionPrinter.toString(expression:)) ?? "<nil>"
            let expStr = expected.map(ExpressionPrinter.toString(expression:)) ?? "<nil>"

            return assertFailed(
                message: #"assert(expressionNotEquals:) failed: ("\#(objStr)") == ("\#(expStr)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
}
