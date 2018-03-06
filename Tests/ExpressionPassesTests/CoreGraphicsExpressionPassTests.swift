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
            into: .postfix(.identifier("CGRect"),
                               .functionCall(arguments: [
                                    .labeled("x", .constant(1)),
                                    .labeled("y", .constant(2)),
                                    .labeled("width", .constant(3)),
                                    .labeled("height", .constant(4))
                                ])))
        
        assertNotifiedChange()
        
        assertTransformParsed(
            expression: "abc = [[UIView alloc] initWithFrame:CGRectMake(1, 2, 3, 4)]",
            into: .assignment(lhs: .identifier("abc"),
                                  op: .assign,
                                  rhs: .postfix(
                                    .postfix(
                                        .postfix(
                                            .postfix(.identifier("UIView"), .member("alloc")),
                                            .functionCall(arguments: [])), .member("initWithFrame")
                                    ),
                                    .functionCall(arguments: [.unlabeled(.postfix(.identifier("CGRect"),
                                                                                  .functionCall(arguments: [
                                                                                    .labeled("x", .constant(1)),
                                                                                    .labeled("y", .constant(2)),
                                                                                    .labeled("width", .constant(3)),
                                                                                    .labeled("height", .constant(4))
                                                                                    ])))])))
        )
        
        assertNotifiedChange()
    }
    
    func testUIEdgeInsetsMake() {
        assertTransformParsed(
            expression: "UIEdgeInsetsMake(1, 2, 3, 4)",
            into: .postfix(.identifier("UIEdgeInsets"),
                               .functionCall(arguments: [
                                .labeled("top", .constant(1)),
                                .labeled("left", .constant(2)),
                                .labeled("bottom", .constant(3)),
                                .labeled("right", .constant(4))
                                ])))
        
        assertNotifiedChange()
        
        assertTransformParsed(
            expression: "abc = [[UIView alloc] initWithInsets:UIEdgeInsetsMake(1, 2, 3, 4)]",
            into: .assignment(lhs: .identifier("abc"),
                                  op: .assign,
                                  rhs: .postfix(
                                    .postfix(
                                        .postfix(
                                            .postfix(.identifier("UIView"), .member("alloc")),
                                            .functionCall(arguments: [])), .member("initWithInsets")
                                    ),
                                    .functionCall(arguments: [.unlabeled(.postfix(.identifier("UIEdgeInsets"),
                                                                                  .functionCall(arguments: [
                                                                                    .labeled("top", .constant(1)),
                                                                                    .labeled("left", .constant(2)),
                                                                                    .labeled("bottom", .constant(3)),
                                                                                    .labeled("right", .constant(4))
                                                                                    ])))])))
        )
        
        assertNotifiedChange()
    }
    
    func testCGRecsGetters() {
        assertTransformParsed(
            expression: "CGRectGetWidth(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("width")))
        assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetHeight(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("height")))
        assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetMinX(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("minX")))
        assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetMaxX(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("maxX")))
        assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetMinY(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("minY")))
        assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetMaxY(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("maxY")))
        assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetMidX(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("midX")))
        assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectGetMidY(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("midY")))
        assertNotifiedChange()
        
        assertTransformParsed(
            expression: "CGRectIsNull(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("isNull")))
        assertNotifiedChange()
        
        // Test transformations keep unrecognized members alone
        assertTransformParsed(
            expression: "CGRectGetWidth(self.frame, self.frame)",
            into: "CGRectGetWidth(self.frame, self.frame)"); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetHeight(self.frame, self.frame)",
            into: "CGRectGetHeight(self.frame, self.frame)"); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetMinX(self.frame, self.frame)",
            into: "CGRectGetMinX(self.frame, self.frame)"); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetMinY(self.frame, self.frame)",
            into: "CGRectGetMinY(self.frame, self.frame)"); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetMaxX(self.frame, self.frame)",
            into: "CGRectGetMaxX(self.frame, self.frame)"); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetMaxY(self.frame, self.frame)",
            into: "CGRectGetMaxY(self.frame, self.frame)"); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetMidX(self.frame, self.frame)",
            into: "CGRectGetMidX(self.frame, self.frame)"); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectGetMidY(self.frame, self.frame)",
            into: "CGRectGetMidY(self.frame, self.frame)"); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "CGRectIsNull(self.frame, self.frame)",
            into: "CGRectIsNull(self.frame, self.frame)"); assertDidNotNotifyChange()
    }
    
    func testCGRectIsNullWithCGRectMake() {
        assertTransformParsed(
            expression: "CGRectIsNull(CGRectMake(1, 2, 3, 4))",
            into: .postfix(.postfix(.identifier("CGRect"),
                                        .functionCall(arguments: [
                                            .labeled("x", .constant(1)),
                                            .labeled("y", .constant(2)),
                                            .labeled("width", .constant(3)),
                                            .labeled("height", .constant(4))
                                            ])),
                               .member("isNull")))
        
        assertNotifiedChange()
    }
    
    func testCGRectContainsRectWithCGRectMake() {
        assertTransformParsed(
            expression: "CGRectContainsRect(CGRectMake(1, 2, 3, 4), CGRectMake(1, 2, 3, 4))",
            into: .postfix(.postfix(.postfix(.identifier("CGRect"),
                                        .functionCall(arguments: [
                                            .labeled("x", .constant(1)),
                                            .labeled("y", .constant(2)),
                                            .labeled("width", .constant(3)),
                                            .labeled("height", .constant(4))
                                            ])),
                                        .member("contains")),
                               .functionCall(arguments: [
                                .unlabeled(.postfix(.identifier("CGRect"),
                                                    .functionCall(arguments: [
                                                        .labeled("x", .constant(1)),
                                                        .labeled("y", .constant(2)),
                                                        .labeled("width", .constant(3)),
                                                        .labeled("height", .constant(4))
                                                        ])))
                                ])))
        
        assertNotifiedChange()
    }
    
    func testCGRectContainsPointWithCGPointMake() {
        assertTransformParsed(
            expression: "CGRectContainsPoint(CGRectMake(1, 2, 3, 4), CGPointMake(1, 2))",
            into: .postfix(.postfix(.postfix(.identifier("CGRect"),
                                                 .functionCall(arguments: [
                                                    .labeled("x", .constant(1)),
                                                    .labeled("y", .constant(2)),
                                                    .labeled("width", .constant(3)),
                                                    .labeled("height", .constant(4))
                                                    ])),
                                        .member("contains")),
                               .functionCall(arguments: [
                                .unlabeled(.postfix(.identifier("CGPoint"),
                                                    .functionCall(arguments: [
                                                        .labeled("x", .constant(1)),
                                                        .labeled("y", .constant(2))
                                                        ])))
                                ])))
        
        assertNotifiedChange()
    }
    
    func testCGRectIntersection() {
        assertTransformParsed(
            expression: "CGRectIntersection(self.frame, self.frame)",
            into: .postfix(.postfix(.postfix(.identifier("self"),
                                                 .member("frame")),
                                        .member("intersection")),
                               .functionCall(arguments: [
                                .unlabeled(.postfix(.identifier("self"),
                                                    .member("frame")))
                                ]))
        )
        
        assertNotifiedChange()
    }
    
    func testCGRectIntersectsRect() {
        assertTransformParsed(
            expression: "CGRectIntersectsRect(self.frame, self.frame)",
            into: .postfix(.postfix(.postfix(.identifier("self"),
                                                 .member("frame")),
                                        .member("intersects")),
                               .functionCall(arguments: [
                                .unlabeled(.postfix(.identifier("self"),
                                                    .member("frame")))
                                ]))
        )
        
        assertNotifiedChange()
    }
    
    func testCGPointMake() {
        assertTransformParsed(
            expression: "CGPointMake(1, 2)",
            into: .postfix(.identifier("CGPoint"),
                               .functionCall(arguments: [
                                .labeled("x", .constant(1)),
                                .labeled("y", .constant(2))
                                ]))
        )
        
        assertNotifiedChange()
        
        assertTransformParsed(
            expression: "abc = [[UIView alloc] initWithPoint:CGPointMake(1, 2)]",
            into: .assignment(lhs: .identifier("abc"),
                                  op: .assign,
                                  rhs: .postfix(
                                    .postfix(
                                        .postfix(
                                            .postfix(.identifier("UIView"), .member("alloc")),
                                            .functionCall(arguments: [])), .member("initWithPoint")
                                    ),
                                    .functionCall(arguments: [.unlabeled(.postfix(.identifier("CGPoint"),
                                                                                  .functionCall(arguments: [
                                                                                    .labeled("x", .constant(1)),
                                                                                    .labeled("y", .constant(2))
                                                                                    ])))])))
        )
        
        assertNotifiedChange()
    }
    
    func testCGSizeMake() {
        assertTransformParsed(
            expression: "CGSizeMake(1, 2)",
            into: .postfix(.identifier("CGSize"),
                               .functionCall(arguments: [
                                .labeled("width", .constant(1)),
                                .labeled("height", .constant(2))
                                ])
            )
        )
        
        assertNotifiedChange()
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
                    ]))
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
                    ]))
    }
    
    func testRemovesCGPathRelease() {
        assertTransform(
            statement: .expression(Expression.identifier("CGPathRelease").call([.identifier("a")])),
            into: .expressions([])
        )
    }
}
