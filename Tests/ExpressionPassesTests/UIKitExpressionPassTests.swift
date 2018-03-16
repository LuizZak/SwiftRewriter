import XCTest
import ExpressionPasses
import SwiftRewriterLib
import SwiftAST

class UIKitExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sut = UIKitExpressionPass()
    }
    
    func testNSTextAlignment() {
        assertTransformParsed(
            expression: "NSTextAlignmentLeft",
            into: Expression.identifier("NSTextAlignment").dot("left")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "NSTextAlignmentRight",
            into: Expression.identifier("NSTextAlignment").dot("right")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "NSTextAlignmentCenter",
            into: Expression.identifier("NSTextAlignment").dot("center")
        ); assertNotifiedChange()
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
            into: Expression
                .identifier("self").dot("button")
                .dot("addTarget")
                .call([
                    .unlabeled(.identifier("self")),
                    .labeled("action", Expression.identifier("Selector").call([.constant("didTapButton:")])),
                    .labeled("for", Expression.identifier("UIControlEvents").dot("touchUpInside"))
                ])
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
    
    func testUIFontInitializers() {
        assertTransformParsed(
            expression: "[UIFont systemFontOfSize:12]",
            into: Expression.identifier("UIFont").dot("systemFont").call([.labeled("ofSize", .constant(12))])
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "[UIFont boldSystemFontOfSize:12]",
            into: Expression.identifier("UIFont").dot("boldSystemFont").call([.labeled("ofSize", .constant(12))])
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "[UIFont italicSystemFontOfFont:12]",
            into: Expression.identifier("UIFont").dot("italicSystemFont").call([.labeled("ofSize", .constant(12))])
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "[UIFont systemFontOfFont:12 weight:UIFontWeightBold]",
            into: Expression.identifier("UIFont").dot("systemFont").call([
                .labeled("ofSize", .constant(12)),
                .labeled("weight", Expression.identifier("UIFont").dot("Weight").dot("bold"))
            ])
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "[UIFont monospacedDigitSystemFontOfSize:12 weight:UIFontWeightBold]",
            into: Expression.identifier("UIFont").dot("monospacedDigitSystemFont").call([
                .labeled("ofSize", .constant(12)),
                .labeled("weight", Expression.identifier("UIFont").dot("Weight").dot("bold"))
                ])
        ); assertNotifiedChange()
    }
    
    func testUIFontWeight() {
        assertTransformParsed(
            expression: "UIFontWeightUltraLight",
            into: Expression.identifier("UIFont").dot("Weight").dot("ultraLight")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "UIFontWeightLight",
            into: Expression.identifier("UIFont").dot("Weight").dot("light")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "UIFontWeightThin",
            into: Expression.identifier("UIFont").dot("Weight").dot("thin")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "UIFontWeightRegular",
            into: Expression.identifier("UIFont").dot("Weight").dot("regular")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "UIFontWeightMedium",
            into: Expression.identifier("UIFont").dot("Weight").dot("medium")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "UIFontWeightSemibold",
            into: Expression.identifier("UIFont").dot("Weight").dot("semibold")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "UIFontWeightBold",
            into: Expression.identifier("UIFont").dot("Weight").dot("bold")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "UIFontWeightHeavy",
            into: Expression.identifier("UIFont").dot("Weight").dot("heavy")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "UIFontWeightBlack",
            into: Expression.identifier("UIFont").dot("Weight").dot("black")
        ); assertNotifiedChange()
    }
    
    func testUIColorStaticInitializer() {
        assertTransform(
            expression: Expression
                .identifier("UIColor")
                .dot("colorWithRed")
                .call([
                    FunctionArgument(label: nil, expression: .constant(1)),
                    FunctionArgument(label: "green", expression: .constant(1)),
                    FunctionArgument(label: "blue", expression: .constant(1)),
                    FunctionArgument(label: "alpha", expression: .constant(1))
                ]),
            into: Expression.identifier("UIColor").call([
                FunctionArgument(label: "red", expression: .constant(1)),
                FunctionArgument(label: "green", expression: .constant(1)),
                FunctionArgument(label: "blue", expression: .constant(1)),
                FunctionArgument(label: "alpha", expression: .constant(1))
                ])
        )
    }
}
