import XCTest
@testable import GrammarModels

class SourceRangeTests: XCTestCase {
    func testUnion() {
        let string = "abcde"
        let expected = string.startIndex..<string.endIndex
        let range1 = SourceRange.range(string.startIndex..<string.index(string.startIndex, offsetBy: 1))
        let range2 = SourceRange.range(string.index(string.startIndex, offsetBy: 2)..<string.endIndex)
        
        let result = range1.union(with: range2)
        
        switch result {
        case .range(let range) where range == expected:
            // Success!
            break
        default:
            XCTFail("Failed to receive expected range \(expected), received \(result) instead.")
        }
    }
    
    func testUnionRangeWithLocation() {
        let string = "abcde"
        let expected = string.startIndex..<string.endIndex
        let range1 = SourceRange.location(string.startIndex)
        let range2 = SourceRange.range(string.index(string.startIndex, offsetBy: 2)..<string.endIndex)
        
        let result = range1.union(with: range2)
        
        switch result {
        case .range(let range) where range == expected:
            // Success!
            break
        default:
            XCTFail("Failed to receive expected range \(expected), received \(result) instead.")
        }
    }
    
    func testLocationWithLocation() {
        let string = "abcde"
        let expected = string.startIndex..<string.endIndex
        let range1 = SourceRange.location(string.startIndex)
        let range2 = SourceRange.location(string.endIndex)
        
        let result = range1.union(with: range2)
        
        switch result {
        case .range(let range) where range == expected:
            // Success!
            break
        default:
            XCTFail("Failed to receive expected range \(expected), received \(result) instead.")
        }
    }
    
    func testValidSubstringIn() {
        let string = "abcde"
        let range = SourceRange.range(string.startIndex..<string.index(string.startIndex, offsetBy: 2))
        
        XCTAssertEqual(range.substring(in: string), "ab")
    }
    
    func testInvalidSubstringIn() {
        let string = "abcde"
        let range = SourceRange.invalid
        
        XCTAssertNil(range.substring(in: string))
    }
}
