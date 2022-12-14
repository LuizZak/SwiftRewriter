import ObjcGrammarModels

public extension Asserter where Object: ObjcASTNode {
    /// Asserts that the underlying `ObjcASTNode` being tested has a specified
    /// `isInNonnullContext` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isInNonnullContext inNonnullContext: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.isInNonnullContext, file: file, line: line) { prop in
            prop.assert(
                equals: inNonnullContext,
                message: "Expected node \(object.shortDescription) to have isInNonnullContext value of \(inNonnullContext)",
                file: file,
                line: line
            )
        }
    }
}
