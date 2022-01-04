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

        assertTransformParsed(
            expression: "NSTextAlignmentRight",
            into: .identifier("NSTextAlignment").dot("right")
        )

        assertTransformParsed(
            expression: "NSTextAlignmentCenter",
            into: .identifier("NSTextAlignment").dot("center")
        )
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
    }

    func testEnumifyUIGestureRecognizerState() {
        assertTransform(
            expression: .identifier("UIGestureRecognizerStateEnded"),
            into: .identifier("UIGestureRecognizer").dot("State").dot("ended")
        )
    }

    func testUIFontInitializers() {
        assertTransformParsed(
            expression: "[UIFont systemFontOfSize:12]",
            into: .identifier("UIFont").dot("systemFont").call([.labeled("ofSize", .constant(12))])
        )

        assertTransformParsed(
            expression: "[UIFont boldSystemFontOfSize:12]",
            into: .identifier("UIFont").dot("boldSystemFont").call([
                .labeled("ofSize", .constant(12))
            ])
        )

        assertTransformParsed(
            expression: "[UIFont italicSystemFontOfFont:12]",
            into: .identifier("UIFont").dot("italicSystemFont").call([
                .labeled("ofSize", .constant(12))
            ])
        )

        assertTransformParsed(
            expression: "[UIFont systemFontOfFont:12 weight:UIFontWeightBold]",
            into: .identifier("UIFont").dot("systemFont").call([
                .labeled("ofSize", .constant(12)),
                .labeled("weight", .identifier("UIFont").dot("Weight").dot("bold")),
            ])
        )

        assertTransformParsed(
            expression: "[UIFont monospacedDigitSystemFontOfSize:12 weight:UIFontWeightBold]",
            into: .identifier("UIFont").dot("monospacedDigitSystemFont").call([
                .labeled("ofSize", .constant(12)),
                .labeled("weight", .identifier("UIFont").dot("Weight").dot("bold")),
            ])
        )
    }

    func testUIFontWeight() {
        assertTransformParsed(
            expression: "UIFontWeightUltraLight",
            into: .identifier("UIFont").dot("Weight").dot("ultraLight")
        )

        assertTransformParsed(
            expression: "UIFontWeightLight",
            into: .identifier("UIFont").dot("Weight").dot("light")
        )

        assertTransformParsed(
            expression: "UIFontWeightThin",
            into: .identifier("UIFont").dot("Weight").dot("thin")
        )

        assertTransformParsed(
            expression: "UIFontWeightRegular",
            into: .identifier("UIFont").dot("Weight").dot("regular")
        )

        assertTransformParsed(
            expression: "UIFontWeightMedium",
            into: .identifier("UIFont").dot("Weight").dot("medium")
        )

        assertTransformParsed(
            expression: "UIFontWeightSemibold",
            into: .identifier("UIFont").dot("Weight").dot("semibold")
        )

        assertTransformParsed(
            expression: "UIFontWeightBold",
            into: .identifier("UIFont").dot("Weight").dot("bold")
        )

        assertTransformParsed(
            expression: "UIFontWeightHeavy",
            into: .identifier("UIFont").dot("Weight").dot("heavy")
        )

        assertTransformParsed(
            expression: "UIFontWeightBlack",
            into: .identifier("UIFont").dot("Weight").dot("black")
        )
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

        assertTransformParsed(
            expression: "UITableViewCellSeparatorStyleSingleEtched",
            into: .identifier("UITableViewCell").dot("SeparatorStyle").dot("singleEtched")
        )

        assertTransformParsed(
            expression: "UITableViewCellSeparatorStyleSingleLineEtched",
            into: .identifier("UITableViewCell").dot("SeparatorStyle").dot("singleLineEtched")
        )
    }

    func testUITableViewCellSelectionStyle() {
        assertTransformParsed(
            expression: "UITableViewCellSelectionStyleNone",
            into: .identifier("UITableViewCell").dot("SelectionStyle").dot("none")
        )

        assertTransformParsed(
            expression: "UITableViewCellSelectionStyleBlue",
            into: .identifier("UITableViewCell").dot("SelectionStyle").dot("blue")
        )

        assertTransformParsed(
            expression: "UITableViewCellSelectionStyleGray",
            into: .identifier("UITableViewCell").dot("SelectionStyle").dot("gray")
        )

        assertTransformParsed(
            expression: "UITableViewCellSelectionStyleDefault",
            into: .identifier("UITableViewCell").dot("SelectionStyle").dot("default")
        )
    }

    func testEnumifyUIViewAnimationOptions() {
        assertTransform(
            expression: .identifier("UIViewAnimationOptionLayoutSubviews"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("layoutSubviews")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionAllowUserInteraction"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("allowUserInteraction")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionBeginFromCurrentState"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("beginFromCurrentState")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionRepeat"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("repeat")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionAutoreverse"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("autoreverse")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionOverrideInheritedDuration"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("overrideInheritedDuration")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionOverrideInheritedCurve"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("overrideInheritedCurve")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionAllowAnimatedContent"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("allowAnimatedContent")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionShowHideTransitionViews"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("showHideTransitionViews")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionOverrideInheritedOptions"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("overrideInheritedOptions")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionCurveEaseInOut"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("curveEaseInOut")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionCurveEaseIn"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("curveEaseIn")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionCurveEaseOut"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("curveEaseOut")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionCurveLinear"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("curveLinear")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionNone"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionNone")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionFlipFromLeft"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionFlipFromLeft")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionFlipFromRight"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionFlipFromRight")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionCurlUp"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionCurlUp")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionCurlDown"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionCurlDown")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionCrossDissolve"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionCrossDissolve")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionFlipFromTop"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionFlipFromTop")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionTransitionFlipFromBottom"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("transitionFlipFromBottom")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionPreferredFramesPerSecondDefault"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("preferredFramesPerSecondDefault")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionPreferredFramesPerSecond60"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("preferredFramesPerSecond60")
        )

        assertTransform(
            expression: .identifier("UIViewAnimationOptionPreferredFramesPerSecond30"),
            into:
                .identifier("UIView")
                .dot("AnimationOptions")
                .dot("preferredFramesPerSecond30")
        )

    }
}
