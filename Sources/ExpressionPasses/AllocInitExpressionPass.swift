import Foundation
import SwiftRewriterLib
import SwiftAST

/// Converts Type.alloc().init[...]() expression chains into proper Type() calls.
public class AllocInitExpressionPass: ASTRewriterPass {
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if let newInit = convertAllocInit(exp: exp) {
            notifyChange()
            
            return super.visitExpression(newInit)
        }
        if let newInitParametrized = convertAllocInitWithParameters(exp: exp) {
            notifyChange()
            
            return super.visitExpression(newInitParametrized)
        }
        if let newInit = convertSuperInit(exp: exp) {
            notifyChange()
            
            return super.visitExpression(newInit)
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
        guard let alloc = allocInvocation.exp.asPostfix,
            alloc.exp is IdentifierExpression, alloc.op == .member("alloc") else {
            return nil
        }
        
        // self.alloc.init() -> self.init()
        if alloc.exp.asIdentifier?.identifier == "self", case .metatype? = alloc.exp.resolvedType {
            return alloc.exp.dot("init").call()
        }
        
        return alloc.exp.call()
    }
    
    /// Converts `[[Class alloc] initWithThing:[...]]` -> `Class(thing: [...])`
    /// and `[[self alloc] initWithThing:[...]]` -> `self.init(thing: [...])`
    func convertAllocInitWithParameters(exp: PostfixExpression) -> Expression? {
        guard let initInvocation = exp.asPostfix,
            let args = initInvocation.functionCall?.arguments, !args.isEmpty else {
            return nil
        }
        guard let initTarget = initInvocation.exp.asPostfix,
            let initName = initTarget.member?.name, initName.hasPrefix("initWith") else {
            return nil
        }
        guard let allocInvocation = initTarget.exp.asPostfix, allocInvocation.op == .functionCall(arguments: []) else {
            return nil
        }
        guard let alloc = allocInvocation.exp.asPostfix,
            let typeName = alloc.exp.asIdentifier?.identifier, alloc.op == .member("alloc") else {
            return nil
        }
        
        let newArgs = swiftify(methodName: initName, arguments: args)
        
        // self.alloc.init() -> self.init()
        if alloc.exp.asIdentifier?.identifier == "self", case .metatype? = alloc.exp.resolvedType {
            return alloc.exp.dot("init").call(newArgs)
        }
        
        return Expression.identifier(typeName).call(newArgs)
    }
    
    /// Convert [super initWithThing:[...]] -> super.init(thing: [...])
    func convertSuperInit(exp: PostfixExpression) -> Expression? {
        guard let initInvocation = exp.asPostfix,
            let args = initInvocation.functionCall?.arguments, !args.isEmpty else {
            return nil
        }
        guard let initTarget = initInvocation.exp.asPostfix,
            let initName = initTarget.member?.name, initName.hasPrefix("initWith") else {
            return nil
        }
        guard let superTarget = initTarget.exp.asIdentifier, superTarget.identifier == "super" else {
            return nil
        }
        
        let newArgs = swiftify(methodName: initName, arguments: args)
        
        return Expression.identifier("super").dot("init").call(newArgs)
    }
    
    func swiftify(methodName: String, arguments: [FunctionArgument]) -> [FunctionArgument] {
        // Do a little Swift-importer-like-magic here: If the method selector is
        // in the form `loremWithThing:thing...`, where after a `[...]With`
        // prefix, a noun is followed by a parameter that has the same name, we
        // collapse such selector in Swift as `lorem(with:)`.
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
