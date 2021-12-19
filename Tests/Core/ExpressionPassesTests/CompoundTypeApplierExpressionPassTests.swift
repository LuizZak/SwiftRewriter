import XCTest
import SwiftRewriterLib
import SwiftAST

@testable import ExpressionPasses

class CompoundTypeApplierExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sutType = CompoundTypeApplierExpressionPass.self
    }

    func testUIColorConversions() {
        assertTransform(
            expression: Expression
                .identifier("UIColor")
                .typed(.metatype(for: "UIColor"))
                .dot("orangeColor")
                .call()
                .typed("UIColor"),
            into: Expression
                .identifier("UIColor")
                .typed(.metatype(for: "UIColor"))
                .dot("orange")
                .typed("UIColor")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: Expression
                .identifier("UIColor")
                .typed(.metatype(for: "UIColor"))
                .dot("redColor")
                .call()
                .typed("UIColor"),
            into: Expression
                .identifier("UIColor")
                .typed(.metatype(for: "UIColor"))
                .dot("red")
                .typed("UIColor")
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
    
    func testConvertUIViewBooleanGetters() {
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
            expression: makeGetter("userInteractionEnabled"),
            into: exp.dot("isUserInteractionEnabled")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("focused"),
            into: exp.dot("isFocused")
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

    func testStaticToConstructorTransformerLeniency() {
        // Test case for bug where any static postfix expression is incorrectly
        // transformed
        
        assertTransform(
            expression: Expression
                .identifier("Date")
                .typed(.metatype(for: "Date"))
                .dot("date").call(),
            into: Expression.identifier("Date").call()
        ); assertNotifiedChange()
        
        // This should not be transformed!
        assertTransform(
            expression: Expression
                .identifier("Date")
                .typed(.metatype(for: "Date"))
                .dot("class").call(),
            into: Expression.identifier("Date").dot("class").call()
        ); assertDidNotNotifyChange()
    }
    
    func testCGPointMake() {
        assertTransformParsed(
            expression: "CGPointMake(1, 2)",
            into: Expression
                .identifier("CGPoint").call([
                    .labeled("x", .constant(1)),
                    .labeled("y", .constant(2))
                    ])
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "abc = [[UIView alloc] initWithPoint:CGPointMake(1, 2)]",
            into:
            Expression
                .identifier("abc")
                .assignment(op: .assign,
                            rhs: Expression
                                .identifier("UIView")
                                .dot("alloc").call()
                                .dot("initWithPoint").call([
                                    Expression
                                        .identifier("CGPoint")
                                        .call([
                                            .labeled("x", .constant(1)),
                                            .labeled("y", .constant(2))
                                            ])
                                    ]))
        ); assertNotifiedChange()
    }
    
    func testCGRectConversions() {
        assertTransformParsed(
            expression: "CGRectGetWidth(self.frame)",
            into: Expression.identifier("self").dot("frame").dot("width")
        ); assertNotifiedChange()
    }
    
    func testCGRecsGetters() {
        assertTransformParsed(
            expression: "CGRectGetWidth(self.frame)",
            into: Expression.identifier("self").dot("frame").dot("width")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetHeight(self.frame)",
            into: Expression.identifier("self").dot("frame").dot("height")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetMinX(self.frame)",
            into: Expression.identifier("self").dot("frame").dot("minX")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetMaxX(self.frame)",
            into: Expression.identifier("self").dot("frame").dot("maxX")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetMinY(self.frame)",
            into: Expression.identifier("self").dot("frame").dot("minY")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetMaxY(self.frame)",
            into: Expression.identifier("self").dot("frame").dot("maxY")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetMidX(self.frame)",
            into: Expression.identifier("self").dot("frame").dot("midX")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetMidY(self.frame)",
            into: Expression.identifier("self").dot("frame").dot("midY")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectIsNull(self.frame)",
            into: Expression.identifier("self").dot("frame").dot("isNull")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectIsEmpty(self.frame)",
            into: Expression.identifier("self").dot("frame").dot("isEmpty")
        ); assertNotifiedChange()
        
        // Test transformations keep unrecognized members alone
        assertTransformParsed(
            expression: "CGRectGetWidth(self.frame, self.frame)",
            into: "CGRectGetWidth(self.frame, self.frame)"
        ); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetHeight(self.frame, self.frame)",
            into: "CGRectGetHeight(self.frame, self.frame)"
        ); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetMinX(self.frame, self.frame)",
            into: "CGRectGetMinX(self.frame, self.frame)"
        ); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetMinY(self.frame, self.frame)",
            into: "CGRectGetMinY(self.frame, self.frame)"
        ); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetMaxX(self.frame, self.frame)",
            into: "CGRectGetMaxX(self.frame, self.frame)"
        ); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetMaxY(self.frame, self.frame)",
            into: "CGRectGetMaxY(self.frame, self.frame)"
        ); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetMidX(self.frame, self.frame)",
            into: "CGRectGetMidX(self.frame, self.frame)"
        ); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetMidY(self.frame, self.frame)",
            into: "CGRectGetMidY(self.frame, self.frame)"
        ); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectIsNull(self.frame, self.frame)",
            into: "CGRectIsNull(self.frame, self.frame)"
        ); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectIsEmpty(self.frame, self.frame)",
            into: "CGRectIsEmpty(self.frame, self.frame)"
        ); assertDidNotNotifyChange()
    }
    
    func testCGRectIsNullWithCGRectMake() {
        assertTransformParsed(
            expression: "CGRectIsNull(CGRectMake(1, 2, 3, 4))",
            into: Expression
                .identifier("CGRect")
                .call([
                    .labeled("x", .constant(1)),
                    .labeled("y", .constant(2)),
                    .labeled("width", .constant(3)),
                    .labeled("height", .constant(4))
                ]).dot("isNull")
        ); assertNotifiedChange()
    }
    
    func testCGRectContainsRectWithCGRectMake() {
        assertTransformParsed(
            expression: "CGRectContainsRect(CGRectMake(1, 2, 3, 4), CGRectMake(1, 2, 3, 4))",
            into: Expression
                .identifier("CGRect").call([
                    .labeled("x", .constant(1)),
                    .labeled("y", .constant(2)),
                    .labeled("width", .constant(3)),
                    .labeled("height", .constant(4))
                ])
                .dot("contains").call([
                    Expression
                        .identifier("CGRect")
                        .call([
                            .labeled("x", .constant(1)),
                            .labeled("y", .constant(2)),
                            .labeled("width", .constant(3)),
                            .labeled("height", .constant(4))
                        ])
                    ])
        ); assertNotifiedChange()
    }
    
    func testCGRectContainsPointWithCGPointMake() {
        assertTransformParsed(
            expression: "CGRectContainsPoint(CGRectMake(1, 2, 3, 4), CGPointMake(1, 2))",
            into: Expression
                .identifier("CGRect").call([
                    .labeled("x", .constant(1)),
                    .labeled("y", .constant(2)),
                    .labeled("width", .constant(3)),
                    .labeled("height", .constant(4))
                ])
                .dot("contains").call([
                    Expression
                        .identifier("CGPoint")
                        .call([
                            .labeled("x", .constant(1)),
                            .labeled("y", .constant(2))
                        ])
                    ])
        ); assertNotifiedChange()
    }
    
    func testCGRectIntersection() {
        assertTransformParsed(
            expression: "CGRectIntersection(self.frame, self.frame)",
            into: Expression
                .identifier("self")
                .dot("frame")
                .dot("intersection").call([
                    Expression.identifier("self").dot("frame")
                ])
        ); assertNotifiedChange()
    }
    
    func testCGRectIntersectsRect() {
        assertTransformParsed(
            expression: "CGRectIntersectsRect(self.frame, self.frame)",
            into: Expression
                .identifier("self")
                .dot("frame")
                .dot("intersects").call([
                    Expression.identifier("self").dot("frame")
                ])
        ); assertNotifiedChange()
    }
    
    func testCGRectOffset() {
        assertTransformParsed(
            expression: "CGRectOffset(self.frame, 1, 2)",
            into: Expression
                .identifier("self")
                .dot("frame")
                .dot("offsetBy").call([
                    .labeled("dx", Expression.constant(1)),
                    .labeled("dy", Expression.constant(2))
                ])
        ); assertNotifiedChange()
    }
    
    func testCGRectInset() {
        assertTransformParsed(
            expression: "CGRectInset(self.frame, 1, 2)",
            into: Expression
                .identifier("self")
                .dot("frame")
                .dot("insetBy").call([
                    .labeled("dx", Expression.constant(1)),
                    .labeled("dy", Expression.constant(2))
                ])
        ); assertNotifiedChange()
    }
    
    func testCGRectEqualToRect() {
        assertTransformParsed(
            expression: "CGRectEqualToRect(self.frame, subview.frame)",
            into: Expression
                .identifier("self")
                .dot("frame")
                .dot("equalTo").call([
                    Expression.identifier("subview").dot("frame")
                ])
        ); assertNotifiedChange()
    }
    
    func testCGSizeMake() {
        assertTransformParsed(
            expression: "CGSizeMake(1, 2)",
            into:
            Expression
                .identifier("CGSize")
                .call([
                    .labeled("width", .constant(1)),
                    .labeled("height", .constant(2))
                ])
        ); assertNotifiedChange()
    }
}
