import XCTest

import GrammarModels

public extension Asserter where Object == SourceRange {
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

public extension Asserter where Object == SourceLocation {
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
            return assertFailed(
                message: #"assert(equals:) failed: ("\#(object)") != ("\#(expected)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
}

public extension Asserter where Object == SourceLength {
    /// Asserts that the underlying `SourceLength` object being tested matches
    /// a given value.
    ///
    /// The `ignoreUtf8Length` parameter controls whether to ignore the
    /// `.utf8Length` property during comparison and rely only on `.newlines` and
    /// `.columnsAtLastLine`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        equals expected: SourceLength,
        ignoreUtf8Length: Bool,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        guard ignoreUtf8Length else {
            return assert(equals: expected, message: message(), file: file, line: line)
        }

        guard object.newlines == expected.newlines && object.columnsAtLastLine == expected.columnsAtLastLine else {
            return assertFailed(
                message: #"assert(equals:) failed: ("\#(object)") != ("\#(expected)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
}

public extension Asserter {
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
            return assertFailed(
                message: #"assert(equals:) failed: ("\#(object as Any)") != ("\#(expected as Any)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }

    /// Asserts that the underlying `SourceLength` object being tested matches
    /// a given value.
    ///
    /// The `ignoreUtf8Length` parameter controls whether to ignore the
    /// `.utf8Length` property during comparison and rely only on `.newlines` and
    /// `.columnsAtLastLine`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        equals expected: SourceLength?,
        ignoreUtf8Length: Bool,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? where Object == SourceLength? {
        
        guard ignoreUtf8Length else {
            return assert(equals: expected, message: message(), file: file, line: line)
        }

        guard object?.newlines == expected?.newlines && object?.columnsAtLastLine == expected?.columnsAtLastLine else {
            return assertFailed(
                message: #"assert(equals:) failed: ("\#(object as Any)") != ("\#(expected as Any)"). \#(message())"#,
                file: file,
                line: line
            )
        }

        return self
    }
}

public extension SourceLocation {
    /// Helper initializer provided for tests to ignore `utf8Offset` values during
    /// assertions with an `Asserter<T>`.
    init(line: Int, column: Int) {
        self.init(line: line, column: column, utf8Offset: 0)
    }
}

public extension SourceLength {
    /// Helper initializer provided for tests to ignore `utf8Length` values during
    /// assertions with an `Asserter<T>`.
    init(newlines: Int, columnsAtLastLine: Int) {
        self.init(newlines: newlines, columnsAtLastLine: columnsAtLastLine, utf8Length: 0)
    }
}
