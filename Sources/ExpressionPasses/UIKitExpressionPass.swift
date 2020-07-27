import Utils
import SwiftAST
import Commons

/// Applies passes to simplify known UIKit methods and constructs
public class UIKitExpressionPass: BaseExpressionPass {
    
    public required init(context: ASTRewriterPassContext) {
        super.init(context: context)
        
        makeEnumTransformers()
        makeFunctionTransformers()
    }
    
    public override func visitIdentifier(_ exp: IdentifierExpression) -> Expression {
        // 'enumifications'
        if let exp = enumify(ident: exp.identifier,
                             enumPrefix: "UIControlEvent",
                             swiftEnumName: Expression.identifier("UIControl").dot("Event")) {
            notifyChange()
            
            return visitExpression(exp)
        }
        if let exp = enumify(ident: exp.identifier,
                             enumPrefix: "UIGestureRecognizerState",
                             swiftEnumName: Expression.identifier("UIGestureRecognizer").dot("State")) {
            notifyChange()
            
            return visitExpression(exp)
        }
        if let exp = enumify(ident: exp.identifier,
                             enumPrefix: "UITableViewCellSeparatorStyle",
                             swiftEnumName: Expression.identifier("UITableViewCell").dot("SeparatorStyle")) {
            notifyChange()
            
            return visitExpression(exp)
        }
        if let exp = enumify(ident: exp.identifier,
                             enumPrefix: "UITableViewCellSelectionStyle",
                             swiftEnumName: Expression.identifier("UITableViewCell").dot("SelectionStyle")) {
            notifyChange()
            
            return visitExpression(exp)
        }
        if let exp = enumify(ident: exp.identifier,
                             enumPrefix: "UIViewAnimationOption",
                             swiftEnumName: Expression.identifier("UIView").dot("AnimationOptions")) {
            notifyChange()
            
            return visitExpression(exp)
        }
        
        return super.visitIdentifier(exp)
    }
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if let exp = convertAddTargetForControlEvents(exp) {
            notifyChange()
            
            return visitExpression(exp)
        }
        
        return super.visitPostfix(exp)
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
    /// "UIControl.Event" (Swift)
    /// will return `Expression.identifier("UIControl").dot("Events").dot("touchUpInside")`.
    func enumify(ident: String,
                 enumPrefix: String,
                 swiftEnumName: Expression) -> Expression? {
        
        if !ident.hasPrefix(enumPrefix) {
            return nil
        }
        
        let suffix = ident.suffix(from: enumPrefix.endIndex)
        let enumCase = suffix.lowercasedFirstLetter
        
        return swiftEnumName.dot(enumCase)
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
                .labeled("red"),
                .labeled("green"),
                .labeled("blue"),
                .labeled("alpha")
            ]
        )
        makeInit(
            typeName: "UIColor", method: "colorWithWhite", convertInto: .identifier("UIColor"),
            andCallWithArguments: [
                .labeled("white"),
                .labeled("alpha")
            ]
        )
    }
    
    func makeUIFontTransformers() {
        // UIFont.systemFontOfSize() -> UIFont.systemFont(ofSize:)
        makeInit(
            typeName: "UIFont", method: "systemFontOfSize",
            convertInto: Expression.identifier("UIFont").dot("systemFont"),
            andCallWithArguments: [.labeled("ofSize")],
            andTypeAs: .typeName("UIFont")
        )
        
        // UIFont.boldSystemFontOfSize() -> UIFont.boldSystemFont(ofSize:)
        makeInit(
            typeName: "UIFont", method: "boldSystemFontOfSize",
            convertInto: Expression.identifier("UIFont").dot("boldSystemFont"),
            andCallWithArguments: [.labeled("ofSize")],
            andTypeAs: .typeName("UIFont")
        )
        
        // UIFont.italicSystemFontOfFont() -> UIFont.italicSystemFont(ofSize:)
        makeInit(
            typeName: "UIFont", method: "italicSystemFontOfFont",
            convertInto: Expression.identifier("UIFont").dot("italicSystemFont"),
            andCallWithArguments: [.labeled("ofSize")],
            andTypeAs: .typeName("UIFont")
        )
        
        // UIFont.systemFontOfFont(_:weight:) -> UIFont.systemFont(ofSize:weight:)
        makeInit(
            typeName: "UIFont", method: "systemFontOfFont",
            convertInto: Expression.identifier("UIFont").dot("systemFont"),
            andCallWithArguments: [.labeled("ofSize"), .labeled("weight")],
            andTypeAs: .typeName("UIFont")
        )
        
        // UIFont.monospacedDigitSystemFontOfSize(_:weight:) -> UIFont.monospacedDigitSystemFont(ofSize:weight:)
        makeInit(
            typeName: "UIFont", method: "monospacedDigitSystemFontOfSize",
            convertInto: Expression.identifier("UIFont").dot("monospacedDigitSystemFont"),
            andCallWithArguments: [.labeled("ofSize"), .labeled("weight")],
            andTypeAs: .typeName("UIFont")
        )
    }
}
