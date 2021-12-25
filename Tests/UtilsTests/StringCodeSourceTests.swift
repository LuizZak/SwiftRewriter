import XCTest

@testable import Utils

class StringCodeSourceTests: XCTestCase {
    func testFetchSource() {
        let string = makeSutString()
        let sut = StringCodeSource(source: string, fileName: "test.file")

        XCTAssertEqual(sut.fetchSource(), string)
    }

    func testStringIndexForCharOffset() {
        let string = makeSutString()
        let sut = StringCodeSource(source: string, fileName: "test.file")

        let start = sut.stringIndex(forCharOffset: 0)
        let end = sut.stringIndex(forCharOffset: string.unicodeScalars.count - 1)

        XCTAssertEqual(start, Array(string.unicodeScalars.indices)[0])
        XCTAssertEqual(end, Array(string.unicodeScalars.indices).last)
    }

    func testCharOffsetForStringIndex() {
        let string = makeSutString()
        let sut = StringCodeSource(source: string, fileName: "test.file")

        let start = sut.charOffset(forStringIndex: string.unicodeScalars.indices.first!)
        let end = sut.charOffset(forStringIndex: string.unicodeScalars.indices.last!)

        XCTAssertEqual(start, 0)
        XCTAssertEqual(end, string.unicodeScalars.count - 1)
    }

    func testSourceRange() {
        let string = makeSutString()
        let sut = StringCodeSource(source: string, fileName: "test.file")

        XCTAssertEqual(sut.sourceRange, string.unicodeScalars.startIndex..<string.unicodeScalars.endIndex)
    }

    // MARK: - Test internals

    private func makeSut() -> StringCodeSource {
        StringCodeSource(
            source: makeSutString(),
            fileName: "test.file"
        )
    }

    private func makeSutString() -> String {
        """
        line 1
        Unicode characters áéã
        line 2
        
        last line
        """
    }
}
