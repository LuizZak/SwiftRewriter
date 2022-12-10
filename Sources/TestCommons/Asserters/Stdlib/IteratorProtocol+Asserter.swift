public extension Asserter where Object: IteratorProtocol {
    /// Opens an asserter context for the next item emitted by the underlying
    /// `IteratorProtocol` being tested.
    ///
    /// Returns `nil` if the end of the iterator has been reached already,
    /// otherwise returns a `self` copy with the mutated iterator for chaining
    /// further tests.
    @discardableResult
    func asserterForNext(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<Object.Element>) -> Void
    ) -> Self? {

        var iterator = object
        let next = iterator.next()
        guard let next = next else {
            return assertFailed(
                message: "asserterForNext failed: unexpected nil value.",
                file: file,
                line: line
            )
        }

        closure(.init(object: next))

        return .init(object: iterator)
    }

    /// Asserts that the underlying `IteratorProtocol` being tested returns no
    /// further items.
    ///
    /// Returns `nil` if the end of the iterator has not been reached yet,
    /// otherwise returns `self` for chaining further tests.
    @discardableResult
    func assertIsAtEnd(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        var iterator = object
        if let next = iterator.next() {
            return assertFailed(
                message: #"assertIsAtEnd failed: unexpected non-nil value: ("\#(next)")."#,
                file: file,
                line: line
            )
        }
        
        return self
    }
}
