import SwiftAST
import ExpressionPasses

/// A mandatory syntax node pass that tidies up typecast operations and other
/// constructs that are not valid Swift syntax yet.
class MandatorySyntaxNodePass: ASTRewriterPass {
    
    override func visitCast(_ exp: CastExpression) -> Expression {
        if let resolvedType = exp.resolvedType, !resolvedType.isOptional {
            exp.resolvedType = .optional(resolvedType)
        }
        
        return super.visitCast(exp)
    }
    
    override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        // Optionalize access to casted value's members
        if exp.exp.unwrappingParens.asCast?.isOptionalCast == true {
            exp.op.optionalAccessKind = .safeUnwrap
        }
        
        // [Type new]
        let typeName = ValueMatcherExtractor("")
        if exp.matches(ident(.any ->> typeName).call("new")) {
            var result: Expression = Expression.identifier(typeName.value)
                
            if typeName.value == "self" {
                result = result.dot("init").call()
            } else {
                result = result.call()
            }
            
            result.resolvedType = exp.resolvedType
            
            return visitExpression(result)
        }
        
        // Type.new
        if exp.matches(ident(.any ->> typeName).dot("new")) {
            let result: Expression
            if typeName.value == "self" {
                result = Expression.identifier(typeName.value).dot("init").call()
            } else {
                result = Expression.identifier(typeName.value).call()
            }
            
            result.resolvedType = exp.resolvedType
            
            return visitExpression(result)
        }
        
        return super.visitPostfix(exp)
    }
}
