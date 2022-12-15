import XCTest
import SwiftAST
import Intentions

public extension Asserter where Object: MethodGenerationIntention {
    /// Asserts that the underlying `MethodGenerationIntention` object being
    /// tested has a specified name.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.name) {
            $0.assert(equals: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `FromSourceIntention` object being tested
    /// has a list of a preceding comments that match a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        precedingComments: [String],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        let converted = object.precedingComments.map(\.string)
        return asserter(for: converted) {
            $0.assert(equals: precedingComments, file: file, line: line)
        }.mapAsserter(self)
    }
}
