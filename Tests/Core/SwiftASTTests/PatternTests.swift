import XCTest

@testable import SwiftAST

class PatternTests: XCTestCase {
    func testSubPatternAt() {
        let pattern = SwiftAST.Pattern.tuple([
            .identifier("a"), .tuple([.identifier("b"), .identifier("c")]),
        ])

        XCTAssertEqual(pattern.subPattern(at: .self), pattern)
        XCTAssertEqual(
            pattern.subPattern(at: .tuple(index: 0, pattern: .self)),
            .identifier("a")
        )
        XCTAssertEqual(
            pattern.subPattern(at: .tuple(index: 1, pattern: .tuple(index: 0, pattern: .self))),
            .identifier("b")
        )
        XCTAssertEqual(
            pattern.subPattern(at: .tuple(index: 1, pattern: .tuple(index: 1, pattern: .self))),
            .identifier("c")
        )
    }

    func testFailedSubPatternAt() {
        let pattern = SwiftAST.Pattern.tuple([
            .identifier("a"), .tuple([.identifier("b"), .identifier("c")]),
        ])

        XCTAssertNil(
            pattern.subPattern(at: .tuple(index: 0, pattern: .tuple(index: 0, pattern: .self)))
        )
        XCTAssertNil(
            pattern.subPattern(at: .tuple(index: 1, pattern: .tuple(index: 3, pattern: .self)))
        )
    }
}
