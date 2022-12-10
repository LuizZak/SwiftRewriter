import GrammarModels

public extension Asserter where Object == ObjcClassInterface {
    /// Asserts that the underlying `ObjcClassInterface` being tested has a
    /// specified super class name.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        superclassName: String?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.superclass?.name, file: file, line: line) { sup in
            sup.assert(equals: superclassName, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcClassInterface` being tested has a
    /// specified list of protocol names in its protocol list node.
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
