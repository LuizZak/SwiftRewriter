import SwiftRewriterLib
import Utils
import SwiftAST

/// Applies passes to simplify known UIKit methods and constructs
public class UIKitExpressionPass: SyntaxNodeRewriterPass {
    
    public override func visitIdentifier(_ exp: IdentifierExpression) -> Expression {
        // 'enumifications'
        if let exp = enumify(ident: exp.identifier, enumPrefix: "UIControlEvent", swiftEnumName: "UIControlEvents") {
            notifyChange()
            
            return super.visitExpression(exp)
        }
        
        return super.visitIdentifier(exp)
    }
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if let exp = convertUIColorStaticColorMethodCall(exp) {
            notifyChange()
            
            return super.visitExpression(exp)
        }
        if let exp = convertAddTargetForControlEvents(exp) {
            notifyChange()
            
            return super.visitExpression(exp)
        }
        if let exp = convertBooleanGetters(exp) {
            notifyChange()
            
            return super.visitExpression(exp)
        }
        
        return super.visitPostfix(exp)
    }
    
    /// Corrects boolean getters `.hidden` -> `.isHidden`, `.editable` -> `.isEditable`, etc.
    func convertBooleanGetters(_ exp: PostfixExpression) -> Expression? {
        // Make sure we're handling a UIView subclass here
        guard case .typeName(let typeName)? = exp.exp.resolvedType else {
            return nil
        }
        guard let member = exp.member else {
            return nil
        }
        
        if !context.typeSystem.isType(typeName, subtypeOf: "UIView") {
            return nil
        }
        
        switch member.name {
        case "hidden":
            exp.op = .member("isHidden")
            return exp
        case "editable":
            exp.op = .member("isEditable")
            return exp
        case "focused":
            exp.op = .member("isFocused")
            return exp
        case "firstResponder":
            exp.op = .member("isFirstResponder")
            return exp
        case "userInteractionEnabled":
            exp.op = .member("isUserInteractionEnabled")
            return exp
        case "opaque":
            exp.op = .member("isOpaque")
            return exp
        default:
            break
        }
        
        return nil
    }
    
    /// Converts UIColor.orangeColor() -> UIColor.orange, etc.
    func convertUIColorStaticColorMethodCall(_ exp: PostfixExpression) -> Expression? {
        guard let args = exp.functionCall?.arguments, args.count == 0 else {
            return nil
        }
        guard let colorMember = exp.exp.asPostfix, colorMember.exp == .identifier("UIColor"),
            let colorName = colorMember.member?.name else {
            return nil
        }
        guard colorName.hasSuffix("Color") && !colorName.replacingOccurrences(of: "Color", with: "").isEmpty else {
            return nil
        }
        
        exp.exp = .identifier("UIColor")
        exp.op = .member(String(colorName.dropLast("Color".count)))
        
        return exp
    }
    
    /// Converts [<exp> addTarget:<a1> action:<a2> forControlEvents:<a3>] -> <exp>.addTarget(<a1>, action: <a2>, for: <a3>)
    func convertAddTargetForControlEvents(_ exp: PostfixExpression) -> Expression? {
        guard let args = exp.functionCall?.arguments, args.count == 3 else {
            return nil
        }
        guard let memberExp = exp.exp.asPostfix, memberExp.op == .member("addTarget") else {
            return nil
        }
        
        // Arg0
        guard !args[0].isLabeled else {
            return nil
        }
        // action:
        guard args[1].label == "action" else {
            return nil
        }
        // forControlEvents:
        guard args[2].label == "forControlEvents" else {
            return nil
        }
        
        exp.op = .functionCall(arguments: [args[0], args[1], .labeled("for", args[2].expression)])
        
        return exp
    }
    
    /// 'Enumify' an identifier it such that it reads like a Swift enum, in case
    /// it matches one.
    ///
    /// E.g.: "UIControlEventTouchUpInside" enumified over "UIControlEvent" (Objective-C) to
    /// "UIControlEvents" (Swift)
    /// will return `.postfix(.identifier("UIControlEvents"), .member("touchUpInside"))`.
    func enumify(ident: String, enumPrefix: String, swiftEnumName: String) -> Expression? {
        if !ident.hasPrefix(enumPrefix) || ident == swiftEnumName {
            return nil
        }
        
        let suffix = ident.suffix(from: enumPrefix.endIndex)
        let enumCase = suffix.lowercasedFirstLetter
        
        return .postfix(.identifier(swiftEnumName), .member(enumCase))
    }
}
