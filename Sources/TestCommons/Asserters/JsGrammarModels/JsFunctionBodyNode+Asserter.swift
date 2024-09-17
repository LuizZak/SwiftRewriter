import Utils
import GrammarModelBase
import JsGrammarModels

public extension Asserter where Object == JsFunctionBodyNode {
    /// Asserts that the underlying `JsFunctionBodyNode` object being tested
    /// has a list of body comments that match a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        comments: [RawCodeComment],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.comments) {
            $0.assert(equals: comments, file: file, line: line)
        }
    }

    /// Asserts that the underlying `JsFunctionBodyNode` object being tested
    /// has a list of body comments that match a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        commentStrings: [String],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        let actual = object.comments.map(\.string)
        return asserter(for: actual) {
            $0.assert(equals: commentStrings, file: file, line: line)
        }.mapAsserter(self)
    }
}
