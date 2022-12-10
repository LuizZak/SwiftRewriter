import XCTest

@testable import Utils

class StringTests: XCTestCase {
    func testStartsUppercased() {
        XCTAssert("Abc".startsUppercased)
        XCTAssert("A".startsUppercased)
        XCTAssertFalse("abc".startsUppercased)
        XCTAssertFalse("a".startsUppercased)
        XCTAssertFalse("0".startsUppercased)
        XCTAssertFalse(" ".startsUppercased)
        XCTAssertFalse("".startsUppercased)
    }

    func testLowercasedFirstLetter() {
        XCTAssertEqual("a", "A".lowercasedFirstLetter)
        XCTAssertEqual("abc", "Abc".lowercasedFirstLetter)
        XCTAssertEqual("abc", "abc".lowercasedFirstLetter)
        XCTAssertEqual("ábc", "Ábc".lowercasedFirstLetter)
        XCTAssertEqual("aBC", "ABC".lowercasedFirstLetter)
        XCTAssertEqual("aBc", "aBc".lowercasedFirstLetter)
        XCTAssertEqual("ábC", "ÁbC".lowercasedFirstLetter)
        XCTAssertEqual("0", "0".lowercasedFirstLetter)
        XCTAssertEqual("", "".lowercasedFirstLetter)
        XCTAssertEqual(" ", " ".lowercasedFirstLetter)
    }

    func testUppercasedFirstLetter() {
        XCTAssertEqual("A", "a".uppercasedFirstLetter)
        XCTAssertEqual("Abc", "abc".uppercasedFirstLetter)
        XCTAssertEqual("Abc", "Abc".uppercasedFirstLetter)
        XCTAssertEqual("Ábc", "ábc".uppercasedFirstLetter)
        XCTAssertEqual("ABC", "aBC".uppercasedFirstLetter)
        XCTAssertEqual("ABc", "ABc".uppercasedFirstLetter)
        XCTAssertEqual("ÁbC", "ábC".uppercasedFirstLetter)
        XCTAssertEqual("0", "0".uppercasedFirstLetter)
        XCTAssertEqual("", "".uppercasedFirstLetter)
        XCTAssertEqual(" ", " ".uppercasedFirstLetter)
    }

    func testMakeDifference() {
        let str1 = """
            Abcdef
            """
        let str2 = """
            Abdef
            """

        let result = str1.makeDifferenceMarkString(against: str2)

        XCTAssertEqual(
            """
            Abcdef
            ~~^ Difference starts here
            """,
            result
        )
    }

    func testMakeDifferenceBetweenLines() {
        let str1 = """
            Abc
            Def
            Ghi
            """
        let str2 = """
            Abc
            Df
            Ghi
            """

        let result = str1.makeDifferenceMarkString(against: str2)

        XCTAssertEqual(
            """
            Abc
            Def
            ~^ Difference starts here
            Ghi
            """,
            result
        )
    }

    func testMakeDifferenceBetweenEqualStrings() {
        let str1 = """
            Abc
            Def
            Ghi
            """
        let str2 = """
            Abc
            Def
            Ghi
            """

        let result = str1.makeDifferenceMarkString(against: str2)

        XCTAssertEqual(
            """
            Abc
            Def
            Ghi
             ~ Strings are equal.
            """,
            result
        )
    }

    func testMakeDifferenceBetweenStringsAtBeginning() {
        let str1 = """
            Abc
            """
        let str2 = """
            Zwx
            """

        let result = str1.makeDifferenceMarkString(against: str2)

        XCTAssertEqual(
            """
            Abc
            ^ Difference starts here
            """,
            result
        )
    }

    func testCommentSectionRangesInEmptyString() {
        let ranges = "".cStyleCommentSectionRanges()
        XCTAssertEqual(ranges.count, 0)
    }

    func testCommentSectionRanges() {
        let input = """
            // A comment!
            Not a comment.
            /*
                A multi-lined comment!
            */
            Not a comment again.
            """

        let ranges = input.cStyleCommentSectionRanges()
        XCTAssertEqual(ranges.count, 2)
        XCTAssertEqual(ranges[0], input.range(of: "// A comment!\n"))
        XCTAssertEqual(
            ranges[1],
            input.range(
                of: """
                    /*
                        A multi-lined comment!
                    */
                    """
            )
        )
    }

