import SwiftAST
import MiniLexer
import Utils

/// Converts Type.alloc().init[...]() expression chains into proper Type() calls.
public class AllocInitExpressionPass: ASTRewriterPass {
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if let newInit = convertAllocInit(exp: exp) {
            notifyChange()
            
            return visitExpression(newInit)
        }
        if let newInitParametrized = convertAllocInitWithParameters(exp: exp) {
            notifyChange()
            
            return visitExpression(newInitParametrized)
        }
        if let newInit = convertExpressionInit(exp: exp) {
            notifyChange()
            
            return visitExpression(newInit)
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
            return alloc.exp.copy().dot("init").call()
        }
        
        // super.alloc.init() -> super.init()
        if alloc.exp.asIdentifier?.identifier == "super", case .metatype? = alloc.exp.resolvedType {
            return alloc.exp.copy().dot("init").call()
        }
        
        return alloc.copy().exp.call()
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
            return alloc.exp.copy().dot("init").call(newArgs)
        }
        
        // super.alloc.init() -> super.init()
        if alloc.exp.asIdentifier?.identifier == "super", case .metatype? = alloc.exp.resolvedType {
            return alloc.exp.copy().dot("init").call(newArgs)
        }
        
        return .identifier(typeName).call(newArgs)
    }
    
    /// Convert [<exp> initWithThing:[...]] -> <exp>.init(thing: [...])
    func convertExpressionInit(exp: PostfixExpression) -> Expression? {
        guard let initInvocation = exp.asPostfix,
            let args = initInvocation.functionCall?.arguments, !args.isEmpty else {
            return nil
        }
        guard let initTarget = initInvocation.exp.asPostfix,
            let initName = initTarget.member?.name, initName.hasPrefix("initWith") else {
            return nil
        }
        
        let target = initTarget.exp.copy()
        
        let newArgs = swiftify(methodName: initName, arguments: args)
        
        if initTarget.op.optionalAccessKind != .none {
            return target.optional().dot("init").call(newArgs)
        }
        
        return target.dot("init").call(newArgs)
    }
    
    func swiftify(methodName: String, arguments: [FunctionArgument]) -> [FunctionArgument] {
        // Do a little Swift-importer-like-magic here: If the method selector is
        // in the form `loremWithThing:thing...`, we collapse such selector in
        // Swift as `lorem(thing:)`.
        let with = "With"
        
        let lexer = Lexer(input: methodName)
        guard let index = lexer.findNext(string: with) else {
            return arguments.map { $0.copy() }
        }
        guard let endIndex = methodName.index(index, offsetBy: with.count, limitedBy: methodName.endIndex) else {
            return arguments.map { $0.copy() }
        }
        guard endIndex < methodName.endIndex else {
            return arguments.map { $0.copy() }
        }
        
        let split: [Substring] = [
            methodName[..<index],
            methodName[endIndex...]
        ]
        
        // All good! Collapse the identifier into a more 'swifty' construct
        var arguments = arguments.map { $0.copy() }
        arguments[0] = .labeled(split[1].lowercasedFirstLetter, arguments[0].expression)
        
        return arguments
    }
}
