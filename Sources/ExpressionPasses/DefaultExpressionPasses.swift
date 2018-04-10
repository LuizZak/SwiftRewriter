import SwiftRewriterLib

public class DefaultExpressionPasses: ASTRewriterPassSource {
    public var syntaxNodePasses: [ASTRewriterPass.Type] = [
        ASTSimplifier.self,
        AllocInitExpressionPass.self,
        CoreGraphicsExpressionPass.self,
        FoundationExpressionPass.self,
        UIKitExpressionPass.self,
        NilValueTransformationsPass.self,
        NumberCommonsExpressionPass.self,
        ASTCorrectorExpressionPass.self,
        NumberCommonsExpressionPass.self,
        EnumRewriterExpressionPass.self,
        // Do a last simplification pass after all other passes
        ASTSimplifier.self
    ]
    
    public init() {
        
    }
}
