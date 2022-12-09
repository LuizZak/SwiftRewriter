public extension Asserter where Object: Collection, Object.Index == Int {
    /// Returns an asserter for the object at a given index in the underlying
    /// `Collection` being tested, asserting that the collection can has an index
    /// of `index`.
    ///
    /// Returns `nil` if the index is not available in the collection, otherwise
    /// returns `Asserter<Object.Element>` for chaining further tests.
    subscript(
        index: Object.Index,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<Object.Element>? {
        
        guard object.count > index else {
            return assertFailed(
                message: #"subscript[\#(index)] failed: collection has less than \#(index) item(s)."#,
                file: file,
                line: line
            )
        }

        return .init(object: object[index])
    }
}
