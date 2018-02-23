import Foundation
import SwiftRewriterLib
import SwiftAST

public class CoreGraphicsExpressionPass: SyntaxNodeRewriterPass {
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        switch (exp.exp, exp.op) {
        // CGRectMake(<x>, <y>, <width>, <height>) -> CGRect(x: <x>, y: <y>, width: <width>, height: <height>)
        case (.identifier("CGRectMake"), .functionCall(let args)) where args.count == 4 && !args.hasLabeledArguments():
            let newArgs = args.enumerated().map { (i, arg) -> FunctionArgument in
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
            
        // UIEdgeInsetsMake(<top>, <left>, <bottom>, <right>) -> UIEdgeInsets(top: <top>, left: <left>, bottom: <bottom>, right: <right>)
        case (.identifier("UIEdgeInsetsMake"), .functionCall(let args)) where args.count == 4 && !args.hasLabeledArguments():
            let newArgs = args.enumerated().map { (i, arg) -> FunctionArgument in
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
        case (.identifier("CGPointMake"), .functionCall(let args)) where args.count == 2 && !args.hasLabeledArguments():
            exp.exp = .identifier("CGPoint")
            exp.op = .functionCall(arguments: [
                .labeled("x", args[0].expression),
                .labeled("y", args[1].expression)
                ])
            
        // CGSizeMake(<width>, <height>) -> CGSize(width: <width>, height: <height>)
        case (.identifier("CGSizeMake"), .functionCall(let args)) where args.count == 2 && !args.hasLabeledArguments():
            exp.exp = .identifier("CGSize")
            exp.op = .functionCall(arguments: [
                .labeled("width", args[0].expression),
                .labeled("height", args[1].expression)
                ])
            
        // CGRectIntersection(<r1>, <r2>) -> <r1>.intersection(<r2>)
        case (.identifier("CGRectIntersection"), .functionCall(let args)) where args.count == 2 && !args.hasLabeledArguments():
            exp.exp = .postfix(args[0].expression, .member("intersection"))
            exp.op = .functionCall(arguments: [
                .unlabeled(args[1].expression)
                ])
            
        // CGRectIntersectsRect(<r1>, <r2>) -> <r1>.intersects(<r2>)
        case (.identifier("CGRectIntersectsRect"), .functionCall(let args)) where args.count == 2 && !args.hasLabeledArguments():
            exp.exp = .postfix(args[0].expression, .member("intersects"))
            exp.op = .functionCall(arguments: [
                .unlabeled(args[1].expression)
                ])
            
        // CGRectContainsRect(<r1>, <r2>) -> <r1>.contains(<r2>)
        case (.identifier("CGRectContainsRect"), .functionCall(let args)) where args.count == 2 && !args.hasLabeledArguments():
            exp.exp = .postfix(args[0].expression, .member("contains"))
            exp.op = .functionCall(arguments: [
                .unlabeled(args[1].expression)
                ])
            
        // CGRectContainsPoint(<r1>, <r2>) -> <r1>.contains(<r2>)
        case (.identifier("CGRectContainsPoint"), .functionCall(let args)) where args.count == 2 && !args.hasLabeledArguments():
            exp.exp = .postfix(args[0].expression, .member("contains"))
            exp.op = .functionCall(arguments: [
                .unlabeled(args[1].expression)
                ])
            
        default:
            break
        }
        
        return super.visitPostfix(exp)
    }
    
    /// Converts a method to a field access, e.g.: `CGRectGetWidth(<exp>)` -> `<exp>.width`.
    private func convertMethodToField(field: String, ifArgCountIs argCount: Int, _ exp: PostfixExpression) {
        switch (exp.exp, exp.op) {
        case (_ as IdentifierExpression, .functionCall(let args)) where args.count == argCount && !args.hasLabeledArguments():
            exp.exp = args[0].expression.accept(self)
            exp.op = .member(field)
        default:
            exp.exp = exp.exp.accept(self)
        }
    }
}

internal extension Sequence where Element == FunctionArgument {
    func hasLabeledArguments() -> Bool {
        return any(pass: { $0.isLabeled })
    }
}

internal extension Sequence {
    func none(pass predicate: (Element) -> Bool) -> Bool {
        return !any(pass: predicate)
    }
    
    func all(pass predicate: (Element) -> Bool) -> Bool {
        for item in self {
            if !predicate(item) {
                return false
            }
        }
        
        return true
    }
    
    func any(pass predicate: (Element) -> Bool) -> Bool {
        for item in self {
            if predicate(item) {
                return true
            }
        }
        
        return false
    }
}
