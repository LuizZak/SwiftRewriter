public extension Asserter where Object: Collection {
    /// Asserts that the underlying `Collection` being tested is empty.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsEmpty(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.isEmpty else {
            return assertFailed(
                message: #"assertIsEmpty failed: found \#(object.count) item(s)."#,
                file: file,
                line: line
            )
        }

        return self
    }

    /// Asserts that the underlying `Collection` being tested is not empty.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsNotEmpty(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard !object.isEmpty else {
            return assertFailed(
                message: #"assertIsNotEmpty failed."#,
                file: file,
                line: line
            )
        }

        return self
    }

    /// Asserts that the underlying `Collection` being tested matches with another
    /// collection of the same elements, using a given test comparator closure.
    /// The comparison is strict in terms of collection length: if one of the
    /// collections contains less elements than the other, the test fails.
    ///
    /// Returns `nil` if the test failed with no passing items, otherwise returns
    /// `self` for chaining further tests.
    @discardableResult
    func assert(
        elementsEqualStrict other: some Collection<Object.Element>,
        file: StaticString = #file,
        line: UInt = #line,
        by comparator: (Object.Element, Object.Element) -> Bool
    ) -> Self? {

        if object.count == other.count && object.elementsEqual(other, by: comparator) {
            return self
        }

        return assertFailed(
            message: #"assert(elementsEqualStrict:) failed: ("\#(object)") != ("\#(other)")"#,
            file: file,
            line: line
        )
    }
}

public extension Asserter where Object: Collection, Object.Index == Int {
    /// Asserts that the underlying `Collection` being tested has a specified
    /// count of elements.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.count == count else {
            return assertFailed(
                message: #"assertCount failed: expected \#(count) found \#(object.count)."#,
                file: file,
                line: line
            )
        }

        return self
    }

    /// Opens an asserter context for a child node on the underlying `Collection`
    /// being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forItemAt index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<Object.Element>) -> Result?
    ) -> Self? {

        guard object.count > index else {
            return assertFailed(
                message: #"asserter(forItemAt: \#(index)) failed: collection has less than \#(index + 1) item(s)."#,
                file: file,
                line: line
            )
        }

        guard closure(.init(object: object[index])) != nil else {
            return nil
        }

        return self
    }
}
