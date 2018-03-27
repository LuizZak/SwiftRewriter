import XCTest
import SwiftAST

class NormalizedSwiftTypeTests: XCTestCase {
    func testZeroOrMoreInitializing() {
        let sut = ZeroOrMore.fromSequence([1, 2, 3])
        
        XCTAssertEqual(sut, ZeroOrMore.list(1, .list(2, .list(3, .tail))))
    }
    
    func testOneOrMoreInitializing() {
        let sut = OneOrMore.fromCollection([1, 2, 3])
        
        XCTAssertEqual(sut, OneOrMore.list(1, .list(2, .tail(3))))
    }
    
    func testTwoOrMoreInitializing() {
        let sut = TwoOrMore.fromCollection([1, 2, 3])
        
        XCTAssertEqual(sut, TwoOrMore.list(1, .tail(2, 3)))
    }
    
    func testIterateZeroOrMore() {
        let sut: ZeroOrMore<Int> = .list(1, .list(2, .list(3, .tail)))
        
        let result = Array(sut)
        
        XCTAssertEqual(result, [1, 2, 3])
    }
    
    func testIterateOneOrMoreOneItem() {
        let sut: OneOrMore<Int> = .tail(1)
        
        let result = Array(sut)
        
        XCTAssertEqual(result, [1])
    }
    
    func testIterateOneOrMore() {
        let sut: OneOrMore<Int> = .list(1, .list(2, .tail(3)))
        
        let result = Array(sut)
        
        XCTAssertEqual(result, [1, 2, 3])
    }
    
    func testIterateTwoOrMore() {
        let sut: TwoOrMore<Int> = .list(1, .tail(2, 3))
        
        let result = Array(sut)
        
        XCTAssertEqual(result, [1, 2, 3])
    }
}
