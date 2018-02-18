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
    
    func testAddTarget() {
        assertTransformParsed(
            original: "[self.button addTarget:self action:@selector(didTapButton:) forControlEvents: UIControlEventTouchUpInside]",
            expected: .postfix(.postfix(.postfix(.identifier("self"), .member("button")),
                                        .member("addTarget")),
                               .functionCall(arguments: [
                                .unlabeled(.identifier("self")),
                                .labeled("action", .postfix(.identifier("Selector"),
                                                            .functionCall(arguments: [
                                                                .unlabeled(.constant("didTapButton:"))
                                                                ]))),
                                .labeled("for", .postfix(.identifier("UIControlEvents"), .member("touchUpInside")))
                                ]))
        )
    }
}
