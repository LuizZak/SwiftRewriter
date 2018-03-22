import SwiftRewriterLib
import Utils
import SwiftAST

/// Applies passes to simplify known UIKit methods and constructs
public class UIKitExpressionPass: BaseExpressionPass {
    
    public required init() {
        super.init()
        
        makeEnumTransformers()
        makeFunctionTransformers()
    }
    
    public override func visitIdentifier(_ exp: IdentifierExpression) -> Expression {
        // 'enumifications'
        if let exp = enumify(ident: exp.identifier,
                             enumPrefix: "UIControlEvent",
                             swiftEnumName: "UIControlEvents") {
            notifyChange()
            
            return super.visitExpression(exp)
        }
        if let exp = enumify(ident: exp.identifier,
                             enumPrefix: "UIGestureRecognizerState",
                             swiftEnumName: "UIGestureRecognizerState") {
            notifyChange()
            
            return super.visitExpression(exp)
        }
        if let exp = enumify(ident: exp.identifier,
                             enumPrefix: "UITableViewCellSeparatorStyle",
                             swiftEnumName: "UITableViewCellSeparatorStyle") {
            notifyChange()
            
            return super.visitExpression(exp)
        }
        if let exp = enumify(ident: exp.identifier,
                             enumPrefix: "UITableViewCellSelectionStyle",
                             swiftEnumName: "UITableViewCellSelectionStyle") {
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
        guard case .nominal(.typeName(let typeName))? = exp.exp.resolvedType?.deepUnwrapped else {
            return nil
        }
        guard let member = exp.member else {
            return nil
        }
        
        if !context.typeSystem.isType(typeName, subtypeOf: "UIView") {
            return nil
        }
        
        let makeMember: (String) -> Postfix = {
            let op = Postfix.member($0)
            op.hasOptionalAccess = exp.op.hasOptionalAccess
            
            return op
        }
        
        switch member.name {
        case "hidden":
            exp.op = makeMember("isHidden")
            return exp
        case "editable":
            exp.op = makeMember("isEditable")
            return exp
        case "focused":
            exp.op = makeMember("isFocused")
            return exp
        case "firstResponder":
            exp.op = makeMember("isFirstResponder")
            return exp
        case "userInteractionEnabled":
            exp.op = makeMember("isUserInteractionEnabled")
            return exp
        case "opaque":
            exp.op = makeMember("isOpaque")
            return exp
        default:
            break
        }
        
        return nil
    }
    
    /// Converts UIColor.orangeColor() -> UIColor.orange, etc.
    func convertUIColorStaticColorMethodCall(_ exp: PostfixExpression) -> Expression? {
        guard let args = exp.functionCall?.arguments, args.isEmpty else {
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
    
    /// Converts [<exp> addTarget:<a1> action:<a2> forControlEvents:<a3>]
    /// -> <exp>.addTarget(<a1>, action: <a2>, for: <a3>)
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

extension UIKitExpressionPass {
    func makeEnumTransformers() {
        makeNSTextAlignmentTransformers()
        makeUIFontEnumTransformers()
    }
    
    func makeFunctionTransformers() {
        makeUIFontTransformers()
        makeUIColorTransformes()
    }
}

extension UIKitExpressionPass {
    func makeNSTextAlignmentTransformers() {
        enumMappings["NSTextAlignmentLeft"] = {
            Expression.identifier("NSTextAlignment").dot("left")
        }
        enumMappings["NSTextAlignmentRight"] = {
            Expression.identifier("NSTextAlignment").dot("right")
        }
        enumMappings["NSTextAlignmentCenter"] = {
            Expression.identifier("NSTextAlignment").dot("center")
        }
    }
    
    func makeUIFontEnumTransformers() {
        enumMappings["UIFontWeightUltraLight"] = {
            Expression.identifier("UIFont").dot("Weight").dot("ultraLight")
        }
        enumMappings["UIFontWeightLight"] = {
            Expression.identifier("UIFont").dot("Weight").dot("light")
        }
        enumMappings["UIFontWeightThin"] = {
            Expression.identifier("UIFont").dot("Weight").dot("thin")
        }
        enumMappings["UIFontWeightRegular"] = {
            Expression.identifier("UIFont").dot("Weight").dot("regular")
        }
        enumMappings["UIFontWeightMedium"] = {
            Expression.identifier("UIFont").dot("Weight").dot("medium")
        }
        enumMappings["UIFontWeightSemibold"] = {
            Expression.identifier("UIFont").dot("Weight").dot("semibold")
        }
        enumMappings["UIFontWeightBold"] = {
            Expression.identifier("UIFont").dot("Weight").dot("bold")
        }
        enumMappings["UIFontWeightHeavy"] = {
            Expression.identifier("UIFont").dot("Weight").dot("heavy")
        }
        enumMappings["UIFontWeightBlack"] = {
            Expression.identifier("UIFont").dot("Weight").dot("black")
        }
    }
    
    func makeUIColorTransformes() {
        makeInit(
            typeName: "UIColor", method: "colorWithRed", convertInto: .identifier("UIColor"),
            andCallWithArguments: [
                .labeled("red", .asIs),
                .labeled("green", .asIs),
                .labeled("blue", .asIs),
                .labeled("alpha", .asIs)
            ]
        )
    }
    
    func makeUIFontTransformers() {
        // UIFont.systemFontOfSize() -> UIFont.systemFont(ofSize:)
        makeInit(
            typeName: "UIFont", method: "systemFontOfSize",
            convertInto: Expression.identifier("UIFont").dot("systemFont"),
            andCallWithArguments: [.labeled("ofSize", .asIs)],
            andTypeAs: .typeName("UIFont")
        )
        
        // UIFont.boldSystemFontOfSize() -> UIFont.boldSystemFont(ofSize:)
        makeInit(
            typeName: "UIFont", method: "boldSystemFontOfSize",
            convertInto: Expression.identifier("UIFont").dot("boldSystemFont"),
            andCallWithArguments: [.labeled("ofSize", .asIs)],
            andTypeAs: .typeName("UIFont")
        )
        
        // UIFont.italicSystemFontOfFont() -> UIFont.italicSystemFont(ofSize:)
        makeInit(
            typeName: "UIFont", method: "italicSystemFontOfFont",
            convertInto: Expression.identifier("UIFont").dot("italicSystemFont"),
            andCallWithArguments: [.labeled("ofSize", .asIs)],
            andTypeAs: .typeName("UIFont")
        )
        
        // UIFont.systemFontOfFont(_:weight:) -> UIFont.systemFont(ofSize:weight:)
        makeInit(
            typeName: "UIFont", method: "systemFontOfFont",
            convertInto: Expression.identifier("UIFont").dot("systemFont"),
            andCallWithArguments: [.labeled("ofSize", .asIs), .labeled("weight", .asIs)],
            andTypeAs: .typeName("UIFont")
        )
        
        // UIFont.monospacedDigitSystemFontOfSize(_:weight:) -> UIFont.monospacedDigitSystemFont(ofSize:weight:)
        makeInit(
            typeName: "UIFont", method: "monospacedDigitSystemFontOfSize",
            convertInto: Expression.identifier("UIFont").dot("monospacedDigitSystemFont"),
            andCallWithArguments: [.labeled("ofSize", .asIs), .labeled("weight", .asIs)],
            andTypeAs: .typeName("UIFont")
        )
    }
}
