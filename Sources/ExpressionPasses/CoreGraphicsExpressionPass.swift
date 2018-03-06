import Foundation
import SwiftRewriterLib
import SwiftAST
import Utils

public class CoreGraphicsExpressionPass: SyntaxNodeRewriterPass {
    
    private var transformers: [FunctionInvocationTransformer] = []
    
    public required init() {
        super.init()
        createCoreGraphicsTransformers()
    }
    
    public override func visitExpressions(_ stmt: ExpressionsStatement) -> Statement {
        // Remove CGPathRelease
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
        // CGRectMake(<x>, <y>, <width>, <height>) -> CGRect(x: <x>, y: <y>, width: <width>, height: <height>)
        case (.identifier("CGRectMake"), let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == 4 && !functionCall.arguments.hasLabeledArguments():
            
            let newArgs = functionCall.arguments.enumerated().map { (i, arg) -> FunctionArgument in
                let lbl: String
                switch i {
                case 0:
                    lbl = "x"
                case 1:
                    lbl = "y"
                case 2:
                    lbl = "width"
                case 3:
                    lbl = "height"
                default:
                    lbl = "_"
                }
                
                return .labeled(lbl, arg.expression)
            }
            
            exp.exp = .identifier("CGRect")
            exp.op = .functionCall(arguments: newArgs)
            
            notifyChange()
            
        // UIEdgeInsetsMake(<top>, <left>, <bottom>, <right>) -> UIEdgeInsets(top: <top>, left: <left>, bottom: <bottom>, right: <right>)
        case (.identifier("UIEdgeInsetsMake"), let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == 4 && !functionCall.arguments.hasLabeledArguments():
            
            let newArgs = functionCall.arguments.enumerated().map { (i, arg) -> FunctionArgument in
                let lbl: String
                switch i {
                case 0:
                    lbl = "top"
                case 1:
                    lbl = "left"
                case 2:
                    lbl = "bottom"
                case 3:
                    lbl = "right"
                default:
                    lbl = "_"
                }
                
                return .labeled(lbl, arg.expression)
            }
            
            exp.exp = .identifier("UIEdgeInsets")
            exp.op = .functionCall(arguments: newArgs)
            
            notifyChange()
            
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
    
    func createCoreGraphicsTransformers() {
        /// Default `transform` parameter handler
        let transform: FunctionInvocationTransformer.ArgumentStrategy =
            .omitIf(matches: .constant(.nil), .labeled("transform", .fromArgIndex(0)))
        
        func make(_ name: String, swiftName: String, arguments: [FunctionInvocationTransformer.ArgumentStrategy]) {
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
        
        make("CGPathAddRoundedRect", swiftName: "addRoundedRect",
             arguments: [
                .labeled("in", .fromArgIndex(1)),
                .labeled("cornerWidth", .fromArgIndex(2)),
                .labeled("cornerHeight", .fromArgIndex(3))
            ]
        )
        
        make("CGPathMoveToPoint", swiftName: "move",
             arguments: [
                .labeled("to", .mergeArguments(arg0: 1, arg1: 2, toCGPoint))
            ]
        )
        
        make("CGPathAddLineToPoint", swiftName: "addLine",
             arguments: [
                .labeled("to", .mergeArguments(arg0: 1, arg1: 2, toCGPoint))
            ]
        )
        
        make("CGPathAddQuadCurveToPoint", swiftName: "addQuadCurve",
             arguments: [
                .labeled("to", .mergeArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("control", .mergeArguments(arg0: 3, arg1: 4, toCGPoint))
            ]
        )
        
        make("CGPathAddCurveToPoint", swiftName: "addCurve",
             arguments: [
                .labeled("to", .mergeArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("control1", .mergeArguments(arg0: 3, arg1: 4, toCGPoint)),
                .labeled("control2", .mergeArguments(arg0: 5, arg1: 6, toCGPoint))
            ]
        )
        
        make("CGPathAddRect", swiftName: "addRect",
             arguments: [
                .fromArgIndex(1)
            ]
        )
        
        make("CGPathAddRects", swiftName: "addRects",
             arguments: [
                .fromArgIndex(1)
            ]
        )
        
        // TODO: This considers a `count` value. We need to make sure in case the
        // count is passed lower than the array's actual count that we keep the
        // same behavior.
        make("CGPathAddLines", swiftName: "addLines",
             arguments: [
                .labeled("between", .fromArgIndex(1))
            ]
        )
        
        make("CGPathAddEllipseInRect", swiftName: "addEllipse",
             arguments: [
                .labeled("in", .fromArgIndex(1))
            ]
        )
        
        make("CGPathAddRelativeArc", swiftName: "addRelativeArc",
             arguments: [
                .labeled("center", .mergeArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("radius", .fromArgIndex(3)),
                .labeled("startAngle", .fromArgIndex(4)),
                .labeled("delta", .fromArgIndex(5))
            ]
        )
        
        make("CGPathAddArc", swiftName: "addArc",
             arguments: [
                .labeled("center", .mergeArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("radius", .fromArgIndex(3)),
                .labeled("startAngle", .fromArgIndex(4)),
                .labeled("endAngle", .fromArgIndex(5)),
                .labeled("clockwise", .fromArgIndex(6))
            ]
        )
        
        make("CGPathAddArcToPoint", swiftName: "addArc",
             arguments: [
                .labeled("tangent1End", .mergeArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("tangent2End", .mergeArguments(arg0: 3, arg1: 4, toCGPoint)),
                .labeled("radius", .fromArgIndex(5))
            ]
        )
        
        make("CGPathAddPath", swiftName: "addPath",
             arguments: [
                .fromArgIndex(1)
            ]
        )
        
        make("CGPathAddPath", swiftName: "addPath",
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
