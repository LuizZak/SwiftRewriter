import Utils
import ObjcGrammarModels

public extension Asserter where Object == ObjcPropertyImplementationNode {
    
    /// Asserts that the underlying `ObjcPropertyImplementationNode` being tested
    /// has a specified kind.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        kind: ObjcPropertyImplementationNode.Kind,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.kind, file: file, line: line) { sup in
            sup.assert(equals: kind, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcPropertyImplementationNode` being tested
    /// has a valid `ObjcPropertySynthesizeListNode` node with a list of
    /// synthesizations of `PropertySynthesizeItem`'s that have a matching list
    /// of `.propertyName` and `.instanceVarName` identifiers.
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
