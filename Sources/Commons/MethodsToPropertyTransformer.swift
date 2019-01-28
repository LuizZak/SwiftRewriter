import SwiftAST

/// Allows transforming method invocations to property accessors.
public final class MethodsToPropertyTransformer: PostfixInvocationTransformer {
    
    let baseExpressionMatcher: ValueMatcher<Expression>
    let getterName: String
    let setterName: String?
    let propertyName: String
    let resultType: SwiftType
    
    public init(baseExpressionMatcher: ValueMatcher<Expression>,
                getterName: String,
                setterName: String?,
                propertyName: String,
                resultType: SwiftType) {
        
        self.baseExpressionMatcher = baseExpressionMatcher
        self.getterName = getterName
        self.setterName = setterName
        self.propertyName = propertyName
        self.resultType = resultType
    }
    
    public func canApply(to postfix: PostfixExpression) -> Bool {
        guard let memberNameAccess = postfix.exp.asPostfix else {
            return false
        }
        guard let memberName = memberNameAccess.asPostfix?.op.asMember else {
            return false
        }
        guard let function = postfix.op.asFunctionCall else {
            return false
        }
        
        // Handle either getter or setter transformation, depending on argument
        // count of call site
        
        if function.arguments.isEmpty {
            guard memberName.name == getterName else {
                return false
            }
            
            guard baseExpressionMatcher.matches(memberNameAccess.exp) else {
                return false
            }
            
            return true
        } else if let setterName = setterName, function.arguments.count == 1 {
            guard memberName.name == setterName else {
                return false
            }
            
            guard baseExpressionMatcher.matches(memberNameAccess.exp) else {
                return false
            }
            
            return true
        }
        
        return false
    }
    
    public func attemptApply(on postfix: PostfixExpression) -> Expression? {
        if !canApply(to: postfix) {
            return nil
        }
        guard let memberNameAccess = postfix.exp.asPostfix else {
            return nil
        }
        guard let functionCall = postfix.functionCall else {
            return nil
        }
        
        if functionCall.arguments.isEmpty {
            return memberNameAccess.exp.copy().dot(propertyName).typed(resultType)
        } else if functionCall.arguments.count == 1 && setterName != nil {
            return
                memberNameAccess
                    .exp.copy()
                    .dot(propertyName)
                    .assignment(op: .assign,
                                rhs: functionCall.arguments[0].expression.copy())
        }
        
        return nil
    }
}
