import GrammarModelBase
import Utils

public extension Asserter where Object: ASTNode {
    /// Asserts that the underlying `ASTNode` being tested has a specified count
    /// of children nodes.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertChildCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        guard object.children.count == count else {
            return assertFailed(
                message: "assertChildCount(_:) failed: Expected node '\(object.shortDescription)' to have \(count) child(ren) but found \(object.children.count).",
                file: file,
                line: line
            )
        }

        return self
    }

    /// Opens an asserter context for a child node on the underlying `ASTNode`
    /// being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forChildAt index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ASTNode>) -> Void
    ) -> Self? {

        guard object.children.count > index else {
            return assertFailed(
                message: "asserter(forChildAt:) failed: Expected node '\(object.shortDescription)' to have at least \(index) child(ren) but found \(object.children.count).",
                file: file,
                line: line
            )
        }

        closure(.init(object: object.children[index]))

        return self
    }

    /// Opens an asserter context for the first child on the underlying `ASTNode`
    /// being tested that is of a given type.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<T: ASTNode>(
        forFirstChildOfType type: T.Type,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<T>) -> Void = { _ in }
    ) -> Self? {

        guard let child: T = object.firstChild() else {
            return assertFailed(
                message: "asserter(forFirstChildOfType:) failed: Expected node '\(object.shortDescription)' to have at least one \(T.self)-typed child.",
                file: file,
                line: line
            )
        }

        closure(.init(object: child))

        return self
    }

    /// Asserts that the underlying `ASTNode` object being tested has a list of
    /// preceding comments that match a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        precedingComments: [RawCodeComment],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.precedingComments) {
            $0.assert(equals: precedingComments, file: file, line: line)
        }
    }

    /// Asserts that the underlying `FromSourceIntention` object being tested
    /// has a list of a preceding comments that match a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        precedingCommentStrings: [String],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        let actual = object.precedingComments.map(\.string)
        return asserter(for: actual) {
            $0.assert(equals: precedingCommentStrings, file: file, line: line)
        }.mapAsserter(self)
    }

    /// Asserts that the underlying `FromSourceIntention` object being tested
    /// has a source range that matches a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        sourceRange: SourceRange,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        self[\.sourceRange].assert(
            equals: sourceRange,
            file: file,
            line: line
        )
        .mapAsserter(self)
    }

    /// Asserts that the underlying `FromSourceIntention` object being tested
    /// has a `.location` value that is not `SourceLocation.invalid`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsLocationValid(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        self[\.location].assert(
            notEquals: .invalid,
            file: file,
            line: line
        )
        .mapAsserter(self)
    }
}
