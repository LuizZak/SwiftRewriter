import Foundation
import SwiftRewriterLib
import SwiftAST
import Utils

public class CoreGraphicsExpressionPass: BaseExpressionPass {
    public required init() {
        super.init()
        
        createTransformers()
    }
    
    public override func visitExpressions(_ stmt: ExpressionsStatement) -> Statement {
        // Remove CGPathRelease(<path>)
        stmt.expressions = stmt.expressions.compactMap { (exp: Expression) -> Expression? in
            guard let call = exp.asPostfix?.functionCall, let ident = exp.asPostfix?.exp.asIdentifier else {
                return exp
            }
            
            if ident.identifier == "CGPathRelease" && call.arguments.count == 1 && !call.arguments.hasLabeledArguments() {
                notifyChange()
                return nil
            }
            
            return exp
        }
        
        return super.visitExpressions(stmt)
    }
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        switch (exp.exp, exp.op) {
        // CGRectGetWidth(<exp>) -> <exp>.width
        case (.identifier("CGRectGetWidth"), _):
            convertMethodToField(field: "width", ifArgCountIs: 1, exp)
            
        // CGRectGetHeight(<exp>) -> <exp>.height
        case (.identifier("CGRectGetHeight"), _):
            convertMethodToField(field: "height", ifArgCountIs: 1, exp)
            
        // CGRectGet[Min/Max/Mid][X/Y](<exp>) -> <exp>.height
        case (.identifier("CGRectGetMinX"), _):
            convertMethodToField(field: "minX", ifArgCountIs: 1, exp)
        case (.identifier("CGRectGetMinY"), _):
            convertMethodToField(field: "minY", ifArgCountIs: 1, exp)
        case (.identifier("CGRectGetMaxX"), _):
            convertMethodToField(field: "maxX", ifArgCountIs: 1, exp)
        case (.identifier("CGRectGetMaxY"), _):
            convertMethodToField(field: "maxY", ifArgCountIs: 1, exp)
        case (.identifier("CGRectGetMidX"), _):
            convertMethodToField(field: "midX", ifArgCountIs: 1, exp)
        case (.identifier("CGRectGetMidY"), _):
            convertMethodToField(field: "midY", ifArgCountIs: 1, exp)
            
        // CGRectIsNull(<exp>) -> <exp>.isNull
        case (.identifier("CGRectIsNull"), _):
            convertMethodToField(field: "isNull", ifArgCountIs: 1, exp)
            
        // MARK: CGPath
            
        // CGPathCreateMutable() -> CGMutablePath()
        case (.identifier("CGPathCreateMutable"), .functionCall()):
            exp.exp.asIdentifier?.identifier = "CGMutablePath"
            
            notifyChange()
            
        // CGPathIsEmpty(<path>) -> <path>.isEmpty
        case (.identifier("CGPathIsEmpty"), _):
            convertMethodToField(field: "isEmpty", ifArgCountIs: 1, exp)
            
        // CGPathGetCurrentPoint(<path>) -> <path>.currentPoint
        case (.identifier("CGPathGetCurrentPoint"), _):
            convertMethodToField(field: "currentPoint", ifArgCountIs: 1, exp)
            
        // CGPathGetBoundingBox(<path>) -> <path>.boundingBox
        case (.identifier("CGPathGetBoundingBox"), _):
            convertMethodToField(field: "boundingBox", ifArgCountIs: 1, exp)
            
        // CGPathGetPathBoundingBox(<path>) -> <path>.boundingBoxOfPath
        case (.identifier("CGPathGetPathBoundingBox"), _):
            convertMethodToField(field: "boundingBoxOfPath", ifArgCountIs: 1, exp)
            
        default:
            break
        }
        
