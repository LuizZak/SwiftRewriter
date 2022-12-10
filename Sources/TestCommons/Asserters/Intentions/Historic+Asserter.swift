import Intentions

public extension Asserter where Object: Historic {
    /// Asserts that the underlying `Historic` object being tested has a specified
    /// `history.summary` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        historySummary: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.history.summary, file: file, line: line) { summary in
            summary.assert(equals: historySummary, file: file, line: line)
        }
    }
    
    /// Asserts that the underlying `Historic` object being tested has an empty
    /// list of entries.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsHistoryEmpty(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.history.entries, file: file, line: line) { entries in
            entries.assertIsEmpty(file: file, line: line)
        }
    }
}
