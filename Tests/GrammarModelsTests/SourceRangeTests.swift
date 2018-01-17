import XCTest
@testable import GrammarModels

class SourceRangeTests: XCTestCase {
    func testUnion() {
        let string = "abcde"
        let expected = string.startIndex..<string.endIndex
        let range1 = SourceRange.valid(string.startIndex..<string.index(string.startIndex, offsetBy: 1))
        let range2 = SourceRange.valid(string.index(string.startIndex, offsetBy: 2)..<string.endIndex)
        
        let result = range1.union(with: range2)
        
        switch result {
        case .valid(let range) where range == expected:
            // Success!
            break
        default:
            XCTFail("Failed to receive expected range \(expected), received \(result) instead.")
        }
    }
    
    func testValidSubstringIn() {
        let string = "abcde"
        let range = SourceRange.valid(string.startIndex..<string.index(string.startIndex, offsetBy: 2))
        
        XCTAssertEqual(range.substring(in: string), "ab")
    }
    
    func testInvalidSubstringIn() {
        let string = "abcde"
        let range = SourceRange.invalid
        
        XCTAssertNil(range.substring(in: string))
    }
}
