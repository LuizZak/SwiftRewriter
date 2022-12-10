import Utils
import GrammarModels

public extension Asserter where Object == ObjcComment {
    /// Asserts that the underlying `ObjcComment` being tested has a
    /// specified `string` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        string: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.string, file: file, line: line) {
            $0.assert(equals: string, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcComment` being tested has a
    /// specified `range` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        range: Range<String.Index>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.range, file: file, line: line) {
            $0.assert(equals: range, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcComment` being tested has a
    /// specified `location` value.
    ///
    /// The `ignoreUtf8Offset` parameter controls whether to ignore the
    /// `.utf8Offset` property during comparison and rely only on `.line` and
    /// `.column`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        location: SourceLocation,
        ignoreUtf8Offset: Bool = true,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.location, file: file, line: line) {
            $0.assert(
                equals: location,
                ignoreUtf8Offset: ignoreUtf8Offset,
                file: file,
                line: line
            )
        }
    }

    /// Asserts that the underlying `ObjcComment` being tested has a
    /// specified `length` value.
    ///
    /// The `ignoreUtf8Length` parameter controls whether to ignore the
    /// `.utf8Length` property during comparison and rely only on `.newlines` and
    /// `.columnsAtLastLine`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        length: SourceLength,
        ignoreUtf8Length: Bool = true,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.length, file: file, line: line) {
            $0.assert(
                equals: length,
                ignoreUtf8Length: true,
                file: file,
                line: line
            )
        }
    }
}
