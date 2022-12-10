import Utils
import ObjcGrammarModels

public extension Asserter where Object == ObjcVariableDeclarationNode {
    /// Asserts that the underlying `ObjcVariableDeclarationNode` being tested 
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
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcVariableDeclarationNode` being tested 
    /// has a type node with a specified `type` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.type, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(type: type, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcVariableDeclarationNode` being tested 
    /// has an initial expression node with a parser rule expression that matches
    /// a specified string value exactly.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        expressionString: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(
            forKeyPath: \.initialExpression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(expressionString: expressionString, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcVariableDeclarationNode` being tested 
    /// has a specified `isStatic` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isStatic: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(
            forKeyPath: \.isStatic,
            file: file,
            line: line
        ) {
            $0.assert(
                equals: isStatic,
                message: "Expected variable '\(object.identifier?.name ?? "<nil>").isStatic' to be \(isStatic).",
                file: file,
                line: line
            )
        }
    }

    /// Asserts that the underlying `ObjcVariableDeclarationNode` being tested 
    /// has no initial value expression associated with it.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertNoInitializer(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(
            forKeyPath: \.initialExpression,
            file: file,
            line: line
        ) {
            $0.assertNil(
                message: "Expected variable '\(object.identifier?.name ?? "<nil>")' to have no initializer.",
                file: file,
                line: line
            )
        }
    }
}
