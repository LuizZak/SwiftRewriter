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

    func testUtf8IndexForCharOffset_unicode() {
        let string = """
            ©áéã unicode
            """
        let sut = StringCodeSource(source: string, fileName: "test.file")

        let result = sut.utf8Index(forCharOffset: 5)

        XCTAssertEqual(result, 9)
    }

    func testUtf8IndexForCharOffset_nonUnicode() {
        let string = """
            1234 non unicode
            """
        let sut = StringCodeSource(source: string, fileName: "test.file")

        let result = sut.utf8Index(forCharOffset: 5)

        XCTAssertEqual(result, 5)
    }

    func testSourceSubstring_unicode() {
        let string = makeSutString()
        let sut = StringCodeSource(source: string, fileName: "test.file")
        let sourceRange = SourceRange(
            forStart: .init(
                line: 2,
                column: 1,
                utf8Offset: 7
            ),
            end: .init(
                line: 2,
                column: 24,
                utf8Offset: 34
            )
        )

        let result = sut.sourceSubstring(sourceRange)

        XCTAssertEqual(result, "Unicode characters ©áéã")
    }

    func testSourceSubstring_nonUnicode() {
        let string = makeSutString_noUnicode()
        let sut = StringCodeSource(source: string, fileName: "test.file")
        let sourceRange = SourceRange(
            forStart: .init(
                line: 2,
                column: 1,
                utf8Offset: 7
            ),
            end: .init(
                line: 2,
                column: 24,
                utf8Offset: 30
            )
        )

        let result = sut.sourceSubstring(sourceRange)

        XCTAssertEqual(result, "Non uni characters 1234")
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
        Unicode characters ©áéã
        line 2
        
        last line
        """
    }

    private func makeSutString_noUnicode() -> String {
        """
        line 1
        Non uni characters 1234
        line 2
        
        last line
        """
    }
}
