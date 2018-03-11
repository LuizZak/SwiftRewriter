import SwiftAST

/// A mandatory syntax node pass that tidies up typecast operations and other
/// constructs that are not valid Swift syntax yet.
///
///
class MandatorySyntaxNodePass: SyntaxNodeRewriterPass {
    
    override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        // Optionalize access to casted value's members
        if exp.exp.unwrappingParens is CastExpression {
            exp.op.hasOptionalAccess = true
        }
        
        // [Type new] expressions
        if let ident = exp.exp.asPostfix?.exp.asIdentifier,
            exp.functionCall?.arguments.count == 0,
            exp.exp.asPostfix?.member?.name == "new" {
            let result = ident.call()
            result.resolvedType = exp.resolvedType
            
            return super.visitExpression(result)
        }
        
        // Type.new expressions
        if let ident = exp.exp.asIdentifier, exp.member?.name == "new" {
            let result = ident.call()
            result.resolvedType = exp.resolvedType
            
            return super.visitExpression(result)
        }
        
        return super.visitPostfix(exp)
    }
}
