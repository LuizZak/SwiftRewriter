
public extension Asserter where Object == Bool {
    /// Asserts that the underlying `Bool` being tested is true.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsTrue(
        message: @autoclosure () -> String = "\(#function): Expected value to be true",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object else {
            return assertFailed(
                message: "assertIsTrue failed. \(message())",
                file: file,
                line: line
            )
        }

        return self
    }

    /// Asserts that the underlying `Bool` being tested is false.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsFalse(
        message: @autoclosure () -> String = "\(#function): Expected value to be false",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard !object else {
            return assertFailed(
                message: "assertIsFalse failed. \(message())",
                file: file,
                line: line
            )
        }

        return self
    }
}
