import Utils
import ObjcGrammarModels

public extension Asserter where Object == ObjcTypeNameNode {
    /// Asserts that the underlying `ObjcTypeNameNode` being tested has the
    /// specified `type` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        type: ObjcType,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.type, file: file, line: line) {
            $0.assert(equals: type, message: message(), file: file, line: line)
        }
    }
}
