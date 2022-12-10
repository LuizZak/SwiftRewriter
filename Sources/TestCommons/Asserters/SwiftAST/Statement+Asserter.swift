import SwiftAST

public extension Asserter where Object: Statement {
    /// Asserts that the underlying `Statement` object being tested tests true
    /// under equality against a given instance of the same type.
    ///
    /// Used as a convenience over `assert(equals:)` in tests for printing the
    /// underlying statement syntax properly in diagnostic messages.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        statementEquals expected: Object,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object == expected else {
            let objStr = StatementPrinter.toString(statement: object)
            let expStr = StatementPrinter.toString(statement: object)

            return assertFailed(
                message: #"assert(statementEquals:) failed: ("\#(objStr)") != ("\#(expStr)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
    
    /// Asserts that the underlying `Statement` object being tested tests false
    /// under equality against a given instance of the same type.
    ///
    /// Used as a convenience over `assert(notEquals:)` in tests for printing the
    /// underlying statement syntax properly in diagnostic messages.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        statementNotEquals expected: Object,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object != expected else {
            let objStr = StatementPrinter.toString(statement: object)
            let expStr = StatementPrinter.toString(statement: object)

            return assertFailed(
                message: #"assert(statementNotEquals:) failed: ("\#(objStr)") == ("\#(expStr)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
}

public extension Asserter {
    /// Asserts that the underlying `Optional<Statement>` object being tested
    /// tests true under equality against a given instance of the same type.
    ///
    /// Used as a convenience over `assert(equals:)` in tests for printing the
    /// underlying statement syntax properly in diagnostic messages.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert<S: Statement>(
        statementEquals expected: S?,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? where Object == S? {

        guard object == expected else {
            let objStr = object.map(StatementPrinter.toString(statement:)) ?? "<nil>"
            let expStr = expected.map(StatementPrinter.toString(statement:)) ?? "<nil>"

            return assertFailed(
                message: #"assert(statementEquals:) failed: ("\#(objStr)") != ("\#(expStr)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
    
    /// Asserts that the underlying `Optional<Statement>` object being tested
    /// tests false under equality against a given instance of the same type.
    ///
    /// Used as a convenience over `assert(notEquals:)` in tests for printing the
    /// underlying statement syntax properly in diagnostic messages.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert<S: Statement>(
        statementNotEquals expected: S?,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? where Object == S? {

        guard object != expected else {
            let objStr = object.map(StatementPrinter.toString(statement:)) ?? "<nil>"
            let expStr = expected.map(StatementPrinter.toString(statement:)) ?? "<nil>"

            return assertFailed(
                message: #"assert(statementNotEquals:) failed: ("\#(objStr)") == ("\#(expStr)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
}