    func testCommentSectionRangesEntireString() {
        let input = "// A comment!"

        let ranges = input.cStyleCommentSectionRanges()
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0], input.startIndex..<input.endIndex)
    }

    func testCommentSectionRangesEntireStringMultiLine() {
        let input = "/* A comment! \n*/"

        let ranges = input.cStyleCommentSectionRanges()
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0], input.startIndex..<input.endIndex)
    }

    func testCommentSectionRangesOpenMultiLineComment() {
        let input = "/* A comment! \n"

        let ranges = input.cStyleCommentSectionRanges()
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0], input.startIndex..<input.endIndex)
    }

    func testCommentSectionRangesIgnoresCommentsInStringLiterals() {
        let input = "\"A comment in a string: // etc.\""

        let ranges = input.cStyleCommentSectionRanges()
        XCTAssertEqual(ranges.count, 0)
    }

    func testCommentSectionRangesIgnoresStringLiteralsWithinSingleLineComments() {
        let input = "/* A comment! \"A string\" \n"

        let ranges = input.cStyleCommentSectionRanges()
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0], input.startIndex..<input.endIndex)
    }

    func testCommentSectionRangesIgnoresStringLiteralsWithinMultiLineComments() {
        let input = """
            /* A comment! "An unterminated string literal
            */ "A string /* */"
            """

        let ranges = input.cStyleCommentSectionRanges()
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(
            ranges[0],
            input.range(
                of: """
                    /* A comment! "An unterminated string literal
                    */
                    """
            )
        )
    }

    func testLineRangesWithCountedLines() {
        let input = """
            1
            2
            3
            """

        let ranges = input.lineRanges()
        XCTAssertEqual(ranges.count, 3)
        XCTAssertEqual(ranges[0], input.range(of: "1"))
        XCTAssertEqual(ranges[1], input.range(of: "2"))
        XCTAssertEqual(ranges[2], input.range(of: "3"))
    }

    func testLineRangesWithEmptyLines() {
        let input = """
            1

            3
            """

        let ranges = input.lineRanges()
        XCTAssertEqual(ranges.count, 3)
        XCTAssertEqual(ranges[0], input.range(of: "1"))
        XCTAssertEqual(
            ranges[1],
            input.range(of: "1\n")!.upperBound..<input.range(of: "\n3")!.lowerBound
        )
        XCTAssertEqual(ranges[2], input.range(of: "3"))
    }

    func testLineRangesWithEmptyFinalLine() {
        let input = """
            1

            """

        let ranges = input.lineRanges()
        XCTAssertEqual(ranges.count, 2)
        XCTAssertEqual(ranges[0], input.range(of: "1"))
        XCTAssertEqual(ranges[1], input.range(of: "1\n")!.upperBound..<input.endIndex)
    }

    func testLineRangesWithTwoEmptyFinalLines() {
        let input = """
            1


            """

        let ranges = input.lineRanges()
        XCTAssertEqual(ranges.count, 3)
        XCTAssertEqual(ranges[0], input.intRange(0..<1))
        XCTAssertEqual(ranges[1], input.intRange(2..<2))
        XCTAssertEqual(ranges[2], input.intRange(3..<3))
    }

    func testLineRangesWithSingleLine() {
        let input = "123"

        let ranges = input.lineRanges()
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0], input.startIndex..<input.endIndex)
    }

    func testLineRangesWithEmptyString() {
        let input = ""

        let ranges = input.lineRanges()
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0], input.startIndex..<input.endIndex)
    }

    func testLineRangesWithSingleEmptyLine() {
        let input = "\n"

        let ranges = input.lineRanges()
        XCTAssertEqual(ranges.count, 2)
        XCTAssertEqual(ranges[0], input.startIndex..<input.startIndex)
        XCTAssertEqual(ranges[1], input.endIndex..<input.endIndex)
    }

    func testTrimWhitespace() {
        XCTAssertEqual(trimWhitespace(""), "")
        XCTAssertEqual(trimWhitespace("  "), "")
        XCTAssertEqual(trimWhitespace("a "), "a")
        XCTAssertEqual(trimWhitespace(" a"), "a")
        XCTAssertEqual(trimWhitespace("abc"), "abc")
        XCTAssertEqual(trimWhitespace("abc "), "abc")
        XCTAssertEqual(trimWhitespace(" abc"), "abc")
        XCTAssertEqual(trimWhitespace("  abc "), "abc")
        XCTAssertEqual(trimWhitespace("\nabc\n"), "abc")
        XCTAssertEqual(trimWhitespace("\n abc def \t "), "abc def")
        XCTAssertEqual(trimWhitespace("  abc def "), "abc def")
    }

    func testTrimWhitespaceLead() {
        XCTAssertEqual(trimWhitespaceLead(""), "")
        XCTAssertEqual(trimWhitespaceLead("  "), "")
        XCTAssertEqual(trimWhitespaceLead("a "), "a ")
        XCTAssertEqual(trimWhitespaceLead(" a"), "a")
        XCTAssertEqual(trimWhitespaceLead("abc"), "abc")
        XCTAssertEqual(trimWhitespaceLead("abc "), "abc ")
        XCTAssertEqual(trimWhitespaceLead(" abc"), "abc")
        XCTAssertEqual(trimWhitespaceLead("  abc "), "abc ")
        XCTAssertEqual(trimWhitespaceLead("\nabc\n"), "abc\n")
        XCTAssertEqual(trimWhitespaceLead("\n abc def \t "), "abc def \t ")
        XCTAssertEqual(trimWhitespaceLead("  abc def "), "abc def ")
    }

    func testTrimWhitespaceTrail() {
        XCTAssertEqual(trimWhitespaceTrail(""), "")
        XCTAssertEqual(trimWhitespaceTrail("  "), "")
        XCTAssertEqual(trimWhitespaceTrail("a "), "a")
        XCTAssertEqual(trimWhitespaceTrail(" a"), " a")
        XCTAssertEqual(trimWhitespaceTrail("abc"), "abc")
        XCTAssertEqual(trimWhitespaceTrail("abc "), "abc")
        XCTAssertEqual(trimWhitespaceTrail(" abc"), " abc")
        XCTAssertEqual(trimWhitespaceTrail("  abc "), "  abc")
        XCTAssertEqual(trimWhitespaceTrail("\nabc\n"), "\nabc")
        XCTAssertEqual(trimWhitespaceTrail("\n abc def \t "), "\n abc def")
        XCTAssertEqual(trimWhitespaceTrail("  abc def "), "  abc def")
    }
}

extension String {
    func intRange<R>(_ range: R) -> Range<Index> where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: Array(0..<count))

        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)

        return start..<end
    }
}
