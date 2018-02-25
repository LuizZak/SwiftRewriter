import Foundation
import SwiftRewriterLib
import SwiftAST

/// Converts Type.alloc().init[...]() expression chains into proper Type() calls.
public class AllocInitExpressionPass: SyntaxNodeRewriterPass {
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if let newInit = convertAllocInit(exp: exp) {
            return newInit
        }
        if let newInitParametrized = convertAllocInitWithParameters(exp: exp) {
            return newInitParametrized
        }
        if let newInit = convertSuperInit(exp: exp) {
            return newInit
        }
        
        return super.visitPostfix(exp)
    }
    
    /// Converts plain `[[Class alloc] init]` -> `Class()` and
    /// `[[self alloc] init]` -> `self.init()`
    func convertAllocInit(exp: PostfixExpression) -> Expression? {
        guard let initInvocation = exp.asPostfix, initInvocation.op == .functionCall(arguments: []) else {
            return nil
        }
        guard let initTarget = initInvocation.exp.asPostfix, initTarget.op == .member("init") else {
            return nil
        }
        guard let allocInvocation = initTarget.exp.asPostfix, allocInvocation.op == .functionCall(arguments: []) else {
            return nil
        }
        guard let alloc = allocInvocation.exp.asPostfix, alloc.exp is IdentifierExpression, alloc.op == .member("alloc") else {
            return nil
        }
        
        // self.alloc.init() -> self.init()
        if alloc.exp.asIdentifier?.identifier == "self", case .metatype? = alloc.exp.resolvedType {
            return .postfix(.postfix(alloc.exp, .member("init")), .functionCall(arguments: []))
        }
        
        return .postfix(alloc.exp, .functionCall(arguments: []))
    }
    
    /// Converts `[[Class alloc] initWithThing:[...]]` -> `Class(thing: [...])`
    /// and `[[self alloc] initWithThing:[...]]` -> `self.init(thing: [...])`
    func convertAllocInitWithParameters(exp: PostfixExpression) -> Expression? {
        guard let initInvocation = exp.asPostfix, case .functionCall(let args) = initInvocation.op, args.count > 0 else {
            return nil
        }
        guard let initTarget = initInvocation.exp.asPostfix, case .member(let initName) = initTarget.op, initName.hasPrefix("initWith") else {
            return nil
        }
        guard let allocInvocation = initTarget.exp.asPostfix, allocInvocation.op == .functionCall(arguments: []) else {
            return nil
        }
        guard let alloc = allocInvocation.exp.asPostfix, let typeName = alloc.exp.asIdentifier?.identifier, alloc.op == .member("alloc") else {
            return nil
        }
        
        let newArgs = clangify(methodName: initName, arguments: args)
        
        // self.alloc.init() -> self.init()
        if alloc.exp.asIdentifier?.identifier == "self", case .metatype? = alloc.exp.resolvedType {
            return .postfix(.postfix(alloc.exp, .member("init")), .functionCall(arguments: newArgs))
        }
        
        return .postfix(.identifier(typeName), .functionCall(arguments: newArgs))
    }
    
    /// Convert [super initWithThing:[...]] -> super.init(thing: [...])
    func convertSuperInit(exp: PostfixExpression) -> Expression? {
        guard let initInvocation = exp.asPostfix, case .functionCall(let args) = initInvocation.op, args.count > 0 else {
            return nil
        }
        guard let initTarget = initInvocation.exp.asPostfix, case .member(let initName) = initTarget.op, initName.hasPrefix("initWith") else {
            return nil
        }
        guard let superTarget = initTarget.exp.asIdentifier, superTarget.identifier == "super" else {
            return nil
        }
        
        let newArgs = clangify(methodName: initName, arguments: args)
        
        return .postfix(.postfix(.identifier("super"), .member("init")), .functionCall(arguments: newArgs))
    }
    
    func clangify(methodName: String, arguments: [FunctionArgument]) -> [FunctionArgument] {
        // Do a little Clang-like-magic here: If the method selector is in the
        // form `loremWithThing:thing...`, where after a `[...]With` prefix, a
        // noun is followed by a parameter that has the same name, we collapse
        // such selector in Swift as `lorem(with:)`.
        let split = methodName.components(separatedBy: "With")
        if split.count != 2 || split.contains(where: { $0.count < 2 }) {
            return arguments
        }
        
        // All good! Collapse the identifier into a more 'swifty' construct
        var arguments = arguments
        arguments[0] = .labeled(split[1].lowercasedFirstLetter, arguments[0].expression)
        
        return arguments
    }
}
