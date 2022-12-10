import Utils
import GrammarModels

public extension Asserter where Object == FunctionParameter {
    /// Asserts that the underlying `FunctionParameter` being tested has an
    /// identifier node with a specified `name` value.
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
            $0.assertNotNil(message: "Expected parameter to have identifier '\(name)', found nil", file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `FunctionParameter` being tested has no
    /// identifier node associated with it.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertNoName(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNil(message: "Expected parameter to have no identifier", file: file, line: line)
        }
    }

    /// Asserts that the underlying `FunctionParameter` being tested has a
    /// type node with a specified `type` value.
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
            $0.assertNotNil(message: "Expected parameter to have type '\(type)', found nil", file: file, line: line)?
                .assert(type: type, file: file, line: line)
        }
    }
}
