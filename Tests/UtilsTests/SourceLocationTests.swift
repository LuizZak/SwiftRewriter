import XCTest

@testable import Utils

class SourceLocationTests: XCTestCase {
    func testLengthTo_singleLine() {
        let start = SourceLocation(
            line: 1,
            column: 1,
            utf8Offset: 0
        )
        let end = SourceLocation(
            line: 1,
            column: 8,
            utf8Offset: 12
        )

        let distance = start.length(to: end)

        XCTAssertEqual(distance, .init(
            newlines: 0,
            columnsAtLastLine: 7,
            utf8Length: 12
        ))
    }

    func testLengthTo_multiLine() {
        let start = SourceLocation(
            line: 1,
            column: 1,
            utf8Offset: 0
        )
        let end = SourceLocation(
            line: 2,
            column: 8,
            utf8Offset: 12
        )

        let distance = start.length(to: end)

        XCTAssertEqual(distance, .init(
            newlines: 1,
            columnsAtLastLine: 7,
            utf8Length: 12
        ))
    }

    func testAddLength() {
        let start = SourceLocation(
            line: 1,
            column: 1,
            utf8Offset: 0
        )
        let length = SourceLength(
            newlines: 1,
            columnsAtLastLine: 7,
            utf8Length: 12
        )

        let end = start + length

        XCTAssertEqual(end, .init(
            line: 2,
            column: 8,
            utf8Offset: 12
        ))
    }
}
