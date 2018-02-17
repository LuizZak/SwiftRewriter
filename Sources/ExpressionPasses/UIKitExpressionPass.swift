import SwiftRewriterLib

/// Applies passes to simplify known UIKit methods and constructs
public class UIKitExpressionPass: ExpressionPass {
    public override func visitPostfix(_ exp: Expression, op: Postfix) -> Expression {
        var (exp, op) = (exp, op)
        
        switch (exp, op) {
            
        // UIColor.orangeColor() -> UIColor.orange, etc.
        case (.postfix(.identifier("UIColor"), .member(let colorName)),
              .functionCall(arguments: [])) where colorName.hasSuffix("Color") && colorName.count > "Color".count:
            
            exp = .identifier("UIColor")
            op = .member(String(colorName.dropLast("Color".count)))
            
        default:
            break
        }
        
        return super.visitPostfix(exp, op: op)
    }
}
