import Utils
import GrammarModels

public extension Asserter where Object == ExpressionNode {
    /// Asserts that the underlying `ExpressionNode` being tested has a
    /// parser rule expression that matches a specified string value exactly.
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

        return asserter(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) { asserter in

            asserter.assertNotNil(file: file, line: line)?.inClosure { asserter -> Any? in
                switch asserter.object {
                case .antlr(let ctx):
                    return Asserter<_>(object: ctx)
                        .assert(textEquals: expressionString, file: file, line: line)
                case .string(let str):
                    return Asserter<_>(object: str)
                        .assert(equals: expressionString, file: file, line: line)
                }
            }
        }
    }
}
