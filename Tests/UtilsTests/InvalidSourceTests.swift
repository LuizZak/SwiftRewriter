import XCTest

@testable import Utils

class SourceTests: XCTestCase {

    func testInvalidSourceIsEquatableToItself() {
        let inv1 = InvalidSource.invalid
        let inv2 = InvalidSource.invalid

        XCTAssert(inv1.isEqual(to: inv2))
    }

    func testInvalidSourceIsNotEquatableToOtherSources() {
        struct TestSource: Source {
            var filePath: String = ""

            var sourceRange: Range<String.UnicodeScalarView.Index> {
                InvalidSource.invalid.sourceRange
            }

            func stringIndex(forCharOffset offset: Int) -> String.Index {
                return "".startIndex
            }

            func charOffset(forStringIndex index: String.Index) -> Int {
                return 0
            }

            func utf8Index(forCharOffset offset: Int) -> Int {
                return 0
            }

            func isEqual(to other: Source) -> Bool {
                return other is TestSource
            }

            func lineNumber(at index: String.Index) -> Int {
                return 0
            }

            func columnNumber(at index: String.Index) -> Int {
                return 0
            }

            func substring(inCharRange range: Range<Int>) -> Substring? {
                return nil
            }
        }

        let sut = InvalidSource.invalid
        let other = TestSource()

        XCTAssertFalse(sut.isEqual(to: other))
    }

    func testInvalidSourceAlwaysReturnsZeroForLineAndColumnQueries() {
        let sut = InvalidSource.invalid
        let str = "abcd\nfghij"

        XCTAssertEqual(sut.columnNumber(at: str.startIndex), 0)
        XCTAssertEqual(sut.columnNumber(at: str.endIndex), 0)
        XCTAssertEqual(sut.lineNumber(at: str.startIndex), 0)
        XCTAssertEqual(sut.lineNumber(at: str.endIndex), 0)
    }

    func testInvalidSourceRange_doesNotCrash() {
        // Sanity check to make sure the range produced by `InvalidSource.sourceRange`
        // does not result in a runtime crash due to invalid ranges.
        let sut = InvalidSource.invalid

        _ = sut.sourceRange
    }
}