        return super.visitPostfix(exp)
    }
    
    /// Converts a method to a field access, e.g.: `CGRectGetWidth(<exp>)` -> `<exp>.width`.
    private func convertMethodToField(field: String, ifArgCountIs argCount: Int, _ exp: PostfixExpression) {
        switch (exp.exp, exp.op) {
        case (_ as IdentifierExpression, let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == argCount && !functionCall.arguments.hasLabeledArguments():
            
            exp.exp = functionCall.arguments[0].expression.accept(self)
            exp.op = .member(field)
            
            notifyChange()
        default:
            exp.exp = exp.exp.accept(self)
        }
    }
    
    func createTransformers() {
        // UIEdgeInsetsMake(<top>, <left>, <bottom>, <right>) -> UIEdgeInsets(top: <top>, left: <left>, bottom: <bottom>, right: <right>)
        makeFuncTransform("UIEdgeInsetsMake", swiftName: "UIEdgeInsets",
             arguments: [
                .labeled("top", .asIs), .labeled("left", .asIs),
                .labeled("bottom", .asIs), .labeled("right", .asIs)
            ])
        // CGointMake(<x>, <y>) -> CGPoint(x: <x>, y: <y>)
        makeFuncTransform("CGPointMake", swiftName: "CGPoint",
             arguments: [
                .labeled("x", .asIs), .labeled("y", .asIs)
            ])
        // CGRectMake(<x>, <y>, <width>, <height>) -> CGRect(x: <x>, y: <y>, width: <width>, height: <height>)
        makeFuncTransform("CGRectMake", swiftName: "CGRect",
             arguments: [
                .labeled("x", .asIs), .labeled("y", .asIs),
                .labeled("width", .asIs), .labeled("height", .asIs)
            ])
        // CGSizeMake(<width>, <height>) -> CGSize(width: <width>, height: <height>)
        makeFuncTransform("CGSizeMake", swiftName: "CGSize",
             arguments: [
                .labeled("width", .asIs), .labeled("height", .asIs)
            ])
        // CGRectIntersectsRect(<r1>, <r2>) -> <r1>.intersects(<r2>)
        makeFuncTransform("CGRectIntersectsRect", swiftName: "intersects", arguments: [.asIs],
             firstArgIsInstance: true)
        // CGRectIntersection(<r1>, <r2>) -> <r1>.intersection(<r2>)
        makeFuncTransform("CGRectIntersection", swiftName: "intersection", arguments: [.asIs],
             firstArgIsInstance: true)
        // CGRectContainsPoint(<r>, <p>) -> <r>.contains(<p>)
        makeFuncTransform("CGRectContainsPoint", swiftName: "contains", arguments: [.asIs],
             firstArgIsInstance: true)
        // CGRectContainsRect(<r1>, <r2>) -> <r1>.contains(<r2>)
        makeFuncTransform("CGRectContainsRect", swiftName: "contains", arguments: [.asIs],
             firstArgIsInstance: true)
        // CGRectOffset(<r>, <x>, <y>) -> <r>.offsetBy(dx: <x>, dy: <y>)
        makeFuncTransform("CGRectOffset", swiftName: "offsetBy",
                          arguments: [.labeled("dx", .asIs), .labeled("dy", .asIs)],
                          firstArgIsInstance: true)
        
        createCGPathTransformers()
    }
    
    func createCGPathTransformers() {
        /// Default `transform` parameter handler
        let transform: FunctionInvocationTransformer.ArgumentStrategy =
            .omitIf(matches: .constant(.nil), .labeled("transform", .fromArgIndex(0)))
        
        func makeInstanceCall(_ name: String,
                              swiftName: String,
                              arguments: [FunctionInvocationTransformer.ArgumentStrategy] = [.fromArgIndex(1)]) {
            let transformer =
                FunctionInvocationTransformer(name: name, swiftName: swiftName,
                                              firstArgumentBecomesInstance: true,
                                              arguments: arguments + [transform])
            
            transformers.append(transformer)
        }
        
        /// Converts two expressions into a CGPoint initializer
        let toCGPoint: (Expression, Expression) -> Expression = { x, y in
            Expression
                .identifier("CGPoint")
                .call([.labeled("x", x), .labeled("y", y)])
        }
        
        makeInstanceCall("CGPathAddRoundedRect", swiftName: "addRoundedRect",
             arguments: [
                .labeled("in", .fromArgIndex(1)),
                .labeled("cornerWidth", .fromArgIndex(2)),
                .labeled("cornerHeight", .fromArgIndex(3))
            ]
        )
        
        makeInstanceCall("CGPathMoveToPoint", swiftName: "move",
             arguments: [
                .labeled("to", .mergingArguments(arg0: 1, arg1: 2, toCGPoint))
            ]
        )
        
        makeInstanceCall("CGPathAddLineToPoint", swiftName: "addLine",
             arguments: [
                .labeled("to", .mergingArguments(arg0: 1, arg1: 2, toCGPoint))
            ]
        )
        
        makeInstanceCall("CGPathAddQuadCurveToPoint", swiftName: "addQuadCurve",
             arguments: [
                .labeled("to", .mergingArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("control", .mergingArguments(arg0: 3, arg1: 4, toCGPoint))
            ]
        )
        
        makeInstanceCall("CGPathAddCurveToPoint", swiftName: "addCurve",
             arguments: [
                .labeled("to", .mergingArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("control1", .mergingArguments(arg0: 3, arg1: 4, toCGPoint)),
                .labeled("control2", .mergingArguments(arg0: 5, arg1: 6, toCGPoint))
            ]
        )
        
        makeInstanceCall("CGPathAddRect", swiftName: "addRect", arguments: [.fromArgIndex(1)])
        
        makeInstanceCall("CGPathAddRects", swiftName: "addRects")
        
        // TODO: This considers a `count` value. We need to make sure in case the
        // count is passed lower than the array's actual count that we keep the
        // same behavior.
        makeInstanceCall("CGPathAddLines", swiftName: "addLines",
             arguments: [
                .labeled("between", .fromArgIndex(1))
            ]
        )
        
        makeInstanceCall("CGPathAddEllipseInRect", swiftName: "addEllipse",
             arguments: [
                .labeled("in", .fromArgIndex(1))
            ]
        )
        
        makeInstanceCall("CGPathAddRelativeArc", swiftName: "addRelativeArc",
             arguments: [
                .labeled("center", .mergingArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("radius", .fromArgIndex(3)),
                .labeled("startAngle", .fromArgIndex(4)),
                .labeled("delta", .fromArgIndex(5))
            ]
        )
        
        makeInstanceCall("CGPathAddArc", swiftName: "addArc",
             arguments: [
                .labeled("center", .mergingArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("radius", .fromArgIndex(3)),
                .labeled("startAngle", .fromArgIndex(4)),
                .labeled("endAngle", .fromArgIndex(5)),
                .labeled("clockwise", .fromArgIndex(6))
            ]
        )
        
        makeInstanceCall("CGPathAddArcToPoint", swiftName: "addArc",
             arguments: [
                .labeled("tangent1End", .mergingArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("tangent2End", .mergingArguments(arg0: 3, arg1: 4, toCGPoint)),
                .labeled("radius", .fromArgIndex(5))
            ]
        )
        
        makeInstanceCall("CGPathAddPath", swiftName: "addPath")
    }
}

internal extension Sequence where Element == FunctionArgument {
    func hasLabeledArguments() -> Bool {
        return any { $0.isLabeled }
    }
}
