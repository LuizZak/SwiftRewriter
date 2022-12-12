import Utils
import JsGrammarModels

public extension Asserter where Object: JsIdentifierNode {
    /// Asserts that the underlying `JsIdentifierNode` being tested has the
    /// specified `name` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.name, file: file, line: line) {
            $0.assert(equals: name, message: message(), file: file, line: line)
        }
    }
}
