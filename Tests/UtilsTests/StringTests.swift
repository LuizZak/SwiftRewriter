import XCTest
import Utils

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
        XCTAssertEqual("0", "0".lowercasedFirstLetter)
        XCTAssertEqual("", "".lowercasedFirstLetter)
        XCTAssertEqual(" ", " ".lowercasedFirstLetter)
    }
    
    func testUppercasedFirstLetter() {
        XCTAssertEqual("A", "a".uppercasedFirstLetter)
        XCTAssertEqual("Abc", "abc".uppercasedFirstLetter)
        XCTAssertEqual("Abc", "Abc".uppercasedFirstLetter)
        XCTAssertEqual("Ábc", "ábc".uppercasedFirstLetter)
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
        
        XCTAssertEqual("""
            Abcdef
            ~~^ Difference starts here
            """, result)
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
        
        XCTAssertEqual("""
            Abc
            Def
            ~^ Difference starts here
            Ghi
            """, result)
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
        
        XCTAssertEqual("""
            Abc
            Def
            Ghi
             ~ Strings are equal.
            """, result)
    }
    
    func testMakeDifferenceBetweenStringsAtBeginning() {
        let str1 = """
            Abc
            """
        let str2 = """
            Zwx
            """
        
        let result = str1.makeDifferenceMarkString(against: str2)
        
        XCTAssertEqual("""
            Abc
             ~ Difference at start of string.
            """, result)
    }
    
    func testRangeOfComments() {
        let input = """
        // A comment!
        Not a comment.
        /*
            A multi-lined comment!
        */
        Not a comment again.
        """
        
        let ranges = input.rangesOfCommentSections()
        XCTAssertEqual(ranges.count, 2)
        XCTAssertEqual(ranges[0], input.range(of: "// A comment!\n")!)
        XCTAssertEqual(ranges[1], input.range(of: """
            /*
                A multi-lined comment!
            */
            """))
    }
    
    func testRangeOfCommentsEntireString() {
        let input = "// A comment!"
        
        let ranges = input.rangesOfCommentSections()
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0], input.startIndex..<input.endIndex)
    }
    
    func testRangeOfCommentsEntireStringMultiLine() {
        let input = "/* A comment! \n*/"
        
        let ranges = input.rangesOfCommentSections()
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0], input.startIndex..<input.endIndex)
    }
    
    func testRangeOfCommentsOpenMultiLineComment() {
        let input = "/* A comment! \n"
        
        let ranges = input.rangesOfCommentSections()
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0], input.startIndex..<input.endIndex)
    }
    
    func testRangeOfCommentsIgnoresCommentsInStringLiterals() {
        let input = "\"A comment in a string: // etc.\""
        
        let ranges = input.rangesOfCommentSections()
        XCTAssertEqual(ranges.count, 0)
    }
    
    func testRangeOfCommentsIgnoresStringLiteralsWithinSingleLineComments() {
        let input = "/* A comment! \"A string\" \n"
        
        let ranges = input.rangesOfCommentSections()
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0], input.startIndex..<input.endIndex)
    }
    
    func testRangeOfCommentsIgnoresStringLiteralsWithinMultiLineComments() {
        let input = """
            /* A comment! "An unterminated string literal
            */ "A string /* */"
            """
        
        let ranges = input.rangesOfCommentSections()
        XCTAssertEqual(ranges.count, 1)
        XCTAssertEqual(ranges[0], input.range(of: """
            /* A comment! "An unterminated string literal
            */
            """))
    }
}
