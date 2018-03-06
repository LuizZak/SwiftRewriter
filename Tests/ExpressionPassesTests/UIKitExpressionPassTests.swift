import XCTest
import ExpressionPasses
import SwiftRewriterLib
import SwiftAST

class UIKitExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sut = UIKitExpressionPass()
    }
    
    func testUIColor() {
        assertTransformParsed(
            expression: "[UIColor orangeColor]",
            into: .postfix(.identifier("UIColor"), .member("orange"))
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "[UIColor redColor]",
            into: .postfix(.identifier("UIColor"), .member("red"))
        ); assertNotifiedChange()
        
        // Test unrecognized cases are left alone
        assertTransformParsed(
            expression: "UIColor->redColor",
            into: "UIColor.redColor"
        ); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "[UIColor redColor:@1]",
            into: "UIColor.redColor(1)"
        ); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "[UIColor Color:@1]",
            into: "UIColor.Color(1)"
        ); assertDidNotNotifyChange()
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
        ); assertNotifiedChange()
    }
    
    func testEnumifyUIGestureRecognizerState() {
        assertTransform(
            expression: .identifier("UIGestureRecognizerStateEnded"),
            into: Expression.identifier("UIGestureRecognizerState").dot("ended")
        ); assertNotifiedChange()
    }
    
    func testConvertBooleanGetters() {
        let exp = Expression.identifier("view")
        exp.resolvedType = .typeName("UIView")
        
        let makeGetter: (String) -> Expression = {
            return exp.dot($0)
        }
        
        assertTransform(
            expression: makeGetter("opaque"),
            into: exp.dot("isOpaque")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("hidden"),
            into: exp.dot("isHidden")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("editable"),
            into: exp.dot("isEditable")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("userInteractionEnabled"),
            into: exp.dot("isUserInteractionEnabled")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("focused"),
            into: exp.dot("isFocused")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("firstResponder"),
            into: exp.dot("isFirstResponder")
        ); assertNotifiedChange()
    }
    
    func testConvertBooleanGettersOnOptionalViews() {
        let exp = Expression.identifier("view").optional()
        exp.exp.resolvedType = .optional(.typeName("UIView"))
        
        let makeGetter: (String) -> Expression = {
            return exp.dot($0)
        }
        
        assertTransform(
            expression: makeGetter("opaque"),
            into: exp.dot("isOpaque")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("hidden"),
            into: exp.dot("isHidden")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("editable"),
            into: exp.dot("isEditable")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("userInteractionEnabled"),
            into: exp.dot("isUserInteractionEnabled")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("focused"),
            into: exp.dot("isFocused")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("firstResponder"),
            into: exp.dot("isFirstResponder")
        ); assertNotifiedChange()
    }
}
