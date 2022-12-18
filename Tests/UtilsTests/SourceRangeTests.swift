import XCTest

@testable import Utils

class SourceRangeTests: XCTestCase {
    func testUnion() {
        let range1 = SourceRange.range(
            start: .init(line: 1, column: 1, utf8Offset: 0),
            end: .init(line: 1, column: 2, utf8Offset: 1)
        )
        let range2 = SourceRange.range(
            start: .init(line: 2, column: 3, utf8Offset: 10),
            end: .init(line: 2, column: 5, utf8Offset: 12)
        )
        let expected = (
            start: SourceLocation(
                line: 1,
                column: 1,
                utf8Offset: 0
            ),
            end: SourceLocation(
                line: 2,
                column: 5,
                utf8Offset: 12
            )
        )
        
        let result = range1.union(with: range2)

        switch result {
        case .range(let start, let end) where (start, end) == expected:
            // Success!
            break
        default:
            XCTFail("Failed to receive expected range \(expected), received \(result) instead.")
        }
    }

    func testUnion_withLineGap() {
        let range1 = SourceRange.range(
            start: .init(line: 1, column: 1, utf8Offset: 0),
            end: .init(line: 2, column: 3, utf8Offset: 8)
        )
        let range2 = SourceRange.range(
            start: .init(line: 5, column: 3, utf8Offset: 28),
            end: .init(line: 6, column: 5, utf8Offset: 35)
        )
        let expected = (
            start: SourceLocation(
                line: 1,
                column: 1,
                utf8Offset: 0
            ),
            end: SourceLocation(
                line: 6,
                column: 5,
                utf8Offset: 35
            )
        )
        
        let result = range1.union(with: range2)

        switch result {
        case .range(let start, let end) where (start, end) == expected:
            // Success!
            break
        default:
            XCTFail("Failed to receive expected range \(expected), received \(result) instead.")
        }
    }

    func testUnionOutOrOrder() {
        let range1 = SourceRange.range(
            start: .init(line: 2, column: 3, utf8Offset: 10),
            end: .init(line: 2, column: 5, utf8Offset: 12)
        )
        let range2 = SourceRange.range(
            start: .init(line: 1, column: 1, utf8Offset: 0),
            end: .init(line: 1, column: 2, utf8Offset: 1)
        )
        let expected = (
            start: SourceLocation(
                line: 1,
                column: 1,
                utf8Offset: 0
            ),
            end: SourceLocation(
                line: 2,
                column: 5,
                utf8Offset: 12
            )
        )
        
        let result = range1.union(with: range2)

        switch result {
        case .range(let start, let end) where (start, end) == expected:
            // Success!
            break
        default:
            XCTFail("Failed to receive expected range \(expected), received \(result) instead.")
        }
    }

    func testUnionRangeWithLocation() {
        let range1 = SourceRange.location(.init(line: 1, column: 1, utf8Offset: 0))
        let range2 = SourceRange.range(
            start: .init(line: 2, column: 3, utf8Offset: 10),
            end: .init(line: 2, column: 5, utf8Offset: 12)
        )
        let expected = (
            start: SourceLocation(
                line: 1,
                column: 1,
                utf8Offset: 0
            ),
            end: SourceLocation(
                line: 2,
                column: 5,
                utf8Offset: 12
            )
        )
        
        let result = range1.union(with: range2)

        switch result {
        case .range(let start, let end) where (start, end) == expected:
            // Success!
            break
        default:
            XCTFail("Failed to receive expected range \(expected), received \(result) instead.")
        }
    }

    func testLocationWithLocation() {
        let range1 = SourceRange.location(.init(line: 1, column: 1, utf8Offset: 0))
        let range2 = SourceRange.location(.init(line: 2, column: 5, utf8Offset: 12))
        let expected = (
            start: SourceLocation(
                line: 1,
                column: 1,
                utf8Offset: 0
            ),
            end: SourceLocation(
                line: 2,
                column: 5,
                utf8Offset: 12
            )
        )
        
        let result = range1.union(with: range2)

        switch result {
        case .range(let start, let end) where (start, end) == expected:
            // Success!
            break
        default:
            XCTFail("Failed to receive expected range \(expected), received \(result) instead.")
        }
    }

    func testValidSubstringIn() {
        let string = "abcde"
        let range = SourceRange.range(
            start: .init(line: 1, column: 1, utf8Offset: 0),
            end: .init(line: 1, column: 3, utf8Offset: 2)
        )
        
        XCTAssertEqual(range.substring(in: string), "ab")
    }
    
    func testInvalidSubstringIn_invalidRange() {
        let string = "abcde"
        let range = SourceRange.invalid

        XCTAssertNil(range.substring(in: string))
    }
    
    func testInvalidSubstringIn_locationOnly() {
        let string = "abcde"
        let range = SourceRange.location(.init(line: 1, column: 1, utf8Offset: 0))
        
        XCTAssertNil(range.substring(in: string))
    }
    
    func testInvalidSubstringIn_outOfRange() {
        let string = "abcde"
        let range = SourceRange.range(
            start: .init(line: 1, column: 1, utf8Offset: 0),
            end: .init(line: 1, column: 15, utf8Offset: 15)
        )
        
        XCTAssertNil(range.substring(in: string))
    }
}
