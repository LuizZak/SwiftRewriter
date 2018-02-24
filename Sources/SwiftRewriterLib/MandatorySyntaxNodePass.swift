import SwiftAST

/// A mandatory syntax node pass that tidies up typecast operations and other
/// constructs that are not valid Swift syntax.
class MandatorySyntaxNodePass: SyntaxNodeRewriterPass {
    
    override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        // Optionalize access to casted value's members
        if exp.exp is CastExpression {
            exp.op = .optionalAccess(exp.op)
        }
        
        return super.visitPostfix(exp)
    }
}
