import XCTest
import ExpressionPasses
import SwiftRewriterLib

class FoundationExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        sut = FoundationExpressionPass()
    }
    
    func testIsEqualToString() {
        assertTransformParsed(
            original: "[self.aString isEqualToString:@\"abc\"]",
            expected: .binary(lhs: .postfix(.identifier("self"), .member("aString")),
                              op: .equals,
                              rhs: .constant("abc")))
    }
}
