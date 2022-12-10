import Utils
import GrammarModels

public extension Asserter where Object == ObjcStructDeclaration {
    /// Asserts that the underlying `ObjcStructDeclaration` being tested has an
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

    /// Asserts that the underlying `ObjcStructDeclaration` being tested has a
    /// specified count of children fields defined.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertFieldCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.body?.children, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assertCount(count, file: file, line: line)
        }
    }

    /// Opens an asserter context for the field on the underlying
    /// `ObjcStructDeclaration` object at a given index.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forFieldIndex index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ObjcStructField>) -> Void
    ) -> Self? {

        return asserter(forKeyPath: \.body?.fields, file: file, line: line) { fields in
            fields.assertNotNil(file: file, line: line)?[index]?.inClosure(closure)
        }
    }

    /// Opens an asserter context for the first field on the underlying
    /// `ObjcStructDeclaration` object that matches a given name.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forFieldName name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ObjcStructField>) -> Void
    ) -> Self? {

        return asserter(forKeyPath: \.body?.fields, file: file, line: line) { fields in
            fields
                .assertNotNil(file: file, line: line)?
                .asserterForFirstElement(
                    message: "Expected to find a field with name '\(name)' in struct declaration '\(object.identifier?.name ?? "<nil>")'.",
                    file: file,
                    line: line
                ) { field in
                    field.identifier?.name == name
                }?.inClosure(closure)
        }
    }
}
