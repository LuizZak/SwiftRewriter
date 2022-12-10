public extension Asserter where Object: Equatable {
    /// Asserts that the underlying `Equatable` object being tested tests true
    /// under equality against a given instance of the same type.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        equals expected: Object,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object == expected else {
            return assertFailed(
                message: #"assert(equals:) failed: ("\#(object)") != ("\#(expected)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
    
    /// Asserts that the underlying `Equatable` object being tested tests false
    /// under equality against a given instance of the same type.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        notEquals expected: Object,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object != expected else {
            return assertFailed(
                message: #"assert(notEquals:) failed: ("\#(object)") == ("\#(expected)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
}
