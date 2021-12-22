import GrammarModelBase
import Utils
import XCTest

@testable import ObjcParser

class ObjcLexerTests: XCTestCase {
    func testStartRange() {
        let source = "@end abc def"
        let sut = makeLexer(source)

        let range = sut.startRange()

        XCTAssertEqual(range.makeString(), "")
        XCTAssertEqual(range.makeLocation().line, 1)
        XCTAssertEqual(range.makeLocation().column, 1)
    }

    func testStartRangeAfterInvokingToken() {
        let source = "@end abc def"
        let sut = makeLexer(source)

        _ = sut.token()
        let range = sut.startRange()

        XCTAssertEqual(range.makeString(), "")
        XCTAssertEqual(range.makeLocation().line, 1)
        XCTAssertEqual(range.makeLocation().column, 1)
    }

    func testStartRangeNextToken() {
        let source = "@end abc def"
        let sut = makeLexer(source)

        let range = sut.startRange()
        _ = sut.nextToken()
        let rangeNext = sut.startRange()

        XCTAssertEqual(range.makeString(), "@end")
        XCTAssertEqual(rangeNext.makeLocation().line, 1)
        XCTAssertEqual(rangeNext.makeLocation().column, 6)
    }

    func testStartRangeSkippingToken() {
        let source = "@end abc def"
        let sut = makeLexer(source)

        let range = sut.startRange()
        sut.skipToken()
        let nextRange = sut.startRange()

        XCTAssertEqual(range.makeString(), "@end")
        XCTAssertEqual(nextRange.makeLocation().line, 1)
        XCTAssertEqual(nextRange.makeLocation().column, 6)
    }

    func testStartRangeSkippingTokenAfterConsumingToken() {
        let source = "@end abc def"
        let sut = makeLexer(source)

        _ = sut.token()  // Consume a token to force-parse it
        let range = sut.startRange()
        sut.skipToken()
        let nextRange = sut.startRange()

        XCTAssertEqual(range.makeString(), "@end")
        XCTAssertEqual(nextRange.makeLocation().line, 1)
        XCTAssertEqual(nextRange.makeLocation().column, 6)
    }

    private func makeLexer(_ str: String) -> ObjcLexer {
        let src = StringCodeSource(source: str)
        return ObjcLexer(source: src)
    }
}
