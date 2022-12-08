import XCTest
import Antlr4

extension Asserter where Object: ParserRuleContext {
    /// Asserts that the underlying `ParserRuleContext` object being tested has
    /// a textual value from the underlying source code that matches a given
    /// string.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        textEquals expected: String,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        let text = object.getText()
        guard text == expected else {
            XCTAssertEqual(text, expected, message(), file: file, line: line)
            dumpObject()

            return nil
        }

        return self
    }
}
