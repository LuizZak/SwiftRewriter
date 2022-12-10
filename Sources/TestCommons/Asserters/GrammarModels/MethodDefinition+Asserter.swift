import Utils
import GrammarModels

public extension Asserter where Object == MethodDefinition {
    /// Asserts that the underlying `MethodDefinition` being tested has a
    /// return type node with a specified `type` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        returnType type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.returnType?.type, file: file, line: line) {
            $0.assertNotNil(
                message: "Expected method to have return type '\(type)', found nil",
                file: file,
                line: line
            )?
                .assert(type: type, file: file, line: line)
        }
    }

    /// Asserts that the underlying `MethodDefinition` being tested has a
    /// specified `isClassMethod` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isClassMethod: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.isClassMethod, file: file, line: line) { value in
            value.assert(equals: isClassMethod, file: file, line: line)
        }
    }

    /// Asserts that the underlying `MethodDefinition` being tested has a
    /// specified `isOptionalMethod` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isOptionalMethod: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.isOptionalMethod, file: file, line: line) { value in
            value.assert(equals: isOptionalMethod, file: file, line: line)
        }
    }

    /// Asserts that the underlying `MethodDefinition` being tested has a
    /// function body.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertHasBody(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.body?.statements, file: file, line: line) { stmt in
            stmt.assertNotNil(
                message: "Expected method definition to have a body.",
                file: file,
                line: line
            )
        }
    }

    /// Asserts that the underlying `MethodDefinition` being tested has no
    /// function body associated with it.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertHasNoBody(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.body?.statements, file: file, line: line) { stmt in
            stmt.assertNil(
                message: "Expected method definition to have no body.",
                file: file,
                line: line
            )
        }
    }
}
