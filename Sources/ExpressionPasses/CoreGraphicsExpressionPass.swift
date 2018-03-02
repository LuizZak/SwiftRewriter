import Foundation
import SwiftRewriterLib
import SwiftAST
import Utils

public class CoreGraphicsExpressionPass: SyntaxNodeRewriterPass {
    
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
            
            context.notifyChangedTree()
            
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
            
            context.notifyChangedTree()
            
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
            
            context.notifyChangedTree()
            
        // CGSizeMake(<width>, <height>) -> CGSize(width: <width>, height: <height>)
        case (.identifier("CGSizeMake"), let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == 2 && !functionCall.arguments.hasLabeledArguments():
            let args = functionCall.arguments
            
            exp.exp = .identifier("CGSize")
            exp.op = .functionCall(arguments: [
                .labeled("width", args[0].expression),
                .labeled("height", args[1].expression)
                ])
            
            context.notifyChangedTree()
            
        // CGRectIntersection(<r1>, <r2>) -> <r1>.intersection(<r2>)
        case (.identifier("CGRectIntersection"), let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == 2 && !functionCall.arguments.hasLabeledArguments():
            let args = functionCall.arguments
            
            exp.exp = .postfix(args[0].expression, .member("intersection"))
            exp.op = .functionCall(arguments: [
                .unlabeled(args[1].expression)
                ])
            
            context.notifyChangedTree()
            
        // CGRectIntersectsRect(<r1>, <r2>) -> <r1>.intersects(<r2>)
        case (.identifier("CGRectIntersectsRect"), let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == 2 && !functionCall.arguments.hasLabeledArguments():
            let args = functionCall.arguments
            
            exp.exp = .postfix(args[0].expression, .member("intersects"))
            exp.op = .functionCall(arguments: [
                .unlabeled(args[1].expression)
                ])
            
            context.notifyChangedTree()
            
        // CGRectContainsRect(<r1>, <r2>) -> <r1>.contains(<r2>)
        case (.identifier("CGRectContainsRect"), let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == 2 && !functionCall.arguments.hasLabeledArguments():
            let args = functionCall.arguments
            
            exp.exp = .postfix(args[0].expression, .member("contains"))
            exp.op = .functionCall(arguments: [
                .unlabeled(args[1].expression)
                ])
            
            context.notifyChangedTree()
            
        // CGRectContainsPoint(<r1>, <r2>) -> <r1>.contains(<r2>)
        case (.identifier("CGRectContainsPoint"), let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == 2 && !functionCall.arguments.hasLabeledArguments():
            let args = functionCall.arguments
            
            exp.exp = .postfix(args[0].expression, .member("contains"))
            exp.op = .functionCall(arguments: [
                .unlabeled(args[1].expression)
                ])
            
            context.notifyChangedTree()
            
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
            
            context.notifyChangedTree()
        default:
            exp.exp = exp.exp.accept(self)
        }
    }
}

internal extension Sequence where Element == FunctionArgument {
    func hasLabeledArguments() -> Bool {
        return any { $0.isLabeled }
    }
}
