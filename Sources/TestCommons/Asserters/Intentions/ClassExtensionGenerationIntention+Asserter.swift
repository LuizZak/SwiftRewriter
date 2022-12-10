import Intentions

public extension Asserter where Object: ClassExtensionGenerationIntention {
    
    /// Asserts that the underlying `ClassExtensionGenerationIntention` being
    /// tested has a category name.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        categoryName: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.categoryName) {
            $0.assert(equals: categoryName, file: file, line: line)
        }
    }
}
