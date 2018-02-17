import XCTest
import ExpressionPasses
import SwiftRewriterLib

class UIKitExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        sut = UIKitExpressionPass()
    }
    
    func testUIColor() {
        assertTransformParsed(
            original: "[UIColor orangeColor]",
            expected: .postfix(.identifier("UIColor"), .member("orange"))
        )
        
        assertTransformParsed(
            original: "[UIColor redColor]",
            expected: .postfix(.identifier("UIColor"), .member("red"))
        )
        
        // Test unrecognized cases are left alone
        assertTransformParsed(
            original: "UIColor->redColor",
            expected: "UIColor.redColor"
        )
        assertTransformParsed(
            original: "[UIColor redColor:@1]",
            expected: "UIColor.redColor(1)"
        )
        assertTransformParsed(
            original: "[UIColor Color:@1]",
            expected: "UIColor.Color(1)"
        )
    }
}
