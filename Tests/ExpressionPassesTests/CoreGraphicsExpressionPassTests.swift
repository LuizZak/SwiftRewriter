import XCTest
import SwiftRewriterLib
import ExpressionPasses

class CoreGraphicsExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        sut = CoreGraphicsExpressionPass()
    }
    
    func testCGRectMake() {
        assertTransformParsed(
            original: "CGRectMake(1, 2, 3, 4)",
            expected: .postfix(.identifier("CGRect"),
                               .functionCall(arguments: [
                                    .labeled("x", .constant(1)),
                                    .labeled("y", .constant(2)),
                                    .labeled("width", .constant(3)),
                                    .labeled("height", .constant(4))
                                ])))
    }
    
    func testCGRectGetWidthAndGetHeight() {
        assertTransformParsed(
            original: "CGRectGetWidth(self.frame)",
            expected: .postfix(.postfix(.identifier("self"), .member("frame")), .member("width")))
        
        assertTransformParsed(
            original: "CGRectGetHeight(self.frame)",
            expected: .postfix(.postfix(.identifier("self"), .member("frame")), .member("height")))
        
        // Test transformations keep unrecognized members alone
        assertTransformParsed(
            original: "CGRectGetWidth(self.frame, self.frame)",
            expected: "CGRectGetWidth(self.frame, self.frame)")
        assertTransformParsed(
            original: "CGRectGetHeight(self.frame, self.frame)",
            expected: "CGRectGetHeight(self.frame, self.frame)")
    }
}
