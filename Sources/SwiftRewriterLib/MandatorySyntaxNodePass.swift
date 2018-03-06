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
        
        return super.visitPostfix(exp)
    }
    
    override func visitIdentifier(_ exp: IdentifierExpression) -> Expression {
        return super.visitIdentifier(exp)
    }
}
