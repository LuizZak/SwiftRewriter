import Utils
import ObjcGrammarModels

public extension Asserter where Object == ObjcFunctionDefinitionNode {
    /// Asserts that the underlying `ObjcFunctionDefinitionNode` being tested
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

    /// Asserts that the underlying `ObjcFunctionDefinitionNode` being tested
    /// has a return type node with a specified `type` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        returnType type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.returnType, file: file, line: line) {
            $0.assertNotNil(message: "Expected function to have return type '\(type)', found nil", file: file, line: line)?
                .assert(type: type, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcFunctionDefinitionNode` being tested is
    /// variadic or not, depending on the value of the provided `isVariadic`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isVariadic: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        return asserter(forKeyPath: \.parameterList, file: file, line: line) { parameterList -> Asserter<ObjcParameterListNode>? in
            return parameterList
                .assertNotNil(message: "Expected function to have parameter list, found nil", file: file, line: line)?
                .asserter(forKeyPath: \.variadicParameter) { (vParam) -> Asserter<Bool>? in
                    Asserter<Bool>(object: vParam.object != nil)
                        .assert(equals: isVariadic, file: file, line: line)
                }
        }
    }

    /// Asserts that the underlying `ObjcFunctionDefinitionNode` being tested
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

        asserter(forKeyPath: \.parameterList, file: file, line: line) {
            $0.assertNotNil(message: "Expected function to have parameter list, found nil", file: file, line: line)?
                .asserter(forKeyPath: \.parameters) { parameters in
                    parameters.assertCount(count, file: file, line: line)
                }
        }
    }

    /// Opens an asserter context for a specified parameter node index on the
    /// underlying `ObjcFunctionDefinitionNode` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forParameterAt index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ObjcFunctionParameterNode>) -> Void
    ) -> Self? {

        guard let parameterList = object.parameterList else {
            return assertFailed(
                message: #"asserter(forParameterAt:) failed: `parameterList` node is nil."#,
                file: file,
                line: line
            )
        }
        guard parameterList.parameters.count > index else {
            return assertFailed(
                message: #"asserter(forParameterAt: \#(index)) failed: parameter list has less than \#(index + 1) parameter(s)."#,
                file: file,
                line: line
            )
        }

        closure(.init(object: parameterList.parameters[index]))

        return self
    }

    /// Asserts that the underlying `ObjcFunctionDefinitionNode` being tested
    /// has a function body.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertHasBody(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.methodBody?.statements, file: file, line: line) { stmt in
            stmt.assertNotNil(
                message: "Expected function definition to have a body.",
                file: file,
                line: line
            )
        }
    }

    /// Asserts that the underlying `ObjcFunctionDefinitionNode` being tested
    /// has no function body associated with it.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertHasNoBody(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.methodBody?.statements, file: file, line: line) { stmt in
            stmt.assertNil(
                message: "Expected function definition to have no body.",
                file: file,
                line: line
            )
        }
    }
}
