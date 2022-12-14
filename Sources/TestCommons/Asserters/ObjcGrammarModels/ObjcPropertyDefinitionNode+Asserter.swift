import Utils
import ObjcGrammarModels

public extension Asserter where Object == ObjcPropertyDefinitionNode {
    /// Asserts that the underlying `ObjcPropertyDefinitionNode` being tested
    /// has a specified attribute list.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        attributesList: [ObjcPropertyAttributeNode.Attribute],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.attributesList, file: file, line: line) { attr in
            attr.assertNotNil()?
                .assert(attributesList: attributesList, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcPropertyDefinitionNode` being tested
    /// has a specified `isOptionalProperty` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isOptionalProperty: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.isOptionalProperty, file: file, line: line) {
            $0.assert(equals: isOptionalProperty, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcPropertyDefinitionNode` being tested
    /// has a specified `hasIbOutletSpecifier` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        hasIbOutletSpecifier: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.hasIbOutletSpecifier, file: file, line: line) {
            $0.assert(equals: hasIbOutletSpecifier, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcPropertyDefinitionNode` being tested
    /// has a specified `hasIbInspectableSpecifier` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        hasIbInspectableSpecifier: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.hasIbInspectableSpecifier, file: file, line: line) {
            $0.assert(equals: hasIbInspectableSpecifier, file: file, line: line)
        }
    }
}
