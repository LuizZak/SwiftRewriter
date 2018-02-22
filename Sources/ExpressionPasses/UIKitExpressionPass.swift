import SwiftRewriterLib
import Utils

/// Applies passes to simplify known UIKit methods and constructs
public class UIKitExpressionPass: ExpressionPass {
    public override func visitIdentifier(_ exp: IdentifierExpression) -> Expression {
        return super.visitIdentifier(exp)
        /*
        // 'enumifications'
        if identifier.hasPrefix("UIControlEvent") {
            return enumify(ident: identifier, enumPrefix: "UIControlEvent", swiftEnumName: "UIControlEvents")
        }
        
        return .identifier(identifier)
        */
    }
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        return super.visitPostfix(exp)
        /*
        var (exp, op) = (exp, op)
        
        switch (exp, op) {
            
        // UIColor.orangeColor() -> UIColor.orange, etc.
        case (.postfix(.identifier("UIColor"), .member(let colorName)),
              .functionCall(arguments: [])) where colorName.hasSuffix("Color") && colorName.count > "Color".count:
            
            exp = .identifier("UIColor")
            op = .member(String(colorName.dropLast("Color".count)))
            
            
        // [<exp> addTarget:<a1> action:<a2> forControlEvents:<a3>] -> <exp>.addTarget(<a1>, action: <a2>, for: <a3>)
        case (.postfix(_, .member("addTarget")),
              .functionCall(let args)) where args.count == 3:
            
            // Arg0
            guard case .unlabeled = args[0] else {
                break
            }
            // action:
            guard case .labeled("action", _) = args[1] else {
                break
            }
            // forControlEvents:
            guard case .labeled("forControlEvents", let controlEvents) = args[2] else {
                break
            }
            
            op = .functionCall(arguments: [
                args[0],
                args[1],
                .labeled("for", controlEvents)
                ])
        default:
            break
        }
        
        return super.visitPostfix(exp, op: op)
        */
    }
    
    /// 'Enumify' an identifier it such that it reads like a Swift enum, in case
    /// it matches one.
    ///
    /// E.g.: "UIControlEventTouchUpInside" enumified over "UIControlEvent" (Objective-C) to
    /// "UIControlEvents" (Swift)
    /// will return `.postfix(.identifier("UIControlEvents"), .member("touchUpInside"))`.
    func enumify(ident: String, enumPrefix: String, swiftEnumName: String) -> Expression {
        if !ident.hasPrefix(enumPrefix) {
            return .identifier(ident)
        }
        
        let suffix = ident.suffix(from: enumPrefix.endIndex)
        let enumCase = suffix.lowercasedFirstLetter
        
        return .postfix(.identifier(swiftEnumName), .member(enumCase))
    }
}
