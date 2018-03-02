import XCTest
import SwiftRewriterLib
import ExpressionPasses

class CoreGraphicsExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
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
    }
    
    func testCGRecsGetters() {
        assertTransformParsed(
            expression: "CGRectGetWidth(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("width")))
        
        assertTransformParsed(
            expression: "CGRectGetHeight(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("height")))
        
        assertTransformParsed(
            expression: "CGRectGetMinX(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("minX")))
        
        assertTransformParsed(
            expression: "CGRectGetMaxX(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("maxX")))
        
        assertTransformParsed(
            expression: "CGRectGetMinY(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("minY")))
        
        assertTransformParsed(
            expression: "CGRectGetMaxY(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("maxY")))
        
        assertTransformParsed(
            expression: "CGRectGetMidX(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("midX")))
        
        assertTransformParsed(
            expression: "CGRectGetMidY(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("midY")))
        
        assertTransformParsed(
            expression: "CGRectIsNull(self.frame)",
            into: .postfix(.postfix(.identifier("self"), .member("frame")), .member("isNull")))
        
        // Test transformations keep unrecognized members alone
        assertTransformParsed(
            expression: "CGRectGetWidth(self.frame, self.frame)",
            into: "CGRectGetWidth(self.frame, self.frame)")
        assertTransformParsed(
            expression: "CGRectGetHeight(self.frame, self.frame)",
            into: "CGRectGetHeight(self.frame, self.frame)")
        assertTransformParsed(
            expression: "CGRectGetMinX(self.frame, self.frame)",
            into: "CGRectGetMinX(self.frame, self.frame)")
        assertTransformParsed(
            expression: "CGRectGetMinY(self.frame, self.frame)",
            into: "CGRectGetMinY(self.frame, self.frame)")
        assertTransformParsed(
            expression: "CGRectGetMaxX(self.frame, self.frame)",
            into: "CGRectGetMaxX(self.frame, self.frame)")
        assertTransformParsed(
            expression: "CGRectGetMaxY(self.frame, self.frame)",
            into: "CGRectGetMaxY(self.frame, self.frame)")
        assertTransformParsed(
            expression: "CGRectGetMidX(self.frame, self.frame)",
            into: "CGRectGetMidX(self.frame, self.frame)")
        assertTransformParsed(
            expression: "CGRectGetMidY(self.frame, self.frame)",
            into: "CGRectGetMidY(self.frame, self.frame)")
        assertTransformParsed(
            expression: "CGRectIsNull(self.frame, self.frame)",
            into: "CGRectIsNull(self.frame, self.frame)")
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
    }
}
