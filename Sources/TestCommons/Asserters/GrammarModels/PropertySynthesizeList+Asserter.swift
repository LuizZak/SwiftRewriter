import Utils
import GrammarModels

public extension Asserter where Object == PropertySynthesizeList {
    
    /// Asserts that the underlying `PropertySynthesizeList` being tested has a
    /// list of `PropertySynthesizeItem` nodes that have a matching list of
    /// `.propertyName` and `.instanceVarName` identifiers.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        propertySynthesizeList: [(propertyName: String?, instanceVarName: String?)],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        let synthesized = object.synthesizations.map {
            ($0.propertyName?.name, $0.instanceVarName?.name)
        }

        return asserter(for: synthesized) { synthesized in
            synthesized.assert(
                elementsEqualStrict: propertySynthesizeList,
                file: file,
                line: line,
                by: ==
            )
        }.map(self)
    }
}
