import Utils
import GrammarModels

public extension Asserter where Object == ObjcEnumDeclaration {
    /// Asserts that the underlying `ObjcEnumDeclaration` being tested has an
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

    /// Asserts that the underlying `ObjcEnumDeclaration` being tested has a
    /// specified count of children fields defined.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertEnumeratorCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.cases, file: file, line: line) {
            $0.assertCount(count, file: file, line: line)
        }
    }

    /// Opens an asserter context for the first field on the underlying
    /// `ObjcEnumDeclaration` object that matches a given name.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forEnumeratorName name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ObjcEnumCase>) -> Void
    ) -> Self? {

        guard let field = object.cases.first(where: { $0.identifier?.name == name }) else {
            return assertFailed(
                message: #"asserter(forEnumeratorName:) failed: No enumerator named "\#(name)" found."#,
                file: file,
                line: line
            )
        }

        closure(.init(object: field))

        return self
    }

    /// Asserts that the underlying `ObjcEnumDeclaration` being tested has a
    /// type name node with a specified type.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        typeName: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.type, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(type: typeName, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcEnumDeclaration` being tested has no
    /// type name node specified.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertNoTypeName(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.type, file: file, line: line) {
            $0.assertNil(file: file, line: line)
        }
    }
}
