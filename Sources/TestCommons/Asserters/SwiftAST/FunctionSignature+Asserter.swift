import SwiftAST

public extension Asserter where Object == FunctionSignature {
    /// Asserts that the underlying `FunctionSignature` being tested has a
    /// specified return type.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        returnType: SwiftType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.returnType) {
            $0.assert(equals: returnType, file: file, line: line)
        }
    }

    /// Asserts that the underlying `FunctionSignature` being tested has a
    /// specified name.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.name) {
            $0.assert(equals: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `FunctionSignature` being tested has a
    /// specified `isMutating` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isMutating: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.isMutating) {
            $0.assert(equals: isMutating, file: file, line: line)
        }
    }

    /// Asserts that the underlying `FunctionSignature` being tested has a
    /// specified `isStatic` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isStatic: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.isStatic) {
            $0.assert(equals: isStatic, file: file, line: line)
        }
    }

    /// Asserts that the underlying `FunctionSignature` being tested has a parameter
    /// list with a specified count of parameters.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertParameterCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.parameters) { parameters in
            parameters.assertCount(count, file: file, line: line)
        }
    }

    /// Opens an asserter context for a specified parameter node index on the
    /// underlying `FunctionSignature` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forParameterAt index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ParameterSignature>) -> Result?
    ) -> Self? {

        guard object.parameters.count > index else {
            return assertFailed(
                message: #"asserter(forParameterAt: \#(index)) failed: parameter list has less than \#(index + 1) parameter(s)."#,
                file: file,
                line: line
            )
        }

        return asserter(for: object.parameters[index]) { param in
            param.inClosure(closure)
        }.map(self)
    }
}
