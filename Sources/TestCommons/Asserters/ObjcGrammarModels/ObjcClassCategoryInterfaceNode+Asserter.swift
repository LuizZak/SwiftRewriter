import ObjcGrammarModels

public extension Asserter where Object == ObjcClassCategoryInterfaceNode {
    /// Asserts that the underlying `ObjcClassCategoryInterfaceNode` being tested
    /// has a given name identifier.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        identifier: String?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        self[\.identifier?.name]
            .assert(
                equals: identifier,
                file: file,
                line: line
            )
            .mapAsserter(self)
    }

    /// Asserts that the underlying `ObjcClassCategoryInterfaceNode` being tested
    /// has a given category name.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        categoryName: String?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        self[\.categoryName?.name]
            .assert(
                equals: categoryName,
                file: file,
                line: line
            )
            .mapAsserter(self)
    }

    /// Asserts that the underlying `ObjcClassCategoryInterfaceNode` being tested
    /// has a specified list of protocol names in its protocol list node.
    ///
    /// Test fails if `object.protocolList` is `nil`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        protocolListString: [String],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.protocolList, file: file, line: line) { list in
            list.assertNotNil(file: file, line: line)?
                .asserter(forKeyPath: \.protocols) { protocols in
                    let mapped = protocols.object.map(\.name)

                    return asserter(for: mapped) {
                        $0.assert(equals: protocolListString)
                    }
                }
        }
    }
}
