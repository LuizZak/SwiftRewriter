import XCTest
import SwiftRewriterLib
import ExpressionPasses

class CoreGraphicsExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        sut = CoreGraphicsExpressionPass()
    }
    
    func testCGRectMake() {
        assertTransformParsed(
            original: "CGRectMake(1, 2, 3, 4)",
            expected: .postfix(.identifier("CGRect"),
                               .functionCall(arguments: [
                                    .labeled("x", .constant(1)),
                                    .labeled("y", .constant(2)),
                                    .labeled("width", .constant(3)),
                                    .labeled("height", .constant(4))
                                ])))
        
        assertTransformParsed(
            original: "abc = [[UIView alloc] initWithFrame:CGRectMake(1, 2, 3, 4)]",
            expected: .binary(lhs: .identifier("abc"),
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
            original: "UIEdgeInsetsMake(1, 2, 3, 4)",
            expected: .postfix(.identifier("UIEdgeInsets"),
                               .functionCall(arguments: [
                                .labeled("top", .constant(1)),
                                .labeled("left", .constant(2)),
                                .labeled("bottom", .constant(3)),
                                .labeled("right", .constant(4))
                                ])))
        
        assertTransformParsed(
            original: "abc = [[UIView alloc] initWithInsets:UIEdgeInsetsMake(1, 2, 3, 4)]",
            expected: .binary(lhs: .identifier("abc"),
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
            original: "CGRectGetWidth(self.frame)",
            expected: .postfix(.postfix(.identifier("self"), .member("frame")), .member("width")))
        
        assertTransformParsed(
            original: "CGRectGetHeight(self.frame)",
            expected: .postfix(.postfix(.identifier("self"), .member("frame")), .member("height")))
        
        assertTransformParsed(
            original: "CGRectGetMinX(self.frame)",
            expected: .postfix(.postfix(.identifier("self"), .member("frame")), .member("minX")))
        
        assertTransformParsed(
            original: "CGRectGetMaxX(self.frame)",
            expected: .postfix(.postfix(.identifier("self"), .member("frame")), .member("maxX")))
        
        assertTransformParsed(
            original: "CGRectGetMinY(self.frame)",
            expected: .postfix(.postfix(.identifier("self"), .member("frame")), .member("minY")))
        
        assertTransformParsed(
            original: "CGRectGetMaxY(self.frame)",
            expected: .postfix(.postfix(.identifier("self"), .member("frame")), .member("maxY")))
        
        assertTransformParsed(
            original: "CGRectIsNull(self.frame)",
            expected: .postfix(.postfix(.identifier("self"), .member("frame")), .member("isNull")))
        
        // Test transformations keep unrecognized members alone
        assertTransformParsed(
            original: "CGRectGetWidth(self.frame, self.frame)",
            expected: "CGRectGetWidth(self.frame, self.frame)")
        assertTransformParsed(
            original: "CGRectGetHeight(self.frame, self.frame)",
            expected: "CGRectGetHeight(self.frame, self.frame)")
        assertTransformParsed(
            original: "CGRectGetMinX(self.frame, self.frame)",
            expected: "CGRectGetMinX(self.frame, self.frame)")
        assertTransformParsed(
            original: "CGRectGetMinY(self.frame, self.frame)",
            expected: "CGRectGetMinY(self.frame, self.frame)")
        assertTransformParsed(
            original: "CGRectGetMaxX(self.frame, self.frame)",
            expected: "CGRectGetMaxX(self.frame, self.frame)")
        assertTransformParsed(
            original: "CGRectGetMaxY(self.frame, self.frame)",
            expected: "CGRectGetMaxY(self.frame, self.frame)")
        assertTransformParsed(
            original: "CGRectIsNull(self.frame, self.frame)",
            expected: "CGRectIsNull(self.frame, self.frame)")
    }
    
    func testCGRectIsNullWithCGRectMake() {
        assertTransformParsed(
            original: "CGRectIsNull(CGRectMake(1, 2, 3, 4))",
            expected: .postfix(.postfix(.identifier("CGRect"),
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
            original: "CGRectContainsRect(CGRectMake(1, 2, 3, 4), CGRectMake(1, 2, 3, 4))",
            expected: .postfix(.postfix(.postfix(.identifier("CGRect"),
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
            original: "CGRectContainsPoint(CGRectMake(1, 2, 3, 4), CGPointMake(1, 2))",
            expected: .postfix(.postfix(.postfix(.identifier("CGRect"),
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
    
    func testCGRectIntersects() {
        assertTransformParsed(
            original: "CGRectIntersection(self.frame, self.frame)",
            expected: .postfix(.postfix(.postfix(.identifier("self"),
                                                 .member("frame")),
                                        .member("intersection")),
                               .functionCall(arguments: [
                                .unlabeled(.postfix(.identifier("self"),
                                                    .member("frame")))
                                ]))
        )
    }
    
    func testCGPointMake() {
        assertTransformParsed(
            original: "CGPointMake(1, 2)",
            expected: .postfix(.identifier("CGPoint"),
                               .functionCall(arguments: [
                                .labeled("x", .constant(1)),
                                .labeled("y", .constant(2))
                                ])))
        
        assertTransformParsed(
            original: "abc = [[UIView alloc] initWithPoint:CGPointMake(1, 2)]",
            expected: .binary(lhs: .identifier("abc"),
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
}
