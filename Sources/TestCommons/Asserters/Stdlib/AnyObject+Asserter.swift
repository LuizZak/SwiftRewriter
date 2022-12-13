public extension Asserter where Object: AnyObject {
    /// Asserts that the underlying `AnyObject` object being tested tests true
    /// under reference equality (`===`) against a given instance of some other
    /// reference type.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        identical expected: AnyObject,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object === expected else {
            return assertFailed(
                message: #"assert(identical:) failed: ("\#(object)") != ("\#(expected)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
    
    /// Asserts that the underlying `AnyObject` object being tested tests false
    /// under reference equality (`!==`) against a given instance of some other
    /// reference type.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        notIdentical expected: AnyObject,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object !== expected else {
            return assertFailed(
                message: #"assert(notIdentical:) failed: ("\#(object)") == ("\#(expected)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
}
