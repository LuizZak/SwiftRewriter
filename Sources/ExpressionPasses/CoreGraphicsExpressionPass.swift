import Foundation
import SwiftRewriterLib
import SwiftAST
import Utils

public class CoreGraphicsExpressionPass: SyntaxNodeRewriterPass {
    
    private var transformers: [FunctionInvocationTransformer] = []
    
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
            
        // CGPointMake(<x>, <y>) -> CGPoint(x: <x>, y: <y>)
        case (.identifier("CGPointMake"), let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == 2 && !functionCall.arguments.hasLabeledArguments():
            let args = functionCall.arguments
            
            exp.exp = .identifier("CGPoint")
            exp.op = .functionCall(arguments: [
                .labeled("x", args[0].expression),
                .labeled("y", args[1].expression)
                ])
            
            notifyChange()
            
        // CGSizeMake(<width>, <height>) -> CGSize(width: <width>, height: <height>)
        case (.identifier("CGSizeMake"), let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == 2 && !functionCall.arguments.hasLabeledArguments():
            let args = functionCall.arguments
            
            exp.exp = .identifier("CGSize")
            exp.op = .functionCall(arguments: [
                .labeled("width", args[0].expression),
                .labeled("height", args[1].expression)
                ])
            
            notifyChange()
            
        // CGRectIntersection(<r1>, <r2>) -> <r1>.intersection(<r2>)
        case (.identifier("CGRectIntersection"), let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == 2 && !functionCall.arguments.hasLabeledArguments():
            let args = functionCall.arguments
            
            exp.exp = .postfix(args[0].expression, .member("intersection"))
            exp.op = .functionCall(arguments: [
                .unlabeled(args[1].expression)
                ])
            
            notifyChange()
            
        // CGRectIntersectsRect(<r1>, <r2>) -> <r1>.intersects(<r2>)
        case (.identifier("CGRectIntersectsRect"), let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == 2 && !functionCall.arguments.hasLabeledArguments():
            let args = functionCall.arguments
            
            exp.exp = .postfix(args[0].expression, .member("intersects"))
            exp.op = .functionCall(arguments: [
                .unlabeled(args[1].expression)
                ])
            
            notifyChange()
            
        // CGRectContainsRect(<r1>, <r2>) -> <r1>.contains(<r2>)
        case (.identifier("CGRectContainsRect"), let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == 2 && !functionCall.arguments.hasLabeledArguments():
            let args = functionCall.arguments
            
            exp.exp = .postfix(args[0].expression, .member("contains"))
            exp.op = .functionCall(arguments: [
                .unlabeled(args[1].expression)
                ])
            
            notifyChange()
            
        // CGRectContainsPoint(<r1>, <r2>) -> <r1>.contains(<r2>)
        case (.identifier("CGRectContainsPoint"), let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == 2 && !functionCall.arguments.hasLabeledArguments():
            let args = functionCall.arguments
            
            exp.exp = .postfix(args[0].expression, .member("contains"))
            exp.op = .functionCall(arguments: [
                .unlabeled(args[1].expression)
                ])
            
            notifyChange()
            
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
        
        if let transf = transformers.first(where: { $0.canApply(to: exp) }),
            let res = transf.attemptApply(on: exp) {
            notifyChange()
            
            return super.visitExpression(res)
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
        func make(_ name: String, swiftName: String, arguments: [FunctionInvocationTransformer.ArgumentStrategy]) {
            let transformer =
                FunctionInvocationTransformer(name: name, swiftName: swiftName,
                                              firstArgIsInstance: false,
                                              arguments: arguments)
            transformers.append(transformer)
        }
        
        // UIEdgeInsetsMake(<top>, <left>, <bottom>, <right>) -> UIEdgeInsets(top: <top>, left: <left>, bottom: <bottom>, right: <right>)
        make("UIEdgeInsetsMake", swiftName: "UIEdgeInsets",
             arguments: [
                .labeled("top", .asIs), .labeled("left", .asIs),
                .labeled("bottom", .asIs), .labeled("right", .asIs)
            ])
        // CGointMake(<x>, <y>) -> CGPoint(x: <x>, y: <y>)
        make("CGPointMake", swiftName: "CGPoint",
             arguments: [
                .labeled("x", .asIs), .labeled("y", .asIs)
            ])
        // CGRectMake(<x>, <y>, <width>, <height>) -> CGRect(x: <x>, y: <y>, width: <width>, height: <height>)
        make("CGRectMake", swiftName: "CGRect",
             arguments: [
                .labeled("x", .asIs), .labeled("y", .asIs),
                .labeled("width", .asIs), .labeled("height", .asIs)
            ])
        
        createCGPathTransformers()
    }
    
    func createCGPathTransformers() {
        /// Default `transform` parameter handler
        let transform: FunctionInvocationTransformer.ArgumentStrategy =
            .omitIf(matches: .constant(.nil), .labeled("transform", .fromArgIndex(0)))
        
        func makeInstance(_ name: String, swiftName: String, arguments: [FunctionInvocationTransformer.ArgumentStrategy]) {
            let transformer =
                FunctionInvocationTransformer(name: name, swiftName: swiftName,
                                              firstArgIsInstance: true,
                                              arguments: arguments + [transform])
            
            transformers.append(transformer)
        }
        
        /// Converts two expressions into a CGPoint initializer
        let toCGPoint: (Expression, Expression) -> Expression = { x, y in
            Expression
                .identifier("CGPoint")
                .call([.labeled("x", x), .labeled("y", y)])
        }
        
        makeInstance("CGPathAddRoundedRect", swiftName: "addRoundedRect",
             arguments: [
                .labeled("in", .fromArgIndex(1)),
                .labeled("cornerWidth", .fromArgIndex(2)),
                .labeled("cornerHeight", .fromArgIndex(3))
            ]
        )
        
        makeInstance("CGPathMoveToPoint", swiftName: "move",
             arguments: [
                .labeled("to", .mergeArguments(arg0: 1, arg1: 2, toCGPoint))
            ]
        )
        
        makeInstance("CGPathAddLineToPoint", swiftName: "addLine",
             arguments: [
                .labeled("to", .mergeArguments(arg0: 1, arg1: 2, toCGPoint))
            ]
        )
        
        makeInstance("CGPathAddQuadCurveToPoint", swiftName: "addQuadCurve",
             arguments: [
                .labeled("to", .mergeArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("control", .mergeArguments(arg0: 3, arg1: 4, toCGPoint))
            ]
        )
        
        makeInstance("CGPathAddCurveToPoint", swiftName: "addCurve",
             arguments: [
                .labeled("to", .mergeArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("control1", .mergeArguments(arg0: 3, arg1: 4, toCGPoint)),
                .labeled("control2", .mergeArguments(arg0: 5, arg1: 6, toCGPoint))
            ]
        )
        
        makeInstance("CGPathAddRect", swiftName: "addRect",
             arguments: [
                .fromArgIndex(1)
            ]
        )
        
        makeInstance("CGPathAddRects", swiftName: "addRects",
             arguments: [
                .fromArgIndex(1)
            ]
        )
        
        // TODO: This considers a `count` value. We need to make sure in case the
        // count is passed lower than the array's actual count that we keep the
        // same behavior.
        makeInstance("CGPathAddLines", swiftName: "addLines",
             arguments: [
                .labeled("between", .fromArgIndex(1))
            ]
        )
        
        makeInstance("CGPathAddEllipseInRect", swiftName: "addEllipse",
             arguments: [
                .labeled("in", .fromArgIndex(1))
            ]
        )
        
        makeInstance("CGPathAddRelativeArc", swiftName: "addRelativeArc",
             arguments: [
                .labeled("center", .mergeArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("radius", .fromArgIndex(3)),
                .labeled("startAngle", .fromArgIndex(4)),
                .labeled("delta", .fromArgIndex(5))
            ]
        )
        
        makeInstance("CGPathAddArc", swiftName: "addArc",
             arguments: [
                .labeled("center", .mergeArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("radius", .fromArgIndex(3)),
                .labeled("startAngle", .fromArgIndex(4)),
                .labeled("endAngle", .fromArgIndex(5)),
                .labeled("clockwise", .fromArgIndex(6))
            ]
        )
        
        makeInstance("CGPathAddArcToPoint", swiftName: "addArc",
             arguments: [
                .labeled("tangent1End", .mergeArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("tangent2End", .mergeArguments(arg0: 3, arg1: 4, toCGPoint)),
                .labeled("radius", .fromArgIndex(5))
            ]
        )
        
        makeInstance("CGPathAddPath", swiftName: "addPath",
             arguments: [
                .fromArgIndex(1)
            ]
        )
        
        makeInstance("CGPathAddPath", swiftName: "addPath",
             arguments: [
                .fromArgIndex(1)
            ]
        )
    }
}

internal extension Sequence where Element == FunctionArgument {
    func hasLabeledArguments() -> Bool {
        return any { $0.isLabeled }
    }
}
