import SwiftAST

/// A mandatory syntax node pass that tidies up typecast operations and other
/// constructs that are not valid Swift syntax yet.
class MandatorySyntaxNodePass: ASTRewriterPass {
    
    override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        // Optionalize access to casted value's members
        if exp.exp.unwrappingParens is CastExpression {
            exp.op.hasOptionalAccess = true
        }
        
        // [Type new]
        var typeName: String = ""
        if Expression.matcher(ident(.any ->> &typeName).call("new")).matches(exp) {
            var result: Expression = Expression.identifier(typeName)
                
            if typeName == "self" {
                result = result.dot("init").call()
            } else {
                result = result.call()
            }
            
            result.resolvedType = exp.resolvedType
            
            return super.visitExpression(result)
        }
        
        // Type.new
        if Expression.matcher(ident(.any ->> &typeName).dot("new")).matches(exp) {
            let result: Expression
            if typeName == "self" {
                result = Expression.identifier(typeName).dot("init").call()
            } else {
                result = Expression.identifier(typeName).call()
            }
            
            result.resolvedType = exp.resolvedType
            
            return super.visitExpression(result)
        }
        
        return super.visitPostfix(exp)
    }
}
