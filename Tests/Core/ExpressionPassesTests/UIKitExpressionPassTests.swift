import SwiftAST
import SwiftRewriterLib
import XCTest

@testable import ExpressionPasses

class UIKitExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()

        sutType = UIKitExpressionPass.self
    }

    func testNSTextAlignment() {
        assertTransformParsed(
            expression: "NSTextAlignmentLeft",
            into: .identifier("NSTextAlignment").dot("left")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "NSTextAlignmentRight",
            into: .identifier("NSTextAlignment").dot("right")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "NSTextAlignmentCenter",
            into: .identifier("NSTextAlignment").dot("center")
        )
        assertNotifiedChange()
    }

    func testAddTarget() {
        assertTransformParsed(
            expression:
                "[self.button addTarget:self action:@selector(didTapButton:) forControlEvents: UIControlEventTouchUpInside]",
            into:
                .identifier("self").dot("button")
                .dot("addTarget")
                .call([
                    .unlabeled(.identifier("self")),
                    .labeled(
                        "action",
                        .selector(FunctionIdentifier(name: "didTapButton", argumentLabels: [nil]))
                    ),
                    .labeled("for", .identifier("UIControl").dot("Event").dot("touchUpInside")),
                ])
        )
        assertNotifiedChange()
    }

    func testEnumifyUIGestureRecognizerState() {
        assertTransform(
            expression: .identifier("UIGestureRecognizerStateEnded"),
            into: .identifier("UIGestureRecognizer").dot("State").dot("ended")
        )
        assertNotifiedChange()
    }

    func testUIFontInitializers() {
        assertTransformParsed(
            expression: "[UIFont systemFontOfSize:12]",
            into: .identifier("UIFont").dot("systemFont").call([.labeled("ofSize", .constant(12))])
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "[UIFont boldSystemFontOfSize:12]",
            into: .identifier("UIFont").dot("boldSystemFont").call([
                .labeled("ofSize", .constant(12))
            ])
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "[UIFont italicSystemFontOfFont:12]",
            into: .identifier("UIFont").dot("italicSystemFont").call([
                .labeled("ofSize", .constant(12))
            ])
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "[UIFont systemFontOfFont:12 weight:UIFontWeightBold]",
            into: .identifier("UIFont").dot("systemFont").call([
                .labeled("ofSize", .constant(12)),
                .labeled("weight", .identifier("UIFont").dot("Weight").dot("bold")),
            ])
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "[UIFont monospacedDigitSystemFontOfSize:12 weight:UIFontWeightBold]",
            into: .identifier("UIFont").dot("monospacedDigitSystemFont").call([
                .labeled("ofSize", .constant(12)),
                .labeled("weight", .identifier("UIFont").dot("Weight").dot("bold")),
            ])
        )
        assertNotifiedChange()
    }

    func testUIFontWeight() {
        assertTransformParsed(
            expression: "UIFontWeightUltraLight",
            into: .identifier("UIFont").dot("Weight").dot("ultraLight")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "UIFontWeightLight",
            into: .identifier("UIFont").dot("Weight").dot("light")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "UIFontWeightThin",
            into: .identifier("UIFont").dot("Weight").dot("thin")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "UIFontWeightRegular",
            into: .identifier("UIFont").dot("Weight").dot("regular")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "UIFontWeightMedium",
            into: .identifier("UIFont").dot("Weight").dot("medium")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "UIFontWeightSemibold",
            into: .identifier("UIFont").dot("Weight").dot("semibold")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "UIFontWeightBold",
            into: .identifier("UIFont").dot("Weight").dot("bold")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "UIFontWeightHeavy",
            into: .identifier("UIFont").dot("Weight").dot("heavy")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "UIFontWeightBlack",
            into: .identifier("UIFont").dot("Weight").dot("black")
        )
        assertNotifiedChange()
    }

    func testUIColorStaticInitializers() {
        assertTransform(
            expression:
                .identifier("UIColor")
                .dot("colorWithRed")
                .call([
                    FunctionArgument(label: nil, expression: .constant(1)),
                    FunctionArgument(label: "green", expression: .constant(1)),
                    FunctionArgument(label: "blue", expression: .constant(1)),
                    FunctionArgument(label: "alpha", expression: .constant(1)),
                ]),
            into: .identifier("UIColor").call([
                FunctionArgument(label: "red", expression: .constant(1)),
                FunctionArgument(label: "green", expression: .constant(1)),
                FunctionArgument(label: "blue", expression: .constant(1)),
                FunctionArgument(label: "alpha", expression: .constant(1)),
            ])
        )

        assertTransform(
            expression:
                .identifier("UIColor")
                .dot("colorWithWhite")
                .call([
                    FunctionArgument(label: nil, expression: .constant(1)),
                    FunctionArgument(label: "alpha", expression: .constant(0.5)),
                ]),
            into: .identifier("UIColor").call([
                FunctionArgument(label: "white", expression: .constant(1)),
                FunctionArgument(label: "alpha", expression: .constant(0.5)),
            ])
        )
    }

    func testUITableViewCellSeparatorStyle() {
        assertTransformParsed(
            expression: "UITableViewCellSeparatorStyleNone",
            into: .identifier("UITableViewCell").dot("SeparatorStyle").dot("none")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "UITableViewCellSeparatorStyleSingleEtched",
            into: .identifier("UITableViewCell").dot("SeparatorStyle").dot("singleEtched")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "UITableViewCellSeparatorStyleSingleLineEtched",
            into: .identifier("UITableViewCell").dot("SeparatorStyle").dot("singleLineEtched")
        )
        assertNotifiedChange()
    }

    func testUITableViewCellSelectionStyle() {
        assertTransformParsed(
            expression: "UITableViewCellSelectionStyleNone",
            into: .identifier("UITableViewCell").dot("SelectionStyle").dot("none")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "UITableViewCellSelectionStyleBlue",
            into: .identifier("UITableViewCell").dot("SelectionStyle").dot("blue")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "UITableViewCellSelectionStyleGray",
            into: .identifier("UITableViewCell").dot("SelectionStyle").dot("gray")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "UITableViewCellSelectionStyleDefault",
            into: .identifier("UITableViewCell").dot("SelectionStyle").dot("default")
        )
        assertNotifiedChange()
    }

    func testEnumifyUIViewAnimationOptions() {
        assertTransform(
            expression: .identifier("UIViewAnimationOptionLayoutSubviews"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("layoutSubviews")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionAllowUserInteraction"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("allowUserInteraction")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionBeginFromCurrentState"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("beginFromCurrentState")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionRepeat"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("repeat")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionAutoreverse"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("autoreverse")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionOverrideInheritedDuration"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("overrideInheritedDuration")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionOverrideInheritedCurve"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("overrideInheritedCurve")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionAllowAnimatedContent"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("allowAnimatedContent")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionShowHideTransitionViews"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("showHideTransitionViews")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionOverrideInheritedOptions"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("overrideInheritedOptions")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionCurveEaseInOut"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("curveEaseInOut")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionCurveEaseIn"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("curveEaseIn")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionCurveEaseOut"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("curveEaseOut")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionCurveLinear"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("curveLinear")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionNone"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionNone")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionFlipFromLeft"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionFlipFromLeft")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionFlipFromRight"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionFlipFromRight")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionCurlUp"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionCurlUp")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionCurlDown"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionCurlDown")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionCrossDissolve"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionCrossDissolve")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionFlipFromTop"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionFlipFromTop")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionFlipFromBottom"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionFlipFromBottom")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionPreferredFramesPerSecondDefault"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("preferredFramesPerSecondDefault")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionPreferredFramesPerSecond60"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("preferredFramesPerSecond60")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("UIViewAnimationOptionPreferredFramesPerSecond30"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("preferredFramesPerSecond30")
        )
        assertNotifiedChange()

    }
}
