import Utils
import ObjcGrammarModels

public extension Asserter where Object == ObjcStructFieldNode {
    /// Asserts that the underlying `ObjcStructFieldNode` being tested has an 
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
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcStructFieldNode` being tested has a type
    /// node with a specified `type` value.
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

    /// Asserts that the underlying `ObjcStructFieldNode` being tested has an
    /// expression node with a parser rule expression that matches a
    /// specified string value exactly.
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
            forKeyPath: \.expression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(expressionString: expressionString, file: file, line: line)
        }
    }
}
