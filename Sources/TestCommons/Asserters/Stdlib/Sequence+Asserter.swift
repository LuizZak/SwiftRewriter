public extension Asserter where Object: Sequence {
    /// Creates a new leaf testing asserter for testing the iterator of the
    /// underlying `Sequence` being tested.
    ///
    /// Returns `Asserter<Object.Iterator>` for chaining further tests.
    @discardableResult
    func asserterForIterator(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<Object.Iterator> {

        let iterator = object.makeIterator()

        return .init(object: iterator)
    }

    /// Creates a new leaf testing asserter for the first element within the
    /// underlying `Sequence` being tested that passes a given predicate.
    ///
    /// Returns `nil` if the test failed with no passing items, otherwise returns
    /// `Asserter<Object.Element>` for chaining further tests.
    @discardableResult
    func asserterForFirstElement(
        message: @autoclosure () -> String = "No element in sequence passed the provided predicate.",
        file: StaticString = #file,
        line: UInt = #line,
        where predicate: (Object.Element) -> Bool
    ) -> Asserter<Object.Element>? {

        for element in object {
            if predicate(element) {
                return .init(object: element)
            }
        }

        return assertFailed(
            message: "asserterForFirstElement(where:) failed. \(message())",
            file: file,
            line: line
        )
    }

    /// Asserts that the underlying `Sequence` being tested contains at least one
    /// element that passes the given predicate.
    ///
    /// Returns `nil` if the test failed with no passing items, otherwise returns
    /// `self` for chaining further tests.
    @discardableResult
    func assertContains(
        message: @autoclosure () -> String = "No element in sequence passed the provided predicate.",
        file: StaticString = #file,
        line: UInt = #line,
        predicate: (Object.Element) -> Bool
    ) -> Self? {

        for element in object {
            if predicate(element) {
                return self
            }
        }

        return assertFailed(
            message: "assertContains(predicate:) failed. \(message())",
            file: file,
            line: line
        )
    }

    /// Asserts that the underlying `Sequence` being tested contains no elements
    /// that pass the given predicate.
    ///
    /// Returns `nil` if the test failed with at least one passing item, otherwise
    /// returns `self` for chaining further tests.
    @available(*, deprecated, renamed: "assertNoneSatisfy")
    @discardableResult
    func assertDoesNotContain(
        message: @autoclosure () -> String = "Found element that passed the provided predicate.",
        file: StaticString = #file,
        line: UInt = #line,
        predicate: (Object.Element) -> Bool
    ) -> Self? {

        return assertNoneSatisfy(
            message: message(),
            file: file,
            line: line,
            predicate: predicate
        )
    }

    /// Asserts that the underlying `Sequence` being tested has all of its elements
    /// pass a given predicate.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertAllSatisfy(
        message: @autoclosure () -> String = "Not all elements in sequence passed the provided predicate.",
        file: StaticString = #file,
        line: UInt = #line,
        predicate: (Object.Element) -> Bool
    ) -> Self? {

        for element in object {
            if !predicate(element) {
                return assertFailed(
                    message: "assertAllSatisfy(predicate:) failed. \(message())",
                    file: file,
                    line: line
                )
            }
        }

        return self
    }

    /// Asserts that the underlying `Sequence` being tested contains no elements
    /// that pass the given predicate.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertNoneSatisfy(
        message: @autoclosure () -> String = "Found element that passed the provided predicate.",
        file: StaticString = #file,
        line: UInt = #line,
        predicate: (Object.Element) -> Bool
    ) -> Self? {

        for element in object {
            if predicate(element) {
                return assertFailed(
                    message: "assertNoneSatisfy(predicate:) failed. \(message())",
                    file: file,
                    line: line
                )
            }
        }

        return self
    }
}
