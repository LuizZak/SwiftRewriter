import GrammarModelBase
import ObjcGrammarModels
import Utils

public extension Asserter where Object == ObjcMethodBodyNode {
    /// Asserts that the underlying `ObjcMethodBodyNode` object being tested
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

    /// Asserts that the underlying `ObjcMethodBodyNode` object being tested
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
        }.map(self)
    }
}
