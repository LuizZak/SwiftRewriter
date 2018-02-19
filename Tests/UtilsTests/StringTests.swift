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
        XCTAssertEqual("abc", "Abc".lowercasedFirstLetter)
        XCTAssertEqual("abc", "abc".lowercasedFirstLetter)
        XCTAssertEqual("ábc", "Ábc".lowercasedFirstLetter)
        XCTAssertEqual("0", "0".lowercasedFirstLetter)
        XCTAssertEqual("", "".lowercasedFirstLetter)
        XCTAssertEqual(" ", " ".lowercasedFirstLetter)
    }
    
    func testUppercasedFirstLetter() {
        XCTAssertEqual("Abc", "abc".uppercasedFirstLetter)
        XCTAssertEqual("Abc", "Abc".uppercasedFirstLetter)
        XCTAssertEqual("Ábc", "ábc".uppercasedFirstLetter)
        XCTAssertEqual("0", "0".uppercasedFirstLetter)
        XCTAssertEqual("", "".uppercasedFirstLetter)
        XCTAssertEqual(" ", " ".uppercasedFirstLetter)
    }
    
    func testMarkDifference() {
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
    
    func testMarkDifferenceBetweenLines() {
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
}
