import XCTest
import SwiftRewriterLib
import SwiftAST
import ExpressionPasses

class CoreGraphicsExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sut = CoreGraphicsExpressionPass()
    }
    
    func testCGRectMake() {
        assertTransformParsed(
            expression: "CGRectMake(1, 2, 3, 4)",
            into: Expression
                .identifier("CGRect").call([
                    .labeled("x", .constant(1)),
                    .labeled("y", .constant(2)),
                    .labeled("width", .constant(3)),
                    .labeled("height", .constant(4))
                ])
        ); assertNotifiedChange()
        
        assertTransform(
            expression: Expression
                .identifier("abc")
                .assignment(op: .assign, rhs:
                    Expression.identifier("UIView")
                        .dot("alloc").call()
                        .dot("initWithFrame").call([
                            Expression.identifier("CGRectMake").call([
                                .unlabeled(.constant(1)),
                                .unlabeled(.constant(2)),
                                .unlabeled(.constant(3)),
                                .unlabeled(.constant(4)),
                            ])
                        ])
            ),
            into: Expression
                .identifier("abc")
                .assignment(op: .assign,
                            rhs: Expression
                                .identifier("UIView")
                                .dot("alloc").call()
                                .dot("initWithFrame")
                                .call([
                                    .unlabeled(Expression
                                        .identifier("CGRect")
                                        .call([
                                            .labeled("x", .constant(1)),
                                            .labeled("y", .constant(2)),
                                            .labeled("width", .constant(3)),
                                            .labeled("height", .constant(4))
                                        ]))
                                    ]))
        ); assertNotifiedChange()
    }
    
    func testUIEdgeInsetsMake() {
        assertTransformParsed(
            expression: "UIEdgeInsetsMake(1, 2, 3, 4)",
            into: Expression
                .identifier("UIEdgeInsets")
                .call([
                    .labeled("top", .constant(1)),
                    .labeled("left", .constant(2)),
                    .labeled("bottom", .constant(3)),
                    .labeled("right", .constant(4))
                ])
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "abc = [[UIView alloc] initWithInsets:UIEdgeInsetsMake(1, 2, 3, 4)]",
            into: Expression
                .identifier("abc")
                .assignment(op: .assign, rhs:
                    Expression
                        .identifier("UIView")
                        .dot("alloc").call()
                        .dot("initWithInsets")
                        .call([.unlabeled(
                            Expression
                            .identifier("UIEdgeInsets")
                            .call([
                                .labeled("top", .constant(1)),
                                .labeled("left", .constant(2)),
                                .labeled("bottom", .constant(3)),
                                .labeled("right", .constant(4))
                            ]))
                        ])
            )
        ); assertNotifiedChange()
    }
    
    func testCoreGraphicsStaticConstants() {
        
        assertTransformParsed(
            expression: "CGRectZero",
            into: Expression.identifier("CGRect").dot("zero")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectNull",
            into: Expression.identifier("CGRect").dot("null")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectInfinite",
            into: Expression.identifier("CGRect").dot("infinite")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGPointZero",
            into: Expression.identifier("CGPoint").dot("zero")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGSizeZero",
            into: Expression.identifier("CGSize").dot("zero")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGVectorZero",
            into: Expression.identifier("CGVector").dot("zero")
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
    
    func testConvertCGPathAddPoint() {
        assertTransformParsed(
            expression: "CGPathAddLineToPoint(path, nil, 1, 2)",
            into: Expression
                .identifier("path")
                .dot("addLine")
                .call([.labeled("to",
                                Expression
                                    .identifier("CGPoint")
                                    .call([
                                        .labeled("x", .constant(1)),
                                        .labeled("y", .constant(2))
                                    ]))
                    ])
        ); assertNotifiedChange()
    }
    
    func testConvertCGPathAddPointWithTransform() {
        assertTransformParsed(
            expression: "CGPathAddLineToPoint(path, t, 1, 2)",
            into: Expression
                .identifier("path")
                .dot("addLine")
                .call([.labeled("to",
                                Expression
                                    .identifier("CGPoint")
                                    .call([
                                        .labeled("x", .constant(1)),
                                        .labeled("y", .constant(2))
                                        ])),
                       .labeled("transform",
                                Expression.identifier("t"))
                        ])
        ); assertNotifiedChange()
    }
    
    func testRemovesCGPathRelease() {
        assertTransform(
            statement: .expression(Expression.identifier("CGPathRelease").call([.identifier("a")])),
            into: .expressions([])
        ); assertNotifiedChange()
    }
    
    func testCGContextStrokePath() {
        assertTransform(
            expression: Expression.identifier("CGContextStrokePath").call([.identifier("context")]),
            into: Expression.identifier("context").dot("strokePath").call()
        ); assertNotifiedChange()
    }
}
