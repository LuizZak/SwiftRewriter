import SwiftAST
import KnownType

/// Corrects invocations of properties of types which are expressed as method
/// invocations. This is a common construct in Objective-C.
public class PropertyAsMethodAccessCorrectingExpressionPass: BaseExpressionPass {
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if exp.isTopPostfixExpression {
            let result = checkExpressionChain(exp)
            
            if result.didWork {
                notifyChange()
                
                return super.visitExpression(result.exp)
            }
        }
        
        return super.visitPostfix(exp)
    }
    
    func checkExpressionChain(_ exp: PostfixExpression) -> (exp: PostfixExpression, didWork: Bool) {
        var didWork = false
        if let inner = exp.exp.asPostfix {
            let result = checkExpressionChain(inner)
            exp.exp = result.exp
            didWork = result.didWork
        }
        if let transformed = checkExpression(exp) {
            return (transformed, true)
        }
        return (exp, didWork)
    }
    
    func checkExpression(_ exp: PostfixExpression) -> PostfixExpression? {
        guard let functionCall = exp.op.asFunctionCall else {
            return nil
        }
        guard functionCall.arguments.isEmpty else {
            return nil
        }
        guard let baseMemberExp = exp.exp.asPostfix else {
            return nil
        }
        guard let memberDefinition = memberDefinition(in: baseMemberExp) else {
            return nil
        }
        
        if let member = memberDefinition as? KnownProperty {
            // Ignore invocations to closure member types
            if typeSystem.resolveAlias(in: member.memberType).deepUnwrapped.isBlock {
                return nil
            }
            
            return baseMemberExp.copy().typed(memberDefinition.memberType)
        }
        
        return nil
    }
    
    func memberDefinition(in exp: PostfixExpression) -> KnownMember? {
        // Try to use existing type member information
        guard let member = exp.member else {
            return nil
        }
        if let memberDefinition = member.memberDefinition {
            return memberDefinition
        }
        
        // Use type system to search for member
        guard let type = exp.exp.resolvedType else {
            return nil
        }
        
        if let resolvedProperty = typeSystem.property(named: member.name,
                                                      static: type.isMetatype,
                                                      includeOptional: false,
                                                      in: type) {
            return resolvedProperty
        }
        
        // Fields can only be expressed on instance types!
        if !type.isMetatype {
            return typeSystem.field(named: member.name,
                                    static: type.isMetatype,
                                    in: type)
        }
        
        return nil
    }
}
