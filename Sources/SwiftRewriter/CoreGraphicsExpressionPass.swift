import SwiftRewriterLib

public class CoreGraphicsExpressionPass: ExpressionPass {
    
    public override func visitPostfix(_ exp: Expression, op: Postfix) -> Expression {
        // CGRectMake(<x>, <y>, <width>, <height>) -> CGRect(x: <x>, y: <y>, width: <width>, height: <height>)
        if case .identifier("CGRectMake") = exp, case .functionCall(let args) = op, args.count == 4 {
            // Check all arguments are unlabeled
            if args.contains(where: { if case .labeled = $0 { return true } else { return false } }) {
                return super.visitPostfix(exp, op: op)
            }
            
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
            
            return .postfix(.identifier("CGRect"), .functionCall(arguments: newArgs))
        }
        
        return super.visitPostfix(exp, op: op)
    }
}
