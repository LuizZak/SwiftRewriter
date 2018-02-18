import Foundation
import SwiftRewriterLib

/// Converts Type.alloc().init[...]() expression chains into proper Type() calls.
public class AllocInitExpressionPass: ExpressionPass {
    
    public override init() {
        super.init()
        inspectBlocks = true
    }
    
    public override func visitPostfix(_ exp: Expression, op: Postfix) -> Expression {
        var (exp, op) = (exp, op)
        
        switch (exp, op) {
        // Plain [[Class alloc] init] -> Class()
        case (.postfix(.postfix(.postfix(.identifier(let typeName),
                                         .member("alloc")),
                                .functionCall(arguments: [])),
                       .member("init")),
              .functionCall(let args))
            where args.count == 0:
            
            (exp, op) = (.identifier(typeName), .functionCall(arguments: []))
            
        // [[Class alloc] initWithThing:[...]] -> Class(thing: [...])
        case (.postfix(.postfix(.postfix(.identifier(let typeName),
                                         .member("alloc")),
                                .functionCall(arguments: [])),
                       .member(let initCall)),
              .functionCall(let args)) where args.count > 0 && initCall.hasPrefix("initWith"):
            
            let args = clangify(methodName: initCall, arguments: args)
            (exp, op) = (.identifier(typeName), .functionCall(arguments: args))
        
        // [super initWithThing:[...]] -> super.init(thing: [...])
        case (.postfix(.identifier("super"),
                       .member(let initMethod)),
              .functionCall(let args)) where args.count > 0 && initMethod.hasPrefix("initWith"):
            
            let args = clangify(methodName: initMethod, arguments: args)
            (exp, op) = (.postfix(.identifier("super"), .member("init")),
                         .functionCall(arguments: args))
        default:
            break
        }
        
        return super.visitPostfix(exp, op: op)
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
