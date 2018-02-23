import SwiftAST

public class ExpressionTypeResolver: SyntaxNodeRewriter {
    public override func visitConstant(_ exp: ConstantExpression) -> Expression {
        
        
        return super.visitConstant(exp)
    }
}
