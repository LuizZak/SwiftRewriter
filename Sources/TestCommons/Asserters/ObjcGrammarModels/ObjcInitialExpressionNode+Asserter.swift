import Utils
import ObjcGrammarModels

public extension Asserter where Object == ObjcInitialExpressionNode {
    /// Asserts that the underlying `ObjcInitialExpressionNode` being tested has
    /// a parser rule expression that matches a specified string value exactly.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        expressionString: String,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(expressionString: expressionString, message: message(), file: file, line: line)
        }
    }
}
