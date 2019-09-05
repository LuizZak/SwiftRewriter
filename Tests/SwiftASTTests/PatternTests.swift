import XCTest
@testable import SwiftAST

class PatternTests: XCTestCase {
    func testSubpatternAt() {
        let pattern = SwiftAST.Pattern.tuple([.identifier("a"), .tuple([.identifier("b"), .identifier("c")])])
        
        XCTAssertEqual(pattern.subpattern(at: .tuple(index: 0, pattern: .self)),
                       .identifier("a"))
        XCTAssertEqual(pattern.subpattern(at: .tuple(index: 1, pattern: .tuple(index: 0, pattern: .self))),
                       .identifier("b"))
        XCTAssertEqual(pattern.subpattern(at: .tuple(index: 1, pattern: .tuple(index: 1, pattern: .self))),
                       .identifier("c"))
    }
}
