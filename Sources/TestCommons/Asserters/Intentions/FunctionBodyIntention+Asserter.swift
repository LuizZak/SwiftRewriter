import Intentions
import SwiftAST

public extension Asserter where Object == FunctionBodyIntention {
    /// Asserts that the underlying `FunctionBodyIntention` being tested has a
    /// specified compound statement as a body.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        body: CompoundStatement,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.body) {
            $0.assert(equals: body, file: file, line: line)
        }
    }
}
