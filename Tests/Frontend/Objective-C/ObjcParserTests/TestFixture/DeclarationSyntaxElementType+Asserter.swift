import XCTest

import ObjcParser
import Utils

extension Asserter where Object: DeclarationSyntaxElementType {
    /// Asserts that the underlying `DeclarationSyntaxElementType` being tested
    /// has a given source range
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        sourceRange: SourceRange,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.sourceRange, file: file, line: line) { asserter in
            asserter.assert(equals: sourceRange, file: file, line: line)
        }
    }
}

extension Asserter where Object == ExpressionSyntax {
    /// Asserts that the underlying `ExpressionSyntax` object being tested has
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
        
        asserter(forKeyPath: \.expressionString, file: file, line: line) { asserter in
            asserter.assert(equals: expected, message: message(), file: file, line: line)
        }
    }
}

extension Asserter where Object == ConstantExpressionSyntax {
    /// Asserts that the underlying `ConstantExpressionSyntax` object being tested
    /// has a textual value from the underlying source code that matches a given
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
        
        asserter(forKeyPath: \.constantExpressionString, file: file, line: line) { asserter in
            asserter.assert(equals: expected, message: message(), file: file, line: line)
        }
    }
}

extension Asserter where Object == InitializerSyntax {
    /// Asserts that the underlying `InitializerSyntax` object being tested has
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
        
        switch object {
        case .expression(let exp):
            return inClosure { object in
                Asserter<_>(object: exp)
                    .assert(textEquals: expected, message: message(), file: file, line: line)
            }
        }
    }
}
