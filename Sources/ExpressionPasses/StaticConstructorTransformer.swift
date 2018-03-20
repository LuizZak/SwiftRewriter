import SwiftAST

/// Transforms static type initializers into other expression constructs.
///
/// Example:
/// ```
/// StaticConstructorTransformer(
///     typeName: "NSTimeZone",
///     kind: .property("systemTimeZone"),
///     conversion: Expression.identifier("TimeZone").dot("current"))
/// ```
///
/// would perform conversions of the form:
///
/// ```
/// NSTimeZone.systemTimeZone
/// // or
/// [NSTimeZone systemTimeZone]
/// ```
///
/// into a Swift equivalent:
///
/// ```
/// TimeZone.current
/// ```
///
/// There's also support for method transformers that work on expressions that are
/// static constructors:
///
/// ```
/// StaticConstructorTransformer(
///     typeName: "NSLocale",
///     kind: .method("localeWithLocaleIdentifier", .labeled("identifier", .asIs)),
///     conversion: Expression.identifier("Locale"))
/// ```
///
/// which would transform into (method call is appended to `conversion` expression
/// automatically):
///
/// ```
/// [NSLocale localeWithLocaleIdentifier:@"en_US"]
/// ```
///
/// to Swift:
///
/// ```
/// Locale(identifier: "en_US")
/// ```
final class StaticConstructorTransformer {
    let typeName: String
    let kind: Kind
    let leading: () -> Expression
    
    init(typeName: String, kind: Kind, leading: @escaping () -> Expression) {
        self.typeName = typeName
        self.kind = kind
        self.leading = leading
    }
    
    func attemptApply(on postfix: PostfixExpression) -> Expression? {
        switch kind {
        case .property(let property):
            // For properties, accessing via '.' or via function call are
            // semantically equivalent in Objective-C.
            if postfix.exp.asIdentifier?.identifier == typeName && postfix.op == .member(property) {
                if postfix.parent is PostfixExpression {
                    return nil
                }
                
                return leading()
            }
            guard postfix.exp.asPostfix?.exp.asIdentifier?.identifier == typeName else {
                return nil
            }
            guard let call = postfix.functionCall, call.arguments.isEmpty else {
                return nil
            }
            guard let inner = postfix.exp.asPostfix, inner.member?.name == property else {
                return nil
            }
            
            return leading()
        case .method(let methodName, let args):
            let transformer =
                FunctionInvocationTransformer(
                    objcFunctionName: "", toSwiftFunction: "",
                    firstArgumentBecomesInstance: false,
                    arguments: args)
            
            guard let call = postfix.functionCall,
                let result = transformer.attemptApply(on: call, name: "", firstArgIsInstance: false, args: args) else {
                return nil
            }
            guard let inner = postfix.exp.asPostfix, inner.member?.name == methodName else {
                return nil
            }
            
            let base = leading()
            
            return base.call(result.arguments)
        }
    }
    
    enum Kind {
        case property(String)
        case method(String, [FunctionInvocationTransformer.ArgumentStrategy])
    }
}
