import SwiftRewriterLib
import Utils
import SwiftAST

/// Applies passes to simplify known Foundation methods
public class FoundationExpressionPass: SyntaxNodeRewriterPass {
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if let new = convertIsEqualToString(exp) {
            return super.visitExpression(new)
        }
        if let new = convertStringWithFormat(exp) {
            return super.visitExpression(new)
        }
        if let new = convertAddObjectsFromArray(exp) {
            return super.visitExpression(new)
        }
        if let new = convertClassCall(exp) {
            return super.visitExpression(new)
        }
        if let new = convertDataStructureInit(exp) {
            return super.visitExpression(new)
        }
        
        return super.visitPostfix(exp)
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
        
        // Use resolved expression type, if available
        if case .metatype? = classMember.exp.resolvedType {
            return Expression.postfix(classMember.exp, .member("self"))
        } else if !classMember.exp.isErrorTyped && classMember.exp.resolvedType != nil {
            return Expression.postfix(.identifier("type"),
                                      .functionCall(arguments: [
                                        .labeled("of", classMember.exp)
                                        ]))
        }
        
        // Deduce using identifier or expression capitalization
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
             ("NSMutableSet", "set"),
             ("NSDate", "date"):
            return .postfix(.identifier(typeName), .functionCall(arguments: []))
        default:
            return nil
        }
    }
}
