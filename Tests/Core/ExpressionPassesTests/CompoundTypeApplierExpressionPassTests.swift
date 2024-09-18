import SwiftAST
import SwiftRewriterLib
import XCTest

@testable import ExpressionPasses

class CompoundTypeApplierExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()

        sutType = CompoundTypeApplierExpressionPass.self
    }

    func testUIColorConversions() {
        assertTransform(
            expression:
                .identifier("UIColor")
                .typed(.metatype(for: "UIColor"))
                .dot("orangeColor")
                .call()
                .typed("UIColor"),
            into:
                .identifier("UIColor")
                .typed(.metatype(for: "UIColor"))
                .dot("orange")
                .typed("UIColor")
        )

        assertTransform(
            expression:
                .identifier("UIColor")
                .typed(.metatype(for: "UIColor"))
                .dot("redColor")
                .call()
                .typed("UIColor"),
            into:
                .identifier("UIColor")
                .typed(.metatype(for: "UIColor"))
                .dot("red")
                .typed("UIColor")
        )

        // Test unrecognized cases are left alone
        assertNoTransformParsed(
            expression: "UIColor->redColor"
        )
        assertNoTransformParsed(
            expression: "[UIColor redColor:@1]"
        )
        assertNoTransformParsed(
            expression: "[UIColor Color:@1]"
        )
    }

    func testConvertUIViewBooleanGetters() {
        let _exp = Expression.identifier("view")
        _exp.resolvedType = .typeName("UIView")

        var exp: SwiftAST.Expression {
            return _exp.copy()
        }

        let makeGetter: (String) -> SwiftAST.Expression = {
            return exp.dot($0)
        }

        assertTransform(
            expression: makeGetter("opaque"),
            into: exp.dot("isOpaque")
        )

        assertTransform(
            expression: makeGetter("hidden"),
            into: exp.dot("isHidden")
        )

        assertTransform(
            expression: makeGetter("userInteractionEnabled"),
            into: exp.dot("isUserInteractionEnabled")
        )

        assertTransform(
            expression: makeGetter("focused"),
            into: exp.dot("isFocused")
        )
    }

    func testUIViewAnimateWithDuration() {
        assertTransform(
            expression:
                .identifier("UIView")
                .typed(.metatype(for: .typeName("UIView")))
                .dot("animateWithDuration")
                .call([
                    .unlabeled(.constant(0.3)),
                    .labeled("animations", .block(body: [])),
                ]),
            into:
                .identifier("UIView")
                .dot("animate")
                .call([
                    .labeled("withDuration", .constant(0.3)),
                    .labeled("animations", .block(body: [])),
                ])
        )
    }

    func testStaticToConstructorTransformerLeniency() {
        // Test case for bug where any static postfix expression is incorrectly
        // transformed

        assertTransform(
            expression:
                .identifier("Date")
                .typed(.metatype(for: "Date"))
                .dot("date").call(),
            into: .identifier("Date").call()
        )

        // This should not be transformed!
        assertNoTransform(
            expression:
                .identifier("Date")
                .typed(.metatype(for: "Date"))
                .dot("class").call()
        )
    }

    func testCGPointMake() {
        assertTransformParsed(
            expression: "CGPointMake(1, 2)",
            into:
                .identifier("CGPoint").call([
                    .labeled("x", .constant(1)),
                    .labeled("y", .constant(2)),
                ])
        )

        assertTransformParsed(
            expression: "abc = [[UIView alloc] initWithPoint:CGPointMake(1, 2)]",
            into:
                .identifier("abc")
                .assignment(
                    op: .assign,
                    rhs:
                        .identifier("UIView")
                        .dot("alloc").call()
                        .dot("initWithPoint")
                        .call([
                            .identifier("CGPoint")
                                .call([
                                    .labeled("x", .constant(1)),
                                    .labeled("y", .constant(2)),
                                ])
                        ])
                )
        )
    }

    func testCGRectConversions() {
        assertTransformParsed(
            expression: "CGRectGetWidth(self.frame)",
            into: .identifier("self").dot("frame").dot("width")
        )
    }

    func testCGRecsGetters() {
        assertTransformParsed(
            expression: "CGRectGetWidth(self.frame)",
            into: .identifier("self").dot("frame").dot("width")
        )

        assertTransformParsed(
            expression: "CGRectGetHeight(self.frame)",
            into: .identifier("self").dot("frame").dot("height")
        )

        assertTransformParsed(
            expression: "CGRectGetMinX(self.frame)",
            into: .identifier("self").dot("frame").dot("minX")
        )

        assertTransformParsed(
            expression: "CGRectGetMaxX(self.frame)",
            into: .identifier("self").dot("frame").dot("maxX")
        )

        assertTransformParsed(
            expression: "CGRectGetMinY(self.frame)",
            into: .identifier("self").dot("frame").dot("minY")
        )

        assertTransformParsed(
            expression: "CGRectGetMaxY(self.frame)",
            into: .identifier("self").dot("frame").dot("maxY")
        )

        assertTransformParsed(
            expression: "CGRectGetMidX(self.frame)",
            into: .identifier("self").dot("frame").dot("midX")
        )

        assertTransformParsed(
            expression: "CGRectGetMidY(self.frame)",
            into: .identifier("self").dot("frame").dot("midY")
        )

        assertTransformParsed(
            expression: "CGRectIsNull(self.frame)",
            into: .identifier("self").dot("frame").dot("isNull")
        )

        assertTransformParsed(
            expression: "CGRectIsEmpty(self.frame)",
            into: .identifier("self").dot("frame").dot("isEmpty")
        )

        // Test transformations keep unrecognized members alone
        assertNoTransformParsed(
            expression: "CGRectGetWidth(self.frame, self.frame)"
        )
        assertNoTransformParsed(
            expression: "CGRectGetHeight(self.frame, self.frame)"
        )
        assertNoTransformParsed(
            expression: "CGRectGetMinX(self.frame, self.frame)"
        )
        assertNoTransformParsed(
            expression: "CGRectGetMinY(self.frame, self.frame)"
        )
        assertNoTransformParsed(
            expression: "CGRectGetMaxX(self.frame, self.frame)"
        )
        assertNoTransformParsed(
            expression: "CGRectGetMaxY(self.frame, self.frame)"
        )
        assertNoTransformParsed(
            expression: "CGRectGetMidX(self.frame, self.frame)"
        )
        assertNoTransformParsed(
            expression: "CGRectGetMidY(self.frame, self.frame)"
        )
        assertNoTransformParsed(
            expression: "CGRectIsNull(self.frame, self.frame)"
        )
        assertNoTransformParsed(
            expression: "CGRectIsEmpty(self.frame, self.frame)"
        )
    }

    func testCGRectIsNullWithCGRectMake() {
        assertTransformParsed(
            expression: "CGRectIsNull(CGRectMake(1, 2, 3, 4))",
            into:
                .identifier("CGRect")
                .call([
                    .labeled("x", .constant(1)),
                    .labeled("y", .constant(2)),
                    .labeled("width", .constant(3)),
                    .labeled("height", .constant(4)),
                ]).dot("isNull")
        )
    }

    func testCGRectContainsRectWithCGRectMake() {
        assertTransformParsed(
            expression: "CGRectContainsRect(CGRectMake(1, 2, 3, 4), CGRectMake(1, 2, 3, 4))",
            into:
                .identifier("CGRect").call([
                    .labeled("x", .constant(1)),
                    .labeled("y", .constant(2)),
                    .labeled("width", .constant(3)),
                    .labeled("height", .constant(4)),
                ])
                .dot("contains")
                .call([
                    .identifier("CGRect")
                        .call([
                            .labeled("x", .constant(1)),
                            .labeled("y", .constant(2)),
                            .labeled("width", .constant(3)),
                            .labeled("height", .constant(4)),
                        ])
                ])
        )
    }

    func testCGRectContainsPointWithCGPointMake() {
        assertTransformParsed(
            expression: "CGRectContainsPoint(CGRectMake(1, 2, 3, 4), CGPointMake(1, 2))",
            into:
                .identifier("CGRect").call([
                    .labeled("x", .constant(1)),
                    .labeled("y", .constant(2)),
                    .labeled("width", .constant(3)),
                    .labeled("height", .constant(4)),
                ])
                .dot("contains")
                .call([
                    .identifier("CGPoint")
                        .call([
                            .labeled("x", .constant(1)),
                            .labeled("y", .constant(2)),
                        ])
                ])
        )
    }

    func testCGRectIntersection() {
        assertTransformParsed(
            expression: "CGRectIntersection(self.frame, self.frame)",
            into:
                .identifier("self")
                .dot("frame")
                .dot("intersection").call([
                    .identifier("self").dot("frame")
                ])
        )
    }

    func testCGRectIntersectsRect() {
        assertTransformParsed(
            expression: "CGRectIntersectsRect(self.frame, self.frame)",
            into:
                .identifier("self")
                .dot("frame")
                .dot("intersects").call([
                    .identifier("self").dot("frame")
                ])
        )
    }

    func testCGRectOffset() {
        assertTransformParsed(
            expression: "CGRectOffset(self.frame, 1, 2)",
            into:
                .identifier("self")
                .dot("frame")
                .dot("offsetBy").call([
                    .labeled("dx", .constant(1)),
                    .labeled("dy", .constant(2)),
                ])
        )
    }

    func testCGRectInset() {
        assertTransformParsed(
            expression: "CGRectInset(self.frame, 1, 2)",
            into:
                .identifier("self")
                .dot("frame")
                .dot("insetBy").call([
                    .labeled("dx", .constant(1)),
                    .labeled("dy", .constant(2)),
                ])
        )
    }

    func testCGRectEqualToRect() {
        assertTransformParsed(
            expression: "CGRectEqualToRect(self.frame, subview.frame)",
            into:
                .identifier("self")
                .dot("frame")
                .dot("equalTo").call([
                    .identifier("subview").dot("frame")
                ])
        )
    }

    func testCGSizeMake() {
        assertTransformParsed(
            expression: "CGSizeMake(1, 2)",
            into:
                Expression
                .identifier("CGSize")
                .call([
                    .labeled("width", .constant(1)),
                    .labeled("height", .constant(2)),
                ])
        )
    }
}
