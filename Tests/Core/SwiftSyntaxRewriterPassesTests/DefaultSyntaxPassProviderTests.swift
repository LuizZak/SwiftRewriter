import SwiftSyntaxRewriterPasses
import XCTest

class DefaultSyntaxPassProviderTests: XCTestCase {

    func testDefaultSyntaxPasses() {
        let passes = DefaultSyntaxPassProvider().passes

        // Using iterator so we can test ordering without indexing into array
        // (could crash and abort tests halfway through)
        var passesIterator = passes.makeIterator()

        XCTAssert(passesIterator.next() is StatementSpacingSyntaxPass)
        XCTAssertNil(passesIterator.next())
    }
}
