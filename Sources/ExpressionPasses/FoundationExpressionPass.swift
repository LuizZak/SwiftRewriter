import SwiftRewriterLib
import Utils

/// Applies passes to simplify known Foundation methods
public class FoundationExpressionPass: ExpressionPass {
    
    public override init() {
        super.init()
        inspectBlocks = true
    }
    
    /// Converts [<lhs> isEqualToString:<rhs>] -> <lhs> == <rhs>
    func convertIsEqualToString(_ exp: PostfixExpression) -> Expression? {
        guard let postfix = exp.exp.asPostfix,
            postfix.op == .member("isEqualToString"),
            case .functionCall(let args) = exp.op, args.count == 1 && !args.hasLabeledArguments() else {
            return nil
        }
        
        return .binary(lhs: postfix.exp, op: .equals, rhs: args[0].expression)
    }
    
    /// Converts [NSString stringWithFormat:@"format", <...>] -> String(format: "format", <...>)
    func convertStringWithFormat(_ exp: PostfixExpression) -> Expression? {
        guard exp.exp == .postfix(.identifier("NSString"), .member("stringWithFormat")),
            case .functionCall(let args) = exp.op, args.count > 0 else {
            return nil
        }
        
        let newArgs: [FunctionArgument] = [
            .labeled("format", args[0].expression),
        ] + args.dropFirst()
        
        exp.exp = .identifier("String")
        exp.op = .functionCall(arguments: newArgs)
        
        return exp
    }
    
    /// Converts [<array> addObjectsFromArray:<exp>] -> <array>.addObjects(from: <exp>)
    func convertAddObjectsFromArray(_ exp: PostfixExpression) -> Expression? {
        guard let memberPostfix = exp.exp.asPostfix, memberPostfix.op == .member("addObjectsFromArray"),
            case .functionCall(let args) = exp.op, args.count == 1 else {
            return nil
        }
        
        let newArgs: [FunctionArgument] = [
            .labeled("from", args[0].expression),
        ]
        
        exp.exp = .postfix(memberPostfix.exp, .member("addObjects"))
        exp.op = .functionCall(arguments: newArgs)
        
        return exp
    }
    
    /// Converts [Type class] and [expression class] expressions
    func convertClassCall(_ exp: PostfixExpression) -> Expression? {
        guard case .functionCall(let args) = exp.op, args.count == 0 else {
            return nil
        }
        guard let classMember = exp.exp.asPostfix, classMember.op == .member("class") else {
            return nil
        }
        
        switch classMember.exp {
        case let ident as IdentifierExpression where ident.identifier.startsUppercased:
            return Expression.postfix(classMember.exp, .member("self"))
        default:
            return Expression.postfix(.identifier("type"),
                                      .functionCall(arguments: [
                                        .labeled("of", classMember.exp)
                                        ]))
        }
    }
    
    /// Converts [NSArray array], [NSDictionary dictionary], etc. constructs
    func convertDataStructureInit(_ exp: PostfixExpression) -> Expression? {
        guard case .functionCall(let args) = exp.op, args.count == 0 else {
            return nil
        }
        guard let initMember = exp.exp.asPostfix, let typeName = initMember.exp.asIdentifier?.identifier else {
            return nil
        }
        guard case .member(let initName) = initMember.op else {
            return nil
        }
        
        switch (typeName, initName) {
        case ("NSArray", "array"),
             ("NSMutableArray", "array"),
             ("NSDictionary", "dictionary"),
             ("NSMutableDictionary", "dictionary"),
             ("NSSet", "set"),
             ("NSMutableSet", "set"):
            return .postfix(.identifier(typeName), .functionCall(arguments: []))
        default:
            return nil
        }
    }
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        
        if let new = convertIsEqualToString(exp) {
            return new.accept(self)
        }
        if let new = convertStringWithFormat(exp) {
            return new.accept(self)
        }
        if let new = convertAddObjectsFromArray(exp) {
            return new.accept(self)
        }
        if let new = convertClassCall(exp) {
            return new.accept(self)
        }
        if let new = convertDataStructureInit(exp) {
            return new.accept(self)
        }
        
        return exp
        
        /*
        switch (exp.exp, exp.op) {
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
        */
    }
}
