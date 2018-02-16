import Foundation
import SwiftRewriterLib

public class CoreGraphicsExpressionPass: ExpressionPass {
    
    public override func visitPostfix(_ exp: Expression, op: Postfix) -> Expression {
        switch (exp, op) {
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
                
                return .labeled(lbl, arg.expression.accept(self))
            }
            
            return .postfix(.identifier("CGRect"), .functionCall(arguments: newArgs))
            
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
                
                return .labeled(lbl, arg.expression.accept(self))
            }
            
            return .postfix(.identifier("UIEdgeInsets"), .functionCall(arguments: newArgs))
            
        // CGRectGetWidth(<exp>) -> <exp>.width
        case (.identifier("CGRectGetWidth"), _):
            return convertMethodToField(field: "width", exp, op)
            
        // CGRectGetHeight(<exp>) -> <exp>.height
        case (.identifier("CGRectGetHeight"), _):
            return convertMethodToField(field: "height", exp, op)
            
        // CGRectGet[Min/Max][X/Y](<exp>) -> <exp>.height
        case (.identifier("CGRectGetMinX"), _):
            return convertMethodToField(field: "minX", exp, op)
        case (.identifier("CGRectGetMinY"), _):
            return convertMethodToField(field: "minY", exp, op)
        case (.identifier("CGRectGetMaxX"), _):
            return convertMethodToField(field: "maxX", exp, op)
        case (.identifier("CGRectGetMaxY"), _):
            return convertMethodToField(field: "maxY", exp, op)
            
        // CGRectIsNull(<exp>) -> <exp>.isNull
        case (.identifier("CGRectIsNull"), _):
            return convertMethodToField(field: "isNull", exp, op)
            
        // CGPointMake(<x>, <y>) -> CGPoint(x: <x>, y: <y>)
        case (.identifier("CGPointMake"), .functionCall(let args)) where args.count == 2 && !args.hasLabeledArguments():
            return .postfix(.identifier("CGPoint"),
                            .functionCall(arguments: [
                                .labeled("x", args[0].expression.accept(self)),
                                .labeled("y", args[1].expression.accept(self))
                                ]))
            
        // CGRectIntersection(<r1>, <r2>) -> <r1>.intersection(<r2>)
        case (.identifier("CGRectIntersection"), .functionCall(let args)) where args.count == 2 && !args.hasLabeledArguments():
            return .postfix(.postfix(args[0].expression.accept(self), .member("intersection")),
                            .functionCall(arguments: [
                                .unlabeled(args[1].expression.accept(self))
                                ]))
            
        // CGRectIntersectsRect(<r1>, <r2>) -> <r1>.intersects(<r2>)
        case (.identifier("CGRectIntersectsRect"), .functionCall(let args)) where args.count == 2 && !args.hasLabeledArguments():
            return .postfix(.postfix(args[0].expression.accept(self), .member("intersects")),
                            .functionCall(arguments: [
                                .unlabeled(args[1].expression.accept(self))
                                ]))
            
        // CGRectContainsRect(<r1>, <r2>) -> <r1>.contains(<r2>)
        case (.identifier("CGRectContainsRect"), .functionCall(let args)) where args.count == 2 && !args.hasLabeledArguments():
            return .postfix(.postfix(args[0].expression.accept(self), .member("contains")),
                            .functionCall(arguments: [
                                .unlabeled(args[1].expression.accept(self))
                                ]))
            
        // CGRectContainsPoint(<r1>, <r2>) -> <r1>.contains(<r2>)
        case (.identifier("CGRectContainsPoint"), .functionCall(let args)) where args.count == 2 && !args.hasLabeledArguments():
            return .postfix(.postfix(args[0].expression.accept(self), .member("contains")),
                            .functionCall(arguments: [
                                .unlabeled(args[1].expression.accept(self))
                                ]))
            
        default:
            return super.visitPostfix(exp, op: op)
        }
    }
    
    /// Converts a method to a field access, e.g.: `CGRectGetWidth(<exp>)` -> `<exp>.width`.
    private func convertMethodToField(field: String, _ exp: Expression, _ op: Postfix) -> Expression {
        switch (exp, op) {
        case (.identifier, .functionCall(let args)) where args.count == 1 && !args.hasLabeledArguments():
            return .postfix(args[0].expression.accept(self), .member(field))
        default:
            return .postfix(exp.accept(self), op)
        }
    }
}

private extension Sequence where Element == FunctionArgument {
    func hasLabeledArguments() -> Bool {
        return any(pass: { $0.isLabeled })
    }
}

private extension Sequence {
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
