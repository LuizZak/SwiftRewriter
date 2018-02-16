import SwiftRewriterLib

/// Applies passes to simplify known Foundation methods
public class FoundationExpressionPass: ExpressionPass {
    
    public override init() {
        super.init()
        inspectBlocks = true
    }
    
    public override func visitPostfix(_ exp: Expression, op: Postfix) -> Expression {
        var (exp, op) = (exp, op)
        
        switch (exp, op) {
        case (.postfix(let innerExp, .member("isEqualToString")),
              .functionCall(arguments: let args))
            where args.count == 1 && !args.hasLabeledArguments():
            
            return visitBinary(lhs: innerExp, op: .equals, rhs: args[0].expression)
            
        case (.postfix(.identifier("NSString"), .member("stringWithFormat")),
              .functionCall(let args)) where args.count > 0:
            let newArgs: [FunctionArgument] = [
                .labeled("format", args[0].expression),
            ] + args.dropFirst()
            
            (exp, op) = (.identifier("String"), .functionCall(arguments: newArgs))
        default:
            break
        }
        
        return super.visitPostfix(exp, op: op)
    }
}
