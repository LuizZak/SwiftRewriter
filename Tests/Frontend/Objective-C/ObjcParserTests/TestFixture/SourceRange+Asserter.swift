import XCTest

import Utils

extension Asserter {
    /// Asserts that the underlying `SourceLocation` object being tested matches
    /// a given value.
    ///
    /// The `ignoreUtf8Offset` parameter controls whether to ignore the
    /// `.utf8Offset` property during comparison and rely only on `.line` and
    /// `.column`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        equals expected: SourceLocation?,
        ignoreUtf8Offset: Bool,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? where Object == SourceLocation? {
        
        guard ignoreUtf8Offset else {
            return assert(equals: expected, message: message(), file: file, line: line)
        }

        guard object?.line == expected?.line && object?.column == expected?.column else {
            XCTAssertEqual(object, expected, message(), file: file, line: line)
            dumpObject()

            return nil
        }

        return self
    }
}

extension Asserter where Object == SourceLocation {
    /// Asserts that the underlying `SourceLocation` object being tested matches
    /// a given value.
    ///
    /// The `ignoreUtf8Offset` parameter controls whether to ignore the
    /// `.utf8Offset` property during comparison and rely only on `.line` and
    /// `.column`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        equals expected: SourceLocation,
        ignoreUtf8Offset: Bool,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        guard ignoreUtf8Offset else {
            return assert(equals: expected, message: message(), file: file, line: line)
        }

        guard object.line == expected.line && object.column == expected.column else {
            XCTAssertEqual(object, expected, message(), file: file, line: line)
            dumpObject()

            return nil
        }

        return self
    }
}

extension Asserter where Object == SourceRange {
    /// Asserts that the underlying `SourceRange` object being tested has a
    /// `.start` property that matches a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        start expected: SourceLocation?,
        ignoreUtf8Offset: Bool = true,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.start, file: file, line: line) { start in
            start.assert(
                equals: expected,
                ignoreUtf8Offset: ignoreUtf8Offset,
                message: message(),
                file: file,
                line: line
            )
        }
    }

    /// Asserts that the underlying `SourceRange` object being tested has a
    /// `.end` property that matches a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        end expected: SourceLocation?,
        ignoreUtf8Offset: Bool = true,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.end, file: file, line: line) { start in
            start.assert(
                equals: expected,
                ignoreUtf8Offset: ignoreUtf8Offset,
                message: message(),
                file: file,
                line: line
            )
        }
    }
}

extension SourceLocation {
    init(line: Int, column: Int) {
        self.init(line: line, column: column, utf8Offset: 0)
    }
}
