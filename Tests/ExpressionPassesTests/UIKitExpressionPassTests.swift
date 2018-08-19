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
            into: Expression.identifier("UIColor").dot("orange")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "[UIColor redColor]",
            into: Expression.identifier("UIColor").dot("red")
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
        let _exp = Expression.identifier("view")
        _exp.resolvedType = .typeName("UIView")
        
        var exp: Expression {
            return _exp.copy()
        }
        
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
        let _exp = Expression.identifier("view").optional()
        _exp.exp.resolvedType = .optional(.typeName("UIView"))
        
        var exp: OptionalAccessPostfixBuilder {
            return _exp.copy()
        }
        
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
    
    func testUITableViewCellSeparatorStyle() {
        assertTransformParsed(
            expression: "UITableViewCellSeparatorStyleNone",
            into: Expression.identifier("UITableViewCellSeparatorStyle").dot("none")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "UITableViewCellSeparatorStyleSingleEtched",
            into: Expression.identifier("UITableViewCellSeparatorStyle").dot("singleEtched")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "UITableViewCellSeparatorStyleSingleLineEtched",
            into: Expression.identifier("UITableViewCellSeparatorStyle").dot("singleLineEtched")
        ); assertNotifiedChange()
    }
    
    func testUITableViewCellSelectionStyle() {
        assertTransformParsed(
            expression: "UITableViewCellSelectionStyleNone",
            into: Expression.identifier("UITableViewCellSelectionStyle").dot("none")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "UITableViewCellSelectionStyleBlue",
            into: Expression.identifier("UITableViewCellSelectionStyle").dot("blue")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "UITableViewCellSelectionStyleGray",
            into: Expression.identifier("UITableViewCellSelectionStyle").dot("gray")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "UITableViewCellSelectionStyleDefault",
            into: Expression.identifier("UITableViewCellSelectionStyle").dot("default")
        ); assertNotifiedChange()
    }
    
    func testUIViewAnimateWithDuration() {
        assertTransform(
            expression: Expression
                .identifier("UIView")
                .typed(.metatype(for: .typeName("UIView")))
                .dot("animateWithDuration")
                .call([
                    .unlabeled(.constant(0.3)),
                    .labeled("animations", .block(body: []))
                ]),
            into: Expression
                .identifier("UIView")
                .dot("animate")
                .call([
                    .labeled("withDuration", .constant(0.3)),
                    .labeled("animations", .block(body: []))
                ])
        ); assertNotifiedChange()
    }
    
    func testEnumifyUIViewAnimationOptions() {
        assertTransform(
            expression: .identifier("UIViewAnimationOptionLayoutSubviews"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("layoutSubviews")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionAllowUserInteraction"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("allowUserInteraction")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionBeginFromCurrentState"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("beginFromCurrentState")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionRepeat"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("repeat")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionAutoreverse"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("autoreverse")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionOverrideInheritedDuration"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("overrideInheritedDuration")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionOverrideInheritedCurve"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("overrideInheritedCurve")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionAllowAnimatedContent"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("allowAnimatedContent")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionShowHideTransitionViews"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("showHideTransitionViews")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionOverrideInheritedOptions"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("overrideInheritedOptions")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionCurveEaseInOut"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("curveEaseInOut")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionCurveEaseIn"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("curveEaseIn")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionCurveEaseOut"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("curveEaseOut")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionCurveLinear"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("curveLinear")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionNone"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("transitionNone")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionFlipFromLeft"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("transitionFlipFromLeft")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionFlipFromRight"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("transitionFlipFromRight")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionCurlUp"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("transitionCurlUp")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionCurlDown"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("transitionCurlDown")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionCrossDissolve"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("transitionCrossDissolve")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionFlipFromTop"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("transitionFlipFromTop")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionFlipFromBottom"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("transitionFlipFromBottom")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionPreferredFramesPerSecondDefault"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("preferredFramesPerSecondDefault")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionPreferredFramesPerSecond60"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("preferredFramesPerSecond60")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: .identifier("UIViewAnimationOptionPreferredFramesPerSecond30"),
            into: Expression
                .identifier("UIViewAnimationOptions")
                .dot("preferredFramesPerSecond30")
        ); assertNotifiedChange()
        
    }
}
