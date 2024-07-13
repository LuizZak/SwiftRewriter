import XCTest
import SwiftAST
import Intentions

public extension Asserter where Object: FromSourceIntention {
    /// Asserts that the underlying `FromSourceIntention` object being tested
    /// has an access level of a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        accessLevel: AccessLevel,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.accessLevel) {
            $0.assert(equals: accessLevel, file: file, line: line)
        }
    }

    /// Asserts that the underlying `FromSourceIntention` object being tested
    /// has a list of preceding comments that match a specified value.
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
