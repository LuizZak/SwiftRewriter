import XCTest
import ExpressionPasses
import SwiftRewriterLib

class UIKitExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        sut = UIKitExpressionPass()
    }
    
    func testUIColor() {
        assertTransformParsed(
            expression: "[UIColor orangeColor]",
            into: .postfix(.identifier("UIColor"), .member("orange"))
        )
        
        assertTransformParsed(
            expression: "[UIColor redColor]",
            into: .postfix(.identifier("UIColor"), .member("red"))
        )
        
        // Test unrecognized cases are left alone
        assertTransformParsed(
            expression: "UIColor->redColor",
            into: "UIColor.redColor"
        )
        assertTransformParsed(
            expression: "[UIColor redColor:@1]",
            into: "UIColor.redColor(1)"
        )
        assertTransformParsed(
            expression: "[UIColor Color:@1]",
            into: "UIColor.Color(1)"
        )
    }
    
    func testAddTarget() {
        assertTransformParsed(
            expression: "[self.button addTarget:self action:@selector(didTapButton:) forControlEvents: UIControlEventTouchUpInside]",
            into: .postfix(.postfix(.postfix(.identifier("self"), .member("button")),
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
