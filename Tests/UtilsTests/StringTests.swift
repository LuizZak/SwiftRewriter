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
}
