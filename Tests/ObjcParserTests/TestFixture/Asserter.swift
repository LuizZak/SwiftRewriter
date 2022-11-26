/// Scaffolding object used by test fixtures to create DSL testing utilities
/// for common testing procedures.
struct Asserter<Object> {
    /// The object that is being tested upon.
    var object: Object

    func dumpObject(maxDepth: Int = 3) {
        var buffer = ""
        dump(object, to: &buffer, maxDepth: maxDepth)

        print("Result state: \(buffer)")
    }
}
