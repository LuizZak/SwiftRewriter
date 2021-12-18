import XCTest
import SwiftRewriterLib
import SwiftAST
import ExpressionPasses

class CoreGraphicsExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sutType = CoreGraphicsExpressionPass.self
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
    
    func testCoreGraphicsGetters() {
        assertTransformParsed(
            expression: "CGRectGetWidth(rect)",
            into: Expression.identifier("rect").dot("width")
        ); assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetHeight(rect)",
            into: Expression.identifier("rect").dot("height")
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
