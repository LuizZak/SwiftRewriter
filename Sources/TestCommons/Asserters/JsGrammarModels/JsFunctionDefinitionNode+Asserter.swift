import Utils
import GrammarModelBase
import JsGrammarModels

public extension Asserter where Object == JsFunctionDeclarationNode {
    /// Asserts that the underlying `JsFunctionDeclarationNode` being tested
    /// has an identifier node with a specified `name` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(message: "Expected function to have identifier '\(name)', found nil", file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `JsFunctionDeclarationNode` being tested has
    /// one or more variadic parameters, depending on the value of the provided
    /// `hasVariadicParameter`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        hasVariadicParameter: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        return asserter(forKeyPath: \.signature?.arguments, file: file, line: line) { parameterList -> Asserter<[JsFunctionArgument]>? in
            let parameterList = parameterList
                .assertNotNil(
                    message: "Expected function to have parameter list, found nil",
                    file: file,
                    line: line
                )
            
            if hasVariadicParameter {
                return parameterList?.assertContains(
                    message: "Expected function to have at least one variadic parameter, found none",
                    file: file,
                    line: line
                ) {
                    $0.isVariadic
                }
            } else {
                return parameterList?.assertDoesNotContain(
                    message: "Expected function to have no variadic parameter, found one",
                    file: file,
                    line: line
                ) {
                    $0.isVariadic
                }
            }
        }
    }

    /// Asserts that the underlying `JsFunctionDeclarationNode` being tested
    /// has a parameter list with a specified count of parameters.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertParameterCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.signature?.arguments, file: file, line: line) {
            $0.assertNotNil(message: "Expected function to have parameter list, found nil", file: file, line: line)?
                .assertCount(count, file: file, line: line)
        }
    }

    /// Opens an asserter context for a specified parameter node index on the
    /// underlying `JsFunctionDeclarationNode` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forParameterAt index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<JsFunctionArgument>) -> Void
    ) -> Self? {

        guard let signature = object.signature else {
            return assertFailed(
                message: #"asserter(forParameterAt:) failed: `signature` node is nil."#,
                file: file,
                line: line
            )
        }
        guard signature.arguments.count > index else {
            return assertFailed(
                message: #"asserter(forParameterAt: \#(index)) failed: parameter list has less than \#(index + 1) parameter(s)."#,
                file: file,
                line: line
            )
        }

        closure(.init(object: signature.arguments[index]))

        return self
    }

    /// Asserts that the underlying `JsFunctionDeclarationNode` being tested
    /// has a function body.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertHasBody(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.body?.body, file: file, line: line) { stmt in
            stmt.assertNotNil(
                message: "Expected function definition to have a body.",
                file: file,
                line: line
            )
        }
    }

    /// Asserts that the underlying `JsFunctionDeclarationNode` being tested
    /// has no function body associated with it.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertHasNoBody(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.body?.body, file: file, line: line) { stmt in
            stmt.assertNil(
                message: "Expected function definition to have no body.",
                file: file,
                line: line
            )
        }
    }

    /// Asserts that the underlying `JsFunctionDeclarationNode` object being
    /// tested has a body with a given list of body comments.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        comments: [RawCodeComment],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.body) { body in
            body.assertNotNil(
                message: "Expected function body",
                file: file,
                line: line
            )?.assert(comments: comments, file: file, line: line)
        }
    }

    /// Asserts that the underlying `JsFunctionDeclarationNode` object being
    /// tested has a body with a given list of body comments
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        commentStrings: [String],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.body) { body in
            body.assertNotNil(
                message: "Expected function body",
                file: file,
                line: line
            )?.assert(commentStrings: commentStrings, file: file, line: line)
        }
    }
}
