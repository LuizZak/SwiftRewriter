import Foundation
import SwiftRewriterLib

/// Converts Type.alloc().init[...]() expression chains into proper Type() calls.
public class AllocInitExpressionPass: ExpressionPass {
    public override func visitPostfix(_ exp: Expression, op: Postfix) -> Expression {
        switch (exp, op) {
        // Plain [[Class alloc] init] -> Class()
        case (.postfix(.postfix(.postfix(.identifier(let typeName),
                                         .member("alloc")),
                                .functionCall(arguments: [])),
                       .member(let initCall)),
              .functionCall(arguments: let args))
            where initCall == "init" && args.count == 0:
            
            return .postfix(.identifier(typeName), .functionCall(arguments: []))
            
        // [[Class alloc] initWithThing:[...]] -> Class(thing: [...])
        case (.postfix(.postfix(.postfix(.identifier(let typeName),
                                         .member("alloc")),
                                .functionCall(arguments: [])),
                       .member(let initCall)),
              .functionCall(arguments: var args))
            where args.count > 0 && initCall.hasPrefix("initWith"):
            
            // Do a little Clang-like-magic here: If the method selector is in the
            // form `loremWithThing:thing...`, where after a `[...]With` prefix, a
            // noun is followed by a parameter that has the same name, we collapse
            // such selector in Swift as `lorem(with:)`.
            let split = initCall.components(separatedBy: "With")
            if split.count != 2 || split.contains(where: { $0.count < 2 }) {
                break
            }
            
            // All good! Collapse the identifier into a more 'swifty' construct
            args[0] = .labeled(split[1].lowercased(), args[0].expression)
            
            return .postfix(.identifier(typeName), .functionCall(arguments: args))
        default:
            break
        }
        
        return super.visitPostfix(exp, op: op)
    }
}
