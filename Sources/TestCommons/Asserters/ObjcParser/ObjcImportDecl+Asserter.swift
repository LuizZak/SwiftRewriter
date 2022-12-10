import Utils
import ObjcParser

public extension Asserter where Object == ObjcImportDecl {
    /// Asserts that the underlying `ObjcImportDecl` being tested has a
    /// specified `path` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        path: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.path, file: file, line: line) {
            $0.assert(equals: path, file: file, line: line)
        }
    }

    /// Asserts that the underlying `isSystemImport` being tested has a
    /// specified `path` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isSystemImport: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.isSystemImport, file: file, line: line) {
            $0.assert(equals: isSystemImport, file: file, line: line)
        }
    }
}
