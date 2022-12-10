import GrammarModels

public extension Asserter where Object: ASTNode {
    /// Asserts that the underlying `ASTNode` being tested has a specified
    /// `isInNonnullContext` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isInNonnullContext inNonnullContext: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.isInNonnullContext, file: file, line: line) { prop in
            prop.assert(
                equals: inNonnullContext,
                message: "Expected node \(object.shortDescription) to have isInNonnullContext value of \(inNonnullContext)",
                file: file,
                line: line
            )
        }
    }

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
                message: #"assertChildCount failed: expected \#(count) child(ren), found \#(object.children.count)."#,
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
                message: #"asserter(forChildAt: \#(index)) failed: node has less than \#(index + 1) child(ren)."#,
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
                message: #"asserter(forFirstChildOfType:) failed: No child of type ("\#(T.self)") found.."#,
                file: file,
                line: line
            )
        }

        closure(.init(object: child))

        return self
    }
}
