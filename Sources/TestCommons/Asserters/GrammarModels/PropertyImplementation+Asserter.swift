import Utils
import GrammarModels

public extension Asserter where Object == PropertyImplementation {
    
    /// Asserts that the underlying `PropertyImplementation` being tested has a
    /// specified kind.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        kind: PropertyImplementationKind,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.kind, file: file, line: line) { sup in
            sup.assert(equals: kind, file: file, line: line)
        }
    }

    /// Asserts that the underlying `PropertyImplementation` being tested has a
    /// valid `PropertySynthesizeList` node with a list of synthesizations of
    /// `PropertySynthesizeItem`'s that have a matching list of `.propertyName`
    /// and `.instanceVarName` identifiers.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        propertySynthesizeList: [(propertyName: String?, instanceVarName: String?)],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.list) { list in
            list.assertNotNil(
                message: "assert(propertySynthesizeList:) failed: No .list node present.",
                file: file,
                line: line
            )?.assert(
                propertySynthesizeList: propertySynthesizeList,
                file: file,
                line: line
            )
        }
    }
}
