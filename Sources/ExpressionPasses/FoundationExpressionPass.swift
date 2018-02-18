import SwiftRewriterLib
import Utils

/// Applies passes to simplify known Foundation methods
public class FoundationExpressionPass: ExpressionPass {
    
    public override init() {
        super.init()
        inspectBlocks = true
    }
    
    public override func visitPostfix(_ exp: Expression, op: Postfix) -> Expression {
        var (exp, op) = (exp, op)
        
        switch (exp, op) {
        // [<lhs> isEqualToString:<rhs>] -> <lhs> == <rhs>
        case (.postfix(let innerExp, .member("isEqualToString")),
              .functionCall(arguments: let args))
            where args.count == 1 && !args.hasLabeledArguments():
            
            return visitBinary(lhs: innerExp, op: .equals, rhs: args[0].expression)
            
        // [NSString stringWithFormat:@"format", <...>] -> String(format: "format", <...>)
        case (.postfix(.identifier("NSString"), .member("stringWithFormat")),
              .functionCall(let args)) where args.count > 0:
            let newArgs: [FunctionArgument] = [
                .labeled("format", args[0].expression),
            ] + args.dropFirst()
            
            (exp, op) = (.identifier("String"), .functionCall(arguments: newArgs))
            
        // [<array> addObjectsFromArray:<exp>] -> <array>.addObjects(from: <exp>)
        case (.postfix(let innerExp, .member("addObjectsFromArray")),
              .functionCall(let args)) where args.count == 1:
            let newArgs: [FunctionArgument] = [
                .labeled("from", args[0].expression),
            ]
            
            (exp, op) = (.postfix(innerExp, .member("addObjects")), .functionCall(arguments: newArgs))
            
        // [Type class], [expression class]
        case (.postfix(let innerExp, .member("class")), .functionCall(arguments: [])):
            
            switch innerExp {
            // Upper cased identifier: Type's metatype
            case .identifier(let ident) where ident.startsUppercased:
                (exp, op) = (.identifier(ident), .member("self"))
            // Any other case: expression's type
            default:
                (exp, op) = (.identifier("type"),
                             .functionCall(arguments: [
                                .labeled("of", innerExp)
                                ]))
            }
            
        // [NSArray array], [NSDictionary dictionary], etc. constructs
        case (.postfix(.identifier(let ident), .member(let member)), .functionCall(arguments: [])):
            
            switch (ident, member) {
            case ("NSArray", "array"),
                 ("NSMutableArray", "array"),
                 ("NSDictionary", "dictionary"),
                 ("NSMutableDictionary", "dictionary"),
                 ("NSSet", "set"),
                 ("NSMutableSet", "set"):
                (exp, op) = (.identifier(ident), .functionCall(arguments: []))
            default:
                break
            }
        default:
            break
        }
        
        return super.visitPostfix(exp, op: op)
    }
}
