import Utils
import GrammarModels

public extension Asserter where Object == PropertyAttributesList {
    /// Asserts that the underlying `PropertyAttributesList` being tested has a
    /// specified attribute list.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        attributesList: [PropertyAttributeNode.Attribute],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.attributes, file: file, line: line) { attr in
            let actual = attr.object.map(\.attribute)

            return asserter(for: actual) { actual in
                actual.assert(equals: attributesList, file: file, line: line)
            }
        }
    }
}

